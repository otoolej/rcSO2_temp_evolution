%-------------------------------------------------------------------------------
% cal_area_above_below: Area above 85% and area below 55%
%
% Syntax: [a_below,a_above]=cal_area_above_below(t,x,ABOVE_OR_BELOW)
%
% Inputs: 
%     t            - time (in seconds)
%     x            - rcSO2 signal 
%     LOW_CUT_OFF  - lower cut-off value [default=55]
%     HIGH_CUT_OFF - upper cut-off value [default=85]
%
% Outputs: 
%     a_below - area below 55% 
%     a_above - area above 85%
%
% Example:
%     
%

% John M. O' Toole, University College Cork
% Started: 04-11-2014
%
% last update: Time-stamp: <2017-10-10 10:10:03 (otoolej)>
%-------------------------------------------------------------------------------
function [a_below,a_above]=cal_area_above_below(t,x,LOW_CUT_OFF,HIGH_CUT_OFF)
if(nargin<3 || isempty(LOW_CUT_OFF)), LOW_CUT_OFF=55; end
if(nargin<4 || isempty(HIGH_CUT_OFF)), HIGH_CUT_OFF=85; end


a_below=0; a_above=0;

ix_nan=isnan(x);
x_all=x;
x(ix_nan)=[];

N=length(x);
ilow=find(x<=LOW_CUT_OFF); ihigh=find(x>=HIGH_CUT_OFF);

t2=(t-t(1)).*(24*60*60);
t_all=t2;

t_all(ix_nan)=[];
x_all(ix_nan)=[];

if(~isempty(ilow))
    a_below=trapz(t_all, (LOW_CUT_OFF-min(x_all,LOW_CUT_OFF)) )./ ...
            ((t_all(end)-t_all(1))*(LOW_CUT_OFF-15));
end
if(~isempty(ihigh))
    a_above=trapz(t_all,(max(x_all,HIGH_CUT_OFF)-HIGH_CUT_OFF) )./ ...
            ((t_all(end)-t_all(1))*(95-HIGH_CUT_OFF));        
end

