% Register images with one another; cluster on overlap metric.

% Inputs: The imaging run in question
% Outputs: clusters of related image stacks, based on a metric of image
% overlap (calculated elsewhere).


% REGISTRATION SECTION, CALCULATE ALL INDIVIDUAL IMAGE STACK OVERLAPS

% Datasets over which to carry out the clustering, with associated
% directories
datasets = {4,5,6,7};
dataset_directories{4} = 'K:\fourth set NG PI1 11-16 to 11-17\Stacks';
dataset_directories{5} = 'K:\NG PI1 11-18-15\Stacks';
dataset_directories{6} = 'K:\NG PI1 11-19-15\Stacks';
dataset_directories{7} = 'L:\NG PI1 11-20-15\Stacks';

% Gather the parameters for the datasets / alignment runs
ParametersRun500NG
write_files = true;

num_datasets = length(datasets);

% Full set of datasets / positions can be inferred from ParametersRun500NG
% file or overwritten here.
dataset_positions = [{4,1}; {4,2}; {4,3}; {4,4}; {4,5}; {5,1}; {5,2}; {5,3}; {5,4}; {5,5}; {6,1}; {6,2}; {6,3}; {6,4}; {6,5}; {7,1}; {7,2}; {7,3}; {7,4}; {7,5}; {7,6}];
total_num_positions = size(dataset_positions,1);

time_method = 0;
% How to choose time points for clustering between image sequence

register_counter = 0;
for i = 1:total_num_positions
    for j = 1:total_num_positions
        if i>j
            register_counter = register_counter + 1;
            
            % Get values associated to these runs to read in
            % file params and transform matrices.
            first_moving_dataset = dataset_positions{i,1};
            first_moving_position = dataset_positions{i,2};
            second_moving_dataset = dataset_positions{j,1};
            second_moving_position = dataset_positions{j,2};
            
            first_moving_start_time = moving_start_times{first_moving_dataset,first_moving_position +1};
            second_moving_start_time = moving_start_times{second_moving_dataset,second_moving_position +1};
            
            first_moving_dataset_directory = [dataset_directories{first_moving_dataset} '/Position ' num2str(first_moving_position) '/resized images'];
            second_moving_dataset_directory = [dataset_directories{second_moving_dataset} '/Position ' num2str(second_moving_position) '/resized images'];

            % Begin setting up registration, to calculate overlap.
            
            cd([first_moving_dataset_directory '/Run ' num2str(set_run_number)])
            load(['reg params ' set_strain_name '_' num2str(first_moving_dataset) '_' num2str(first_moving_position) '_r' num2str(set_run_number) ' tar ' num2str(target_dataset) '_' num2str(target_position) '_r' num2str(target_run_number) '. ' first_moving_start_time '.mat']);
            % produces file "optreg"
            load(['calculated params ' set_strain_name '_' num2str(first_moving_dataset) '_' num2str(first_moving_position) '_r' num2str(set_run_number) ' tar ' num2str(target_dataset) '_' num2str(target_position) '_r' num2str(target_run_number) '. ' first_moving_start_time '.mat']);
            % produces file "calculated_params"
            calculated_params1 = calculated_params;
            optreg1 = optreg;
            time_offset_1 = optreg.time_offset;
            
            cd([second_moving_dataset_directory '/Run ' num2str(set_run_number)])
            load(['reg params ' set_strain_name '_' num2str(second_moving_dataset) '_' num2str(second_moving_position) '_r' num2str(set_run_number) ' tar ' num2str(target_dataset) '_' num2str(target_position) '_r' num2str(target_run_number) '. ' second_moving_start_time '.mat']);
            % produces file "optreg"
            load(['calculated params ' set_strain_name '_' num2str(second_moving_dataset) '_' num2str(second_moving_position) '_r' num2str(set_run_number) ' tar ' num2str(target_dataset) '_' num2str(target_position) '_r' num2str(target_run_number) '. ' second_moving_start_time '.mat']);
            % produces file "calculated_params"
            calculated_params2 = calculated_params;
            optreg2 = optreg;
            time_offset_2 = optreg.time_offset;
            
            % calculate time points for registration.
            if time_method == 1
                first_moving_time_point = 89 + time_offset_1;
                second_moving_time_point = 89 + time_offset_2;
            else
                first_moving_time_point  = calculated_stacks{first_moving_dataset,first_moving_position+1}(2);
                second_moving_time_point = calculated_stacks{second_moving_dataset,second_moving_position+1}(2);
            end
            
            % Queue this registration job, assigning to spot register_counter
            ParameterCellRegistration{register_counter} = {optreg1,optreg2,calculated_params1,calculated_params2,first_moving_time_point,second_moving_time_point,write_files,-1,-1};

        end
    end
