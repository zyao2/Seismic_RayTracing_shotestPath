function [Xi, Zj, dd]=getRay(DOTMN,lu_i,lu_j,s_i,s_j)
Xi(1)=lu_i; 
Zj(1)=lu_j;
dd(1)=0;
counter_lu=1; 
%lu_panju=isnan(DOTMN(lu_i,lu_j).before_i) 
 
  
while(1) % lu_panju<1 
    counter_lu=counter_lu+1;
    lu_i1=DOTMN(lu_i,lu_j).before_i; 
    lu_j1=DOTMN(lu_i,lu_j).before_j; 
    dd(counter_lu)=DOTMN(lu_i,lu_j).dist;
    Xi(counter_lu)=lu_i1; 
    Zj(counter_lu)=lu_j1; 
    if(lu_i1==s_i && lu_j1==s_j)
        break;
    end
    lu_i=lu_i1;lu_j=lu_j1;
end 