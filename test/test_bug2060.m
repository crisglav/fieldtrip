function test_bug2060

% MEM 1gb
% WALLTIME 00:10:00
% DEPENDENCY ft_read_event read_neuralynx_nev
% DATA private

filename = dccnpath('/project/3031000.02/test/bug2060/Events.Nev');

event = ft_read_event(filename);

assert(~isempty(event));

% display
event;
event(1)

