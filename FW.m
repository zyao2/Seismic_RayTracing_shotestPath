function [Model]=FW(m,n,s_i,s_j,N2In,In2N,zpos,xpos,Model) 
global zorder xorder
Frozen=zeros(m,n); 
%input source location 
Model(s_i,s_j).time=0; 
node_i=s_i; 
node_j=s_j; 
Frozen(node_i,node_j)=1;
x0=xpos(node_j);
z0=zpos(node_i);
t0=Model(node_i,node_j).time;
nInd_b = In2N(node_i,node_j);
[LV,V_i,V_j]=Fw_star(node_i,node_j,m,n,zorder,xorder); 
narrowBand = heap(m*n);
for ii=1:LV 
   i=V_i(ii); 
   j=V_j(ii);
   if(Model(i,j).time==-1)
        nInd = In2N(i,j);
        x=xpos(j);
        z=zpos(i);
        dist=(x-x0).^2+(z-z0).^2; 
        dist=sqrt(dist);
        slowness=2/(Model(i,j).velocity+Model(node_i,node_j).velocity); 
        delta_t=dist*slowness;
        tt=t0+delta_t;
        narrowBand.insert(tt,nInd,nInd_b);
   end
end   

while (narrowBand.heapCount > 0)
    [t0, CP,nInd_b] = narrowBand.getSmallest();
    node_i=N2In(CP).i;
    node_j=N2In(CP).j;
    Model(node_i,node_j).time=t0;
    Model(node_i,node_j).node=nInd_b;
    Frozen(node_i,node_j)=1;
    x0=xpos(node_j);
    z0=zpos(node_i);
    v0=Model(node_i,node_j).velocity;

    [LV,V_i,V_j]=Fw_star(node_i,node_j,m,n,zorder,xorder); 
    for ii=1:LV 
        i=V_i(ii); 
        j=V_j(ii);
        if (Frozen(i,j))
            continue;
        end
        nInd=In2N(i,j);
        if (~narrowBand.isInHeap(nInd))
            x=xpos(j);
            z=zpos(i);
            vv=Model(i,j).velocity;
            ss=2/(vv+v0);
                
            dist=sqrt((x-x0)^2+(z-z0)^2);
            tt=dist*ss+t0;
            narrowBand.insert(tt,nInd,CP);  
        else
            x=xpos(j);
            z=zpos(i);
            vv=Model(i,j).velocity;
            ss=2/(vv+v0);
                
            dist=sqrt((x-x0)^2+(z-z0)^2);
            tt=dist*ss+t0;  
            narrowBand.update(tt,CP,nInd);                 
        end
    end   
end 
disp('!===== Forward End =====!')  
return;
