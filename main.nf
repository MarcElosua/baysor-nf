#!/usr/bin/env nextflow

include { FILTER_TRANSCRIPTS } from './modules/local/filter_transcripts'
include { CELLID_INTEGER     } from './modules/local/cellid_integer'
include { BAYSOR             } from './modules/local/baysor'
include { MAP_TRANSCRIPTS    } from './modules/local/map_transcripts'

workflow {

    ch_input = file(params.input)

    FILTER_TRANSCRIPTS (
        ch_input
    )

    CELLID_INTEGER (
        FILTER_TRANSCRIPTS.out.csv
    )

    BAYSOR (
        CELLID_INTEGER.out.csv
    )

    MAP_TRANSCRIPTS (
        BAYSOR.out.csv
    )
} 