clear
clc

mkdir MigrationsDaily
addpath /home/ppoli/CorrelationTAserver/gismotools-read-only/GISMO
startup_GISMO
addpath /home/ppoli/CorrelationTAserver/matlab
%addpath /Users/pieropoli/GISMO_r362/GISMO
%startup_GISMO
%addpath /Users/pieropoli/CorrelationTAserver/matla
%% grid ...
dgrid =.5;
X = -76:dgrid :-72;
Y = -48 : dgrid : -44;

Vgrid=3.5;
wingrid = .1;
inpdir ='/Users/pieropoli/Autmoatic_Parsing_Downloading_Events/TremorAnalysis/CorrelationsCodes/test';

dday = 1;

D = dir(char(inpdir));

for day = 5%:99;
    countcorr = 1;
    
    
    for i2 = 3 : length(D)
        i2/length(D)
        %% load data
        inpdir2 = [char(inpdir) '/' char(D(i2).name)];
        d = dir([char(inpdir2) '/julDay_' num2str(day) '.mat']);
        if i2 ==3
            gridout = zeros(length(Y),length(X));
        end

        
        if isempty(d)==0
            load([char(inpdir2) '/'  d(1).name])
            
            ctmp = get(C,'C1');
            t = -0.5*(length(get(C,'c1'))-1)/get(C,'freq') : 1/get(C,'freq') : 0.5*(length(get(C,'c1'))-1)/get(C,'freq');
            countcorr = countcorr + 1;
            
            ctmp = mean(ctmp,1);
            
            
            
            %% grid travel time
            for ix = 1 : length(X)
                
                for iy = 1 : length(Y)
                    d1 = distance(Y(iy),X(ix),get(C,'WBLA'),get(C,'WBLO'));
                    d2 = distance(Y(iy),X(ix),get(C,'WALA'),get(C,'WALO'));
                    t1 = deg2km(d1)/Vgrid;
                    t2 = deg2km(d2)/Vgrid;
                    dt = t1-t2;
                    F =find(t>(dt-wingrid)&t<(dt+wingrid));
                    Cs = sum(abs(ctmp(F)),2);
                    gridout(iy,ix) = (gridout(iy,ix) + Cs);
                    clear F
                    
                end
                
            end
            
            clear ctmp
            
        end
    end
    
    v = get(C,'winstart');
    eval(['save MigrationsDaily/migration_Correlation' num2str(day) '.mat gridout countcorr X Y v;'])
    
    clear gridout v
    
end
