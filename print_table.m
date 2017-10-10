%-------------------------------------------------------------------------------
% print_table: Print table of strings
%
% Syntax: print_table(str_table,x_column,y_row,max_length,fout,dec_point)
%
% Inputs: 
%     str_table  - cell of strings or matrix of values
%     x_column   - column names [empty by default]
%     y_row      - row names [empty by default]
%     max_length - character width of each table 'cell' [default=12]
%     fout       - output file point (if needed) [default=stdout]
%     dec_point  - decimal point places [default=5]
%
%
% Example:
%     head_str={'header 1','header 2'};
%     row_str={'var1','var2','var3','var4'};
%     print_table(rand(4,2),head_str,row_str,[6 8 6],[],3);
%

% John M. O' Toole, University College Cork
% Started: 17-10-2014
%
% last update: Time-stamp: <2017-10-09 18:26:56 (otoolej)>
%-------------------------------------------------------------------------------
function []=print_table(str_table,x_column,y_row,max_length,fout,dec_point)
if(nargin<2 || isempty(x_column)), x_column=[]; end
if(nargin<3 || isempty(y_row)), y_row=[]; end
if(nargin<4 || isempty(max_length)), max_length=12; end
if(nargin<5 || isempty(fout)), fout=1; end
if(nargin<6 || isempty(dec_point)), dec_point=5; end



[N,M]=size(str_table);
if(~isempty(x_column))
    if(M~=length(x_column))
        error('column headers too short');
    end
end
if(~isempty(y_row))
    if(N~=length(y_row))
        error('row headers too short');
    end
    N_cols=M+1;
else
    N_cols=M;
end


L_max=length(max_length);
if(L_max==1)
    max_length=ones(1,N_cols).*max_length;
    L_max=N_cols;
elseif(L_max<N_cols)
    max_length=[max_length ones(1,N_cols-length(max_length)).*max_length(end)];
end
L_max=length(max_length);


for n=1:L_max
    blank{n}=repmat(' ',1,max_length(n));
    sep_tile{n}=repmat('-',1,max_length(n)+2);
end


%---------------------------------------------------------------------
% if headers:
%---------------------------------------------------------------------
if(~isempty(x_column))
    if(~isempty(y_row))
        x_column=pad_limit_str(x_column,max_length(2:end));
    else
        x_column=pad_limit_str(x_column,max_length);
    end


    if(~isempty(y_row))
        head=['| ' blank{1} ' | ' x_column{1} ' |'];
    else
        head=['| ' x_column{1} ' |'];
    end
    sep=['-' char(sep_tile{1}(1:end-1))];
    for n=2:M
        head=[head ' ' x_column{n} ' |'];
        sep=[sep '+' char(sep_tile{n})];
    end
    fw_fprintf(fout,'%s\n',head);
    if(~isempty(y_row))
        sep=[sep '+' char(sep_tile{end})];
    end
    fw_fprintf(fout,'|%s|\n',sep);
end


%---------------------------------------------------------------------
% if row names:
%---------------------------------------------------------------------
if(~isempty(y_row))
    y_row=pad_limit_str(y_row,max_length(1));
end
if(~isempty(dec_point))
    if(length(dec_point)==1)
        dec_point=repmat(dec_point,1,M);
    end
end


%---------------------------------------------------------------------
% main table
%---------------------------------------------------------------------
for m=1:N
    if(~isempty(y_row))    
        fw_fprintf(fout,'| %s |',y_row{m});
    else
        fw_fprintf(fout,'|');        
    end
    for n=1:M
        if(iscell(str_table))
            tentry=str_table{m,n};
        else
            tentry=str_table(m,n);
        end
        if(ischar(tentry))
            num=sprintf('%s',tentry);
        else
            sp=['%0.' num2str(dec_point(n)) 'f'];
            num=sprintf(sp,tentry);
        end
        if(N_cols==M)
            num=pad_limit_str(char(num),max_length(n));
        else
            num=pad_limit_str(char(num),max_length(n+1));
        end
                        
        fw_fprintf(fout,'%s  |',num);
    end
    fw_fprintf(fout,'\n');
end




function x=pad_limit_str(x,max_length)
%---------------------------------------------------------------------
% pad or limit string
%---------------------------------------------------------------------
if(iscell(x))
    if(length(max_length)<2)
        max_length=repmat(max_length,1,length(x));
    end
    
    for n=1:length(x)
        ml=max_length(n);
        
        if(length(x{n})>ml)
            x{n}=x{n}(1:ml);
        else
            L=length(x{n});
            x{n}=[repmat(' ',1,ml-L) x{n}];
        end
    end
else
    if(length(x)>max_length)
        x=x(1:max_length);
    else
        L=length(x);
        x=[repmat(' ',1,max_length-L) x];
    end
end    
