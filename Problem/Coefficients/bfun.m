function val=bfun(x,rhval)
    
if nargin < 2
    rhval = 1;
end
d = 8;
n = 128;
H = 1/d;
h = 1/n;

val=1.0;


% ------------------------------------------------------------%
% 3 inclusions on each boundary of each interior subdomain   %
% ------------------------------------------------------------%
for j = 1:8
for i = 2:4

            x0 = (i-1)*H;
            y0 = (j-1)*H+2*h; 
            x1 = x0-6*h;
            x2 = x0+6*h;
            y1 = y0-h;
            y2 = y0+h;
        if (x(1)>=x1 && x(1)<=x2 && x(2)>=y1 && x(2)<=y2)
            val=rhval;
        end  

                
            x0 = (i-1)*H;
            y0 = (j-1)*H+5*h; 
            x1 = x0-3*h;
            x2 = x0+3*h;
            y1 = y0-h;
            y2 = y0+h;
        if (x(1)>=x1 && x(1)<=x2 && x(2)>=y1 && x(2)<=y2)
            val=rhval;
        end  
        
            x0 = (i-1)*H;
            y0 = (j-1)*H+8*h; 
            x1 = x0-6*h;
            x2 = x0+6*h;
            y1 = y0-h;
            y2 = y0+h;
        if (x(1)>=x1 && x(1)<=x2 && x(2)>=y1 && x(2)<=y2)
            val=rhval;
        end  
end
end 
for j = 5:d-1
for i = 5:d

%             x0 = (i-1)*H;
%             y0 = (j-1)*H+2*h; 
%             x1 = x0-6*h;
%             x2 = x0+2*h;
%             y1 = y0-h;
%             y2 = y0+h;
%         if (x(1)>=x1 & x(1)<=x2 & x(2)>=y1 & x(2)<=y2)
%             val=rhval;
%         end  

                
            x0 = (i-1)*H;
            y0 = (j-1)*H+5*h; 
            x1 = x0-5*h;
            x2 = x0+5*h;
            y1 = y0-h;
            y2 = y0+h;
        if (x(1)>=x1 && x(1)<=x2 && x(2)>=y1 && x(2)<=y2)
            val=rhval;
        end  
        
            x0 = (i-1)*H-4*h;
            y0 = (j-1)*H+6*h; 
            x1 = x0-h;
            x2 = x0+h;
            y1 = y0;
            y2 = y0+12*h;
        if (x(1)>=x1 && x(1)<=x2 && x(2)>=y1 && x(2)<=y2)
            val=rhval;
        end  
end
end 

            x0=0;
            y0=1-4*h;
            x1 = x0;
            x2 = x0+1;
            y1 = y0-3*h;
            y2 = y0;
        if (x(1)>=x1 && x(1)<=x2 && x(2)>=y1 && x(2)<=y2)
            val=rhval;
        end  



%------------------------------------------------------------%
% 2 inclusions on each boundary of each interior subdomain   %
%------------------------------------------------------------%

