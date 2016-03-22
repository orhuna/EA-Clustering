function idx = evidence_accumulation(y,N,cutoff)
%  Evindence Accumulation for Determining Number of Clusters in Data. see http://cs.joensuu.fi/~zhao/Courses/Clustering2012/Ensemble.pdf
% Cluster the Data Set N times with Random Number of Clusters
assoc_vote = zeros(size(y,1),size(y,1)) ;
%% Compute Co-Association Matrix Between Observations
for num_clust = 1 : N
	% Run A Clustering Algorithm with Inputs Sampled from a Normal Distribution (In this Case K-Means ++)
    clust_num = randi([2 size(y,1)]) ;
	%Displace the Clustering Round with The Input Parameters
    display(['Iteration ',num2str(num_clust),' with ',num2str(clust_num),' clusters']);
	%Run Clustering Algorithm
    try
		% Perform K-Means++ Clustering
        [idx(:,num_clust),~,~,D{num_clust}]=kmeans(y,clust_num) ;   
        d=pdist(idx(:,num_clust)); d = squareform(d);
		d(d~=0)=-99;d(d==0)=1;d(d==-99)=0;
		assoc_vote = assoc_vote + d ; 
    end
    
end

assoc_vote = assoc_vote / N ;% Association Matrix - Note this is a Similarity Matrix

assoc_diss = 1 - assoc_vote;

ind = zeros(size(y,1),1);

for el = 1:size(y,1)
    if (ind(el) == 0 )
       assoc = assoc_vote(:,el); 
       assoc_rank = assoc > cutoff ;
       ind(assoc_rank) = max(ind) + 1 ;
    else
       assoc = assoc_vote(:,el); 
       assoc_rank = assoc > cutoff ;
       ind(assoc_rank) = ind(el) ; 
    end
end
idx = zeros(size(ind,1),1) ;
clus_vals = unique(ind) ;

for i = 1 : length(clus_vals)
    idx(ind==clus_vals(i)) = i ;
end