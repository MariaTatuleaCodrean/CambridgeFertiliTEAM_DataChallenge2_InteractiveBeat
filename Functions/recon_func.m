function [] = recon_func_v2(spNo, tStep, rec_modes, for_pca, coeff_op, modes_op, mu_op)

% x_inds = 1:1000;
% y_inds = 1001:2000;

% num_frames = 100;

rowNo = (spNo-1)*100 + tStep;

% x_dat = for_pca(rowNo, x_inds);
% y_dat = for_pca(rowNo, y_inds);

loc_skip = 1;

figure(3)
clf
% plot(for_pca(rowNo, 1:1000), for_pca(rowNo, 1001:2000), '-', 'linewidth', 3, 'color', 'b'); hold all
plot(for_pca(rowNo, 1:loc_skip:1000), for_pca(rowNo, 1001:loc_skip:2000), '-', 'linewidth', 3, 'color', 'b'); hold all

xy_rec = sum( coeff_op(rowNo,1:rec_modes) .* modes_op(:,1:rec_modes), 2 ); % this is the reconstruction step

% x_rec_pre = xy_rec(x_inds);
% y_rec_pre = xy_rec(y_inds);

% x_rec = xy_rec(x_inds) + mu_op(x_inds)';
% y_rec = xy_rec(y_inds) + mu_op(y_inds)';

% plot(xy_rec(1:1000) + mu_op(1:1000)', xy_rec(1001:2000) + mu_op(1001:2000)', '--', 'linewidth', 2, 'color', 'r')
plot(xy_rec(1:loc_skip:1000) + mu_op(1:loc_skip:1000)', xy_rec(1001:loc_skip:2000) + mu_op(1001:loc_skip:2000)', '--', 'linewidth', 2, 'color', 'r')

xlabel( '$x$', 'interpreter', 'latex', 'fontsize', 22 );
ylabel( '$y$', 'interpreter', 'latex', 'fontsize', 22 );
set( gca, 'fontsize', 22, 'fontname', 'times new roman' );

axis tight

title( strcat( 'Sperm ID=', num2str(spNo), ', $t=$', num2str(tStep),', no. of modes=', num2str(rec_modes)), 'interpreter', 'latex', 'fontsize', 22 )

daspect([1 1 1])

shg

end