% for j = 2:3;
% i = 3;
% 
%             x0 = (i-1)*H;
%             y0 = (j-1)*H+4*h; 
%             x1 = x0-h;
%             x2 = x0+h;
%             y1 = y0-h;
%             y2 = y0+h;
%         if (x(1)>=x1 & x(1)<=x2 & x(2)>=y1 & x(2)<=y2)
%             val=rhval;
%         end  
% 
%                 
%             x0 = (i-1)*H;
%             y0 = (j-1)*H+8*h; 
%             x1 = x0-h;
%             x2 = x0+h;
%             y1 = y0-h;
%             y2 = y0+h;
%         if (x(1)>=x1 & x(1)<=x2 & x(2)>=y1 & x(2)<=y2)
%             val=rhval;
%         end  
% 
% end 
%              
% for j = 2:d;
% for i = 2:d-1;
%     
%             x0 = (i-1)*H+4*h;
%             y0 = (j-1)*H; 
%             x1 = x0-h;
%             x2 = x0+h;
%             y1 = y0-h;
%             y2 = y0+h;
%         if (x(1)>=x1 & x(1)<=x2 & x(2)>=y1 & x(2)<=y2)
%             val=rhval;
%         end  
% 
%             
%             x0 = (i-1)*H+8*h;
%             y0 = (j-1)*H; 
%             x1 = x0-h;
%             x2 = x0+h;
%             y1 = y0-h;
%             y2 = y0+h;
%         if (x(1)>=x1 & x(1)<=x2 & x(2)>=y1 & x(2)<=y2)
%             val=rhval;
%         end  
%  
% end 
% end    
% 
% for j = 2:d-1;
% for i = 2:d;
%     
%             x0 = (i-1)*H;
%             y0 = (j-1)*H+4*h; 
%             x1 = x0-h;
%             x2 = x0+h;
%             y1 = y0-h;
%             y2 = y0+h;
%         if (x(1)>=x1 & x(1)<=x2 & x(2)>=y1 & x(2)<=y2)
%             val=rhval;
%         end  
% 
%             
%             x0 = (i-1)*H;
%             y0 = (j-1)*H+8*h; 
%             x1 = x0-h;
%             x2 = x0+h;
%             y1 = y0-h;
%             y2 = y0+h;
%         if (x(1)>=x1 & x(1)<=x2 & x(2)>=y1 & x(2)<=y2)
%             val=rhval;
%         end  
% end 
% end


% ------------------------------------------------------------%
% 3 inclusions on each boundary of each interior subdomain   %
% ------------------------------------------------------------%
% for j = 2:3;
% i = 3;
% 
%             x0 = (i-1)*H;
%             y0 = (j-1)*H+2*h; 
%             x1 = x0-h;
%             x2 = x0+h;
%             y1 = y0-h;
%             y2 = y0+h;
%         if (x(1)>=x1 & x(1)<=x2 & x(2)>=y1 & x(2)<=y2)
%             val=rhval;
%         end  
% 
%                 
%             x0 = (i-1)*H;
%             y0 = (j-1)*H+5*h; 
%             x1 = x0-h;
%             x2 = x0+h;
%             y1 = y0-h;
%             y2 = y0+h;
%         if (x(1)>=x1 & x(1)<=x2 & x(2)>=y1 & x(2)<=y2)
%             val=rhval;
%         end  
%         
%             x0 = (i-1)*H;
%             y0 = (j-1)*H+8*h; 
%             x1 = x0-h;
%             x2 = x0+h;
%             y1 = y0-h;
%             y2 = y0+h;
%         if (x(1)>=x1 & x(1)<=x2 & x(2)>=y1 & x(2)<=y2)
%             val=rhval;
%         end  
% 
% end 
%-------------------------------------------------------------------------%
%3 inclusions on each boundary, 9 interior of each interior subdomain     %
%-------------------------------------------------------------------------%
for j = 2:5
for i = 5:d-1
    
            x0 = (i-1)*H+3*h;
            y0 = (j-1)*H; 
            x1 = x0-h;
            x2 = x0+h;
            y1 = y0-h;
            y2 = y0+h;
        if (x(1)>=x1 && x(1)<=x2 && x(2)>=y1 && x(2)<=y2)
            val=rhval;
        end  

            x0 = (i-1)*H+6*h;
            y0 = (j-1)*H; 
            x1 = x0-h;
            x2 = x0+h;
            y1 = y0-h;
            y2 = y0+h;
        if (x(1)>=x1 && x(1)<=x2 && x(2)>=y1 && x(2)<=y2)
            val=rhval;
        end  
            
            x0 = (i-1)*H+9*h;
            y0 = (j-1)*H; 
            x1 = x0-h;
            x2 = x0+h;
            y1 = y0-h;
            y2 = y0+h;
        if (x(1)>=x1 && x(1)<=x2 && x(2)>=y1 && x(2)<=y2)
            val=rhval;
        end  
 
