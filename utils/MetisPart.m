function [PrtE,DD]=MetisPart(t,nparts,s)

ne=length(t(:,1));
a=ne;
a={a};
t ={t'};

fileID = fopen('celldata.txt','w');
forSpec = '%d \n';

fprintf(fileID,forSpec,a{1,:});

formatSpec = '%d %d %d \n';
fprintf(fileID,formatSpec,t{1,:});

fclose(fileID);


% calling metis
if isempty(s.metisFolder) 
    mpmetis=['mpmetis -ncommon=2 celldata.txt ' int2str(nparts)];
else
    mpmetis = [s.metisFolder,'mpmetis -ncommon=2 celldata.txt ' int2str(nparts)];
end

[status,result] = system(mpmetis);

if (contains(result,'not recognized as'))
    PrtE = [];
    DD   = [];
    return
end

celldata=['celldata.txt.epart.' int2str(nparts)];

% Reading metis
fileID = fopen(celldata,'r');
formatSpec = '%d';
sizeA = [1 Inf];
PrtE = fscanf(fileID,formatSpec,sizeA);
fclose(fileID);

celldatan=['celldata.txt.npart.' int2str(nparts)];

if isempty(s.metisFolder) 
    m2gmetis=['m2gmetis -ncommon=2 celldata.txt dual.txt'];  
else
    m2gmetis=[s.metisFolder,'m2gmetis -ncommon=2 celldata.txt dual.txt']; 
end
[status,result] = system(m2gmetis);

if (contains(result,'not recognized as'))
    PrtE = [];
    DD   = [];
    return
end
                                                           
dualdata=['dual.txt'];                                   
                                                           
Dual = fopen(dualdata,'r');                                
D=textscan(Dual,'%d %d %d');                               
fclose(Dual);                                              
                                                           
D1=[D{:,1}];                                               
D2=[D{:,2}];                                               
D3=[D{:,3}];                                               
                                                           
n1=length(D1);                                             
n2=length(D2);                                             
n3=length(D3);                                             
                                                           
if n1>n2                                                   
    D2=[D2;zeros(n1-n2,1)];                                
end                                                        
                                                           
if n1>n3                                                   
    D3=[D3;zeros(n1-n3,1)];                                
end                                                        
                                                           
DD=[D1 D2 D3];                                             
DD(1,:)=[];                                                
%*************************************************************

PrtE=PrtE';

