process manta {
    input:
    tuple val(sample_id), val(match_id), path(bam), path(bai), path(bam_match), path(bai_match)
    path reference_genome
    path fasta_index
    val ncpu_manta

    output:
    tuple val(sample_id), val(match_id), path(candidate_indels), path(candidate_indels_idx), path(bam), path(bai), path(bam_match), path(bai_match)

    script:
    candidate_indels = "manta_out/results/variants/candidateSmallIndels.vcf.gz"
    candidate_indels_idx = "manta_out/results/variants/candidateSmallIndels.vcf.gz.tbi"
    """
    mkdir manta_out
    ${projectDir}/bin/manta-1.6.0.centos6_x86_64/bin/configManta.py --normalBam ${bam_match} --tumorBam ${bam} --referenceFasta ${reference_genome} --runDir manta_out
    manta_out/runWorkflow.py -j ${ncpu_manta} -m local
    """
}