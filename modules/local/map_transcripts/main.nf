process MAP_TRANSCRIPTS {
    tag "$csv"

    conda "conda-forge::python=3.9.5"
    container "biocontainers/python:3.9--1"

    input:
    path csv

    output:
    path "*baysor-out",       emit: csv
    path "versions.yml",    emit: versions

    when:
    task.ext.when == null || task.ext.when

    script: // cellid_integer.R is bundled with the pipeline in the bin/ directory
    """
    map_transcripts.py -baysor $csv -out baysor-out

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version | sed 's/Python //g')
    END_VERSIONS
    """
}