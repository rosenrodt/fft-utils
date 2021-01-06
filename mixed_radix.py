import numpy as np
from numpy.fft import fft, ifft
import pytest

# python3 -m pytest -v [-k keyword] mixed_radix.py

gDebug=False

def tw_mul(xx, dims=[0,1], debug=gDebug):
    if debug: print("===twiddle table===")
    shape = [xx.shape[dim] for dim in dims]
    assert len(shape) == 2
    with np.nditer(xx, op_flags=["readwrite"], flags=["multi_index"]) as it:
        for i in it:
            y, x = (it.multi_index[dim] for dim in dims)
            twiddle = np.exp(-1j * 2 * np.pi * y*x / (shape[0]*shape[1]))
            i[...] = i * twiddle
            if debug: print("(x, y)=({}, {}), tw={}".format(x,y,twiddle))

def fft_mixed2_impl(xx):
    kx = fft(xx, axis=0) # axis same as dim: from highest to lowest
    # print("after fft columns"); print(kx)

    tw_mul(kx)
    # print("after twiddle");print(kx)

    kk = fft(kx, axis=1)
    # print("after fft row");print(kk)

    k = kk.transpose().flatten() # explicit bit-reversal step
    return k

# mixed radix
def toy_fft_mixed_3_7(x):
    xx = x.reshape(7,3) # fastest changing index placed last
    print("after reshape=\n{x}, elem(1,2)= {elem}".format(x=xx, elem=xx[1,2]))
    return fft_mixed2_impl(xx)

# mixed radix
def toy_fft_mixed_7_3(x):
    xx = x.reshape(3,7) # fastest changing index placed last
    print("after reshape=\n{x}, elem(1,2)= {elem}".format(x=xx, elem=xx[1,2]))
    return fft_mixed2_impl(xx)

# +-----> x
# | (row is contiguous)
# |
# V y
def toy_fft_mixed_3_7_2(x):
    xxx = x.reshape(2,21) # z-yx
    print("xxx="); print(xxx)

    kxx = fft(xxx, axis=0) # operate on z-axis
    tw_mul(kxx, dims=[0,1])

    kxx = kxx.reshape(2,7,3) # z-y-x
    kkx = fft(kxx, axis=1) # operate on y-axis
    tw_mul(kkx, dims=[1,2])

    kkk = fft(kkx, axis=2) # operate on x-axis
    k = kkk.transpose().flatten() # explicit bit-reversal step
    return k

def toy_fft_mixed_3_7_2_stockham(x):
    xxx = x.reshape(2,21)        # z-yx

    print("shape=", xxx.shape)   # shape= (2, 21)
    kxx = fft(xxx, axis=0)       # operate on z-axis
    tw_mul(kxx, [0,1])
    kxx_t = kxx.reshape(2,7,3).transpose(1,2,0) # y-x-z

    print("shape=", kxx_t.shape) # shape= (7, 3, 2)
    kkx = fft(kxx_t, axis=0)     # operate on y-axis
    tw_mul(kkx, [0,1])
    kkx_t = kkx.transpose(1,0,2) # x-y-z

    print("shape=", kkx_t.shape) # shape= (3, 7, 2)
    kkk = fft(kkx_t, axis=0)     # operate on x-axis

    k = kkk.flatten()
    return k

def toy_fft_mixed_2_2_2_stockham(x):
    xxx = x.reshape(2,4)        # z-yx

    kxx = fft(xxx, axis=0)       # operate on z-axis
    tw_mul(kxx, [0,1])
    kxx_t = kxx.reshape(2,2,2).transpose(1,2,0) # y-x-z

    kkx = fft(kxx_t, axis=0)     # operate on y-axis
    tw_mul(kkx, [0,1])
    kkx_t = kkx.transpose(1,0,2) # x-y-z

    kkk = fft(kkx_t, axis=0)     # operate on x-axis

    k = kkk.flatten()
    return k

# DIF/DIT differs in twiddle factor generation
# DIF: Starts from time domain a more granular twiddle, to freq domain a coarser twiddle
# DIT: Starts from time domain a coarser twiddle, to freq domain a more granular tiwddle
def toy_fft_mixed_2_2_2_2_stockham_dif(x):
    x0 = x.reshape(2,8)

    x1 = fft(x0, axis=0)
    tw_mul(x1, [0,1])
    x1t = x1.reshape(2,2,4).transpose(1,2,0)

    x2 = fft(x1t, axis=0)
    tw_mul(x2, [0,1])
    x2t = x2.reshape(2,2,2,2).transpose(1,2,0,3)

    x3 = fft(x2t, axis=0)
    tw_mul(x3, [0,1])
    x3t = x3.transpose(1,0,2,3)

    x4 = fft(x3t, axis=0)

    k = x4.flatten()
    return k

def toy_fft_mixed_2_2_2_2_stockham_dit(x):
    x0 = x.reshape(2,2,2,2)

    x1 = fft(x0, axis=0)
    x1t = x1.reshape(2,2,2,2).transpose(1,2,3,0).reshape(2,4,2)
    tw_mul(x1t, [0,2])

    x2 = fft(x1t, axis=0)
    x2t = x2.reshape(2,2,2,2).transpose(1,2,0,3).reshape(2,2,4)
    tw_mul(x2t, [0,2])

    x3 = fft(x2t, axis=0)
    x3t = x3.reshape(2,2,2,2).transpose(1,0,2,3).reshape(2,8)
    tw_mul(x3t, [0,1])

    x4 = fft(x3t, axis=0)

    k = x4.flatten()
    return k

# first 2 dims are shape, third dim is batch count
def stockham_recursive_impl(x):
    batch = x.shape[2]
    for xx in [x[:,:,i] for i in range(0,batch)]:
        kx = fft(xx, axis=0)
        tw_mul(kx)
        xx[...] = fft(kx, axis=1)
    return x.transpose(1,0,2)

def stockham_recursive_4_4_4_4(x):
    x = x.reshape(4,4,-1) # highest 2 dim
    x = stockham_recursive_impl(x)

    x = x.reshape(16,16)
    tw_mul(x, [0, 1]) # transpose before multiplying

    xt = x.transpose(1,0).reshape(4,4,-1)
    xt = stockham_recursive_impl(xt)

    return xt.flatten()

@pytest.mark.parametrize("N,func",[(21, toy_fft_mixed_3_7),
                                   (21, toy_fft_mixed_7_3),
                                   (42, toy_fft_mixed_3_7_2),
                                   (42, toy_fft_mixed_3_7_2_stockham),
                                   ( 8, toy_fft_mixed_2_2_2_stockham),
                                   (16, toy_fft_mixed_2_2_2_2_stockham_dit),
                                   (16, toy_fft_mixed_2_2_2_2_stockham_dif),
                                   (256, stockham_recursive_4_4_4_4)
                                   ])
def test(N, func):
    # x = np.arange(N, dtype=np.complex) # real ascending value
    x = np.random.random(N) + 1j*np.random.random(N) # complex random value
    kref = fft(x)
    print("x=\n", x)
    print("kref=\n", kref)
    k1 = func(x)
    print("answer="); print(k1)
    err = np.linalg.norm(k1 - kref)
    print("l2-error=", err)
    assert err/N < 1e-10

# def test2D(M, N, func):
#     x = np.arange(M*N).reshape(M,N)
#     pass

# test(21, toy_fft_mixed_3_7)
# test(42, toy_fft_mixed_3_7_2_stockham)
# test(16, toy_fft_mixed_2_2_2_2_stockham_dit)
test(256, stockham_recursive_4_4_4_4)