%-------------------------------------------------------------------------------
% gen_random_NIRS_data: generate a structure with random noise as a placeholder for 
%                       NIRS (rcSO2) data. Use only for testing computer code.
%
% Syntax: all_data=gen_random_NIRS_data(N_babies)
%
% Inputs: 
%     N_babies - number of babies 
%
% Outputs: 
%     all_data - data structure as an array of structures, of the form:
%
%                     baby_ID: '1'
%                    DOB_time: '14-Sep-2015 01:16:00'
%                          GA: 203
%                     outcome: 2
%                   nirs_time: [10463x1 double]
%                   nirs_data: [10463x1 double]
%
% Example:
%     >> all_data = gen_random_NIRS_data(120);
%

% John M. O' Toole, University College Cork
% Started: 10-10-2017
%
% last update: Time-stamp: <2017-10-10 13:25:48 (otoolej)>
%-------------------------------------------------------------------------------
function all_data=gen_random_NIRS_data(N_babies)
if(nargin<1 || isempty(N_babies)), N_babies=50; end


% baby IDs:
ids=arrayfun(@num2str,1:N_babies,'un',0);

% date of births:
t_start=datenum(2017,1,1,0,0,1);
t_end=datenum(2017,12,31,23,59,0);
dobs=arrayfun(@datestr,linspace(t_start,t_end,N_babies),'un',0);

% gestational age:
ga=randi([168 223],1,N_babies);


% outcome:
iall=randperm(N_babies,N_babies);
igood=iall(1:floor(N_babies*0.7));
iall(1:length(igood))=[];
imod=iall(1:floor(N_babies*0.2));

outcome=zeros(1,N_babies);
outcome(igood)=1;
outcome(imod)=2;
outcome(outcome==0)=3;


% fill into structure array:
all_data=struct('baby_ID',ids,'DOB_time',dobs,'GA',num2cell(ga), ...
                'outcome',num2cell(outcome));


% $$$ dispVars(100*length(find([all_data.outcome]==1))./N_babies, ...
% $$$          100*length(find([all_data.outcome]==2))./N_babies, ...
% $$$          100*length(find([all_data.outcome]==3))./N_babies, ...
% $$$          100*length(find([all_data.outcome]==0))./N_babies)
% $$$ 

DBplot=0;
if(DBplot), set_figure(1); end
for n=1:N_babies
    N=randi([24 47],1,1);
    N=N*(60*60);
    nirs_time=0:5:N;
    all_data(n).nirs_time=nirs_time';
    
    % rcSO2 as coloured Gaussian noise (placeholder only!):
    nirs_data=randn(1,length(nirs_time));
    h_impulse=ones(1,5*120); 
    h_impulse=h_impulse./length(h_impulse);
    nirs_data=filter(h_impulse,1,nirs_data);
    nirs_data=nirs_data.*(2*120)+70;
    
    
    nirs_data(nirs_data>95)=95;
    nirs_data(nirs_data<15)=15;    
    all_data(n).nirs_data=nirs_data';
    
    if(DBplot)
        plot(nirs_time./(60*60),nirs_data);
        disp('--- paused; hit key to continue ---'); pause;
    end
end

