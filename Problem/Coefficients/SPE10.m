function val=SPE10(x,s)

[n,m]=size(s.rhoData);
hx=1/(n);
hy=1/(m);

coord=floor([x(1)*(n)+1,x(2)*(m)+1]);
            x1 = (coord(1)-1)*hx;
            y1 = (coord(2)-1)*hy;
            x2 = (coord(1)-1)*hx+hx;
            y2 = (coord(2)-1)*hy+hy;
        if (x(1)>=x1 && x(1)<=x2 && x(2)>=y1 && x(2)<=y2)
            val=s.rhoData(coord(2),coord(1));
        end  
end