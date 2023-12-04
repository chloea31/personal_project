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
  
      - N50: length of the shortest contig for which longer and equal contig lengths cover at least 50% of the assembly. The highest the better, as we can see on the graph N50 according to kmer length. For this N50 value, we have a genome fraction over 90% (highest value).
      - N90: same as N50, but covering at least 90% of the assembly (minimum contig length to cover at least 90% of the assembly). The highest the better (highest N90 value for the highest N50 one).
      - L50: smallest number of contigs whose length sum covers half of the assembly. The smallest the better (value of 2 for kmer = 55, highest for kmer value > 55 for kmer value < 55).
  
- Misassembly statistics: the smallest the better (3 for kmer = 55 and the majority of kmer values, 2 for kmer = 31 and 67).
- Unaligned regions in the assembly: the smallest the better (0 for kmer = 55 and for the majority of kmer values).
- Mismatches compared to the reference genome: one of the smallest values (7.87 mismatches per 100 kbp) for kmer = 55 (similar values for kmer = 31 and kmer = 35).
- Statistics about the assembly: 