import numpy as np

#FASTA_FILE="./epitope_match/B_output.fasta"
#FASTA_FILE="./epitope_match/T_output.fasta"
FASTA_FILE="./epitope_match/MHC_output.fasta"
#FASTA_FILE="./epitope_match/epitopes_merlin_gB_clean.fasta"
with open(FASTA_FILE,'r') as f:
    _name, sequence = f.readline(), f.readline().strip()
    counts = np.array([0 for _ in sequence])
    while _name := f.readline():
        sequence = f.readline().strip()
        counts += np.array([1 if aa != '-' else 0 for aa in sequence])
    print(counts)
    
    # TODO Build plot from this

    import matplotlib.pyplot as plt

    plt.figure(figsize=(10, 5))
    plt.bar(range(len(counts)), counts, color='green')
    plt.ylim(top=20)
    plt.xlabel('Amino Acid Position')
    plt.ylabel('Number of Overlapping Epitopes')
    plt.title('Overlap of Epitopes per Amino Acid Residue (MHC)')
    plt.savefig('./epitope_match/MHC_epitopes.png', bbox_inches='tight')
    plt.show()

