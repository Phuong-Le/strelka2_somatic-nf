#!/usr/bin/env nextflow 

// enable DSL 2
nextflow.enable.dsl=2

// all of the default parameters are set in `nextflow.config`

// include functions
include { validateParameters; paramsHelp; paramsSummaryLog; samplesheetToList } from 'plugin/nf-schema'
include { manta } from "$projectDir/modules/manta.nf"
include { strelka } from "$projectDir/modules/strelka.nf"


// Validate input parameters
validateParameters()

// print help message, with typical command line usage
if (params.help) {
  def String command = """nextflow run strelka2-somatic-nf \\
    --samplesheet /path/to/samplesheet.csv \\
    --reference_genome /path/to/genome.fa \\
    --outdir /path/to/output/directory/""".stripIndent()
  log.info paramsHelp(command)
  exit 0
}


workflow {
  // print summary of supplied parameters
  log.info paramsSummaryLog(workflow)

  // get data
  samples_ch = Channel.fromList(samplesheetToList(params.samplesheet, "$projectDir/assets/samplesheet_schema.json"))
      .map { it -> tuple(it[0].sample_id, it[0].match_id, it[0].bam, it[0].bai, it[0].bam_match, it[0].bai_match) }

  manta(samples_ch, params.reference_genome, params.fasta_index, params.ncpu_manta)

  strelka(manta.out, params.reference_genome, params.fasta_index, params.ncpu_strelka)

}