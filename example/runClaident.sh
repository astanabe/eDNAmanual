#demultiplexing
clsplitseq \
--runname=RunID \
--forwardprimerfile=forwardprimer.fasta \
--reverseprimerfile=reverseprimer.fasta \
--truncateN=enable \
--index1file=index1.fasta \
--index2file=index2.fasta \
--minqualtag=30 \
--compress=xz \
--seqnamestyle=illumina \
--numthreads=4 \
01_undemultiplexed/Undetermined_S0_L001_R1_001.fastq.gz \
01_undemultiplexed/Undetermined_S0_L001_I1_001.fastq.gz \
01_undemultiplexed/Undetermined_S0_L001_I2_001.fastq.gz \
01_undemultiplexed/Undetermined_S0_L001_R2_001.fastq.gz \
02_demultiplexed

#concatenation
clconcatpairv \
--mode=ovl \
--compress=xz \
--numthreads=4 \
02_demultiplexed \
03_concatenated

#filtering
clfilterseqv \
--maxqual=41 \
--minlen=100 \
--maxlen=250 \
--maxnee=2.0 \
--maxnNs=0 \
--compress=xz \
--numthreads=4 \
03_concatenated \
04_filtered

#denoising
cldenoiseseqd \
--pool=pseudo \
--numthreads=4 \
04_filtered \
05_denoised

#de novo chimera removal
clremovechimev \
--mode=denovo \
--uchimedenovo=3 \
05_denoised \
06_chimeraremoved

#clustering internal standards
clclusterstdv \
--standardseq=standard.fasta \
--minident=0.9 \
--numthreads=4 \
06_chimeraremoved \
07_stdclustered

#chimera removal using reference
clremovechimev \
--mode=ref \
--referencedb=cdu12s \
--addtoref=07_stdclustered/stdvariations.fasta \
--numthreads=4 \
07_stdclustered \
08_chimeraremoved

#eliminating index-hopping
clremovecontam \
--test=thompson \
--ignoresamplelist=blanklist.txt \
--index1file=index1.fasta \
--index2file=index2.fasta \
--numthreads=4 \
08_chimeraremoved \
09_hoppingremoved

#decontamination
clremovecontam \
--test=thompson \
--blanklist=blanklist.txt \
--stdconctable=stdconctable.tsv \
--solutionvoltable=solutionvoltable.tsv \
--watervoltable=watervoltable.tsv \
--numthreads=4 \
09_hoppingremoved \
10_decontaminated

#making directory for taxonomic assignment
mkdir 11_taxonomy

#making cache db
clmakecachedb \
--blastdb=animals_mt_species_wsp \
--ignoreotuseq=standard.fasta \
--numthreads=4 \
10_decontaminated/decontaminated.fasta \
11_taxonomy/cachedb_species_wsp

#retrieving neighborhoods based on QCauto method
clidentseq \
--method=QC \
--blastdb=11_taxonomy/cachedb_species_wsp \
--ignoreotuseq=standard.fasta \
--numthreads=4 \
10_decontaminated/decontaminated.fasta \
11_taxonomy/neighborhoods_qcauto_species_wsp.txt

#taxonomic assignment based on QCauto method
classigntax \
--taxdb=animals_mt_species_wsp \
11_taxonomy/neighborhoods_qcauto_species_wsp.txt \
11_taxonomy/taxonomy_qcauto_species_wsp.tsv

#retrieving neighborhoods based on 95%-3NN method
clidentseq \
--method=3,95% \
--blastdb=11_taxonomy/cachedb_species_wsp \
--ignoreotuseq=standard.fasta \
--numthreads=4 \
10_decontaminated/decontaminated.fasta \
11_taxonomy/neighborhoods_95p3nn_species_wsp.txt

#taxonomic assignment based on 95%-3NN method
classigntax \
--taxdb=animals_mt_species_wsp \
--minnsupporter=1 \
11_taxonomy/neighborhoods_95p3nn_species_wsp.txt \
11_taxonomy/taxonomy_95p3nn_species_wsp.tsv

#making identdb of QCauto method
clmakeidentdb \
--append \
11_taxonomy/neighborhoods_qcauto_species_wsp.txt \
11_taxonomy/qcauto_species_wsp.identdb

#making identdb of 95%-3NN method
clmakeidentdb \
--append \
11_taxonomy/neighborhoods_95p3nn_species_wsp.txt \
11_taxonomy/95p3nn_species_wsp.identdb

#merging taxonomic assignment results of QCauto and 95%-3NN methods
clmergeassign \
--preferlower \
--priority=descend \
11_taxonomy/taxonomy_qcauto_species_wsp.tsv \
11_taxonomy/taxonomy_95p3nn_species_wsp.tsv \
11_taxonomy/taxonomy_merged.tsv

#fullfilling taxonomic assignment table
clfillassign \
--fullfill=enable \
11_taxonomy/taxonomy_merged.tsv \
11_taxonomy/taxonomy_merged_filled.tsv

#making directory for otu composition tables
mkdir 12_community

#copying full table
cp \
10_decontaminated/decontaminated.tsv \
12_community/sample_otu_matrix_all.tsv

