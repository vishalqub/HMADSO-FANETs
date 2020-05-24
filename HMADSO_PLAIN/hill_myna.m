
clc;
clear all;
%% initializing the basic paramters
 tc=20;
 N=20;
 I=20;
 size=N;
 X=5000;
 Y=5000;
 R=zeros(size,1); %intialize range
 R=R+1000; %set range =15km for each myna mapped as 30km = 1 km for simulation
%  [x_cord,y_cord,z_cord]= topo(size,X,Y)
%% setting timer for running time analysis
cpu_final_timer=zeros((tc/I),1);
clock_final_time=zeros((tc/I),1);
iterations_for_cluster=zeros((tc/I),1);

 %% setting dialect id of each node depending upon the range
 for time=1:I:tc
     tstart=clock;
     tic;
     initime = cputime;
 
 [x_cord,y_cord,z_cord]= topo(size,X,Y);
 dialect_id=zeros(N,1);
 for i=1:size
     dialect_id(i,1)= randsample(ceil(N/2),1); %allocating dialect_id to each node
 end
 dialect_id
 
dial=unique(dialect_id);
dialects=numel(dial); %number of unique dialects
 
clusters=dialects; %number of clusters = number of unique dialects

cluster_node_count=zeros(clusters,1);
for j=1:clusters
    for k=1:N
        if(dialect_id(k,1)==dial(j))
            cluster_node_count(j,1)=cluster_node_count(j,1)+1;
        end
    end
end
% cluster_node_count %  ---- based upon the dialects 


%% Computing dialect count if each node based on the range
[C_d,dist]=dialect_count(N,x_cord,y_cord,z_cord,R);

%% Eliminating self loop
  C_d=C_d-1;
  
  %% selecting cluster controller for each cluster
%   m_cluster=zeros(clusters,1);
 
  [m_cluster]=cluster_heads(dialect_id,dial,clusters,N,C_d); % cluster Head selected for j number of clusters, denotes UAV numeric id
  
  %% Displaying incidence matrix based upon the dialect connectivity
%   dist
  
  %% computing for time interval 
  
  [W,iterations_for_cluster,clock_final_time1]=update(size,dialect_id,C_d,clusters,m_cluster,x_cord,y_cord,dialects,time,iterations_for_cluster,clock_final_time);
  clock_final_time=desert_sparrow(size,x_cord, y_cord,W,clock_final_time,time);
%  clock_final_time_MAX=max(clock_final_time)
%  clock_final_time_MIN=min(clock_final_time)
%  clock_final_time_AVERAGE=mean(clock_final_time)

  %% Eng clock analysis 
  fintime = cputime;
  cpu_time=fintime - initime;
  elapsed = toc;
  conn_time_clock_time=etime(clock, tstart);
        cpu_final_timer(time,1)=cpu_time;
        clock_final_time(time,1)=conn_time_clock_time;
  
 end
%  cpu_final_timer_MAX=max(cpu_final_timer)
%  cpu_final_timer_MIN=min(cpu_final_timer)
%  cpu_final_timer_AVERAGE=mean(cpu_final_timer)
%  
%  clock_final_time_MAX=max(clock_final_time)
%  clock_final_time_MIN=min(clock_final_time)
%  clock_final_time_AVERAGE=mean(clock_final_time)
% %  
%  MAX_iterations_for_cluster=max(iterations_for_cluster)
%  MIN_iterations_for_cluster=min(iterations_for_cluster)
%  AVERAGE_iterations_for_cluster=ceil(mean(iterations_for_cluster))