function beat = synthetic_beat(data,N,total_length,period)
%% SYNTHETIC_BEAT(data,N,total_length) samples a synthetic beat from the dataset data using
%% N samples, returning a beat in tangent angle and cartesian form with accompanying period and length.
	if nargin < 2
		N = 100;
	end
	if nargin < 3
		% If dimensional length of flagellum is not set, take it to be unity and dimensionless.
		total_length = 1;
	end
	if nargin < 4
		% If period is not set, take it to be unity and dimensionless.
		period = 1;
	end

	% Form the mean angle representation from the dataset.
	mu = zeros(size(data{1}.tangent_angle));
	for i = 1 : length(data)
		mu = mu + data{i}.tangent_angle;
	end
	mu = mu / length(data);

	% Pick N samples, which need not be mutually distinct.
	samples = randi(length(data),N,1);

	% Construct the tangent angle representation of the synthetic beat.
	angles = zeros(size(data{1}.tangent_angle));
	for i = 1 : N
		angles = angles + data{samples(i)}.tangent_angle;
	end
	% Form the weighted sum which guarantees mean and variance.
	angles = (1-sqrt(N))*mu + angles/sqrt(N);

	% Integrate the angle parameterisation to give the cartesian representation.
	xy = zeros([size(angles),2]);
	for i = 1 : size(angles,1)
		xy(i,:,1) = total_length * cumtrapz(cos(angles(i,:))) / size(angles,2);
		xy(i,:,2) = total_length * cumtrapz(sin(angles(i,:))) / size(angles,2);
	end

	beat = struct('tangent_angle',angles,'cartesian',xy,'flagellum_length',total_length,'period',period);

end