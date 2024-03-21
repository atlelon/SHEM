function R_Sine = createSineCoarseSpace(s,A)
np  = size(s.MESH.fine.p,2);
bnd = s.DDPart.nonOvbndInd;
ind = s.DDPart.nonOvASInd;
d   = s.d;
p   = s.MESH.fine.p;
h   = 1/(s.d*2^s.numRefine);
ii=1;

R_Sine=spalloc(2*d*(d-1)*s.levels,np,8*np);
% for kk=1:levels;
for k=1:d-1
    for j=1:d-1
        i=j+(k-1)*(d);
        d1=intersect(bnd(i,:),bnd(i+1,:));
        d2=intersect(bnd(i,:),bnd(i+d,:));
        crspnt=intersect(d1,d2);
        for kk=1:s.levels
            r1=zeros(np,1);
            r1(d1)=solveSineBnd(p(:,d1),h,p(:,crspnt),kk,d1,s);
            r2=zeros(np,1);
            r2(d1)=r1(d1);
            b2=zeros(np,1);
            frNodes=ind(i,:);
            b2=b2-A*r2;
            r1(frNodes)=A(frNodes,frNodes)\b2(frNodes);
            r2=zeros(np,1);
            r2(d1)=r1(d1);
            b2=zeros(np,1);
            frNodes=ind(i+1,:);
            b2=b2-A*r2;
            r1(frNodes)=A(frNodes,frNodes)\b2(frNodes);
            R_Sine(ii,:)=r1;
            %             trisurf(t', p(1,:), p(2,:), r1','facecolor','interp');
            %             pause()
            ii=ii+1;
        end
        for kk=1:s.levels
            r1=zeros(np,1);
            r1(d2)=solveSineBnd(p(:,d2),h,p(:,crspnt),kk,d2,s);
            r2=zeros(np,1);
            r2(d2)=r1(d2);
            b2=zeros(np,1);
            frNodes=ind(i,:);
            b2=b2-A*r2;
            r1(frNodes)=A(frNodes,frNodes)\b2(frNodes);
            r2=zeros(np,1);
            r2(d2)=r1(d2);
            b2=zeros(np,1);
            frNodes=ind(i+d,:);
            b2=b2-A*r2;
            r1(frNodes)=A(frNodes,frNodes)\b2(frNodes);
            %             trisurf(t', p(1,:), p(2,:), r1','facecolor','interp');
            %             pause()
            R_Sine(ii,:)=r1;
            ii=ii+1;
        end
    end

end
for i=d:d:(d)^2-d
    d1=intersect(bnd(i,:),bnd(i-1,:));
    d2=intersect(bnd(i,:),bnd(i+d,:));
    crspnt=intersect(d1,d2);
    for kk=1:s.levels
        r1=zeros(np,1);
        r1(d2)=solveSineBnd(p(:,d2),h,p(:,crspnt),kk,d2,s);
        r2=zeros(np,1);
        r2(d2)=r1(d2);
        b2=zeros(np,1);
        frNodes=ind(i,:);
        b2=b2-A*r2;
        r1(frNodes)=A(frNodes,frNodes)\b2(frNodes);
        r2=zeros(np,1);
        r2(d2)=r1(d2);
        b2=zeros(np,1);
        frNodes=ind(i+d,:);
        b2=b2-A*r2;
        r1(frNodes)=A(frNodes,frNodes)\b2(frNodes);
        R_Sine(ii,:)=r1;
        %             trisurf(t', p(1,:), p(2,:), r1','facecolor','interp');
        %             pause()
        ii=ii+1;
    end
end
for i=d^2-d+1:d^2-1
    d1=intersect(bnd(i,:),bnd(i+1,:));
    d2=intersect(bnd(i,:),bnd(i-d,:));
    crspnt=intersect(d1,d2);
    for kk=1:s.levels
        r1=zeros(np,1);
        r1(d1)=solveSineBnd(p(:,d1),h,p(:,crspnt),kk,d1,s);
        r2=zeros(np,1);
        r2(d1)=r1(d1);
        b2=zeros(np,1);
        frNodes=ind(i,:);
        b2=b2-A*r2;
        r1(frNodes)=A(frNodes,frNodes)\b2(frNodes);
        r2=zeros(np,1);
        r2(d1)=r1(d1);
        b2=zeros(np,1);
        frNodes=ind(i+1,:);
        b2=b2-A*r2;
        r1(frNodes)=A(frNodes,frNodes)\b2(frNodes);
        R_Sine(ii,:)=r1;
        %             trisurf(t', p(1,:), p(2,:), r1','facecolor','interp');
        %             pause()
        ii=ii+1;
    end
end

end