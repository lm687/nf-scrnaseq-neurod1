process CELLBENDER {
    label 'gpus'
    container 'us.gcr.io/broad-dsde-methods/cellbender:latest'
    containerOptions '--nv'
    publishDir "${params.outdir}/cellbender/", mode: 'copy'

    input:
    tuple val(name), path(raw_path), val(filtered_path), val(demultiplexing), val(expected_droplets)

    output:
    val "${name}", emit: name
    path "${name}_cellbender.h5", emit: raw_h5
    val "${filtered_path}", emit: filtered_path
    val "${demultiplexing}", emit: demultiplexing
    //val "${total_droplets_included}", emit: total_droplets_included

    script:
    def gpu_index = task.index % params.maxForks
    if(task.executor == 'singularity')
        """
        export CUDA_VISIBLE_DEVICES=$gpu_index
        python ${baseDir}/bin/run_cellbender.py \
            --raw_h5 ${raw_path} \
            --output_h5 ${name}_cellbender.h5 \
            --total_droplets_included ${params.cellbender.total_droplets_included} \
            --filtered ${filtered_path}
        """
    else
        """
        python ${baseDir}/bin/run_cellbender.py \
            --raw_h5 ${raw_path} \
            --output_h5 ${name}_cellbender.h5 \
            --total_droplets_included ${params.cellbender.total_droplets_included} \
            --filtered ${filtered_path}
        """
}