#extracting internal standards
clfiltersum \
--otuseq=standard.fasta \
12_community/sample_otu_matrix_all.tsv \
12_community/sample_otu_matrix_standard.tsv

#extracting fish otus
clfiltersum \
--negativeotuseq=standard.fasta \
--taxfile=11_taxonomy/taxonomy_merged_filled.tsv \
--includetaxa=class,Hyperoartia,class,Myxini,class,Chondrichthyes \
--includetaxa=superclass,Actinopterygii,order,Coelacanthiformes \
--includetaxa=subclass,Dipnomorpha \
12_community/sample_otu_matrix_all.tsv \
12_community/sample_otu_matrix_fishes.tsv

#extracting non-fish otus
clfiltersum \
--negativeotuseq=standard.fasta \
--taxfile=11_taxonomy/taxonomy_merged_filled.tsv \
--excludetaxa=class,Hyperoartia,class,Myxini,class,Chondrichthyes \
--excludetaxa=superclass,Actinopterygii,order,Coelacanthiformes \
--excludetaxa=subclass,Dipnomorpha \
12_community/sample_otu_matrix_all.tsv \
12_community/sample_otu_matrix_nonfishes.tsv

#extracting fish otu names
head -n 1 12_community/sample_otu_matrix_fishes.tsv \
| perl -ne '@row=split(/\t/);shift(@row);print(join("\n",@row)."\n");' \
> 12_community/fishotus.txt

#extracting non-fish otus
clfiltersum \
--negativeotuseq=standard.fasta \
--negativeotulist=12_community/fishotus.txt \
12_community/sample_otu_matrix_all.tsv \
12_community/sample_otu_matrix_nonfishes2.tsv

#performing rarefaction
clrarefysum \
--minpcov=0.99 \
--minntotalseqsample=1000 \
--nreplicate=10 \
--numthreads=4 \
12_community/sample_otu_matrix_all.tsv \
12_community/sample_otu_matrix_all_rarefied

#extracting internal standards of rarefied tables
for n in `seq -w 1 10`
do clfiltersum \
--otuseq=standard.fasta \
12_community/sample_otu_matrix_all_rarefied-r$n.tsv \
12_community/sample_otu_matrix_standard_rarefied-r$n.tsv
done

#extracting fish otus of rarefied tables
for n in `seq -w 1 10`
do clfiltersum \
--negativeotuseq=standard.fasta \
--taxfile=11_taxonomy/taxonomy_merged_filled.tsv \
--includetaxa=class,Hyperoartia,class,Myxini,class,Chondrichthyes \
--includetaxa=superclass,Actinopterygii,order,Coelacanthiformes \
--includetaxa=subclass,Dipnomorpha \
12_community/sample_otu_matrix_all_rarefied-r$n.tsv \
12_community/sample_otu_matrix_fishes_rarefied-r$n.tsv
done

#extracting non-fish otus of rarefied tables
for n in `seq -w 1 10`
do clfiltersum \
--negativeotuseq=standard.fasta \
--taxfile=11_taxonomy/taxonomy_merged_filled.tsv \
--excludetaxa=class,Hyperoartia,class,Myxini,class,Chondrichthyes \
--excludetaxa=superclass,Actinopterygii,order,Coelacanthiformes \
--excludetaxa=subclass,Dipnomorpha \
12_community/sample_otu_matrix_all_rarefied-r$n.tsv \
12_community/sample_otu_matrix_nonfishes_rarefied-r$n.tsv
done

#estimating DNA concentrations
clestimateconc \
--stdtable=12_community/sample_otu_matrix_standard.tsv \
--stdconctable=stdconctable.tsv \
--solutionvoltable=solutionvoltable.tsv \
--watervoltable=watervoltable.tsv \
--numthreads=4 \
12_community/sample_otu_matrix_fishes.tsv \
12_community/sample_otu_matrix_fishes_concentration.tsv

#estimating DNA concentrations of rarefied tables
for n in `seq -w 1 10`
do clestimateconc \
--stdtable=12_community/sample_otu_matrix_standard_rarefied-r$n.tsv \
--stdconctable=stdconctable.tsv \
--solutionvoltable=solutionvoltable.tsv \
--watervoltable=watervoltable.tsv \
--numthreads=4 \
12_community/sample_otu_matrix_fishes_rarefied-r$n.tsv \
12_community/sample_otu_matrix_fishes_rarefied-r$n\_concentration.tsv
done

#making species composition table based on number of reads
clsumtaxa \
--taxfile=11_taxonomy/taxonomy_merged_filled.tsv \
--targetrank=species \
--taxnamereplace=enable \
--fuseotu=enable \
--numbering=enable \
--sortkey=abundance \
12_community/sample_otu_matrix_fishes.tsv \
12_community/sample_species_matrix_fishes.tsv

#making species composition table based on DNA concentration
clsumtaxa \
--taxfile=11_taxonomy/taxonomy_merged_filled.tsv \
--targetrank=species \
--taxnamereplace=enable \
--taxranknamereplace=enable \
--fuseotu=enable \
--numbering=enable \
--sortkey=abundance \
12_community/sample_otu_matrix_fishes_concentration.tsv \
12_community/sample_species_matrix_fishes_concentration.tsv
