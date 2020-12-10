runs = {}
run ="""#!/bin/bash
# this script is auto-generated
set -x

if [ $1 == "-N" ]; then
echo "set N to $2"
N=$2
else
echo "set N to default=30"
N=30
fi

./rocfft-rider --length 168 80 80 --scale 2 -t 1 -N $N
./rocfft-rider --length 168 168 192 --scale 3 -t 1 -N $N
./rocfft-rider --length 168 80 80 --scale 2 -t 2 -N $N
./rocfft-rider --length 168 168 192 --scale 3 -t 2 -N $N
./rocfft-rider --length 60 60 60 --scale 5 -t 2 -N $N
./rocfft-rider --length 160 168 168 --scale 2 -t 1 -N $N
./rocfft-rider --length 160 168 168 --scale 2 -t 2 -N $N
./rocfft-rider --length 60 60 60 --scale 5 -t 1 -N $N
./rocfft-rider --length 168 192 192 --scale 3 -t 1 -N $N
./rocfft-rider --length 224 108 108 --scale 2 -t 1 -N $N
./rocfft-rider --length 168 192 192 --scale 3 -t 2 -N $N
./rocfft-rider --length 192 84 84 --scale 3 -t 1 -N $N
./rocfft-rider --length 224 108 108 --scale 2 -t 2 -N $N
./rocfft-rider --length 160 80 72 --scale 2 -t 2 -N $N
./rocfft-rider --length 192 84 84 --scale 3 -t 2 -N $N
./rocfft-rider --length 224 104 104 --scale 2 -t 2 -N $N
./rocfft-rider --length 64 64 64 --scale 2 -t 1 -N $N
./rocfft-rider --length 80 80 80 --scale 5 -t 1 -N $N
./rocfft-rider --length 224 104 104 --scale 2 -t 1 -N $N
./rocfft-rider --length 160 80 80 --scale 5 -t 2 -N $N
./rocfft-rider --length 160 80 80 --scale 5 -t 1 -N $N
./rocfft-rider --length 80 80 80 --scale 5 -t 2 -N $N
./rocfft-rider --length 160 72 72 --scale 2 -t 1 -N $N
./rocfft-rider --length 72 72 72 --scale 3 -t 1 -N $N
./rocfft-rider --length 160 80 72 --scale 2 -t 1 -N $N
./rocfft-rider --length 208 100 100 --scale 2 -t 1 -N $N
./rocfft-rider --length 224 108 104 --scale 2 -t 1 -N $N
./rocfft-rider --length 224 108 104 --scale 2 -t 2 -N $N
./rocfft-rider --length 72 72 72 --scale 3 -t 2 -N $N
./rocfft-rider --length 160 72 72 --scale 2 -t 2 -N $N
./rocfft-rider --length 208 100 100 --scale 2 -t 2 -N $N
./rocfft-rider --length 100 100 100 --scale 5 -t 2 -N $N
./rocfft-rider --length 216 104 100 --scale 2 -t 1 -N $N
./rocfft-rider --length 100 100 100 --scale 5 -t 1 -N $N
./rocfft-rider --length 216 104 100 --scale 2 -t 2 -N $N
./rocfft-rider --length 64 64 64 --scale 2 -t 2 -N $N
./rocfft-rider --length 192 96 84 --scale 3 -t 1 -N $N
./rocfft-rider --length 216 104 104 --scale 2 -t 1 -N $N
./rocfft-rider --length 96 96 96 --scale 3 -t 1 -N $N
./rocfft-rider --length 216 104 104 --scale 2 -t 2 -N $N
./rocfft-rider --length 240 112 112 --scale 2 -t 1 -N $N
./rocfft-rider --length 240 112 112 --scale 2 -t 2 -N $N
./rocfft-rider --length 192 96 84 --scale 3 -t 2 -N $N
./rocfft-rider --length 96 96 96 --scale 3 -t 2 -N $N
./rocfft-rider --length 240 112 108 --scale 2 -t 1 -N $N
./rocfft-rider --length 200 100 96 --scale 2 -t 1 -N $N
./rocfft-rider --length 192 96 96 --scale 3 -t 1 -N $N
./rocfft-rider --length 240 108 108 --scale 3 -t 1 -N $N
./rocfft-rider --length 240 112 108 --scale 2 -t 2 -N $N
./rocfft-rider --length 200 96 96 --scale 2 -t 1 -N $N
./rocfft-rider --length 240 108 108 --scale 3 -t 2 -N $N
./rocfft-rider --length 160 160 168 --scale 2 -t 1 -N $N
./rocfft-rider --length 200 96 96 --scale 2 -t 2 -N $N
./rocfft-rider --length 200 100 96 --scale 2 -t 2 -N $N
./rocfft-rider --length 160 160 168 --scale 2 -t 2 -N $N
./rocfft-rider --length 192 96 96 --scale 3 -t 2 -N $N
./rocfft-rider --length 192 200 200 --scale 2 -t 1 -N $N
./rocfft-rider --length 200 200 200 --scale 5 -t 1 -N $N
./rocfft-rider --length 200 200 200 --scale 5 -t 2 -N $N
./rocfft-rider --length 192 192 192 --scale 3 -t 1 -N $N
./rocfft-rider --length 192 192 200 --scale 2 -t 1 -N $N
./rocfft-rider --length 192 200 200 --scale 2 -t 2 -N $N
./rocfft-rider --length 192 192 192 --scale 3 -t 2 -N $N
./rocfft-rider --length 192 192 200 --scale 2 -t 2 -N $N
"""
runs["gromacs"] = run


run ="""#!/bin/bash
# this script is auto-generated
set -x

if [ $1 == "-N" ]; then
echo "set N to $2"
N=$2
else
echo "set N to default=30"
N=30
fi
./rocfft-rider --length 256 256 256 -t 2 -N $N
./rocfft-rider --length 256 256 256 -t 1 -N $N
./rocfft-rider --length 512 512 512 -t 2 -N $N
./rocfft-rider --length 512 512 512 -t 1 -N $N
./rocfft-rider --length 768 768 768 -t 2 -N $N
./rocfft-rider --length 768 768 768 -t 1 -N $N
./rocfft-rider --length 1024 1024 1024 -t 2 -N $N
./rocfft-rider --length 1024 1024 1024 -t 1 -N $N
"""
runs["std-large"] = run
