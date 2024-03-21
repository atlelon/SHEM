function val=example1(x,s)
% Distrubution of the coefficient alpha as given in Figure 5 in the paper.
if nargin < 2
    rhval = 1;
else 
    rhval = s.rhVal;
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
end



