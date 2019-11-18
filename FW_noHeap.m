function [Model]=FW(m,n,s_i,s_j,N2In,In2N,zpos,xpos,Model) 
global zorder xorder
Frozen=zeros(m,n); 
%input source location 
Model(s_i,s_j).time=0; 
node_i=s_i; 
node_j=s_j; 
Frozen(node_i,node_j)=1;
%find number of node 

Heap = zeros(3, m*n);
heapCount = 0;
x0=xpos(node_j);
z0=zpos(node_i);
t0=Model(node_i,node_j).time;
nInd_b = In2N(node_i,node_j);
[LV,V_i,V_j]=Fw_star(node_i,node_j,m,n,zorder,xorder); 
for ii=1:LV 
   i=V_i(ii); 
   j=V_j(ii);
   if(Model(i,j).time==-1)
        heapCount = heapCount + 1;
        heap_ind = heapCount;
        Model(i,j).time=heap_ind;
        nInd = In2N(i,j);
        x=xpos(j);
        z=zpos(i);
        dist=(x-x0).^2+(z-z0).^2; 
        dist=sqrt(dist);
        slowness=2/(Model(i,j).velocity+Model(node_i,node_j).velocity); 
        delta_t=dist*slowness;
        tt=t0+delta_t;
        Heap(1,heap_ind) = tt;
        Heap(2,heap_ind) = nInd;
        Heap(3,heap_ind) = nInd_b;
   end
end   

while (heapCount>0)
    [t0 heap_ind] = min(Heap(1,1:heapCount));
    CP = Heap(2,heap_ind);
    nInd_b = Heap(3,heap_ind);
    node_i=N2In(CP).i;
    node_j=N2In(CP).j;
    Model(node_i,node_j).time=t0;
    Model(node_i,node_j).node=nInd_b;
    Frozen(node_i,node_j)=1;
    x0=xpos(node_j);
    z0=zpos(node_i);
    v0=Model(node_i,node_j).velocity;

    if (heap_ind ~= heapCount)
		Heap(:,heap_ind) = Heap(:,heapCount);
		% Also remember the pointer in T to the heap element
        kk=Heap(2,heap_ind);
        ii=N2In(kk).i;
        jj=N2In(kk).j;
		Model(ii,jj).time = heap_ind;     
    end		
	% Decrement heap counter
	heapCount = heapCount - 1;
   
    [LV,V_i,V_j]=Fw_star(node_i,node_j,m,n,zorder,xorder); 
    for ii=1:LV 
        i=V_i(ii); 
        j=V_j(ii);
        if (Frozen(i,j))
            continue;
        end
        if (Model(i,j).time==-1)
			heapCount = heapCount + 1;
			heap_ind = heapCount;
            Model(i,j).time=heap_ind;
			% Add pointer from heap to T
            kk=In2N(i,j);
            Heap(2,heap_ind) = kk;
            Heap(3,heap_ind) = CP;
			% Calculate tentative T(neigh) distance,
			% and list it in the heap
            x=xpos(j);
            z=zpos(i);
            vv=Model(i,j).velocity;
            ss=2/(vv+v0);
                
            dist=sqrt((x-x0)^2+(z-z0)^2);
            tt=dist*ss+t0;
            Heap(1,heap_ind) = tt;          
        else
			% Get heap indice of (i,j)
			heap_ind = Model(i,j).time;					
			% Calculate distance
            x=xpos(j);
            z=zpos(i);
            vv=Model(i,j).velocity;
            ss=2/(vv+v0);
                
            dist=sqrt((x-x0)^2+(z-z0)^2);
            tt=dist*ss+t0;
            if(tt<Heap(1,heap_ind))
                Heap(1,heap_ind) = tt;
                Heap(3,heap_ind) = CP;
            end
        end
    end   
end 
disp('!===== Forward End =====!')  
return;
