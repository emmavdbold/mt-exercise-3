#! /bin/bash

scripts=`dirname "$0"`
base=$(realpath $scripts/..)

models=$base/models
data=$base/data
tools=$base/tools
logs=$base/logs

mkdir -p $models
mkdir -p $logs

num_threads=4
device=""

SECONDS=0

dropout_rates=(0 0.3 0.4 0.5 0.8)

cd $tools/pytorch-examples/word_language_model

for d in ${dropout_rates[*]}
do
    CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python main.py --data $data/grimm \
        --epochs 40 \
        --log-interval 100 \
        --emsize 200 --nhid 200 --dropout $d --tied \
        --seed 1111 \
        --save $models/model.$d.pt > $logs/model.$d.log
done

echo "time taken:"
echo "$SECONDS seconds"
