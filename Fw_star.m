function [icount,V_i,V_j]=Fw_star(x,y,m,n,iorder,jorder) 
icount=0;
for i=x-iorder:x+iorder
    for j=y-jorder:y+jorder
        if(i==x && j==y)
            continue;
        end
        if(i<1 || j<1 ||i>m ||j>n)
            continue;
        end
        icount=icount+1;
        V_i(icount)=i;
        V_j(icount)=j;
    end
end
        
