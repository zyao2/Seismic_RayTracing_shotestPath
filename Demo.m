close all
clear all
global zorder xorder
zorder=7;xorder=7;
n=100;%j -- x
m=52; %i  --  z
src_z = 1.0;  src_x = 90.0;         % Shot 
rec_z = 1.0;  rec_x = 4.0;        % Recieve 
VModel=zeros(m,n);
xpos=zeros(m,1);
zpos=zeros(n,1);
dz=5;dx=5;
for k=1:m
    VModel(k,:)=800+44*k*dz;
end

for j=1:n
    xpos(j)=(j-1)*5;
end
for i=1:m
    zpos(i)=(i-1)*5;
end
Model=struct('velocity',zeros(m,n),'node',zeros(m,n),...
   'time',zeros(m,n),'dist',zeros(m,n));
N2In=struct('i',zeros(m*n,1),'j',zeros(m*n,1));
%initializing
k=0;
for i=1:m 
    for j=1:n 
          Model(i,j).velocity=VModel(i,j);  %
          Model(i,j).node=-1; 
          Model(i,j).time=-1; 
    end 
end 
In2N=zeros(m,n);
k=0;
for i=1:m
    for j=1:n
        k=k+1;
        N2In(k).i=i;
        N2In(k).j=j;
        In2N(i,j)=k;
    end
end    
t = cputime;
Model = FW(m,n,src_z,src_x,N2In,In2N,zpos,xpos,Model);
[ray_x,ray_z]=getRay(Model,rec_z,rec_x,src_z,src_x,N2In);
DotTime=zeros(m,n);
for k1=1:m
    for k2=1:n
        DotTime(k1,k2)=Model(k1,k2).time;
    end
end
figure;
subplot(1,2,1)  
contour(DotTime);hold on 

grid; 
subplot(1,2,2)  
plot(ray_x,ray_z,m,n);     hold on 
plot(src_z,src_x,'r*');hold on 
plot(rec_z,rec_x,'rv',m,n);hold on 
contour(VModel'); 
grid 
e = cputime-t

