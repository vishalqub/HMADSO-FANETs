function [C_d,dist]=dialect_count(N,x_cord,y_cord,z_cord,R)
C_d=zeros(N,1);
dist=zeros(N,N);
for i=1:N
    for j=1:N
        dist(i,j)=sqrt(power((x_cord(1,i)-x_cord(1,j)),2)+power((y_cord(1,i)-y_cord(1,j)),2));
         
    end
end
% dist
flaga=1;
flagb=0;
for i=1:N
    for j=1:N
        if(dist(i,j)>=R(N,1))
            dist(i,j)=flagb;
            
        else
             dist(i,j)=flaga;
             C_d(j,1)=C_d(j,1)+1; 
        end
        
    end
end

end