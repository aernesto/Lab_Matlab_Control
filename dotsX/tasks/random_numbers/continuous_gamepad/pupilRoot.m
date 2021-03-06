% Make a root for the pupil diameter random numbers task
%   pick subject, ans sub-blick sizes
global ROOT_STRUCT

% who!
subject = 'mattReal';
blockSD = ceil(rand(2).*25+5);
numBlocks = length(blockSD);
%mean sublock size for each block minus 5
mSbs   =  ceil(rand(2).*15+5)


% Reset estimate bar to alpha of .5?
half = true

% select all the response modality tasks
%   pass args for repetitions and stimulus orientations
tL = { ...
    'taskRandom_pupil', numBlocks, {blockSD, mSbs, half} ...
    };

% init and set dXparadigm.screenMode to same
sMode = 'local';
rInit(sMode);

% add with fields customized to subject's name
pName = ['random_pupil_',subject];

% place to save data
FIRADir = ...
    ['/Users/lab/GoldLab/Data/random_numbers/pupil/', subject];
if exist(FIRADir) ~=7
    mkdir(FIRADir)
end

% where to put the output of this file, for loading later
ROOTDir = '/Users/lab/GoldLab/Matlab/mfiles_lab/DotsX/tasks/random_numbers/roots';
if ~exist(ROOTDir, 'dir')
    mkdir(ROOTDir)
end

% show what feedback?
feedbackSelect = { ...
    'showPctGood',      false; ...
    'showNumGood',      false; ...
    'showGoodRate',     false; ...
    'showPctCorrect',   false; ...
    'showNumCorrect',   false; ...
    'showCorrectRate',  false; ...
    'showTrialCount',   false; ...
    'showMoreFeedback', true};
feedbackSelect = cell2struct(feedbackSelect(:,2), feedbackSelect(:,1), 1);

rAdd('dXparadigm',          1, ...
    'name',                 pName, ...
    'screenMode',           sMode, ...
    'taskList',             tL, ...
    'taskOrder',            'randomTaskByBlock', ...
    'FIRA_saveDir',         FIRADir, ...
    'FIRA_filenameBase',    subject, ...
    'ROOT_saveDir',         ROOTDir, ...
    'saveToFIRA',           true, ...
    'FIRA_doWrite',         true, ...
    'iti',                  .1, ...
    'moreFeedbackFunction', @randomFeedback, ...
    'showFeedback',         true, ...
    'feedbackSelect',       feedbackSelect);

% load all tasks (which makes equal proportons) then set proportions
ROOT_STRUCT.dXparadigm = loadTasks(ROOT_STRUCT.dXparadigm);
rDone;

bigName = fullfile(rGet('dXparadigm', 1, 'ROOT_saveDir'), pName);
if exist(bigName)
    save(bigName, 'ROOT_STRUCT', '-append');
else
    save(bigName, 'ROOT_STRUCT');
end

clear all