# Data analysis

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

## Velvet:

### Contigs file

=> Contains the sequences of the contigs longer than 2k.

### Stats file

=> Description of the nodes, information about each contig in the assembly, coverage information for each contig:

- node length: given in k-mer. To obtain the length of the node in nucleotides, add k-1. 
- short1_cov: in k-mer coverage -> coverage information for each contig.

## QUAST, QUality ASsessment Tool

In each file named "report", and for each kmer value, we have:

- Statistics about the quality of the assembly:
  
      - N50: length of the shortest contig for which longer and equal contig lengths cover at least 50% of the assembly. The highest the better.
      - N90: same as N50, but covering at least 90% of the assembly (minimum contig length to cover at least 90% of the assembly).
      - L50: smallest number of contigs whose length sum covers half of the assembly.
  
- Missassembly statistics
- Unaligned regions in the assembly
- Mismatches compared to the reference genome
- Statistics about the assembly: 