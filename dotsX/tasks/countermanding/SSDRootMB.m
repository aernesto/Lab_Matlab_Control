jffjfjf% This file will create a ROOT_STRUCT that is configured for the simple_demo
% task.  The task will run automatically, and the ROOT_STRUCT can be loaded
% again using dXgui.

% who is the subject?
subject = 'Rishi';
paradigmName = ['CMD_', subject];

% create the directory for saving data files
%   this directory must exist before you run the task
FIRADir = ['/Users/rmkalwani/Documents/MATLAB/mfiles_goldlab/CMDPupil_DataMB/', subject];
%FIRADir = ['/Users/ben/Desktop/Lab_City/Gold/Data/CMD_data/SSD/', subject];
if ~exist(FIRADir, 'dir')
    mkdir(FIRADir)
end

% where to put the output of this file, for loading later
ROOTDir = ['/Users/rmkalwani/Documents/MATLAB/mfiles_goldlab/CMDPupil_DataMB/', subject];
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

% pick the task to load
%   filename of the task, number of repetitions to run, task arguments
% numTrials = 100;
SSDs = [300 350 400 450 500];
mute = false;

% Ben set unequal task proportions 
%   and made ridiculously high number of trialsk
taskList = {... 
    'taskSSDMB', 3, {10000, SSDs, mute}, ... %number of repititions here, also specifies relative proportions
    'taskVGSMB', 1, {10000, mute}};


% use 'local' screen mode to showkkgjf graphics on this machine
%   rInit will initialize a ROOT_STRUCT which holds all DotsX data.
screenMode =  'local';
rInit(screenMode);

% Add a dXparadigm to the initialized ROOT_STRUCT.  dXparadigm will contain
% manage and execute the task:
%   name            A name unique to this task and this subject
%   screenMode      Where to show graphics ('debug', 'local', or 'remote')
%   taskList        List of task name, task repetitions, and config. args
%   iti             interval to wait between trials
%   saveToFIRA      Boolean, should DotsX use FIRA to save data?
%   FIRA_doWrite    Boolean, should DotsX write FIRA data to disk?
%   FIRA_saveDir    Where should DotsX write the FIRA data?
%   FIRA_filenameBase	Basis for automatically generated, unique
%   filenames


% Ben set moreFeedbackFunction to awesomeFeedback
%   and set the goodTrialLimit to 5 (new feature)
%   and set repeat allTasks to 4 (so we should see awesomeFeedback 4 times)
rAdd('dXparadigm',          1, ...
    'name',                 paradigmName, ...
    'screenMode',           screenMode, ...
    'taskList',             taskList, ...
    'taskOrder',            'randomTaskByTrial', ...
    'iti',                  2.0, ...
    'saveToFIRA',           true, ...
    'FIRA_doWrite',         true, ...
    'FIRA_saveDir',         FIRADir, ...
    'ROOT_saveDir',         ROOTDir, ...
    'FIRA_filenameBase',	subject, ...
    'showFeedback',         true, ...
    'feedbackSelect',       feedbackSelect, ...
    ...
    'moreFeedbackFunction', @CMDFeedback, ...
    'goodTrialLimit',       5, ...
    'repeatAllTasks',       1);

   

% use the dXparadigm instance to load the task into ROOT_STRUCT
%   this calls on all the task definition files
global ROOT_STRUCT
ROOT_STRUCT.dXparadigm = loadTasks(ROOT_STRUCT.dXparadigm);

% ask the dXparadigm where to save the ROOT_STRUCT it just created
ROOTFile = fullfile(rGet('dXparadigm', 1, 'ROOT_saveDir'), paradigmName);
save(ROOTFile, 'ROOT_STRUCT');

% For demonstration purposes, run the task now
% use a try block so as to ignore errors or F3 quitting
try
    runTasks(ROOT_STRUCT.dXparadigm);
catch
    e = lasterror
end

% all done
rDone
% clear all
