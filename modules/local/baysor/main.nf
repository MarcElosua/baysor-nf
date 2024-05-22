process BAYSOR {
    tag "$csv"

    // conda "conda-forge::r-base=4.1.2"
    container "vpetukhov/baysor:latest"

    input:
    path csv

    output:
    path "baysor-segmentation-mod.csv", emit: csv
    path "versions.yml",                emit: versions

    when:
    task.ext.when == null || task.ext.when

    script: // baysor is a julia based package
    """
    ~/.julia/bin/baysor run -x x_location \
        -y y_location \
        -z z_location \
        -s 0.5 \
        -g feature_name \
        -m 5 \
        -p \
        --count-matrix-format tsv \
        --save-polygons GeoJSON \
        --prior-segmentation-confidence 0.5 $csv :cell_int \
        --output baysor-segmentation.csv

    # Use sed to replace ",," with ",0,"
    sed 's/,,/,0,/g' baysor-segmentation.csv > baysor-segmentation-mod.csv

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(baysor --version | sed 's/R //g')
    END_VERSIONS
    """
}