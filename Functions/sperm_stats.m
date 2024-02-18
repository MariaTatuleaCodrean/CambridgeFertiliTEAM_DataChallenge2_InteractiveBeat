function [] = sperm_stats(spermID)
%SPERM_STATS This function takes the spermID as an integer and displays a
%text message with sperm characteristics (sample A/B, blebbed/unblebbed)

% NOTE: This MATLAB script was written from scratch by the members of
% Cambridge InfertiliTEAM for inFer GW4 network Hackathon 2024

%load('masks.mat','A_mask','B_mask','bleb_mask','unbleb_mask')
load('masks.mat','A_mask','bleb_mask')

if A_mask(spermID)
    disp(['SPERM STATS | Sperm ' num2str(spermID) ' belongs to Sample A (fresh sperm)'])
else
    if bleb_mask(spermID)
        disp(['SPERM STATS | Sperm ' num2str(spermID) ' belongs to Sample' ...
            ' B (thawed sperm) and is blebbed'])
    else
        disp(['SPERM STATS | Sperm ' num2str(spermID) ' belongs to Sample' ...
            ' B (thawed sperm) and is unblebbed'])
    end
end

end