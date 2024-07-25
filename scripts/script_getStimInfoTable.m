% Read in TDT block struct in matalb and extract table with with data on
% all DBS stim conditions

pn = 'L:\Shared drives\Johnson\Lab Projects\Project - ET RO1 preclinical\reports\2023-03-03 Bipolar art test & dry chamber improve\data\tank\';
fn = 'protocol_01-230303-120743';

tdt = TDTbin2mat([pn fn]);

nRows = 156;
nStimsCum = 1;
for iRow = 1:nRows
    % iRow = 1;
    ChnA_data(iRow,1) = tdt.epocs.ChnA.data(iRow);
    ChnB_data(iRow,1) = tdt.epocs.ChnB.data(iRow);
    iStims = tdt.epocs.CntA.data(iRow);
    CntA_data(iRow,1) = iStims;
    AmA_onset{iRow,1} = [tdt.epocs.AmA_.onset(nStimsCum:(nStimsCum + iStims - 1))];
    nStimsCum = nStimsCum + iStims;

end

tab = table(ChnA_data, ChnB_data, CntA_data, AmA_onset);




