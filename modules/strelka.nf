process strelka {
    publishDir "${params.outdir}"

    input:
    tuple val(sample_id), val(match_id), path(candidate_indels), path(candidate_indels_idx), path(bam), path(bai), path(bam_match), path(bai_match)
    path reference_genome
    path fasta_index
    val ncpu_strelka

    output:
    tuple val(sample_id), path(sample_outdir)

    script:
    sample_outdir = "${sample_id}"
    """
    mkdir ${sample_outdir}
    ${projectDir}/bin/strelka-2.9.10.centos6_x86_64/bin/configureStrelkaSomaticWorkflow.py --normalBam ${bam_match} --tumorBam ${bam} --referenceFasta ${reference_genome} --indelCandidates ${candidate_indels} --runDir ${sample_outdir}
    ${sample_outdir}/runWorkflow.py -j ${ncpu_strelka} -m local 
    """
}