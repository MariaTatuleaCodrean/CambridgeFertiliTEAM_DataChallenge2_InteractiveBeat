% NOTE: This MATLAB script was written from scratch by the members of 
% Cambridge InfertiliTEAM for inFer GW4 network Hackathon 2024

% This function reconstructs *data* structure from smaller blocks 
% (GitHub restricts file size to 100 MB)

load('Data/pop_pca.mat','modes','coeff','A_mask','B_mask')

% Check if data exists
if ~exist('data', 'var')

    % Retrieve files containing data blocks
    blockdatafiles = dir('Data/all_data_*.mat');
   
    % Concatenate along dim = 2 of variables
    dim = 2; 
    
    % Initialize data variable
    data = [];

    % Loop over data blocks
    for jj=1:length(blockdatafiles)
        load(blockdatafiles(jj).name, 'data_block')

        % Add newly loaded block to variable
        data = cat(dim,data,data_block);
    end
    
    % Clear redundant variables
    clear data_block
end

%% Uncomment this section if you want to check reconstruction is correct
% % Check the code has parsed the entire data set
% disp(size(data)) % should be 1 by 216