# Fourier transform

Discrete Fourier transform:
$$
X(k)=\sum_{n=0}^{N-1}x(n)e^{{-j2 \pi nk}\over{N}} \xrightarrow{\tiny{exp(-j2\pi/N)=W_N}}\sum_{n=0}^{N-1}x(n)W^{nk}_N
$$

***

### 2-pass decomposition

- With radices $N_x, N_y$ where $N=N_xN_y$
  - Fold 1D index $n$ into 2D index $n_x,n_y$ as $N_x$-by-$N_y$ rectangle
  $\Rightarrow$ $n=n_x+N_xn_y$
  - Fold 1D index $k$ into 2D index $k_y,k_x$ as $N_y$-by-$N_x$ rectangle (dimension reversed/transposed) $\Rightarrow$ $k=k_y+N_y k_x$
- Fourier transform $X(k)=\Sigma_{n=0}^{N-1}x(n)W^{nk}_N$ becomes

$$
\begin{aligned}
X(k_y+N_y k_x) &= \sum_{n_x}\sum_{n_y}x(n_x + N_x n_y)W_{N_x N_y}^{(n_x+N_xn_y)(k_y+N_yk_x)} \\
&= \sum_{n_x}\sum_{n_y}x(\dotsb)W^{n_x k_x}_{N_x} W^{n_y k_y}_{N_y} W^{n_x k_y}_{N_x N_y} W^{n_y k_x}_{1} \\
&= \sum_{n_x} W^{n_x k_y}_{N_x N_y}\left(\sum_{n_y}x(\dotsb)W^{n_y k_y}_{N_y}\right)W^{n_x k_x}_{N_x}
\end{aligned}
$$

- Algorithm
  1. Perform $N_x$ radix-$N_y$ FFTs along the high dimension $N_y$
  2. Multiply by twiddle factor $W^{n_x k_y}_{N_x N_y}$
  3. Perform $N_y$ radix-$N_x$ FFTs along the low dimension $N_x$
  4. Read the resulting data transposed

***

### 3-pass decomposition

- With radices $N_x, N_y, N_z$ where $N=N_xN_yN_z$
  - Fold 1D index $n$ into 3D index $n_x,n_y,n_z$ as $N_x N_y N_z$ volume
  $\Rightarrow$ $n=n_x+N_xn_y+N_xN_yn_z$
  - Fold 1D index $k$ into 3D index $k_z,k_y,k_x$ as $N_z N_y N_x$ volume (dimension reversed/transposed) $\Rightarrow$ $k=k_z+N_zk_y+N_y N_zk_x$
- Fourier transform becomes

$$
\begin{aligned}
X(k_z+N_zk_y+N_y N_zk_x) &= \sum_{n_x}\sum_{n_y}\sum_{n_z}x(n_x+N_xn_y+N_xN_yn_z)W_{N_xN_yN_z}^{(n_x+N_xn_y+N_xN_yn_z)(k_z+N_zk_y+N_y N_zk_x)} \\
&= \sum_{n_x}\sum_{n_y}\sum_{n_z}x(\dotsb)W^{n_x k_x}_{N_x} W^{n_y k_y}_{N_y} W^{n_z k_z}_{N_z} W^{n_x k_y}_{N_x N_y} W^{n_y k_z}_{N_y N_z} W^{n_x k_z}_{N_x N_y N_z} \\
&= \sum_{n_x} W^{n_x(N_z k_y + k_z)}_{N_x (N_y N_z)} \left[ \sum_{n_y} W^{n_y k_z}_{N_y N_z} \left( \sum_{n_z}x(\dotsb)W^{n_z k_z}_{N_z} \right) W^{n_y k_y}_{N_y} \right] W^{n_x k_x}_{N_x} \\
&= \text{FFT}_x\left\{W^{n_x(N_z k_y + k_z)}_{N_x (N_y N_z)} \text{FFT}_y\left[ W^{n_y k_z}_{N_y N_z} \text{FFT}_z \left( x\tiny(\dotsb) \right)\right]\right\}
\end{aligned}
$$



- Recursive tree structure revealed: computing FFT for $N_x$-by-$N_y N_z$ array *in turn requires computing FFT for $N_y$-by-$N_z$ array $\forall n_x \in \{0, 1, \dotsb, N_x-1\}$*

```txt
  N1xN2xN3 .______ N1
           |
           |
            \_____ N2xN3 .___ N2
                          \__ N3
```

***

### Tree decomposition

```txt
  256 (N1xN2xN3xN4) .______ 16 (N1xN2) .___ 4 (N1)
                    |                   \__ 4 (N2)
                    |
                     \_____ 16 (N3xN4) .___ 4 (N3)
                                        \__ 4 (N4)
```

TODO:
- Decompose to pseudo-2D 16x16
- Perform 16 Stockham FFTs in first dimension
  - 4-FFT in
- Multiply by twiddle factor
- Perform 16 Stockham FFTs in second dimension
- Read the data transposed

***

### Decomposition with gradual transposition

- Instead of transposing all dimensions at once, can transpose one at a time
- TODO: Example
  - Before: FFT -> WB   -> FFT -> WB+T
  - Now:    FFT -> WB+T -> FFT -> WB+T
- Improve performance since reads from LDS are always coalesced

```txt
  4 (N2) ___. 16 (N2xN1) ______. 256 (N4xN3xN2xN1)
  4 (N1) __/                   |
                               |
  4 (N4) ___. 16 (N4xN3) _____/
  4 (N3) __/
```


***

Archived

$= \sum_{n_x} W^{n_x k_y}_{N_x N_y} W^{n_x k_z}_{N_x N_y N_z} \left[ \sum_{n_y} W^{n_y k_z}_{N_y N_z} \left( \sum_{n_z}x(\dotsb)W^{n_z k_z}_{N_z} \right) W^{n_y k_y}_{N_y} \right] W^{n_x k_x}_{N_x}$