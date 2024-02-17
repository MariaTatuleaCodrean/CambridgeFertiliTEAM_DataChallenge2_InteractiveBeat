clear; clc;
blockdatafiles = dir('Data/pop_pca_2kModes_*.mat');

%% Reconstruct data structure from smaller blocks
dim = 2; % concatenate along dim = 2 of variables

coeff_op = [];
for_pca  = [];
modes_op = [];
mu_op    = [];

% Loop over data blocks
for jj=1:length(blockdatafiles)
    load(blockdatafiles(jj).name, 'coeff_op_block','for_pca_block','modes_op_block','mu_op_block')
    
    % Add newly loaded block to variable
    coeff_op = cat(2,coeff_op,coeff_op_block);
    for_pca  = cat(2,for_pca,for_pca_block);
    modes_op = cat(2,modes_op,modes_op_block);
    mu_op    = cat(2,mu_op,mu_op_block);
end

clear coeff_op_block for_pca_block modes_op_block mu_op_block

%% Uncomment this section if you want to check reconstruction is correct
% % Check the code has parsed the entire data set 
% disp(size(coeff_op)) % should be 21600 by 2000

% % Check data was parsed correctly
% coeff_op_reconstructed = coeff_op;
% load('pop_pca_2kModes.mat','coeff_op')
% max(coeff_op-coeff_op_reconstructed,[],'all') % should be 0