end 
end    
% 
for j = 1:4
for i = 5:d
    for k=0:3
            x0 = (i-1)*H+3*h*k;
            y0 = (j-1)*H+3*h; 
            x1 = x0-h;
            x2 = x0+h;
            y1 = y0-h;
            y2 = y0+h;
        if (x(1)>=x1 && x(1)<=x2 && x(2)>=y1 && x(2)<=y2)
            val=rhval;
        end  
        
            x0 = (i-1)*H+3*h*k;
            y0 = (j-1)*H+6*h; 
            x1 = x0-h;
            x2 = x0+h;
            y1 = y0-h;
            y2 = y0+h;
        if (x(1)>=x1 && x(1)<=x2 && x(2)>=y1 && x(2)<=y2)
            val=rhval;
        end  
            
            x0 = (i-1)*H+3*h*k;
            y0 = (j-1)*H+9*h; 
            x1 = x0-h;
            x2 = x0+h;
            y1 = y0-h;
            y2 = y0+h;
        if (x(1)>=x1 && x(1)<=x2 && x(2)>=y1 && x(2)<=y2)
            val=rhval;
        end  
    end
end 
end
%-------------------------------------------------------------------------%
%3 inclusions on each boundary, 9 interior of each interior subdomain     %
%-------------------------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------------------------------
%  example 8: Interior inclusion case
%--------------------------------------------------------------------------
% for i = 3:8;
% for j = 3:8;
%             
%             x0 = (i-1)*H;
%             y0 = (j-1)*H-H/2;            
%             x1 = x0-h;
%             x2 = x0+h;
%             y1 = y0-h;
%             y2 = y0+h;
% 
%         if (x(1)>=x1 & x(1)<=x2 & x(2)>=y1 & x(2)<=y2)
%             val=rhval;
%         end    
% 
%             x0 = (i-2)*H;
%             y0 = (j-1)*H-H/2;            
%             x1 = x0-h;
%             x2 = x0+h;
%             y1 = y0-h;
%             y2 = y0+h;
% 
%         if (x(1)>=x1 & x(1)<=x2 & x(2)>=y1 & x(2)<=y2)
%             val=rhval;
%         end    
%         
%             x0 = (i-1)*H-H/2;
%             y0 = (j-1)*H;            
%             x1 = x0-h;
%             x2 = x0+h;
%             y1 = y0-h;
%             y2 = y0+h;
% 
%         if (x(1)>=x1 & x(1)<=x2 & x(2)>=y1 & x(2)<=y2)
%             val=rhval;
%         end    
% 
%             x0 = (i-1)*H-H/2;
%             y0 = (j-2)*H;            
%             x1 = x0-h;
%             x2 = x0+h;
%             y1 = y0-h;
%             y2 = y0+h;
% 
%         if (x(1)>=x1 & x(1)<=x2 & x(2)>=y1 & x(2)<=y2)
%             val=rhval;
%         end    
% end
% end
% j = 2;
% for i = 2:3;
%         
%             x0 = (i-1)*H;
%             y0 = (j-1)*H+H/2;            
%             x1 = x0-h;
%             x2 = x0+h;
%             y1 = y0-h;
%             y2 = y0+h;
% 
%         if (x(1)>=x1 & x(1)<=x2 & x(2)>=y1 & x(2)<=y2)
%             val=rhval;
%         end  
%         
% end 
% 
% i = 3;
% j = 2;
% 
%             x0 = (i-1)*H+H/2;
%             y0 = (j-1)*H;            
%             x1 = x0-h;
%             x2 = x0+h;
%             y1 = y0-h;
%             y2 = y0+h;
% 
%         if (x(1)>=x1 & x(1)<=x2 & x(2)>=y1 & x(2)<=y2)
%             val=rhval;
%         end     
% %--------------------------------------------------------------------------
% example 8: Interior inclusion case
%--------------------------------------------------------------------------
% --------------------------------------------------------------------------
% example 3: L shape
% --------------------------------------------------------------------------
% for j = 1:d-1;
% for i = 1:d-1;
%     
%             x0 = (i-1)*H;
%             y0 = (j-1)*H; 
%             x1 = x0+4*h;
%             x2 = x0+6*h;
%             x3 = x0+12*h;
%             y1 = y0+4*h;
%             y2 = y0+6*h;
%             y3 = y0+12*h;
%             xv = [x1 x3 x3 x2 x2 x1 x1];
%             yv = [y1 y1 y2 y2 y3 y3 y1];
%     
%             ti      = inpolygon( x(1), x(2), xv, yv );         
%             if (ti == 1)
%                val = rhval;
%             end 
%             
% end
% end
% 
% j = d;
% for i = 1:d-1;
%     
%             x0 = (i-1)*H;
%             y0 = (j-1)*H; 
%             x1 = x0+4*h;
%             x2 = x0+6*h;
%             x3 = x0+12*h;
%             y1 = y0+4*h;
%             y2 = y0+6*h;
%             y3 = y0+10*h;
%             xv = [x1 x3 x3 x2 x2 x1 x1];
%             yv = [y1 y1 y2 y2 y3 y3 y1];
%     
%             ti      = inpolygon( x(1), x(2), xv, yv );         
%             if (ti == 1)
%                val = rhval;
%             end            
% end
% 
% i = d;
% for j = 1:d-1;
%     
%             x0 = (i-1)*H;
%             y0 = (j-1)*H; 
%             x1 = x0+4*h;
%             x2 = x0+6*h;
%             x3 = x0+10*h;
%             y1 = y0+4*h;
%             y2 = y0+6*h;
%             y3 = y0+12*h;
%             xv = [x1 x3 x3 x2 x2 x1 x1];
%             yv = [y1 y1 y2 y2 y3 y3 y1];
%     
%             ti      = inpolygon( x(1), x(2), xv, yv );         
%             if (ti == 1)
%                val = rhval;
%             end 
%            
% end
% 
% j = d;
% i = d;
%     
%             x0 = (i-1)*H;
%             y0 = (j-1)*H; 
%             x1 = x0+4*h;
%             x2 = x0+6*h;
%             x3 = x0+10*h;
%             y1 = y0+4*h;
%             y2 = y0+6*h;
%             y3 = y0+10*h;
%             xv = [x1 x3 x3 x2 x2 x1 x1];
%             yv = [y1 y1 y2 y2 y3 y3 y1];
%     
%             ti      = inpolygon( x(1), x(2), xv, yv );         
%             if (ti == 1)
%                val = rhval;
%             end 
%             
% --------------------------------------------------------------------------
% example 3: L shape
% --------------------------------------------------------------------------
% 
% --------------------------------------------------------------------------
% example 4: For comparison 1
% --------------------------------------------------------------------------
% for j = 2:2:d-2
%     
%     for i = 1:2
%         
%             x0 = (i-1)*H;
%             y0 = (j-1)*H; 
%             x1 = x0+3*h;
%             x2 = x0+6*h;
%             y1 = y0+3*h;
%             y2 = y0+6*h;
%             xv = [x1 x2 x2 x1 x1];
%             yv = [y1 y1 y2 y2 y1];
%            
%             ti      = inpolygon( x(1), x(2), xv, yv );         
%             if (ti == 1)
%                val = rhval;
%             end 
%     end
%             
%             
%     for i = 6:7
%         
%             x0 = (i-1)*H;
%             y0 = (j-1)*H; 
%             x1 = x0+3*h;
%             x2 = x0+6*h;
%             y1 = y0+3*h;
%             y2 = y0+6*h;
%             xv = [x1 x2 x2 x1 x1];
%             yv = [y1 y1 y2 y2 y1];
%            
%             ti      = inpolygon( x(1), x(2), xv, yv );         
%             if (ti == 1)
%                val = rhval;
%             end             
%     end 
%             
%      i = 3;
%         
%             x0 = (i-1)*H;
%             y0 = (j-1)*H; 
%             x1 = x0;
%             x2 = x0+3*H;
%             y1 = y0+3*h;
%             y2 = y0+6*h;
%             xv = [x1 x2 x2 x1 x1];
%             yv = [y1 y1 y2 y2 y1];
% 
%             ti      = inpolygon( x(1), x(2), xv, yv );         
%             if (ti == 1)
%                val = rhval;
%             end 
% 
%      i = 8;
%         
%             x0 = (i-1)*H;
%             y0 = (j-1)*H; 
%             x1 = x0;
%             x2 = x0+H;
%             y1 = y0+3*h;
%             y2 = y0+6*h;
%             xv = [x1 x2 x2 x1 x1];
%             yv = [y1 y1 y2 y2 y1];
% 
%             ti      = inpolygon( x(1), x(2), xv, yv );         
%             if (ti == 1)
%                val = rhval;
%             end 
% end 
% 
% for j = 3:2:d-1
%     
%     i = 1;
%         
%             x0 = (i-1)*H;
%             y0 = (j-1)*H; 
%             x1 = x0;
%             x2 = x0+3*H;
%             y1 = y0+3*h;
%             y2 = y0+6*h;
%             xv = [x1 x2 x2 x1 x1];
%             yv = [y1 y1 y2 y2 y1];
% 
%             ti      = inpolygon( x(1), x(2), xv, yv );         
%             if (ti == 1)
%                val = rhval;
%             end 
%                        
%     i = 4;
%         
%             x0 = (i-1)*H;
%             y0 = (j-1)*H; 
%             x1 = x0+3*h;
%             x2 = x0+6*h;
%             y1 = y0+3*h;
%             y2 = y0+6*h;
%             xv = [x1 x2 x2 x1 x1];
%             yv = [y1 y1 y2 y2 y1];
% 
%             ti      = inpolygon( x(1), x(2), xv, yv );         
%             if (ti == 1)
%                val = rhval;
%             end 
%             
%      i = 5;
%         
%             x0 = (i-1)*H;
%             y0 = (j-1)*H; 
%             x1 = x0;
%             x2 = x0+3*H;
%             y1 = y0+3*h;
%             y2 = y0+6*h;
%             xv = [x1 x2 x2 x1 x1];
%             yv = [y1 y1 y2 y2 y1];
%             
%             ti      = inpolygon( x(1), x(2), xv, yv );         
%             if (ti == 1)
%                val = rhval;
%             end 
% end 
% --------------------------------------------------------------------------
% example 4: For comparison 1
% --------------------------------------------------------------------------
% 
% --------------------------------------------------------------------------
% example 5: For comparison 2
% --------------------------------------------------------------------------
% j = 1;
% for i = 1:d
%     
%     x0 = (i-1)*H;
%     y0 = (j-1)*H; 
%     x1 = x0 + 2*h;
%     x2 = x0 + 7*h;
%     y1 = y0 + 2*h;
%     y2 = y0 + 7*h;
%     
%     xv = [x1 x2 x2 x1 x1];
%     yv = [y1 y1 y2 y2 y1];
%     
%       ti      = inpolygon( x(1), x(2), xv, yv );         
%             if (ti == 1)
%                val = rhval;
%             end
%             
% end 
% 
% j = d;
% for i = 1:d
%     
%     x0 = (i-1)*H;
%     y0 = (j-1)*H; 
%     x1 = x0 + 2*h;
%     x2 = x0 + 7*h;
%     y1 = y0 + 2*h;
%     y2 = y0 + 7*h;
%     
%     xv = [x1 x2 x2 x1 x1];
%     yv = [y1 y1 y2 y2 y1];
%     
%        ti      = inpolygon( x(1), x(2), xv, yv );         
%             if (ti == 1)
%                val = rhval;
%             end
%             
% end 
% 
% i = 1;
% for j = 2:d-1
%     
%     x0 = (i-1)*H;
%     y0 = (j-1)*H; 
%     x1 = x0 + 2*h;
%     x2 = x0 + 7*h;
%     y1 = y0 + 2*h;
%     y2 = y0 + 7*h;
%     
%     xv = [x1 x2 x2 x1 x1];
%     yv = [y1 y1 y2 y2 y1];
%     
%        ti      = inpolygon( x(1), x(2), xv, yv );         
%             if (ti == 1)
%                val = rhval;
%             end
%             
% end 
% 
% i = d;
% for j = 2:d-1
%     
%     x0 = (i-1)*H;
%     y0 = (j-1)*H; 
%     x1 = x0 + 2*h;
%     x2 = x0 + 7*h;
%     y1 = y0 + 2*h;
%     y2 = y0 + 7*h;
%     
%     xv = [x1 x2 x2 x1 x1];
%     yv = [y1 y1 y2 y2 y1];
%     
%       ti      = inpolygon( x(1), x(2), xv, yv );         
%             if (ti == 1)
%                val = rhval;
%             end
%            
% end 
%     
% 
% for j = 2:2:d-2
%     
%     i = 2;
%     
%     x0 = (i-1)*H;
%     y0 = (j-1)*H; 
%     x1 = x0 + 3*h;
%     x2 = x0 + 6*h;
%     y1 = y0 + 3*h;
%     y2 = y0 + 6*h;
%     
%     xv = [x1 x2 x2 x1 x1];
%     yv = [y1 y1 y2 y2 y1];
%     
%         ti      = inpolygon( x(1), x(2), xv, yv );         
%             if (ti == 1)
%                val = rhval;
%             end
%        
%     for i = 6:7
%     
%     x0 = (i-1)*H;
%     y0 = (j-1)*H; 
%     x1 = x0 + 3*h;
%     x2 = x0 + 6*h;
%     y1 = y0 + 3*h;
%     y2 = y0 + 6*h;
%     
%     xv = [x1 x2 x2 x1 x1];
%     yv = [y1 y1 y2 y2 y1];
%     
%         ti      = inpolygon( x(1), x(2), xv, yv );         
%             if (ti == 1)
%                val = rhval;
%             end
%             
%     end 
%     
%     i = 3;
%         
%             x0 = (i-1)*H;
%             y0 = (j-1)*H; 
%             x1 = x0;
%             x2 = x0+3*h;
%             x3 = x0+6*h;
%             x4 = x0+10*h;
%             x5 = x0+20*h;
%             x6 = x0+30*h;
%             y1 = y0+h;
%             y2 = y0+2*h;
%             y3 = y0+3*h;
%             y4 = y0+5*h;
%             y5 = y0+6*h;
%             y6 = y0+7*h;
%  
%             xv = [x1 x4 x4 x5 x5 x6 x6 x5 x5 x4 x4 x3 x3 x2 x2 x1 x1];
%             yv = [y1 y1 y2 y2 y3 y3 y6 y6 y5 y5 y4 y4 y5 y5 y4 y4 y1];
%             
%          ti      = inpolygon( x(1), x(2), xv, yv );         
%             if (ti == 1)
%                val = rhval;
%             end
% end 
%        
%  for j = 3:2:d-1
%     
%     i = 2;
%     
%     x0 = (i-1)*H;
%     y0 = (j-1)*H; 
%     x1 = x0;
%     x2 = x0 + 3*h;
%     x3 = x0 + 4*h;
%     x4 = x0 + 9*h;
%     x5 = x0 + 10*h;
%     x6 = x0 + 13*h;
%     x7 = x0 + 16*h;
%     x8 = x0 + 20*h;
%     y1 = y0 + 3*h;
%     y2 = y0 + 4*h;
%     y3 = y0 + 8*h;
%     y4 = y0 + 9*h;
%     
%     xv = [x1 x5 x5 x6 x6 x7 x7 x8 x8 x5 x5 x1 x1];
%     yv = [y1 y1 y2 y2 y1 y1 y2 y2 y4 y4 y3 y3 y1];
%     
%          ti      = inpolygon( x(1), x(2), xv, yv );         
%             if (ti == 1)
%                val = rhval;
%             end
%        
%     i = 4;
%     
%     x0 = (i-1)*H;
%     y0 = (j-1)*H; 
%     x1 = x0 + 3*h;
%     x2 = x0 + 6*h;
%     y1 = y0 + 3*h;
%     y2 = y0 + 6*h;
%     
%     xv = [x1 x2 x2 x1 x1];
%     yv = [y1 y1 y2 y2 y1];
%     
%          ti      = inpolygon( x(1), x(2), xv, yv );         
%             if (ti == 1)
%                val = rhval;
%             end
%     
%     i = 5;
%         
%             x0 = (i-1)*H;
%             y0 = (j-1)*H; 
%             x1 = x0;
%             x2 = x0+3*h;
%             x3 = x0+6*h;
%             x4 = x0+10*h;
%             x5 = x0+20*h;
%             x6 = x0+23*h;
%             x7 = x0+26*h;
%             x8 = x0+30*h;
%             y1 = y0+h;
%             y2 = y0+3*h;
%             y3 = y0+4*h;
%             y4 = y0+5*h;
%             y5 = y0+6*h;
%             y6 = y0+7*h;
%             y7 = y0+8*h;
%  
%             xv = [x1 x4 x4 x5 x5 x6 x6 x7 x7 x8 x8 x5 x5 x4 x4 x3 x3 x2 x2 x1 x1];
%             yv = [y1 y1 y2 y2 y3 y3 y2 y2 y4 y4 y7 y7 y6 y6 y4 y4 y5 y5 y4 y4 y1];
%             
%             ti      = inpolygon( x(1), x(2), xv, yv );         
%             if (ti == 1)
%                val = rhval;
%             end
%                         
%  end     
% --------------------------------------------------------------------------
% example 5: For comparison 2
% --------------------------------------------------------------------------
% 
% --------------------------------------------------------------------------
% example 6: channels with positive slope
% --------------------------------------------------------------------------
% for j = 1:5:6
% for i=1:6
%     
%     x0 = (i-1)*H;
%     y0 = (j-1)*H; 
%     x1 = x0;
%     x2 = x0 + h;
%     x3 = x0 + 24*h;
%     x4 = x0 + 23*h;
%     y1 = y0;
%     y2 = y0 + 23*h;
%     y3 = y0 + 24*h;
%     y4 = y0 + h;
%     
%     xv = [x1 x2 x3 x3 x4 x1 x1];
%     yv = [y1 y1 y2 y3 y3 y4 y1];
%     
%       ti      = inpolygon( x(1), x(2), xv, yv );         
%             if (ti == 1)
%                val = rhval;
%             end 
% end 
% end 
% 
% for j=4:5
%     for i=1:2:d-1
%         
%     x0 = (i-1)*H;
%     y0 = (j-1)*H; 
%     x1 = x0 + 4*h;
%     x2 = x0 + 10*h;
%     y1 = y0 + 2*h;
%     y2 = y0 + 4*h;
%     
%     xv = [x1 x2 x2 x1 x1];
%     yv = [y1 y1 y2 y2 y1];
%     
%       ti      = inpolygon( x(1), x(2), xv, yv );         
%             if (ti == 1)
%                val = rhval;
%             end 
%     end 
% end
% --------------------------------------------------------------------------
% example 6: channels with positive slope
% --------------------------------------------------------------------------
% 
% return

return



   