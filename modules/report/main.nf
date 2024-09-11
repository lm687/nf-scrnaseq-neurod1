process REPORT {
    label 'process_medium'
    container "library://mamie_wang/nf-scrnaseq/postprocessing.sif:latest"
    containerOptions "--bind ${params.mount}"
    publishDir "${params.outdir}/report/", mode: 'copy'

    input:
    val name
    path postprocessing_h5ad
    path celltypist_scvi_h5ad

    output:
    path "${name}_report.ipynb", emit: report_ipynb
    path "${name}_report.html", emit: report_html

    script:
    """
    export HOME=\$PWD
    python -m ipykernel install --user --name postprocessing
    papermill ${baseDir}/bin/QC.ipynb ${name}_report.ipynb -p plots ${params.report.plots}
    jupyter nbconvert --to html ${name}_report.ipynb
    """
}
