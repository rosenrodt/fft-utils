# Fourier transform

Discrete Fourier transform, where $e^{{-j2 \pi}\over{N}} = W_N$:
$$
X(k)=\sum_{n=0}^{N-1}x(n)e^{{-j2 \pi nk}\over{N}}=\sum_{n=0}^{N-1}x(n)W^{nk}_N
$$

### 2-pass decomposition

- With radices $N_x, N_y$ where $N=N_xN_y$
  - Fold 1D index $n$ into 2D index $n_x,n_y$ as $N_x$-by-$N_y$ rectangle
  $\Rightarrow$ $n=n_x+N_xn_y$
  - Fold 1D index $k$ into 2D index $k_y,k_x$ as $N_y$-by-$N_x$ rectangle (dimension reversed/transposed) $\Rightarrow$ $k=k_y+N_y k_x$
- Fourier transform becomes

$$
\begin{aligned}
X(k_y+N_y k_x) &= \sum_{n_x}\sum_{n_y}x(n_x + N_x n_y)W_{N_x N_y}^{(n_x+N_xn_y)(k_y+N_yk_x)} \\
&= \sum_{n_x}\sum_{n_y}x(\dotsb)W^{n_x k_x}_{N_x} W^{n_y k_y}_{N_y} W^{n_x k_y}_{N_x N_y} W^{n_y k_x}_{1} \\
&= \sum_{n_x} W^{n_x k_y}_{N_x N_y}\left(\sum_{n_y}x(\dotsb)W^{n_y k_y}_{N_y}\right)W^{n_x k_x}_{N_x}
\end{aligned}
$$

- Algorithm
  1. Fold 1D array into 2D array (low dimension is $N_x$)
  2. Perform $N_x$ radix-$N_y$ FFTs along the high dimension $N_y$
  3. Multiply by twiddle factor $W^{n_x k_y}_{N_x N_y}$
  4. Perform $N_y$ radix-$N_x$ FFTs along the low dimension $N_x$
  5. Read the resulting data transposed

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
&= \sum_{n_x} W^{n_x k_y}_{N_x N_y} W^{n_x k_z}_{N_x N_y N_z} \left[ \sum_{n_y} W^{n_y k_z}_{N_y N_z} \left( \sum_{n_z}x(\dotsb)W^{n_x k_x}_{N_x} \right) W^{n_y k_y}_{N_y} \right] W^{k_z n_z}_{N_z} \\
&= \sum_{n_x} W^{(N_z k_y + k_z)n_x}_{N_x N_y N_z} \left[ \sum_{n_y} W^{k_y n_x}_{N_x N_y} \left( \sum_{n_z}x(\dotsb)W^{k_x n_x}_{N_x} \right) W^{k_y n_y}_{N_y} \right] W^{k_z n_z}_{N_z}  
\end{aligned}
$$
