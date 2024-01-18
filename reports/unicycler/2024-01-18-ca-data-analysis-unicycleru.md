# Data analysis Unicycler

## FastQC

Sequence length between 35 and 251 bp.

### Per base sequence quality

- Base quality score according to their position in the read:
    - illumina_f: boxplots in the green part => good base quality. The value dispersion is higher for the last boxplot, also a little bit lower that the others, probably due to the fact that the sequencing quality decreases at the end of the reads.
    - illumina_r: boxplots in the green part => good base quality. Boxplots in the orange and red part => base quality decreases, probably due to the fact that the sequencing quality decreases at the end of the reads.
    - minion_2d: boxplots in the red part => bad base quality. No boxplots for positions in the read between 17,500 and 24,999 bp, probably due to the fact that there would not be any base at these positions.

### Per sequence quality scores

- Quality score distribution:
    - illumina_f: the more the curve is shifted to the left, the lower the sequence quality => good sequencing quality.
    - illumina_r: => good sequencing quality.
    - minion_2d: => poor sequencing quality.

### Per sequence GC content

- %GC distribution in all the reads:
A too high %GC might indicate a bad data quality. 
You might want to use this graph to detect a potential contamination by a sample from another specie.
    - illumina_f:  
    - illumina_r:
    - minion_2d:  
