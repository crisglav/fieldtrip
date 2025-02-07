function test_bug2473

% MEM 1gb
% WALLTIME 00:10:00
% DEPENDENCY ft_databrowser
% DATA private

load(dccnpath('/project/3031000.02/test/avgFIC.mat'));

cfg = [];
cfg.preproc.bpfilter = 'yes';
cfg.preproc.bpfreq = [3 45];
ft_databrowser(cfg, avgFIC);

% Opening the preproc window in the databrowser and clicking on save and
% close produces an error because the cfg.preproc.bpfreq value is not on
% the same line anymore.

end
