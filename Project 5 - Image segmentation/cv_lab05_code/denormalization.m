function cluster = denormalization(cluster_norm, T)

cluster = [        cluster_norm'               ;
              ones(1,size(cluster_norm,1))    ];
            
cluster = inv(T) * cluster;

cluster = cluster(1:3, :)';
    
end

