function index_ = taskDetectDownContrast(varargin)
%Contrast task for downward contrast detection, near accelerating PF shoulder
%   index_ = taskDetectDownContrast(varargin)
%
%   no eyetracker
%   lpHID choices
%
%   varargin gets passed to dXtask/set via rAdd.
%
%   index_ specifies the new instance in ROOT_STRUCT.dXtask

% Copyright 2007 by Benjamin Heasly
%   University of Pennsylvania

arg_dXtc = { ...
    'name',         'texture_index', ...
    'values',       [6 6 6 6 6 5 4 3 2 1], ...
    'ptr',          {{'dXfunctionCaller', 1, 'indices'}}};

arg_dXblank = { ...
    'ptr',          {{'dXtc', 1, 'value'}}, ...
    'blankValue',   6};

% statelist options that make this task special
lcon = {'jump', {'dXblank', 1, 'value'}, [0 1], {'incorrect'; 'correct'}};
rcon = {'jump', {'dXblank', 1, 'value'}, [0 1], {'error'; 'error'}};
bcon = {'jump', {'dXblank', 1, 'value'}, [0 1], {'correct'; 'incorrect'}};
ptrs = {'dXtc', 'dXblank'};
nofp = {{}, 'dXtarget', 1:2};
show = 200;
arg_statelist = {lcon, rcon, bcon, ptrs, nofp, show};

% pointer to dXtexture background color
bgPtr = {'dXtexture', 1, 'bgLum'};

name = mfilename;
cta = common_task_args;
index_ = rAdd('dXtask', 1, {'root', false, true, false}, ...
    'name',	name(5:end), ...
    'blockReps', 12, ...
    'bgColor', bgPtr, ...
    'helpers', { ...
    'dXtc',             1,	{'current', false, true, false},	arg_dXtc; ...
    'dXblank',          1,	{'current', false, true, true},     arg_dXblank; ...
    'gXnachmias_contrast',1,true,                               []; ...
    'gXnachmias_helpers',1, true,                               []; ...
    'gXnachmias_statelist',1,false,	arg_statelist}, ...
    cta{:}, varargin{:});