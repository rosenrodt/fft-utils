import numpy as np
from numpy.fft import fft, ifft
import pytest

# python3 -m pytest -v [-k keyword] mixed_radix.py

def tw_mul(xx, dims=[0,1]):
    shape = [xx.shape[dim] for dim in dims]
    assert len(shape) == 2
    with np.nditer(xx, op_flags=["readwrite"], flags=["multi_index"]) as it:
        for i in it:
            y, x = (it.multi_index[dim] for dim in dims)
            i[...] = i * np.exp(-1j * 2 * np.pi * y*x / (shape[0]*shape[1]))

def fft_mixed2_impl(xx):
    kx = fft(xx, axis=0) # axis same as dim: from highest to lowest
    print("after fft columns"); print(kx)

    tw_mul(kx)
    print("after twiddle");print(kx)

    kk = fft(kx, axis=1)
    print("after fft row");print(kk)

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

def toy_fft_mixed_3_7_2_alt(x):
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

@pytest.mark.parametrize("N,func",[(21, toy_fft_mixed_3_7),
                                   (21, toy_fft_mixed_7_3),
                                   (42, toy_fft_mixed_3_7_2),
                                   (42, toy_fft_mixed_3_7_2_alt)
                                   ])
def test(N, func):
    x = np.arange(N)
    kref = fft(x)
    print("x=\n", x)
    print("kref=\n", kref)
    k1 = func(x)
    print("answer="); print(k1)
    err = np.linalg.norm(k1 - kref)
    print("l2-error=", err)
    assert(err < 1e-10)

# test(21, toy_fft_mixed_3_7)
test(42, toy_fft_mixed_3_7_2_alt)
