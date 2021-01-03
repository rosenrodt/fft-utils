# Fourier transform

Discrete Fourier transform:
$$
X(k)=\sum_{n=0}^{N-1}x(n)e^{{-j2 \pi nk}\over{N}} \xrightarrow{\tiny{exp(-j2\pi/N)=W_N}}\sum_{n=0}^{N-1}x(n)W^{nk}_N
$$

***

## 2-pass mixed-radix decomposition

- With $N=N_1N_2$
  - Fold $n$ into $(n_1,n_2)$ where $n=n_1+N_1n_2$
  - Fold $k$ into $(k_2,k_1)$ where $k=k_2+N_2 k_1$ (dimension reversed/transposed)
- Fourier transform $X(k)=\Sigma_{n=0}^{N-1}x(n)W^{nk}_N$ becomes

$$
\begin{aligned}
X(k_2+N_2 k_1) &= \sum_{n_1}\sum_{n_2}x(n_1 + N_1 n_2)W_{N_1 N_2}^{(n_1+N_1n_2)(k_2+N_2k_1)} \\
&= \sum_{n_1}\sum_{n_2}x(\dotsb)W^{n_1 k_1}_{N_1} W^{n_2 k_2}_{N_2} W^{n_1 k_2}_{N_1 N_2} \bcancel{W^{n_2 k_1}_{1}}\underset{\mathrlap{e^{j 2 \pi N}=1}}{} \\
&= \underbrace{\sum_{n_1} \underbrace{\vphantom{\sum_{n_2}}W^{n_1 k_2}_{N_1 N_2}}_{\text{Twiddle}}
  \biggl(
    \underbrace{
      \sum_{n_2}x(\dotsb)W^{n_2 k_2
    }_{N_2}}_{\text{FFT along } \bold{D_2}}
  \biggr)
W^{n_1 k_1}_{N_1}}_{\text{FFT along } \bold{D_1}}
\end{aligned}
$$

- Algorithm
  1. Perform FFTs along the high dimension $\bold{D_2}$
  2. Pointwise multiply by twiddle factor $W^{n_1 k_2}_{N_1 N_2}$
  3. Perform FFTs along the low dimension $\bold{D_1}$
  4. Read the resulting data transposed

***

## 3-pass mixed-radix decomposition

- With $N=N_1N_2N_3$
  - Fold $n$ into $(n_1,n_2,n_3)$ where $n=n_1+N_1n_2+N_1N_2n_3$
  - Fold $k$ into $(k_3,k_2,k_1)$ where $k=k_3+N_3k_2+N_2 N_3k_1$ (dimension reversed/transposed)
- Fourier transform becomes

$$
\begin{aligned}
X(k_3+N_3k_2+N_2 N_3k_1) &= \sum_{n_1}\sum_{n_2}\sum_{n_3}x(n_1+N_1n_2+N_1N_2n_3)W_{N_1N_2N_3}^{(n_1+N_1n_2+N_1N_2n_3)(k_3+N_3k_2+N_2 N_3k_1)} \\
&= \sum_{n_1}\sum_{n_2}\sum_{n_3}x(\dotsb)W^{n_1 k_1}_{N_1} W^{n_2 k_2}_{N_2} W^{n_3 k_3}_{N_3} W^{n_1 k_2}_{N_1 N_2} W^{n_2 k_3}_{N_2 N_3} W^{n_1 k_3}_{N_1 N_2 N_3} \\
%% &= \sum_{n_1} W^{n_1 k_2}_{N_1 N_2} W^{n_1 k_3}_{N_1 N_2 N_3} \biggl[ \sum_{n_2} W^{n_2 k_3}_{N_2 N_3} \biggl( \sum_{n_3}x(\dotsb)W^{n_3 k_3}_{N_3} \biggr) W^{n_2 k_2}_{N_2} \biggr] W^{n_1 k_1}_{N_1} \\
&= \underbrace{
\sum_{n_1} \underbrace{ \vphantom{\sum_{n_1}} W^{n_1(N_3 k_2 + k_3)}_{N_1 (N_2 N_3)} }_{\text{Twiddle}}
\biggl[
\underbrace{
  \sum_{n_2} \underbrace{
    \vphantom{\sum_{n_1}} W^{n_2 k_3}_{N_2 N_3} }_{\text{Twiddle}}
  \biggl(
  \underbrace{
    \sum_{n_3} x(\dotsb)W^{n_3 k_3}_{N_3} }_{\text{FFT along } \bold{D_3}}
  \biggr)
W^{n_2 k_2}_{N_2} }_{\text{FFT along } \bold{D_2}}
\biggr]
W^{n_1 k_1}_{N_1}
}_{\text{FFT along } \bold{D_1}}
\end{aligned}
$$

- Recursive tree structure revealed:
  - FFT for $N_1 N_2 N_3$ array requires 2-pass FFT for $N_1$-by-$N_2 N_3$ pseudo matrix
  - Which in turn requires *another 2-pass FFT* for $N_2$-by-$N_3$ pseudo matrix
  - 3 leaf nodes corresponding to FFTs of 3 different radices, 2 parent nodes corresponding to 2 twiddle multiplication

```txt
  N1xN2xN3 .______ N1
           |
           |
            \_____ N2xN3 .___ N2
                          \__ N3
```

***

## Tree decomposition

```txt
  256 (N1xN2xN3xN4) .____ 16 (N1xN2) .____ 4 (N1)
                    |                 \___ 4 (N2)
                    |
                     \___ 16 (N3xN4) .____ 4 (N3)
                                      \___ 4 (N4)
  or

  256 (N1xN2xN3xN4) .____ 4  (N1)
                     \___ 64 (N2xN3xN4) .____ 4  (N2)
                                         \___ 16 (N3xN4) .____ 4 (N3)
                                                          \___ 4 (N4)
```

TODO:
- Decompose to pseudo-2D 16x16
- Perform 16 Stockham FFTs in first dimension
  - 4-FFT in
- Multiply by twiddle factor
- Perform 16 Stockham FFTs in second dimension- Read the data transposed

***

## Decomposition with gradual transposition

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

