function [idx,C,sumd,D]=k_means_pp_clustering(X,total_cluster_number)
%%  K-Means++ for Seed Selection before K-Means Function
% Initially Any Point In the Point Set Can be a Candidate
clust.candidate.point = X; 
% Select an Initial Point ID for Cluster
clust.sel.ind(1) = randi( [ 1 size(clust.candidate.point,1) ] ) ;
clust.sel.medoid(1,:) = X(clust.sel.ind(1),:) ;
% Update Cluster Candidates
clust.candidate.ind = setdiff(1:size(X,1),clust.sel.ind); 
clust.candidate.point = X(clust.candidate.ind,:);
% Calculate Euclidean Distance Between the Proposed Cluster and the Point
% Set
dist = point_distance(clust.sel.medoid(1,:),clust.candidate.point) ;

clust.count = 1 ;
for i = 2 : total_cluster_number
    flag = 1 ;
    % All Points that Can be Clusters (excluding already selected
    % clusters)
    clust.candidate.ind = setdiff(1:size(X,1),clust.sel.ind); 
    count = 0 ;
    while flag
        count = count + 1 ;
        
        % Randomly Propose a Cluster
        clust.trial.ind = randi( [ 1 size(clust.candidate.point,1) ] );
        clust.trial.medoid = clust.candidate.point(clust.trial.ind,:);
        % Compute the Probability of the Cluster bein Selected-D^2 Weighing
        clust.prob = point_distance(clust.trial.medoid,...
                                    clust.sel.medoid).^2 ...
                                    /sum(dist.^2) ; 
        
        flag = clust.prob < rand() ;
        
    end
        clust.sel.ind(i) = clust.trial.ind;
        clust.sel.medoid(i,:) = clust.trial.medoid;
end
cl = clust;
%% Run K-Means with Selected Seeds
[idx,C,sumd,D] = kmeans(X,total_cluster_number,'Start',clust.sel.medoid);
end