function sout = DecimateAndStretch(signal,Fsin,Fsout)
%% This function do the resampling bae on decimate and stretch method.
%% It looks for the right ratio of Fsin Fsout to maintain the length of the signal
%% It does not handle Fsout > Fsin, it will stop after 10 itetation if not values are found.

a = signal;
%% 1) Check if Fsin > freq(i1)
if Fsin > Fsout
    tag = 0;
    Q = Fsin/Fsout;
    
    %% check Q is round
    if Q - round(Q) ~= 0
        c = 2;
        
        while 1
            
            Fsc = Fsin * c;
            qi = Fsc/Fsout;
            
            if  qi - round(qi) == 0
                
                Q1 = c;
                Q = qi;
                break
                
            end
            c = c +1;
            
            if c>10
                fprintf('No ratio found!')
                sout = zeros(size(a))./0; % Trace out is NaN
                tag = 1;
                break
                
            end
        end
        
        
    end
    
    
    
    %% now resample
    if exist('Q1','var') ==1 && tag == 0;
        % stretch and decimate
        s1 =  resample(a,Q1,1);
        sout = resample(s1,1,Q);
        
        
    elseif exist('Q1','var') ==0 && tag == 0;
        % just decimate
        sout = resample(a,1,Q);
        
    end
    
    %%
elseif Fsin == Fsout
    %% don't do anything the Fs is the same
    sout = a;
    
elseif Fsin < Fsout
    fprintf('Fs input < Fs output. No processing has been done');
    sout = zeros(size(a))./0; % Trace out is NaN
    
end


end