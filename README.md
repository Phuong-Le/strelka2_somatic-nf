# strelka2_somatic-nf


For Sanger users 

```
module load nextflow-23.10.0 

working_dir=/path/to/outdir
samplesheet=/path/to/test_samplesheet.tsv
reference_genome=/path/to/genome.fa
fasta_index=/path/to/genome.fa.fai
ncpu_manta=16
ncpu_strelka=16
outdir=$working_dir
config_file=/path/to/sanger_lsf.config # this should be part of this pipeline

script=/path/to/main.nf # this should be part of this pipeline

bsub -cwd $working_dir -q normal -o %J.o -e %J.e -R'span[hosts=1] select[mem>1000] rusage[mem=1000]' -M1000 \
    "nextflow run ${script} -c ${config_file} --samplesheet ${samplesheet} --reference_genome ${reference_genome} --fasta_index ${fasta_index} --outdir ${outdir} --ncpu_manta ${ncpu_manta} --ncpu_strelka ${ncpu_strelka}"
```

samplesheet should be either csv or tsv, with columns as per "[demo/test_samplesheet.csv](https://github.com/Phuong-Le/strelka2_somatic-nf/tree/main/demo)"