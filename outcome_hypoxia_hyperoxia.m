%-------------------------------------------------------------------------------
% outcome_hypoxia_hyperoxia: simple analysis on large NIRS dataset (120+ babies)
%
% Syntax: [sum_st]=simple_analysis_3dataset(all_info)
%
% Inputs: 
%     all_info - NIRS data structure with the following fields:
%  
%                     baby_ID: '1'
%                    DOB_time: '14-Sep-2015 01:16:00'
%                          GA: 203
%                     outcome: 2
%                   nirs_time: [10463x1 double]
%                   nirs_data: [10463x1 double]
%  
%                [default = use gen_random_NIRS_data.m to generate placeholder data]
%
% Example
%     >> outcome_hypoxia_hyperoxia;
%
% Requires:
%   Matlab (> R2013a) and Statistics toolbox (> v8.2); 
%   functions: gen_random_NIRS_data, holm_p_correction, 
%              cal_area_above_below, print_table.


% John M. O' Toole, University College Cork
% Started: 30-10-2014
%
% last update: Time-stamp: <2017-10-10 14:48:41 (otoolej)>
%-------------------------------------------------------------------------------
function [sum_st]=outcome_hypoxia_hyperoxia(all_info)
if(nargin<1 || isempty(all_info))
    all_info=gen_random_NIRS_data(120);
end


N_babies=length(all_info);



%---------------------------------------------------------------------
% 1) tidy up rcSO2 recordings
%---------------------------------------------------------------------
irem=[]; 
low_cum_total=0; N_cum_total=0;
for n=1:N_babies
    full_nirs_data=all_info(n).nirs_data(:);
    full_nirs_time=all_info(n).nirs_time(:);    

    mean_fs=nanmean(diff(full_nirs_time))*(24*60*60);


    % a) remove 15% values (assume not recording):
    ilow=find(full_nirs_data==15);
    low_cum_total=low_cum_total+length(ilow);
    N_cum_total=N_cum_total+length(full_nirs_data);

    art_mask=zeros(1,length(full_nirs_data));    
    if(~isempty(ilow))
        art_mask(ilow)=1;
        art_mask=collar_mask(art_mask,ceil(30/mean_fs));
        
        irr=find(art_mask==1);
        full_nirs_data(irr)=NaN;
    end


    [full_nirs_data,full_nirs_time]=trim_nans_start_end(full_nirs_data,full_nirs_time);
    tob=datenum(all_info(n).DOB_time);
    nirs_time_secs=(full_nirs_time-tob).*(24*60*60);
    
    % b) remove if less than 48 hours:
    iup_limit=find(nirs_time_secs>48*60*60);
    if(~isempty(iup_limit))
        nirs_time_secs(iup_limit)=[];
        full_nirs_data(iup_limit)=[];        
    end

    % c) remove babies if recordings start after 48 hours:
    if(all(isnan(nirs_time_secs)))
        irem=[irem n];
        fprintf('REMOVING baby because recording starts >48hours: %s\n', ...
                all_info(n).baby_ID);
    end
    
    [full_nirs_data,nirs_time_secs]=trim_nans_start_end(full_nirs_data,nirs_time_secs);
    
    all_info(n).nirs_time=nirs_time_secs;
    all_info(n).nirs_data=full_nirs_data;    
end
all_info(irem)=[];


N_babies=length(all_info);
fprintf('UPDATE: number of babies=%d\n',N_babies);


% stats on duration of data:
for n=1:N_babies
    all_info(n).total_data_length_hours= ...
        (all_info(n).nirs_time(end)-all_info(n).nirs_time(1))./(60*60);
    full_nirs_data=all_info(n).nirs_data;
    all_info(n).prc_NaNs=100*(length(full_nirs_data(isnan(full_nirs_data)))) ...
        / length(full_nirs_data);
end


%---------------------------------------------------------------------
% 2. generate simple descriptors for the data
%---------------------------------------------------------------------
for n=1:N_babies
    sum_st(n).baby_ID=all_info(n).baby_ID;
    sum_st(n).outcome=all_info(n).outcome;
    sum_st(n).GA=(all_info(n).GA)./7;

    dd=[all_info(n).nirs_data];
    [sum_st,N]=simp_stats(dd,sum_st,n,all_info(n).nirs_time);
end

%---------------------------------------------------------------------
% 3. group into good/bad outcome
%---------------------------------------------------------------------
igood=find([sum_st.outcome]==1);   imoderate=find([sum_st.outcome]==2); 
isevere=find([sum_st.outcome]==3); 


