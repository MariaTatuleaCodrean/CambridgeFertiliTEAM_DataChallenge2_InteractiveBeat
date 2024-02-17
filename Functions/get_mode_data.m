function [data_c1, data_c2, data_c3] = get_mode_data(sp_num, coeffs_123, modes_123, mu_x, mu_y)

% size of coeffs_123 = 21600 x 3
% size of modes_123  = 2000 x 3

% data_c1 = zeros(100, 1000, 2);
% data_c2 = data_c1;
% data_c3 = data_c1;

m1x = modes_123(1:1000, 1)'; m1y = modes_123(1001:2000, 1)'; % size of m1x & m1y = 1 x 1000
m2x = modes_123(1:1000, 2)'; m2y = modes_123(1001:2000, 2)'; % size of m2x & m2y = 1 x 1000
m3x = modes_123(1:1000, 3)'; m3y = modes_123(1001:2000, 3)'; % size of m3x & m3y = 1 x 1000

c1_s = coeffs_123((sp_num-1)*100 + 1:(sp_num-1)*100 + 100,1); % size of c1_s = 100 x 1
c2_s = coeffs_123((sp_num-1)*100 + 1:(sp_num-1)*100 + 100,2); % size of c2_s = 100 x 1
c3_s = coeffs_123((sp_num-1)*100 + 1:(sp_num-1)*100 + 100,3); % size of c3_s = 100 x 1

sp_x_1 = c1_s * m1x + mu_x; % x-coord. of 1st mode for all 100 time-steps; size = 100 x 1000
sp_x_2 = c2_s * m2x + mu_x; % x-coord. of 2nd mode for all 100 time-steps; size = 100 x 1000
sp_x_3 = c3_s * m3x + mu_x; % x-coord. of 3rd mode for all 100 time-steps; size = 100 x 1000

sp_y_1 = c1_s * m1y + mu_y; % y-coord. of 1st mode for all 100 time-steps; size = 100 x 1000
sp_y_2 = c2_s * m2y + mu_y; % y-coord. of 2nd mode for all 100 time-steps; size = 100 x 1000
sp_y_3 = c3_s * m3y + mu_y; % y-coord. of 3rd mode for all 100 time-steps; size = 100 x 1000

data_c1(:,:,1) = sp_x_1;
data_c1(:,:,2) = sp_y_1;

data_c2(:,:,1) = sp_x_2;
data_c2(:,:,2) = sp_y_2;

data_c3(:,:,1) = sp_x_3;
data_c3(:,:,2) = sp_y_3;

end