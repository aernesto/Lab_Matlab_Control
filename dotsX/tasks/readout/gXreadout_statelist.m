
function states_ = gXreadout_statelist(varargin)

if nargin
    inc = varargin{1};
    showProbe = varargin{2};
    viewT = varargin{3};
else
    warning(sprintf('%s using default parameters', mfilename))
    inc = 20;
    showProbe = false;
    viewT = 100;
end

% wait-for-response time
post = 1000;

% confirm-or-modify-response time
hang = 100;

% start central fixation or jump to self-adjustment mode
acquire = { ...
    'dXkbHID',  {'any', 'error'}; ...
    'dXPMDHID', {'any', 'error'}; ...
    'dXasl',    {[1,true,inf], 'hold', true}};

% hold central or rebound to acquire
hold = { ...
    'dXkbHID',  {'any', 'error'}; ...
    'dXPMDHID', {'any', 'error'}; ...
    'dXasl',    {[1,false,inf], 'acquire', true}};

% settle on tighter fixation or rebound to acquire
settle = { ...
    'dXkbHID',  {'any', 'error'}; ...
    'dXPMDHID', {'any', 'error'}; ...
    'dXasl',    {[2,false,inf], 'acquire', true}};

% maintain central fixation with hard restart
fixate = { ...
    'dXkbHID',  {'any', 'error'}; ...
    'dXPMDHID', {'any', 'error'}; ...
    'dXasl',    {[2,false,inf], 'error', true}};

% statelist options that make this task special
%  target 3 corresponds to left or "less clockwise"
respond = { ...
    'dXkbHID',  {'j', 'right', 'f', 'left'}; ...
    'dXPMDHID', {11, 'right', 9, 'left'}; ...
    'dXasl',    {[3,true,inf], 'left', [4,true,inf], 'right', true}};

% maintain fixation and pull left or right
left = { ...
    'dXkbHID',  {'j', 'both'}; ...
    'dXPMDHID',	{11, 'both'}; ...
    'dXasl',    {}};

right = { ...
    'dXkbHID',  {'f', 'both'}; ...
    'dXPMDHID',	{9, 'both'}; ...
    'dXasl',    {}};

% correct response depends on random stimulus
%   for dXlr, 0=left, 1=right
lcon = {'jump', {'dXlr', 1, 'value'}, [0 1], {'correct'; 'incorrect'}};
rcon = {'jump', {'dXlr', 1, 'value'}, [0 1], {'incorrect'; 'correct'}};

SP = @rPlay;
GS = @rGraphicsShow;
VU = @rVarUpdate;

CT = @centerTargetOnFixation;
ctf = {2, 300, 'visible', false};

CD = @readout_computeMotionDist;

NS = @newRandSeedSaveToFIRA;

fp = {'dXimage', 'dXtarget', 1};

if showProbe
    dt = {'dXdots',1:2};
else
    dt = {'dXdots',1};
end

noDot = {{}, dt{:}, fp{:}};
bp = 'dXbeep';
sd = 'dXsound';

% THE STATE DINNER. Careful -- this MUST be a double cellery.
%
%   You know those guitars that are like *double* guitars?
%
%   name        fun args        jump    wait    repsDrawQuery   cond
arg_dXstate = {{ ...
    'pickDir',	VU, {'dXtc'},	'next',	0,      0,  0,  0,      {}; ...
    'setupDir',	CD, {inc},      'next', 0,      0,  0,  0,      {}; ...
    'leftRight',VU, {'dXlr'},   'next', 0,      0,  0,  0,      {}; ...
    'indicate', GS, fp,         'next',	0,      0,  3,  0,      {}; ...
    ...
    ...'acquire',  {}, {},         'error',3e4,    0,  0   acquire,{}; ...
    ...'hold',     {}, {},         'next',	350,    0,  0,  hold,   {}; ...
    ...'recenter', CT, ctf,        'next',	0,      0,  0,  1,      {}; ...
    ...'settle',   {}, {},         'next',	150,    0,  0,  settle, {}; ...
    ...
    'tone1',	SP, {bp,1},     'next',	1000,	0,  0,  settle,	{}; ...
    'tone2',	SP, {bp,2},     'next',	100,	0,  0,  fixate,	{}; ...
    'saveSeed', NS, {},         'next', 0,      0,  0,  1,      {}; ...
    'showStim', GS, dt,         'next',	viewT,	0,  1,  1,      {}; ...
    'hideStim', GS, noDot,      'next',	0,      0,  3,  1,      {}; ...
    ...
    'respond',  {}, {},         'error',post,   0,  0,  respond,{}; ...
    'left',     {}, {},         'error',hang,	0,  0,  left,   lcon; ...
    'right',    {}, {},         'error',hang,	0,  0,  right,  rcon; ...
    'both',     {}, {},         'error',0,      0,  0,  0,      {}; ...
    ...
    'correct',  SP, {sd,1},     'end',  500,	0,  0,  0,      {}; ...
    'incorrect',SP, {sd,2},     'end',  500,	0,  0,  0,      {}; ...
    'error',    SP, {sd,3},     'next',	500,	0,  5,  0,      {}; ...
    'end',      {}, {},         'x',    0,      0,  5,  0,      {}; ...
    }};
sz = size(arg_dXstate{1}, 1);

tony = {'current', true, true, false};
states_ = {'dXstate', sz, tony, arg_dXstate};