end

% Start parallel computation of these values
fwd_bck_scores = startmulticoremaster(@RegisterByNucleiCallableForwardBack, ParameterCellRegistration);

register_counter =0;
for i = 1:total_num_positions
    for j = 1:total_num_positions
        if i>j
            register_counter = register_counter +1;
            fwd_score = fwd_bck_scores{register_counter}(1);
            bkw_score = fwd_bck_scores{register_counter}(2);
            % average forwad and backward score and insert in both slots,
            % distance metric should be symmetrical
            output_score= (output_score_fwd+output_score_bkwd)/2;
            output_scores(i,j) = output_score;
            output_scores(j,i) = output_score;
        end
    end
end


% CLUSTERING SECTION

% Takes all overlap scores calculated in previous section; builds up
% clusters by getting groups that are within "cutoff" of one another.
% Clusters by first generating maximum size clusters and then disambiguating
% potential doubly-claimed elements by summed overlap score.

% This is not a hierarchical clustering algorithm, but it can be easily
% extended to one.

% Builds up the clusters up iteratively.  Starts with clusters of 1 element each.
% Accepts possible merges into higher order clusters if possible,
% and keeps unless a "better offer" from a cluster of that size is available.


% Cutoff for overlap metric, above which to consider possibility of clustering.
% Given the overlap function, this is the only parameter provided to the
% clustering algorithm.
cutoff = 1500;


% Intialize clusters.
iter_number = 0;
for i = 1:size(dataset_positions,1)
    initial_clusters{i} = i;
end
accepted_clusters = initial_clusters;


max_iter = 10;
% max_iter also controls the maximum size of clusters (=max_iter)

end_clustering = 0;
% Terminates convergence if there are no changes between runs.


counter =0;

while (~end_clustering) && (iter_number < max_iter)
    
    clear candidate_clusters
    clear candidate_cluster_scores
    end_clustering = 1;
    iter_number = iter_number +1;
    former_clusters = accepted_clusters;

    
    % Keep track of how many new clusters to consider for this loop.
    num_new_candidates = 0;
    
    % Loop over pairs of existing clusters
    for j = 1:length(former_clusters)
        for k = 1:length(former_clusters)
            
            % Check if one cluster group (j) is larger than the other.
            % Permit larger group to steal elements from smaller group.
            if length(former_clusters{j}) >= length(former_clusters{k})
                
                
                merge = ones(1,length(former_clusters{k}));
                % Loop over elements in this pair of clusters, j and k.
                % Initialize vector of elements to merge (or not).
                for l = 1:length(former_clusters{j})
                    for m = 1:length(former_clusters{k})
                        existing_element_number = former_clusters{j}(l);
                        candidate_element_number = former_clusters{k}(m);
                        
                        % Don't merge element if overlap less than cutoff.
                        if output_scores(existing_element_number,candidate_element_number)<cutoff
                            merge(m) = 0;
                        end
                    end
                end
                
                
                % If there were new merges, continue clustering algorithm.
                if nnz(merge)>0
                    end_clustering = 0;
                    
                    % Tally number of new candidate clusters for this
                    % iteration
                    num_new_candidates = num_new_candidates + 1;
                    
                    % Add this candidate to candidate_clusters cell array
                    this_cluster = [former_clusters{j} former_clusters{k}(find(merge))];
                    candidate_clusters{num_new_candidates} = this_cluster;
                    
                    % Calculate a score for a candidate cluster by
                    % summing over all distances of elements in cluster.
                    % This metric works because only ever comparing
                    % clusters with the same number of elements.
                    
                    this_candidate_cluster_score = 0;
                    for l = 1:length(this_cluster)
                        for m = 1:length(this_cluster)
                            if l < m
                                this_candidate_cluster_score = this_candidate_cluster_score + output_scores(this_cluster(l),this_cluster(m));
                            end
                        end
                    end
                    
                    % Add this score to candidate_cluster_scores array
                    candidate_cluster_scores(num_new_candidates) = this_candidate_cluster_score;
                    
                end
            end
            
        end
    end

    
