#!/bin/bash
##SBATCH --mail-type=ALL                    #Mail events (NONE, BEGIN, END, FAIL, ALL)
##SBATCH --mail-user=qxf20ddu@uea.ac.uk           # Where to send mail - change <username> to your  userid
#SBATCH -p compute-64-512                          #Which queue to use
#SBATCH -t 36:00:00                               # Set time limit to 36 hours
#SBATCH --job-name=het        #Job name
#SBATCH --mem 16G
#SBATCH -o het.out                    #Standard output log
#SBATCH -e het.err                     #Standard error log

module load vcftools

vcftools \
--gzvcf /gpfs/home/qxf20ddu/Tribolium_files/T_cas_vcf/bcftools_Tribolium_castaneum.Tcas5.2.dna_sm.toplevel__genetic_rescue__20230926.SNPs.vcf.gz \
--het \
--out bcftools_Tribolium_castaneum.Tcas5.2.dna_sm.toplevel__genetic_rescue__20230926.SNPs_vcftools.het


