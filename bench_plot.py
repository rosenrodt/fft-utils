# %%

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

cmd ="""#!/bin/bash
set -x
./run.sh -N __placeholder__ | tee run.log
grep -P '(?<=Execution gpu time: )([0-9\.\s]*)(?!ms)|\+\+.*' run.log -o > run.log.filtered
"""

# %%
# assumes clientdirs[0] is modified rocFFT, clientdirs[1] is vanilla rocFFT if any
def runBench(clientdirs, dryrun, numtrials):
    import os, subprocess
    import pandas as pd
    import numpy as np

    clientdirs = [d for d in clientdirs if d is not None] # sanitize

    tables = [None] * len(clientdirs)
    for i, clientdir in enumerate(clientdirs):
        runcmd = pd.read_csv(os.path.join(clientdir, 'run.sh'), header=None)
        runcmd = runcmd[runcmd.iloc[:,0].str.contains('rocfft')].reset_index(drop=True)
        runcmd.set_axis(['cmd'], axis='columns', inplace=True)

        runfile = os.path.join(clientdir, 'run.sh')
        with open(runfile, 'w') as f:
            f.write(run)
        os.chmod(runfile, 0x755)
        script = os.path.join(clientdir, '_tmp_run.sh')
        with open(script, 'w') as f:
            f.write(cmd.replace('__placeholder__', str(numtrials)))
        os.chmod(script, 0x755)

        if not dryrun:
            subprocess.run(script, cwd=clientdir, check=True)

        data = pd.read_csv(os.path.join(clientdir, 'run.log.filtered'), sep=' ', header=None)

        partial = runcmd.join(data)
        partial.set_index('cmd', inplace=True)

        tables[i] = partial

    import numpy as np
    import csv

    for i, table in enumerate(tables):
        table.insert(0, 'mean', np.mean(table.values, axis=1))
        table.insert(0, 'median', np.median(table.values, axis=1))
        table.insert(0, 'min', np.amin(table.values, axis=1))
        table.to_csv(f'result{i}.csv', quoting=csv.QUOTE_NONNUMERIC)

    # gain_qq1 = np.quantile(tables[1].values, 0.25, axis=1)/np.quantile(tables[0].values, 0.25, axis=1)
    # gain_qq2 = np.quantile(tables[1].values, 0.50, axis=1)/np.quantile(tables[0].values, 0.50, axis=1)
    # gain_qq3 = np.quantile(tables[1].values, 0.75, axis=1)/np.quantile(tables[0].values, 0.75, axis=1)
    # gain_qq1 = gain_qq1-1
    # gain_qq2 = gain_qq2-1
    # gain_qq3 = gain_qq3-1
    # gain_mean = np.mean(tables[1].values, axis=1)/np.mean(tables[0].values, axis=1)
    # gain_mean = gain_mean-1

    return tables

# %%
def plot(tables):
    import matplotlib.pyplot as plt
    import numpy as np

    data_a = tables[0].values.tolist()
    data_b = tables[1].values.tolist()
    labels = tables[0].index.to_list()

    def set_box_color(bp, color):
        plt.setp(bp['boxes'], color=color)
        plt.setp(bp['whiskers'], color=color)
        plt.setp(bp['caps'], color=color)
        plt.setp(bp['medians'], color=color, linewidth=0.8)
        plt.setp(bp['fliers'], markeredgecolor=color)

    fig = plt.figure(figsize=(40, 20), dpi=200)
    bpl = plt.boxplot(data_a, whis=[5, 95], vert=False, positions=np.array(range(len(data_a)))*2.0-0.4, showfliers=False, sym='.', widths=0.8)
    bpr = plt.boxplot(data_b, whis=[5, 95], vert=False, positions=np.array(range(len(data_b)))*2.0+0.4, showfliers=False, sym='.', widths=0.8)
    set_box_color(bpl, '#D7191C') # colors are from http://colorbrewer2.org/
    set_box_color(bpr, '#2C7BB6')

    # draw temporary red and blue lines and use them to create a legend
    plt.plot([], c='#D7191C', label='Mod')
    plt.plot([], c='#2C7BB6', label='Ref')
    plt.xlabel('Run time (ms)')
    plt.ylabel('FFT sizes')
    plt.legend()
    plt.title("FFT end-to-end run time")

    plt.yticks(range(0, len(labels)*2, 2), labels)
    plt.xticks(np.arange(0, 5, 0.5))
    plt.xlim(left=0)
    plt.tight_layout()

    fig.savefig('plot.jpg', bbox_inches='tight', dpi=200)

# %%
if __name__ == "__main__":
    import argparse, sys
    parser = argparse.ArgumentParser()
    parser.add_argument("dir", help="rocFFT path")
    parser.add_argument("--ref", help="the other rocFFT path when you also want to benchmark original rocFFT", default=None)
    parser.add_argument("--dry", help="dry run benchmarks", action="store_true")
    parser.add_argument("-n", help="number of trials to run", default=3)

    args = parser.parse_args(sys.argv[1:])
    relpath = 'build/release/clients/staging'

    devpath = os.path.join(args.dir, relpath)
    refpath = os.path.join(args.ref, relpath) if args.ref is not None else None
    dryrun = args.dry
    numtrials = args.n

    tables = runBench([devpath, refpath], dryrun, numtrials)
    if refpath is not None:
        plot(tables)
