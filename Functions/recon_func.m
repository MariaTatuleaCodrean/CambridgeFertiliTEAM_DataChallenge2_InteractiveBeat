function [] = recon_func(spNo, tStep, rec_modes, coeff_op, modes_op, mu_op)

% x_inds = 1:1000;
% y_inds = 1001:2000;

% num_frames = 100;

rowNo = (spNo-1)*100 + tStep;

loc_skip = 1;

xy_act = sum( coeff_op(rowNo,1:200) .* modes_op(:,1:200), 2 ); % this is the "true" waveform
xy_rec = sum( coeff_op(rowNo,1:rec_modes) .* modes_op(:,1:rec_modes), 2 ); % this is the reconstruction step

figure
plot(xy_act(1:loc_skip:1000) + mu_op(1:loc_skip:1000)', xy_act(1001:loc_skip:2000) + mu_op(1001:loc_skip:2000)', '-', 'linewidth', 3, 'color', 'b'); hold all

plot(xy_rec(1:loc_skip:1000) + mu_op(1:loc_skip:1000)', xy_rec(1001:loc_skip:2000) + mu_op(1001:loc_skip:2000)', '--', 'linewidth', 2, 'color', 'r')

xlabel( '$x$', 'interpreter', 'latex', 'fontsize', 22 );
ylabel( '$y$', 'interpreter', 'latex', 'fontsize', 22 );
set( gca, 'fontsize', 22, 'fontname', 'times new roman' );

title( strcat( 'Sperm ID=', num2str(spNo), ', $t=$', num2str(tStep),', no. of modes=', num2str(rec_modes)), 'interpreter', 'latex', 'fontsize', 22 )

axis equal
% axis tight
% daspect([1 1 1])

legend('true waveform', strcat(num2str(rec_modes),'-mode best fit'), 'Location', 'northeast', 'interpreter', 'latex')

end