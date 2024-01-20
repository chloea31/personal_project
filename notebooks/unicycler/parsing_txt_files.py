#!/usr/bin/python3

import pandas as pd

with open("../../reports/unicycler/QC/illumina_f_fastqc/illumina_f_fastqc/fastqc_data.txt", "r") as f:
    data = None
    for row in f:
        #if row.startswith(">>Sequence Length Distribution"):
            #print(row)
        new_row = row.rstrip("\n").replace("\t", ",")
        #print(row_splited)
        if "Sequence Length Distribution" in new_row:
            data = []
        elif data is not None:
            if ">>END_MODULE" in new_row:
                break
            else:
                data.append(new_row.split(","))
    #print(data)

df = pd.DataFrame(data).rename(columns = {0:"#Length", 1:"Count"}) # or (data[1:], columns = data[0])
df = df[1:]
print(df)

df.to_csv("../../reports/unicycler/QC/illumina_f_fastqc/illumina_f_fastqc/illumina_f_seq_length_dist.csv", sep = ",", index = False)
