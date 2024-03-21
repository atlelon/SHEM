function [tindx] = node2elementAll(tri,nindx)

    tindx = cell2mat(tri.vertexAttachments(nindx));
end