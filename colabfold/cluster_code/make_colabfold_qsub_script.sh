# runs colabfold for a set of .fasta files in this directory


# runtime vars
install_colabfold=false
working_dir=/cluster/scratch8b/Ana_HV/colabfold

# activate conda

source /share/apps/anaconda/bin/activate

if [ "$install_colabfold" = true ] ; then
	# ref: https://github.com/sokrypton/ColabFold
	conda create --name cfold python=3.7
	source /share/apps/anaconda/bin/activate /home/alankina/.conda/envs/cfold
	pip install "colabfold[alphafold] @ git+https://github.com/sokrypton/ColabFold"
	pip install -q "jax[cuda]>=0.3.8,<0.4" -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html
	# For template-based predictions also install kalign and hhsuite
	conda install -c conda-forge -c bioconda kalign2=2.04 hhsuite=3.3.0
	# For amber also install openmm and pdbfixer
	conda install -c conda-forge openmm=7.5.1 pdbfixer
fi



# qrsh -l tmem=10G,h_vmem=10G -pe smp 4  # thats mem per thread, and per gpu.
# qrsh -l tmem=14G,gpu=true,h_rt=0:30:0 -pe gpu 1



echo "



#!/bin/bash -l
#$ -S /bin/bash
#$ -o ${working_dir}/out
#$ -e ${working_dir}/error
#$ -l h_rt=2:00:00
#$ -l tmem=14G
#$ -pe gpu 1
#$ -N  colabfold
#$ -wd  ${working_dir}
#$ -V
#$ -l gpu=true
#$ -R y

source /share/apps/anaconda/bin/activate /home/alankina/.conda/envs/cfold


colabfold_batch . ./res 


" > ${working_dir}/run.sh
