# rem-diff-len 

A small Julia program that removes too short and too long amino acid  sequences compared with 'query sequence'. 

## Dependencies

* Julia (Version 1.6.3 or more) 

## Input file format 

TOML file that is in this repository.  

Required parameters: 

1. Input filename 
2. Output filename 
3. Title line of the 'query sequence' (See more details in the TOML file) 
4. Lower sequence length threshold (See more details in the TOML file) 
5. Upper sequence length threshold (See more details in the TOML file) 

Also, the input sequence data must be in non-aligned Multi-FASTA format. 

[e.g.]

```

# Remove too short and long sequences to the query sequence in Multi-FASTA file.

[file]

# Input filename in Multi-FASTA format.
# [e.g.] filename = "ace2_human_blast.fasta"
# NOTE : Please remove double quotation marks in the input filename as it induces error in TOML file reading.
[file.input]
name = "input.fasta"

# Output filename .
# [e.g.] filename = "output.fasta"
# NOTE : Please remove double quotation marks in the output filename as it induces error in TOML file reading.
[file.output]
name = "output.fasta"

# The title line of the query sequence.
# [e.g.] title = ">sp|Q9BYF1|ACE2_HUMAN Angiotensin-converting enzyme 2 OS=Homo sapiens OX=9606 GN=ACE2 PE=1 SV=2"
# NOTE : Please remove double quotation marks in the query sequence title as it induces error in TOML file reading.
[query]
title = ">sp|P01939|HBA2_OTOCR Hemoglobin subunit alpha-B OS=Otolemur crassicaudatus OX=9463 GN=HBAB PE=1 SV=3"

[threshold]

# Lower sequence length threshold that is removed (probability).
# [e.g.] If 0.8, sequences that are less than 80% in their length compared to the query sequence are removed.
[threshold.short]
value = 0.5

# Upper sequence length threshold that is removed (probability).
# [e.g.] If 1.5, sequences that are more than 150% in their length compared to the query sequence are removed.
[threshold.long]
value = 1.5

``` 

## Output file format 

Multi-FASTA format.
