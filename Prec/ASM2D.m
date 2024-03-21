function w = ASM2D(r,A,R,s)
    
    % Two level Additive Schwarz Preconditioner.
    np = size(s.MESH.fine.p,2);
    ns = s.d^2;
    w3=zeros(np,1);
    w2=w3;
    w3(s.MESH.fine.internal)=r;
    
    % Solve the coarse space
    B=R(:,s.MESH.fine.internal)*A(s.MESH.fine.internal,s.MESH.fine.internal)*R(:,s.MESH.fine.internal)';
    bc=R(:,s.MESH.fine.internal)*w3(s.MESH.fine.internal);
    wc=B\bc;
    w2(s.MESH.fine.internal)=R(:,s.MESH.fine.internal)'*wc;
    
    % Solve the subdomain problems
    for k = 1:ns
        index=s.DDPart.ovASInd(k,s.DDPart.ovASInd(k,:)>0);
        w2(index) = w2(index) + A(index,index)\w3(index);
    end 
    w=w2(s.MESH.fine.internal);

end 
