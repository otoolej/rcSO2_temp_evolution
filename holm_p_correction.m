%-------------------------------------------------------------------------------
% holm_p_correction: Apply procedure to correct for multiple comparisons (more
% statistical power compared with Bonferroni procedure) [1]
%
% Syntax: [p_adj]=holm_p_correction(p_values,alpha)
%
% Inputs: 
%     p_values - vector of p-values
%     alpha    - alpha value [default=0.05]
%
% Outputs: 
%     p_adj - vector of adjusted p-values
%
% Example:
%     p_values=[0.010 0.450 0.120 0.003];
%     p_adj=holm_p_correction(p_values);  
%
%     print_table([p_values; p_adj]',{'p-values','adjusted p-values'},[],[12 18]);
%
%
% [1] M. Aickin and H. Gensler, “Adjusting for multiple testing when reporting research
% results: The Bonferroni vs Holm methods,” Am. J. Public Health, vol. 86, no. 5,
% pp. 726–728, 1996.

% John M. O' Toole, University College Cork
% Started: 03-11-2014
%
% last update: Time-stamp: <2017-10-10 16:42:14 (otoolej)>
%-------------------------------------------------------------------------------
function [p_adj,h]=holm_p_correction(p_values,alpha)
if(nargin<2 || isempty(alpha)), alpha=0.05; end

DBverbose=0;


N=length(p_values);
p_adj=NaN(1,N);
h_sorted=zeros(1,N);

[p_sorted,isort]=sort(p_values);

% a. adjusted p-values
for n=1:N
    jj=1:n;
    q=max( p_sorted(jj).*(N-jj+1) );
    p_adj(isort(n))=min(1,q);
end


% b. hypthosis testing:
ih=find(p_sorted<=(alpha./(N-(1:N)+1)));
if(~isempty(ih))
    h_sorted(ih)=1;
end
izero=find(h_sorted==0,1,'first');
if(~isempty(izero))
    h_sorted(izero:end)=0;
end
h(isort)=h_sorted;


% c. check:
for n=1:N
    if(h(n)==1 && p_adj(n)>alpha)
        error('hypothesis testing and adjusted p-values dont agree');
    end
end

if(DBverbose)
    print_table([p_values; p_values.*N; p_adj; h]',{'p-value','p-bonf','p-adj.','H'},[],[],1,3);
end
