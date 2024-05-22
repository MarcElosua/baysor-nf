process FILTER_TRANSCRIPTS {
    tag "$csv"

    conda "conda-forge::python=3.9.5"
    container "biocontainers/python:3.9--1"

    input:
    path csv

    output:
    path "*transcripts.csv", emit: csv
    path "versions.yml"    , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script: // filter_transcripts.py is bundled with the pipeline in the bin/ directory
    """
    filter_transcripts.py \\
        -transcript $csv \\
        -out .

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version | sed 's/Python //g')
    END_VERSIONS
    """
}