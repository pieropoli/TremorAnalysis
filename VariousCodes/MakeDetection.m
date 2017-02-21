clear
clc
close

datadir = '/Users/pieropoli/Autmoatic_Parsing_Downloading_Events/TremorAnalysis/chileS';
d=dir(datadir);
d(1:2)=[];
outdir = 'DetectionALLChile';
mkdir(outdir)

for i1 = 1 : length(d) 
    DetectionTremorSpectraFunc2([datadir '/' char(d(i1).name)],outdir,i1);
end