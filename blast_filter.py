#!/usr/bin/python3
# -*- coding: utf-8 -*-
###############################>GENERAL-INFORMATIONS<###############################
"""
Build in Python 3.6

Author:
Filipe Dezordi
zimmer.filipe@gmail.com
https://github.com/dezordi
"""
###############################>LIBRARIES<###############################
import pandas as pd
import numpy as np
import argparse, csv, os
###############################>ARGUMENTS<###############################
parser = argparse.ArgumentParser(description = 'This script remove redundancy of blast output, based on qseqid, and a range of qstart and qend, the match with best bitscore is maintained, besides that, a column called sense its created to indicates the DNA sense of match.')
parser.add_argument("-in", "--input", help="BLAST output in format outfmt 6 with stdin plus qcovs qcovhsp", required=True)
args = parser.parse_args()
input_file = args.input
###############################>FUNCTIONS<###############################
def blast_filter(blast_result):
    """
    This function receives a blastx result and filter based on query ID and ranges of qstart and qend.

    Keyword arguments:
    blast_result = blastx result outfmt 6
    """

    header_outfmt6 = ['qseqid','sseqid','pident','length','mismatch','gapopen','qstart','qend','sstart','send','evalue','bitscore','qcovs','qcovhsp'] #creates a blast header output in format = 6
    df = pd.read_csv(blast_result, sep='\t',header = None,names = header_outfmt6).sort_values(by='bitscore',ascending = False) #convert the csv blast file in a dataframe
    df['sense'] = '' #creates a new column for sense of hit
    df.to_csv(blast_result+'.csv',sep='\t') #convert de dataframe in a csv file
    rows = list()
    with open(blast_result+'.csv','r') as csv_file: 
        csv_reader = csv.reader(csv_file, delimiter='\t')
        for row in csv_reader: #this loop verify the sense of match
            if row[0] == '':
                pass
            else:
                if float(row[9]) > float(row[10]):
                    row[15] = 'neg'
                    a = row[9]
                    b = row[10]
                    row[9] = b
                    row[10] = a
                else:
                    row[15] = 'pos'
            rows.append(row)
        with open(blast_result+'.csv.mod', 'w') as writeFile:
            writer = csv.writer(writeFile, delimiter='\t')
            writer.writerows(rows)
    csv_file.close()
    writeFile.close()
    pd.options.display.float_format = "{:,.2f}".format
    df = pd.read_csv(blast_result+'.csv.mod', sep='\t')
    df["evalue"] = pd.to_numeric(df["evalue"], downcast="float") #this line format the evalue as float, to avoid a representation by a large number pd.dataframe creates, for a limitation of ndarray, numbers fewer than -9223372036854775808 (np.iinfo(np.int64).min) are converted to 0.0
    '''
    The next three line is a trick used to remove redundant hits () in in 4 decimal places, in this case, as we are
    using a blast do recovery the viral signature in queries, that represent our genome, the filter is applied by
    query name and query start and end ranges, an example:
    INPUT:
    qseqid	sseqid	pident	length	mismatch	gapopen	qstart	qend	sstart	send	evalue	bitscore
    162	AAC97621	30.636	173	108	3	130612	130100	132	294	2.43e-08	69.7
    162	AAU10897	23.611	216	163	2	130717	130073	134	348	2.52e-10	75.3
    162	AOC55195	24.535	269	197	4	130864	130073	84	351	4.49e-11	77.8
    OUTPUT:
    qseqid	sseqid	pident	length	mismatch	gapopen	qstart	qend	sstart	send	evalue	bitscore	sense
    162	AOC55195	24.535	269	197	4	130073	130864	84	351	4.49e-11	77.8	-
    '''
    df['sstart_rng'] = df.sstart.floordiv(1000)
    df['send_rng'] = df.send.floordiv(1000)
    df_2 = df.drop_duplicates(subset=['sseqid','sstart_rng','sense']).drop_duplicates(subset=['sseqid','send_rng','sense']).sort_values(by=['sseqid'])
    df_3 = df_2[['qseqid','sseqid','pident','length','mismatch','gapopen','qstart','qend','sstart','send','evalue','bitscore','qcovs','qcovhsp','sense']]
    df_4 = df_3.loc[df_3['qcovhsp'] >= 80]
    out_csv = blast_result+'.filtred'
    df_4.to_csv(out_csv, sep='\t', index = False)
    os.remove(blast_result+'.csv')
    os.remove(blast_result+'.csv.mod')
    return(print(f'{blast_result} filtred!'))

if __name__ == '__main__':
    '''
    Main Routine
    This block of code is executed, whenever the script
    is started from the command line.
    '''
    blast_filter(input_file)