function [tindx] = node2element (tri,nindx)

    nodes2El = tri.vertexAttachments(nindx');
    
    tindx = intersect(nodes2El{1},nodes2El{2});

end