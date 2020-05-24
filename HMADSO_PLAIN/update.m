function [W,iterations_for_cluster,clock_final_time]=update(size,dialect_id,C_d,clusters,m_cluster,x_cord,y_cord,dialects,time,iterations_for_cluster,clock_final_time)
  %for time=1:I:tc
      
      
      tstart1=clock;
  %% performing myna computations and updations for formation of shortest path
  W=zeros(size,1); % normalized weight
  a=zeros(size,1); %dialect constant
  D=zeros(size,1); %neural distance of myna from its mutual controller
%   dialect_id
  min_dialect=min(dialect_id);
  max_dialect=max(dialect_id);
  min_c_d=min(C_d);
  max_c_d=max(C_d);
  
  gamma_t=0; 
  eta_t=0.5;   %learning rate can be updated algorithmically
  max_Id=0;
  C_d_norm=zeros(size,1);
  n_c=10;
  for i=1:size
      W(i,1)=(dialect_id(i,1)-min_dialect)/(max_dialect-min_dialect);
      a(i,1)=C_d(i,1)/size;
      C_d_norm(i,1)=(C_d(i,1)-min_c_d)/(max_c_d-min_c_d);
      
      for j=1:clusters
          if(dialect_id(i,1)==dialect_id(m_cluster(j,1)))
            D(i,1)=(sqrt(power((x_cord(1,i)-x_cord(1,m_cluster(j,1))),2)+power((y_cord(1,i)-y_cord(1,m_cluster(j,1))),2)))*(W(i,1)*(1-(1/size)));
          end
      end
      Id(i,1)=(a(i,1)/max(D)); %dialect index computation
        
  end
   
  %% selecting best suited cluster head
  min_w=min(W);
%   C_d_norm
  max_Id=max_Id+min(Id);
  gamma_t=max_Id;
  beta_t=rand(1,1);
%   dialects
  p=3;
  rend_t=(clusters/size)*(beta_t+gamma_t);%(((beta_t+gamma_t)*eta_t)*dialects)/p %dialects fitness minimzing function
  if(rend_t>1)
      rend_t=gamma_t;
  end
  required_dialect_count=rend_t; %minimum normalized dialect count
  number_of_clusters=0;
  %% 
  for i=1:size
      fin=ismember(i,m_cluster);
      if(C_d_norm(i,1)>=required_dialect_count && fin==1)
          number_of_clusters=number_of_clusters+1;
      end
      
  end

%% number_of_clusters=clusters
  clusters_heads=zeros(number_of_clusters,1);
  iterations_for_cluster(time,1)=number_of_clusters;
  j=1;
  for i=1:size
      x=i;
      fin=ismember(x,m_cluster);
      if(C_d_norm(i,1)>=required_dialect_count && fin==1)
          
          clusters_heads(j,1)=i;
          j=j+1;
      end
     
  end
%   clusters_heads
  %% computing distance between nodes and cluster heads
  connection_cluster_node=zeros(number_of_clusters,size);
  for j=1:number_of_clusters
      for i=1:size
          connection_cluster_node(j,i)=sqrt(power((x_cord(1,i)-x_cord(1,clusters_heads(j,1))),2)+power((y_cord(1,i)-y_cord(1,clusters_heads(j,1))),2));
      end
  end
%   connection_cluster_node;
  
  dist_adj=connection_cluster_node;
  %% final incidence matrix and making connection between cluster heads
  connection_incidence=connection_cluster_node;
   
      for i=1:size
          [value,loc]=min(connection_cluster_node(:,i));
                for j=1:number_of_clusters
                    if(connection_cluster_node(j,i)>0 && j==loc)
                        connection_incidence(j,i)=1;
                        dist_adj=1;
                    else
                        connection_incidence(j,i)=0;
                        dist_adj=0;
                    end
                    
                    for k=1:number_of_clusters
                        if(clusters_heads(j)~=clusters_heads(k))
                        connection_incidence(j,clusters_heads(k))=1;
                        end
                    end
                end
      end
%       connection_incidence
 
  %% % % % %Code here for particular application % % % % % % % % %% 
  %                                                               %
  %       CODE FOR DIALECT ZONE OF NODES W.R.T. CLUSTER HEAD      %
  %                                                               %
  % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
   connection_without_clusterhead=connection_incidence;
 for i=1:size
          [value,loc]=min(connection_cluster_node(:,i));
                for j=1:number_of_clusters
                    if(connection_cluster_node(j,i)>0 && j==loc)
                        connection_without_clusterhead(j,i)=1;
                    else
                        connection_without_clusterhead(j,i)=0;
                    end
                end
 end
 
for j=1:number_of_clusters
    fprintf('Nodes in dialect zone of Cluster Head %d\n',clusters_heads(j,1));
    for i=1:size
        if(connection_without_clusterhead(j,i)==1)
            i
        end
    end
end
conn_time_clock_time=etime(clock, tstart1);
clock_final_time(time,1)=conn_time_clock_time;

end