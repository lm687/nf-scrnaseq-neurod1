process FINALFILTER {
    label 'process_medium'
    container 'library://mamie_wang/nf-scrnaseq/postprocessing.sif:latest'
    publishDir "${params.outdir}/outlier_filtered/", mode: 'copy'

    input:
    val name
    path aggregation_h5ad

    output:
    val "${name}finalfilter", emit: name
    path "${name}_finalfiltered.h5ad", emit: outlier_filtered2_h5ad

    script:
    """
    export NUMBA_CACHE_DIR=\$PWD
    python ${baseDir}/bin/finalfilter.py \
        ${aggregation_h5ad} \
        ${name}_finalfiltered.h5ad
    """
}
