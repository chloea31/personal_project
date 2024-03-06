# Analysis of data from genome assembly using SPAdes

![alt text](work_spades.png)

We considered data used previously for Velvet assembly:
- mutant_R1.fastq
- mutant_R2.fastq

Thus, the first parts of the analysis remain the same:

## FASTQC:

### Per base sequence quality

All boxplots of the set of sequencing quality values in the green zone 

=> Good quality of the reads. The quality of sequencing decreases across the length of the reads.

### Per sequence quality score

Curve on the right, with good mean of Phred scores

=> Good sequencing quality

### Per sequence GC content:

GC count per read in accordance to theoretical distribution => No contamination.

### Sequence duplication level:

High % of duplication (around 89.3%) => DNA

## SPAdes assembly
