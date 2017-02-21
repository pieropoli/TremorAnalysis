clear
clc
close

dir = '/Users/pieropoli/Autmoatic_Parsing_Downloading_Events/TremorAnalysis/CorrelationsCodes/CorrFB0.02-0.05';
out = loaddatafromdir(dir);



%% grid ...
dgrid =.05;
X = -75:dgrid :-73;
Y = -47 : dgrid : -45;

Vgrid=3.5;
wingrid = 1;


for day = 5;
    
    
    count = 0;
    for i1 = 1 : length(out)
        load([dir '/' out(i1).name '/julDay_' num2str(day) '.mat']);
         c = get(C,'C1');
        if i1 ==1
            gridout = zeros(size(c,1),length(Y),length(X));
        end
        
        dd = deg2km(distance(get(C,'WALA'),get(C,'WALO'),get(C,'WBLA'),get(C,'WBLO')));
        
        
            count = count+1;
           
            
            
            t = -0.5*(length(get(C,'c1'))-1)/get(C,'freq') : 1/get(C,'freq') : 0.5*(length(get(C,'c1'))-1)/get(C,'freq');

            %% grid travel time
            for ix = 1 : length(X)
                
                for iy = 1 : length(Y)
                    d1 = distance(Y(iy),X(ix),get(C,'WBLA'),get(C,'WBLO'));
                    d2 = distance(Y(iy),X(ix),get(C,'WALA'),get(C,'WALO'));
                    t1 = deg2km(d1)/Vgrid;
                    t2 = deg2km(d2)/Vgrid;
                    dt = t1-t2;
                    F =find(t>(dt-wingrid)&t<(dt+wingrid));
                    cc=sum(abs(c(:,F)),2);
                    gridout(:,iy,ix) = (gridout(:,iy,ix) + cc);
                    clear F
                end
                
            end
            
        
        
    end
    
    v = get(C,'winstart');
    eval(['save MigrationsDaily/migration_Correlation' num2str(day) '.mat gridout X Y v;'])
    clear gridout v
    
end