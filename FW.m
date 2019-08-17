function [Model]=FW(m,n,s_i,s_j,N2In,In2N,zpos,xpos,Model) 
global zorder xorder
A=zeros(m*n,1);        
%input source location 
Model(s_i,s_j).time=0; 
node_i=s_i; 
node_j=s_j; 
k=In2N(s_i,s_j);
A(k)=1;                 %move in
P(1)=N2In(s_i,s_j);     %move in
na=1;

%find number of node 
counter_P=1;%nnz(P); % nnz -- Number of nonzero matrix elements.

%find shortest time node
while counter_P<(m*n) 
    x0=xpos(node_j);
    z0=zpos(node_i);
    %Determining all node sets V connected to the node where the 
    %minial time node is located
    [LV,V_i,V_j]=Fw_star(node_i,node_j,m,n,zorder,xorder); 
    for ii=1:LV 
        i=V_i(ii); 
        j=V_j(ii);
        k=In2N(i,j);
        if(A(k)==0)
            k=In2N(i,j);
            A(k)=1;              %move in
            na=na+1;
        end
    end   
    %Move the wavelet node out of the set Q and 
    for j=1:counter_P
        k=In2N(P(j).i,P(j).j);
        if(A(k)==1)
            A(k)=0;    %move out
            na=na-1;
        end
    end
    time_min=inf;
    time_min_i=0;
    time_min_j=0;
    for ii=1:m*n    %na
        if(A(ii)==1)
            pp=N2In(ii);
            i=pp.i; 
            j=pp.j; 
            x=xpos(j);
            z=zpos(i);
            dist=(x-x0).^2+(z-z0).^2; 
            dist=sqrt(dist);
            slowness=2/(Model(i,j).velocity+Model(node_i,node_j).velocity); 
            %Model(i,j).uptime=dist*slowness; 
            delta_t=dist*slowness;
            time_try=Model(node_i,node_j).time+delta_t;%Model(i,j).uptime; 
            if time_try<Model(i,j).time 
                Model(i,j).time=time_try; 
                Model(i,j).before_i=node_i; 
                Model(i,j).before_j=node_j;
                Model(i,j).dist=dist;
            end
            if(time_min>Model(i,j).time)
                time_min=Model(i,j).time;
                time_min_i=i;
                time_min_j=j;
            end
        end
    end 
    node_i=time_min_i;
    node_j=time_min_j;
 
    %calculate the number of nodes in the P set
    counter_P=counter_P+1;
    pp.i=node_i;
    pp.j=node_j;
    P(counter_P)=pp;
end 
disp('!===== Forward End =====!')  
return;
