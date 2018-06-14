

This script will first calculate, for each nucleotide position, the %GC of the surrounding nucleotid sequence according to the window size.
        For the first nucleotid, half of the window size will be taken from the end of the sequence, because this script has been developped for cicular genoms.
        Then, i will print a value of % each "step" nucleotides


Input file must look like :

    \>my_sequence  
    ATGTGGCTTCGCTTGCTCTCGCTTCG
    ATGTGGCTTCGCTTGCTCTCGCTTCG

#Usage

    perl gc_content.pl --fasta genome.fasta [--window 1000] [--step 100] [--log] [--help] 
    
    
    arguments details :
    --fasta   one fasta file that can contain multiple sequences. In that case the script will produce as many output files as input sequences. Each sequence can be multiline.
    --window  optional. Window size, even number ONLY. Sets the number of nucleotides used to calculate the %GC value of each position. Default 1000
    --step  optional. step size. The output will contain a sliding GC% value every "step" nucleotides. The numbers of values you get is therefore (length genome)/(step). Default 100
    --log   optional. for debugging purposes only
    --help   optional. Shows this help

#Output files

genome.fasta.gc_content
    
    column 1: "chr1" for convenience when the program is used to create an input for Circos (http://www.circos.ca/) 
    column 2: start position of interval
    column 3: end position of interval 
    column 4: GC% of the interval 
    
    example:
    chr1 1 100 0.499
    chr1 101 200 0.5
    chr1 201 300 0.5
    chr1 301 400 0.5
    chr1 401 500 0.5
    chr1 501 600 0.5
    chr1 601 700 0.499
    chr1 701 800 0.5

genome.fasta.gc_deviation

    column 1: "chr1" for convenience when the program is used to create an input for Circos (http://www.circos.ca/) 
    column 2: start position of interval
    column 3: end position of interval 
    column 4: GC deviation of the interval 
    
    example:
    chr1 1 100 0.162
    chr1 101 200 0.16
    chr1 201 300 0.16
    chr1 301 400 0.16
    chr1 401 500 0.16
    chr1 501 600 0.16
    chr1 601 700 0.162

