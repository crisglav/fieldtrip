function test_bug2100

% MEM 1gb
% WALLTIME 00:10:00
% DEPENDENCY ft_read_mri read_ctf_mri4
% DATA private

filename = dccnpath('/project/3031000.02/test/bug2100/Sub02.mri');
mri = ft_read_mri(filename);

