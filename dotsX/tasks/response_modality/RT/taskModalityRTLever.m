function index_ = taskModalityRTLever(varargin)
%RT Dots task with diagonal motion and lever pulls
%
%   index_ = taskModalityRTLever(varargin)
%
%   asl eye tracker for fixation
%   PMDHID levers for choices
%
%   index_ specifies the new instance in ROOT_STRUCT.dXtask

% copyright 2008 Benjamin Heasly University of Pennsylvania

% which dot direction corresponds to an upward eye response?
if nargin>1 && ischar(varargin{1}) && strcmp(varargin{1}, 'dotParams') ...
        && isstruct(varargin{2})

    arg_dot = {'down-up', varargin{2}};
    varargin(1:2) = [];
else
    arg_dot = {'down-up', []};
end

% name of this task
name = mfilename;

% actions specific to lever pull task
respond = { ...
    'dXkbHID',  {'j', 'right', 'f', 'left'}; ...
    'dXPMDHID', {11, 'right', 9, 'left'}; ...
    'dXasl',    {[2,false,inf], 'error'}};
choose = {};
down = {};
up = {};
left = { ...
    'dXkbHID',  {'j', 'both'}; ...
    'dXPMDHID',	{11, 'both'}; ...
    'dXasl',    {}};
right = { ...
    'dXkbHID',  {'f', 'both'}; ...
    'dXPMDHID',	{9, 'both'}; ...
    'dXasl',    {}};

% never need to allow for saccade time
post = 0;

% Lever task uses no targets
targets = {{}};

% customize the statelist for eye movements
arg_statelist = {respond, choose, up, down, left, right, post, targets};

% get general task settings for modality tasks
arg_dXtask = modality_task_args;

% create this specific task
index_ = rAdd('dXtask', 1, {'root', false, true, false}, ...
    'name',         name(5:end), ...
    'blockReps',    100, ...
    'timeLimit',    7*60, ...
    'intertrialFcn',{@speedAccuracyFeedback}, ...
    'helpers',      { ...
            'gXmodality_hardware',          1,  true,	{}; ...
            'gXmodality_graphics',          1,  true,	arg_dot; ...
            'gXmodality_motionControl',     1,  false,	arg_dot; ...
            'gXmodalityRT_statelist',       1,  false,	arg_statelist; ...
            }, ...
    arg_dXtask{:}, varargin{:});