from typing import Dict, List
import numpy as np

FASTA_FILE="./epitope_match/epitopes_merlin_gB_clean.fasta"
#SEQ_FILE = "./epitope_match/gB_90_Tcell_list.csv"
#SEQ_FILE = "./epitope_match/gB_90_Bcell_list.csv"
SEQ_FILE = "./epitope_match/gB_90_MHC_list.csv"

fastas: Dict[str,str] = {}
sequences: List[str] = []
with open(FASTA_FILE,'r') as fasta_f:
    while name := fasta_f.readline().strip():
        epitope = fasta_f.readline().strip()
        fastas[name] = epitope 
    
with open(SEQ_FILE,'r') as sequence_f:
    while seq := sequence_f.readline().strip():
        sequences.append(seq)

def check_epitope(epitope: str, sequences: List[str]) -> bool:
    """ 
    Check if an epitope contains at least one of the sequences in sequences
    
    :param epitope: The epitope
    :param sequences: The list of sequences you will check against
    """
    for seq in sequences:
        if seq in epitope:
            return True
    return False

filtered_fatass = ''.join([f"{name}\n{epitope}\n" for name,epitope in fastas.items() if check_epitope(epitope,sequences)])

print(filtered_fatass)
with open("./epitope_match/MHC_output.fasta",'w') as fasta_f:
    fasta_f.write(filtered_fatass)

