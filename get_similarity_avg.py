import sys
import pandas as pd
import numpy as np

matrix_table = sys.argv[1]

def get_avg(tsv_file):
    with open(tsv_file,'r') as matrix_file:
        matrix_df = pd.read_csv(matrix_file,sep='\t',index_col=0)
        matrix_df.replace(1,np.nan,inplace=True)
        mean_df = matrix_df.mean()
        mean_df_list = mean_df.tolist()
        matrix_file.close()
    global average_similarity
    average_similarity = "{:.3f}".format(sum(mean_df_list)/len(mean_df_list))

get_avg(matrix_table)
print(f"avg matrix distance: {average_similarity}")