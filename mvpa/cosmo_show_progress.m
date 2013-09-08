function progress_line=cosmo_show_progress(clock_start, progress, msg, prev_progress_line)
% Shows a progress bar and time elapsed and expected to complete.
%
% progress_line=cosmo_show_progress(clock_start, progress[, msg[, prev_progress_line]])
%
% Inputs:
%   clock_start         The time the task started (from clock()).
%   progress            0 <= progress <= 1, where 0 means nothing 
%                       completed and 1 means fully completed.
%   msg                 String with a message to be shown next to the 
%                       progress bar (optional).
%   prev_progress_line  The output from the previous call to this
%                       function, if applicable (optional). If provided
%                       then invoking this function prefixes the output
%                       with numel(prev_progress_msg) backspace characters,
%                       which deletes the output from the previous call 
%                       from the console. In other words, this allows for 
%                       showing a progress message at a fixed location in 
%                       the console window.
%
% Output: 
%   progress_line       String indicating current progress using a bar,
%                       with time elapsed and expected time to complete 
%                       (using linear extrapolation). 
%
% Notes:
%   As a side effect of this function, progress_msg is written to standard
%   out (the console).
%
% Example:
%   % this code takes 3 seconds to run and fill the progress bar
%   prev_msg=''; 
%   clock_start=clock(); 
%   for k=0:100
%       pause(.03); 
%       status=sprintf('done %.1f%%', k);
%       prev_msg=cosmo_show_progress(clock_start,k/100,status,prev_msg); 
%   end
%   % output:
%   > +00:00:03 [####################] -00:00:00  done 100.0%
%
% NNO Sep 2013 


    if nargin<4
        delete_count=0;
    elseif ischar(prev_progress_line)
        delete_count=numel(prev_progress_line);
    end
    
    if nargin<3 || isempty(msg)
        msg='';
    end
    if progress<0 || progress>1
        error('illegal progress: should be between 0 and 1');
    end
    
    took=etime(clock, clock_start);
    
    eta=(1-progress)/progress*took;
   
    delete_str=repmat('\b',1,delete_count);
    
    bar_width=20;
    bar_done=round(progress*bar_width);
    bar_eta=bar_width-bar_done;
    bar_str=[repmat('#',1,bar_done) repmat('-',1,bar_eta)];
    
    % because msg may contain the '%' character (which is not interpolated)
    % care is needed to ensure that neither building the progress line nor
    % printing it to standard out applies interpolation
    
    progress_line=[sprintf('+%s [%s] -%s  ', secs2str(took), bar_str, ...
                                        secs2str(-eta)),...
                   msg,...           % avoid pattern replacement of '%'
                   sprintf('\n')];
                                      
    % the '%%' occurences in msg will be replaced back to '%' by fprintf
    fprintf([delete_str strrep(progress_line,'%','%%')]);
    
    function [m,d]=moddiv(x,y)
        % helper function that does mod and div together
        m=mod(x,y);
        d=(x-m)/y;

    function str=secs2str(secs)
        % helper function that formats the number of seconds as a string
        is_neg=secs<0;
        if is_neg
            secs=-secs;
        end
        
        if ~isfinite(secs)
            str='oo';
            return
        end
        
        secs=round(secs);
        
        [s,secs]=moddiv(secs,60);
        [m,secs]=moddiv(secs,60);
        [h,d]=moddiv(secs,24);
        
        % add prefix for day and sign, if necessary
        if d>0, daypf='%d+'; else daypf=''; end
        
        str=sprintf('%s%02d:%02d:%02d', daypf, h, m, s);
        
    
    



