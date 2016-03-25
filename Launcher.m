global temppath resultpath homedir

%check
if exist('temppath')==0
    run Initialiser;
end

%IJMacroLoader()
% 1=SpotFinder
% 2=CoordinateFinder
% 3=Cleaner
% 4=SubstackMaker
IJMacroLoader(1);
pause(1);
run fit27;
run grapher3;
IJMacroLoader(2);
run xy5;
run logger;
IJMacroLoader(3);
%close all;
%%%%%%%%%%%%%%%%%
