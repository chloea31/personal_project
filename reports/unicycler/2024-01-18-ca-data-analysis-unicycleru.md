# Data analysis Unicycler

## FastQC

Sequence length between 35 and 251 bp.

### Per base sequence quality

- Base quality score according to their position in the read.
    - illumina_f: boxplots in the green part => good base quality. The value dispersion is higher for the last boxplot, also a little bit lower that the others, probably due to the fact that the sequencing quality decreases at the end of the reads.
    - illumina_r: boxplots in the green part => good base quality. Boxplots in the orange and red part => base quality decreases, probably due to the fact that the sequencing quality decreases at the end of the reads.
    - minion_2d: boxplots in the red part => bad base quality. No boxplots for positions in the read between 17,500 and 24,999 bp, probably due to the fact that there would not be any base at these positions.
- 