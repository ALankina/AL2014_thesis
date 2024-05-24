



#!/bin/bash -l
#$ -S /bin/bash
#$ -o /cluster/scratch8b/Ana_HV/colabfold/out
#$ -e /cluster/scratch8b/Ana_HV/colabfold/error
#$ -l h_rt=2:00:00
#$ -l tmem=14G
#$ -pe gpu 1
#$ -N  colabfold
#$ -wd  /cluster/scratch8b/Ana_HV/colabfold
#$ -V
#$ -l gpu=true
#$ -R y

source /share/apps/anaconda/bin/activate /home/alankina/.conda/envs/cfold


colabfold_batch . ./res 



