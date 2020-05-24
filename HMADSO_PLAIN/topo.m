function [x_cord,y_cord,z_cord]= topo(size,X,Y)
 x_cord=randperm(X);
 x_cord= x_cord(1:size);
 y_cord=randperm(Y);
 y_cord= y_cord(1:size);
 z_cord=zeros(1,size);
end