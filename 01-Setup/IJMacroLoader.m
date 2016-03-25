function [] = IJMacroLoader(Macro)
%IMAGEJMACROLOADER Summary of this function goes here
%   Detailed explanation goes here
% 1=SpotFinder
% 2=CoordinateFinder
% 3=Cleaner
% 4=SubstackMaker

global homedir

switch Macro
    case 1
        MacroName='SpotFinder.ijm';
    case 2
        MacroName='CoordinateFinder.ijm';
    case 3
        MacroName='Cleaner.ijm';
    case 4
        MacroName='SubstackMaker.ijm';
end

MacroDir='02-Macro\';

macropath=['path=[' homedir MacroDir MacroName ']'];
ijmacro = strrep(macropath, '\', '\\');
MIJ.run('Run...',ijmacro);
end

