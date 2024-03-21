function [g]=plotDistribution(s)


d=s.d;
n=d*2^s.numRefine;
H=1/d;
t = s.MESH.fine.t;
p = s.MESH.fine.p;
nt = size(t,2);
h = 1/n;
hh=H/h;



axis off;




view(0,90);

if ~strcmp(s.rhofile,'SPE10')

H = triplot(s.MESH.tri);
t(4,:)=1:nt;
ti = find(s.rho > 1);
patchx  = reshape( p(1,t([1 2 3 1],ti)), 4, length(ti) );
patchy  = reshape( p(2,t([1 2 3 1],ti)), 4, length(ti) );

% Color display.
hp = patch(patchx,patchy,'r');

else 
    % H = figure();

    
    t = t';
    p=p';
    C = p(t(:),:);
    SC = repmat(log10(s.rho),size(t,2),1);
    % SC = repmat(s.rho,size(t,2),1);
    FC = bsxfun(@plus,size(t,1)*(0:size(t,2)-1),(1:size(t,1))');
    H=trisurf(FC, C(:,1), C(:,2), SC','facecolor','interp');
    view(0,90);
    colormap(jet);
    minRange=log10(min(s.rho));
    maxRange=log10(max(s.rho));
    clim([minRange, maxRange])
    colorbar()
    t = t';
    p=p';
end


x1 = [0 1 0 0];
x2 = [1 1 1 0];
y1 = [0 0 1 0];
y2 = [0 1 1 1];
x = [x1; x2];
y = [y1; y2];

for i = 1:4

    line(x(:,i),y(:,i),'color','black','LineWidth', 5);

end

switch s.meshType
    case 'regular'
        for i=0:d-1
            for k=0:d-1
                x1 = [hh*h*i   hh*h*(i+1) hh*h*i   hh*h*i];
                x2 = [hh*h*(i+1)  hh*h*(i+1) hh*h*(i+1)  hh*h*i];
                y1 = [hh*h*k hh*h*k  hh*h*(k+1) hh*h*k];
                y2 = [hh*h*k hh*h*(k+1) hh*h*(k+1) hh*h*(k+1)];
                x = [x1; x2];
                y = [y1; y2];
        
                for j = 1:4
        
                    line(x(:,j),y(:,j),'color','black','LineWidth', 5);
        
                end
            end
        end
    case 'irregular'
    H.LineWidth = 0.5;
    % H.set('color',[0.80,0.80,0.80])
    z=[max(s.rho) max(s.rho)];
    for k=1:size(s.DDPart.the_edges,2)
        edge = s.DDPart.nonOvbndInd{k};
        for j=1:size(edge,2)-1
            vv1 = p(:,edge(j));
            vv2 = p(:,edge(j+1));
            x = [vv1(1); vv2(1)];
            y = [vv1(2); vv2(2)];
            line(x,y,z,'color','black','LineWidth', 3);
        end
    end
    otherwise
            error(['Unsupported meshing type. Must be either regular' ...
                'or irregular'])
end
