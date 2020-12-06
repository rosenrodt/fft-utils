import numpy as np
from numpy.random import rand
from numpy.fft import fft, ifft
from copy import copy

def tw_mul(xx):
    shape = xx.shape[-2:] # lowest 2 dims
    with np.nditer(xx, op_flags=["readwrite"], flags=["multi_index"]) as it:
        for i in it:
            y, x = it.multi_index[-2:]
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

def toy_fft_mixed_3_7_2(x):
    xxx = x.reshape(2,21) # z-yx
    print("xxx="); print(xxx)

    kxx = fft(xxx, axis=0) # operate on z-axis
    tw_mul(kxx)

    kxx = kxx.reshape(2,7,3) # z-y-x
    kkx = fft(kxx, axis=1) # operate on y-axis
    tw_mul(kkx)
    
    kkk = fft(kkx, axis=2) # operator on x-axis
    k = kkk.transpose().flatten()
    return k


# x = np.arange(21) # x = rand(N)
# kref = fft(x)
# print("x=\n", x)
# print("kref=\n", kref)
# k = toy_fft_mixed_3_7(x)
# print("answer="); print(k)
# print("l2-error={err}".format(err=np.linalg.norm(k - kref)))

x = np.arange(42)
kref = fft(x)
print("x=\n", x)
print("kref=\n", kref)
k = toy_fft_mixed_3_7_2(x)
print("answer="); print(k)
print("l2-error={err}".format(err=np.linalg.norm(k - kref)))

# x = np.aragne(42) # 3*7*2
# kref = fft(x)
# print("{x}=\nref={k}=".format(x=x, k=kref))