% condition checks if there were any new candidates
if ~end_clustering
    
    % Add initial clusters to list of candidates with low score.
    for initial_cluster_num = 1:length(initial_clusters)
        candidate_clusters{num_new_candidates + initial_cluster_num} = initial_clusters{initial_cluster_num};
        candidate_cluster_scores(num_new_candidates + initial_cluster_num) = .1;
    end
    
    % Update num candidates
    num_new_candidates = num_new_candidates + length(initial_clusters);
    
    % Begin looping over hierarchical levels.  Find largest current cluster.
    top_level = 0;
    
    for candidate_cluster_number = 1:num_new_candidates
        top_level = max(top_level,length(candidate_clusters{candidate_cluster_number}));
    end
    
        
    level = top_level;
    accounted_for_embryos = [];
    accepted_clusters = {};
        
    % Loop from top_level down to level
    while level > 0

        
        % Finding clusters of size "level".  This computation actually
        % inefficient, should be calculated instead with one loop beforehand
        % instead of within while loop.
        
        clusters_at_this_level = [];
        these_candidate_cluster_indices = [];
        cluster_counter = 0;
        
        for l = 1:num_new_candidates
            if length(candidate_clusters{l}) == level
                cluster_counter = cluster_counter +1;
                clusters_at_this_level = [clusters_at_this_level l];
                these_candidate_cluster_indices(cluster_counter) = l;
            end
        end
        
        
        % If there are any clusters of this size, consider them.
        
        if length(clusters_at_this_level)>0
            
            these_candidate_clusters = {};
            these_candidate_cluster_scores = {};
            for cluster_index = 1:length(clusters_at_this_level)
                these_candidate_clusters{cluster_index} = candidate_clusters{clusters_at_this_level(cluster_index)};
                these_candidate_cluster_scores(cluster_index) = candidate_cluster_scores(clusters_at_this_level(cluster_index));
            end
            
            toggler = 0;
            
            while toggler ==0
                
                % Loop through, from best candidate at this level to worst.
                % cluster scores will be set to zero after looking at them.
                [max_val,num_this_cluster] = max(these_candidate_cluster_scores);
                
                % num_this_cluster is index to candidate clusters at this level
                
                if max_val ==0
                    % Meaning, we are out of candidates.
                    toggler = 1;
                else
                    
                    % get the cluster out from the full list (all levels)
                    cluster_under_consideration = candidate_clusters{these_candidate_cluster_indices(num_this_cluster)};
                    
                    % set score to 0; everything looked at once.
                    these_candidate_cluster_scores(num_this_cluster) = 0;
                    
                    ok = 1;
                    
                    % very inefficient; replace with find command
                    for l = 1 : length(cluster_under_consideration)
                        for m = 1 : length(accounted_for_embryos)
                            % check if any embryos in the cluster are
                            % already accounted for; if so, toss out this
                            % candidate.
                            if cluster_under_consideration(l) == accounted_for_embryos(m)
                                ok = 0;
                            end
                        end
                    end
                    
                    if ok
                        accepted_clusters = [accepted_clusters cluster_under_consideration];
                        accounted_for_embryos = [accounted_for_embryos cluster_under_consideration(:)'];
                    end
                end
            end
            
        end
            
        level = level-1;
    end
        
end     
end