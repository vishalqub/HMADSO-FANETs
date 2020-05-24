function clock_final_time=desert_sparrow(size_n,x_cord, y_cord, W,clock_final_time,time)
 tstart2=clock;
desert_sparrows=ceil(size_n);
resource_area=10000; %sq m
guider_lines=desert_sparrows;
vision_range=zeros(desert_sparrows,1)+15; %vision range of each desert_sparrow
x_cord1=x_cord';
y_cord1=y_cord';
coordinated_points=[x_cord1 y_cord1];

[M, N] = size(coordinated_points);

%%% coordinated_pointslot the axes
% Radial offset per axis
th = (2*pi/M)*(ones(2,1)*(M:-1:1));
% Axis start and end
r = [0;1]*ones(1,M);
% Conversion to cartesian coordinates to plot using regular plot.
[x,y] = pol2cart(th, r);
loc_x=x';
loc_y=y';
hLine = line(x, y,...
    'LineWidth', 1.5,...
    'Color','g'); 
toggle = ~ishold;
if toggle
    hold on
end
th = (2*pi/M)*(ones(desert_sparrows,1)*(M:-1:1));  %number of desert_sparrows
% Axis start and end
r = (linspace(0.1, 0.9, desert_sparrows)')*ones(1,M);   %number of desert_sparrows
% Conversion to cartesian coordinates to plot using regular plot.
[x,y] = pol2cart(th, r);
hLine = line([x, x(:,1)]', [y, y(:,1)]',...
    'LineWidth', 1,...
    'Color', 'r');  
% Compute minimum and maximum per axis
minV = min(coordinated_points,[],2);
maxV = max(coordinated_points,[],2);
% set(1,'color','g')

% axis([-1,1,-1,1]*1.5)
set(gca,'YTick',[]);
set(gca,'XTick',[])
% Hold on to plot data points
hold on

% Radius
R = desert_sparrows*((coordinated_points - (minV*ones(1,N)))./((maxV-minV)*ones(1,N))) + desert_sparrows;
R = [R; R(1,:)];
loc_r=R';
Th = (2*pi/M) * ((M:-1:0)'*ones(1,N));
guider_lines=zeros(desert_sparrows,1);
%% compute distance of each desert_sparrow from the origin to allocate the guider line
origin_x=0;
origin_y=0;
desert_sparrow_dist=zeros(size_n,1);
for i=1:size_n
    desert_sparrow_dist(i,1)=sqrt(power((x_cord(1,i)-origin_x),2)+power((y_cord(1,i)-origin_y),2));
end
desert_sparrow_sorted_distance=sort(desert_sparrow_dist);
% % 
desert_sparrow_allocation_guider=zeros(size_n,1);
for i=1:size_n
    [value,loc]=find(desert_sparrow_sorted_distance(i,1)==desert_sparrow_dist);
    desert_sparrow_allocation_guider(i,1)=value;
end

%% mapping desert_sparrows to particular guider zone
% loc_r
% loc_x
% loc_y
loc_x_final=loc_x(:,2)
loc_y_final=loc_y(:,2)
x_cir=0;
add_val=0.9/size_n;

for j = 1:M
    % Generate the axis label
  msg = sprintf('S_{%d}',...
        desert_sparrow_allocation_guider(j,1));
     msg1 = sprintf('S_{%d}',...
        desert_sparrow_allocation_guider(j,1));
 [mx, my] = pol2cart( th(1, j), 1.1);
  text(mx,my, msg1);
 text(x_cir,0,msg);
  x_cir=x_cir+add_val;
%     text(,,msg);
end

for j = M:-1:1
    % Generate the axis label
  msg = sprintf('G_{%d}',...
        j);
  text(-x_cir,0,msg);
  x_cir=x_cir-add_val;
%     text(,,msg);
end

% for i=0:size_n
%     msg = sprintf('x_{%d}',...
%         i+1);
%     text((i+0.1),0, msg);
% end
%  text(0.5,0.1, msg);

%% compute the poisson based vision index
% W;
% desert_sparrow_allocation_guider
vision_index=zeros(size_n,1);
% rho=0.5;
for x=1:size_n;
    loc=desert_sparrow_allocation_guider(x,1);
    y=W(loc,1); %ground Nodes
    vision_index(x,1)=poisspdf(x,y);
%       vision_index(x,1)=binopdf(x,size_n,y);
%              vision_index(x,1)=bbinopdf(x,size_n,loc,loc);
%                     vision_index(x,1)=unidpdf(x,size_n);
%                              vision_index(x,1) = hygecdf(x,size_n,desert_sparrows,loc);
%                                                        vision_index(x,1) = ncfpdf(x,size_n,desert_sparrows,loc);
end
% vision_index
% plot(x,p,'.','color','red');
%% perform poisson search over each desert_sparrow for defined area based on the   %
%            vision perform round search in spiral form                    %
%                                                                          %
%    code here to perform maneuverabilties with UAVs, not required for     %
%   analysis of optimization algorithm as it is independent of algorithm   %
%                               operations                                 %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %%
%% select the task controller with maximum vision range
task_controller_initial=max(vision_index);
[index,value]=find(task_controller_initial==vision_index);
final_task_controller=desert_sparrow_allocation_guider(index,1);
fprintf('Final Task Controller for the desert_sparrows Search operation:  %d\n',final_task_controller);
conn_time_clock_time=etime(clock, tstart2);
clock_final_time(time,1)=conn_time_clock_time;
MAX_vision_index=max(vision_index)
MIN_vision_index=min(vision_index)
AVERAGE_vision_index=mean(vision_index)

end