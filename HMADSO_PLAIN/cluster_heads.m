function m_cluster=cluster_heads(dialect_id,dial,clusters,N,C_d)
min_dialect=0;
m_cluster=zeros(clusters,1);
  for j=1:clusters
    for k=1:N
        if(dialect_id(k,1)==dial(j))
            max_dialect=C_d(k,1);
            if(max_dialect>=min_dialect) 
                %max_dialect=C_d(k,1);
                min_dialect=max_dialect;
                
            end    
             m_cluster(j,1)=k;
        end
    end
  end
end