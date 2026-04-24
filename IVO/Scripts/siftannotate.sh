#!/bin/bash
#SBATCH -N 1
#SBATCH -o /gpfs/home/qxf20ddu/SIFT4G_tests/SIFT4G_Create_Genomic_DB/2_test/SA.otxt
#SBATCH -e /gpfs/home/qxf20ddu/SIFT4G_tests/SIFT4G_Create_Genomic_DB/2_test/SA.sh.etxt
#SBATCH -p "compute-64-512"
#SBATCH -J SA
#SBATCH -t 48:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=qxf20ddu@uea.ac.uk
#SBATCH --mem=80000
#SBATCH -c 8

java -jar SIFT4G_Annotator.jar -c -i bcftools_Tribolium_castaneum.Tcas5.2.dna_sm.toplevel__genetic_rescue__20230926.SNPs.vcf -d Tcas5.2/ -r vcfsift -t
