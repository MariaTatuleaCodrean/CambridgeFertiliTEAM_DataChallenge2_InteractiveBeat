clear; clc;
blockdatafiles = dir('Data/all_data_*.mat');

%% Reconstruct data structure from smaller blocks
dim = 2; % concatenate along dim = 2 of variables

data = [];

% Loop over data blocks
for jj=1:length(blockdatafiles)
    load(blockdatafiles(jj).name, 'data_block')
    
    % Add newly loaded block to variable
    data = cat(2,data,data_block);
end

clear data_block

%% Uncomment this section if you want to check reconstruction is correct
% % Check the code has parsed the entire data set 
% disp(size(data)) % should be 1 by 216