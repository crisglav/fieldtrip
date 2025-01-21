function test_ft_qualitycheck

% MEM 1gb
% WALLTIME 00:30:00
% DEPENDENCY ft_qualitycheck
% DATA private

ft_hastoolbox('compat/obsolete', 1);

cfg           = [];
cfg.dataset   = dccnpath('/project/3031000.02/test/original/meg/ctf275/A0132_Aud-Obj-Recognition_20051115_02.ds'); 
cfg.savemat   = 'no';
cfg.visualize = 'no';
cfg.saveplot  = 'no';
ft_qualitycheck(cfg);
