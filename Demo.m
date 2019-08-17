global zorder xorder
xorder=4; zorder=4;
Length=20; n=40;%j -- x
Width=18;m=48; %i  --  z
src_x = 1.0;  src_z = 2.0;         % Shot 
rec_x = 1.0;  rec_z = 38.0;        % Recieve 
VModel=zeros(m,n);
xpos=zeros(m,1);
zpos=zeros(n,1);
for k=1:m
    VModel(k,:)=2+2*k;
end

for j=1:m
    xpos(j)=(j-1)*Length/(n-1);
end
for i=1:m
    zpos(i)=(i-1)*Width/(m-1);
end
Model=struct('velocity',zeros(m,n),'before_i',zeros(m,n),...
    'before_j',zeros(m,n),'time',zeros(m,n));
N2In=struct('i',zeros(m*n,1),'j',zeros(m*n,1));
%initializing
k=0;
for i=1:m 
    for j=1:n 
          k=k+1;
          Model(i,j).velocity=VModel(i,j);  %
          Model(i,j).before_i=-1; 
          Model(i,j).before_j=-1; 
          Model(i,j).time=inf; 
          %Model(i,j).uptime=NaN; 
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

Model = FW(m,n,src_x,src_z,N2In,In2N,zpos,xpos,Model);
%% plot the result 
[ray_x,ray_z]=getRay(Model,rec_x,rec_z,src_x,src_z);

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
plot(src_x,src_z,'r*');hold on 
plot(rec_x,rec_z,'rv',m,n);hold on 
contour(VModel'); 
grid 
