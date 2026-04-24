#!/bin/bash
##SBATCH --mail-type=ALL                    #Mail events (NONE, BEGIN, END, FAIL, ALL)
##SBATCH --mail-user=qxf20ddu@uea.ac.uk           # Where to send mail - change <username> to your  userid
#SBATCH -p compute-64-512                          #Which queue to use
#SBATCH -t 36:00:00                               # Set time limit to 36 hours
#SBATCH --job-name=gr_snps_plink_ldpruned_50100.1_plink_pca        #Job name
#SBATCH --mem 16G
#SBATCH -o gr_snps_plink_ldpruned_50100.1_plink_pca.out                    #Standard output log
#SBATCH -e gr_snps_plink_ldpruned_50100.1_plink_pca.err                     #Standard error log

module add plink/1.90

# perform linkage pruning - i.e. identify prune sites
plink --vcf /gpfs/home/qxf20ddu/Tribolium_files/T_cas_vcf/bcftools_Tribolium_castaneum.Tcas5.2.dna_sm.toplevel__genetic_rescue__20230926.SNPs.vcf.gz --double-id --allow-extra-chr \
--set-missing-var-ids @:# \
--indep-pairwise 50 10 0.1 --out gr_tcas

# prune and create pca
plink --vcf /gpfs/home/qxf20ddu/Tribolium_files/T_cas_vcf/bcftools_Tribolium_castaneum.Tcas5.2.dna_sm.toplevel__genetic_rescue__20230926.SNPs.vcf.gz --double-id --allow-extra-chr --set-missing-var-ids @:# \
--extract gr_tcas.prune.in \
--make-bed --pca --out gr_tcas
