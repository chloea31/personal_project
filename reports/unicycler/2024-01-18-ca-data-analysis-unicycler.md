# Data analysis Unicycler

Hybrid (both short and long reads) assembly of small genomes (bacteria, virus, organellar).

## FastQC

Maximum Illumina read length: 250 bp.

Maximum Nanopore read length: 27,518 bp. 

### Per base sequence quality

Base quality score according to their position in the read:
- illumina_f: boxplots in the green part => good base quality. The value dispersion is higher for the last boxplot, also a little bit lower that the others, probably due to the fact that the sequencing quality decreases at the end of the reads.
- illumina_r: boxplots in the green part => good base quality. Boxplots in the orange and red part => base quality decreases, probably due to the fact that the sequencing quality decreases at the end of the reads.
- minion_2d: boxplots in the red part => bad base quality. No boxplots for positions in the read between 17,500 and 24,999 bp, probably due to the fact that there would not be any base at these positions.

### Per sequence quality scores

Quality score distribution:
- illumina_f: the more the curve is shifted to the left, the lower the sequence quality => good sequencing quality.
- illumina_r: => good sequencing quality.
- minion_2d: => poor sequencing quality.

### Per sequence GC content

%GC distribution in all the reads:

A too high %GC might indicate a bad data quality. 
You might want to use this graph to detect a potential contamination by a sample from another specie.

- illumina_f: => no contamination  
- illumina_r: => no contamination
- minion_2d: => no contamination

### Sequence length distribution

- illumina_f: sequences do not have the same length => data after adapter trimming
- illumina_r: same as illumina_f
- minion_2d: same as illumina_f

### Sequence duplication level

- illumina_f: high sequence duplication level (>80%) => DNA
- illumina_r: high sequence duplication level (>80%) => DNA
- minion_2d: high sequence duplication level (>80%) => DNA

### Hybrid assembly (Unicycler)


