#still need to create a conda environment including channels for bioconda conda-forge and biobuilds 
#along with installing fastx_toolkit and flash2 (using bioconda)

NUMBER=['JH2_dCN_dCC_hTET1CD_320796w_NG5']

rule all:
    input:
        "test.fq"

rule flash2_input:
    input:
        expand("{name}.fq", name=NUMBER)
    output:
        expand("{name}_flash2", name=NUMBER)
    shell:
        "flash2 -M 260 --interleaved-input {input} -o {output}"

rule bol_splitter:
    input: 
        expand("{name}_flash2.extendedFrags.fastq", name=NUMBER)
    output:
        expand("{name}_bolunmatched.txt", name=NUMBER)
    shell:
        "cat {input} | fastx_barcode_splitter.pl --bcfile bol.txt --bol --mismatches 1 --prefix JH_test_bol --suffix ".txt""

rule eol_splitter:
    input:
        expand("{name}_flash2.extendedFrags.fastq", name=NUMBER)
    output:
        expand("{name}_bolunmatched.txt", name=NUMBER)
    shell:
        "cat JH_test_bolunmatched.txt | fastx_barcode_splitter.pl --bcfile eol.txt --eol --mismatches 1 --prefix JH_test_eol --suffix ".txt""

rule bol_eol_merge:
    input:
        expand("{name}_bolunmatched.txt", name=NUMBER)
    output:
        expand("{name}_bolunmatched.txt", name=NUMBER)
    shell:
        "cat JH_test_bolunmatched.txt JH_test_eolunmatched.txt > test.fq"
