% analysis script
%
% Created 6/18/2018 by jig

% Get the data
testFilename = 'data_2018_08_22_10_45';
[topNode, FIRA] = topsTreeNodeTopNode.getDataFromFile(testFilename, 'DBSStudy');

% timing indices
sgis = cat(2, ...
   find(strcmp(FIRA.ecodes.name, 'time_screen_targsOn'), 1), ...
   find(strcmp(FIRA.ecodes.name, 'time_screen_dotsOn'), 1), ...
   find(strcmp(FIRA.ecodes.name, 'time_screen_targsOff'), 1), ...
   find(strcmp(FIRA.ecodes.name, 'time_screen_fixOff'), 1), ...
   find(strcmp(FIRA.ecodes.name, 'time_screen_dotsOff'), 1), ...
   find(strcmp(FIRA.ecodes.name, 'time_screen_fdbkOn'), 1));
rti = find(strcmp(FIRA.ecodes.name, 'RT'), 1);

% task indices
%  1  = VGS
%  2  = MGS
%  3  = Quest dots
%  7  = Speed, no bias
%  10 = Accuracy, no bias
figure
tis = [1 2 3 7 10];
nts = length(tis);
lm  = 15;
td  = 8; % target distance -- probably can/should read this from the topNode
clf
for tt = 1:nts
   
   for ii = find(FIRA.ecodes.data(:,1)==tis(tt))'
      
      tax   = FIRA.analog.data{ii}(:,1);
      xs    = FIRA.analog.data{ii}(:,2);
      ys    = FIRA.analog.data{ii}(:,3);
            
      % get index of saccade soon after RT
      if FIRA.ecodes.data(ii,1) <= 2
         refTime = FIRA.ecodes.data(ii,sgis(4)); % Fix off for VGS/MGS
      else
         refTime = FIRA.ecodes.data(ii,sgis(2)); % Dots on
      end
      
      sacEndTime  = refTime+FIRA.ecodes.data(ii,rti)+0.2;
      fixIndex    = find(tax>=FIRA.ecodes.data(ii,sgis(4)),1);
      sacEndIndex = find(tax>=(sacEndTime),1);
      Lgood       = tax>=(refTime-0.4) & tax<=min(sacEndTime+0.5, FIRA.ecodes.data(ii,sgis(6))-0.5);

      % x vs y
      subplot(nts, 2, (tt-1)*2+1); hold on;
      plot([-lm lm], [0 0], 'k:');
      plot([0 0], [-lm lm], 'k:');
      if FIRA.ecodes.data(ii,1) <= 2
         plot([-td td 0 0], [0 0 -td td], 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 12);
      else
         plot([-td td], [0 0], 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 12);
      end
      plot(xs(Lgood), ys(Lgood), 'k-');
      plot(xs(fixIndex), ys(fixIndex), 'go', 'MarkerSize', 12);
      plot(xs(sacEndIndex), ys(sacEndIndex), 'go', 'MarkerFaceColor', 'g', 'MarkerSize', 12);
      axis([-lm lm -lm lm]);
      
      % x,y vs t
      subplot(nts, 2, (tt-1)*2+2); hold on;
      plot([-1 2], [0 0], 'k:');
      plot([0 0], [-lm lm], 'k:');
      plot([-1 2],  [td td], 'r:');
      plot([-1 2], -[td td], 'r:');
      plot(tax(Lgood)-refTime, xs(Lgood), 'c-');
      plot(tax(Lgood)-refTime, ys(Lgood), 'm-');
   end
end