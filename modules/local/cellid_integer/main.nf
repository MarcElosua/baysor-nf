process CELLID_INTEGER {
    tag "$csv"

    conda "conda-forge::r-base=4.1.2"
    container "rocker/tidyverse:4.1.2"

    input:
    path csv

    output:
    path "*_mod.csv", emit: csv
    path "versions.yml"    , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script: // cellid_integer.R is bundled with the pipeline in the bin/ directory
    """
    cellid_integer.R $csv

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(r --version | sed 's/R //g')
    END_VERSIONS
    """
}