fprintf('OUTCOME: good, n=%d; moderate, n=%d; severe, n=%d\n', ...
        length(igood),length(imoderate),length(isevere));
icombined=[igood imoderate isevere];


fn=fieldnames(sum_st);
fn(find(strcmp(fn,'baby_ID')))=[]; 
fn(find(strcmp(fn,'outcome')))=[];
fn(find(strcmp(fn,'GA')))=[];
N_feats=length(fn);


% b. do plot:
for n=1:N_feats
    feat_good{n}=[sum_st(igood).(char(fn{n}))];
    feat_moderate{n} =[sum_st(imoderate).(char(fn{n}))];    
    feat_severe{n} =[sum_st(isevere).(char(fn{n}))];        
end

%---------------------------------------------------------------------
% do stats:
%---------------------------------------------------------------------
A=[];
for n=1:N_feats
    feat_name{n}=char(fn{n});
    feat_str{n}=modify_str(feat_name{n});
    
    meds(n,1)=nanmedian([sum_st(igood).(char(fn{n}))]);
    meds(n,2)=nanmedian([sum_st(imoderate).(char(fn{n}))]);    
    meds(n,3)=nanmedian([sum_st(isevere).(char(fn{n}))]);        
    miqr(n,1,:)=prctile([sum_st(igood).(char(fn{n}))],[25 75]);
    miqr(n,2,:)=prctile([sum_st(imoderate).(char(fn{n}))],[25 75]);    
    miqr(n,3,:)=prctile([sum_st(isevere).(char(fn{n}))],[25 75]);        
    
    x=[ [sum_st(igood).(char(fn{n}))] [sum_st(imoderate).(char(fn{n}))] ...
        [sum_st(isevere).(char(fn{n}))] ];
    groups=[ repmat({'good'},1,length(igood)) repmat({'moderate'},1,length(imoderate)) ...
             repmat({'severe'},1,length(isevere)) ];

    [p,tbl,stats]=kruskalwallis(x,groups,'off');

    p_ind(1)=ranksum([sum_st(igood).(char(fn{n}))], [sum_st(imoderate).(char(fn{n}))]);
    p_ind(2)=ranksum([sum_st(imoderate).(char(fn{n}))], [sum_st(isevere).(char(fn{n}))]);    
    p_ind(3)=ranksum([sum_st(igood).(char(fn{n}))], [sum_st(isevere).(char(fn{n}))]);
    p_adj=holm_p_correction(p_ind);
    
    
    p_values(n)=p;
    
    for p=1:3
        A{n,4+p}=sprintf('%.2f (%.2f to %.2f)',meds(n,p),miqr(n,p,:));
    end
    A{n,1}=sprintf('%.3f',p_values(n));
    for p=1:3
        A{n,1+p}=sprintf('%.3f (%.2f)',p_adj(p),p_ind(p));
    end
end

fprintf('\n* features and association with outcome\n\n');
print_table(A',feat_str,{'P-value: 3 groups','P-value: good vs. mild', ...
                    'P-value: mild vs. severe', ...
                    'P-value: good vs. severe','good', ...
                    'mild','moderate/severe'},[26 26 24]);




function [sum_st,N]=simp_stats(x,sum_st,n,t)
%---------------------------------------------------------------------
% generate some statistics on data
%---------------------------------------------------------------------

x_all=x;
x(isnan(x))=[];
N=length(x);

low_thres=50; high_thres=80;
if(sum_st(n).GA>=28)
    low_thres=low_thres+5;
    high_thres=high_thres+5;
end

[a_below,a_above]=cal_area_above_below(t,x_all,low_thres,high_thres);

if(isnan(a_below))
    keyboard;
end

sum_st(n).area_bel55=log(a_below+eps);
sum_st(n).area_ab85 =log(a_above+eps);



function x=modify_str(x)
%---------------------------------------------------------------------
% proper text for string
%---------------------------------------------------------------------
x=strrep(x,'area_bel55','log(AREA <55/60 rcSO2)');
x=strrep(x,'area_ab85','log(AREA >85/90 rcSO2)');


function [data,time]=trim_nans_start_end(data,time)
%---------------------------------------------------------------------
% remove blocks of continuous NaNs at start and end of sequence
%---------------------------------------------------------------------
istart=find(~isnan(data),1,'first');
iend=find(~isnan(data),1,'last');
data=data(istart:iend);
if(nargin>1)
    time=time(istart:iend);
else
    time=[];
end
