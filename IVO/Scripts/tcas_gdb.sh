#!/bin/bash
#SBATCH -N 1
#SBATCH -o /gpfs/home/qxf20ddu/SIFT4G_tests/SIFT4G_Create_Genomic_DB/2_test/Tcas.sh.otxt
#SBATCH -e /gpfs/home/qxf20ddu/SIFT4G_tests/SIFT4G_Create_Genomic_DB/2_test/Tcas.sh.etxt
#SBATCH -p "compute-64-512"
#SBATCH -J Tcas
#SBATCH -t 48:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=qxf20ddu@uea.ac.uk
#SBATCH --mem=80000
#SBATCH -c 8

module add SIFT4G/2.0.0

make-SIFT-db-all.pl -config /gpfs/home/qxf20ddu/SIFT4G_tests/SIFT4G_Create_Genomic_DB/2_test/tribolium_castaneum_config.txt
