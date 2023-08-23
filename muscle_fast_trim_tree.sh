#!/usr/bin/env bash

if ! command -v muscle > /dev/null; then
        printf "\n Muscle aligner not found in path. Exiting"
        exit
fi

if ! command -v trimal > /dev/null; then
        printf "\n Trimal not found in path. Exiting"
        exit
fi

if ! command -v FastTreeDbl > /dev/null; then
        printf "\n FastTree not found in path. Exiting"
        exit
fi

align_input=$(echo $1 | tr -d '\r')
alignment_name=$(basename $1 .faa)

muscle -align "$align_input" --output "$alignment_name".afa

trimal -automated1 -in "$alignment_name".afa -out autotrim_"$alignment_name".afa

FastTreeDbl -lg -slow -gamma autotrim_"$alignment_name".afa > fasttree_"$alignment_name".tree
