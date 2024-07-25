function idxArt = detectArt(data, thresh, varargin)

%% Input parser section
defaulThreshCrossEdge = 'falling';
expectedThreshCrossEdge = {'falling', 'rising'};
defaultSegWindow = [0 0];


p = inputParser;
% addRequired(p,'data',@(x)isvector);
addRequired(p,'data', @(x) isnumeric(x) && isvector(x));
addRequired(p,'thresh',@(x) isnumeric(x) && isscalar(x));
addParameter(p,'threshCrossEdge',defaulThreshCrossEdge,...
    @(x) any(validatestring(x, expectedThreshCrossEdge)));
addParameter(p,'segmentWindow', defaultSegWindow, @(x) legntgh(x) == 2);
parse(p,data,thresh,varargin{:});

  
%% Main Code

threshCrossEdge = p.Results.threshCrossEdge;

% if ~exist('threshCrossEdge')
%     threshCrossEdge = 'falling'; % 'rising' | 'falling'
%     
% end


idxAbove = data > thresh;
idxBelow = data < thresh;
idxDetect = idxAbove + -idxBelow;
idxCross = [0 diff(idxDetect)];

switch threshCrossEdge
    case 'falling'
        idxArt = idxCross == -2;
        
    case 'rising'
        idxArt = idxCross == 2;
        
    otherwise
        error('Enter 3rd input as string, either "falling" or "rising"!');
        
end





end