

%% Initial Testing for matlab model 

% iniitial testing with a very simple model of network with only 5 neurons.
% All neurons have two ouptuts and one input except for the 5th neuron
% which has three inputs.

%from   
%    to n1 n2 n3 n4 n5
% n1        *
% n2           *  
% n3     *        *
% n4        *        *
% n5     *     *

%% definition of each neuron

%%S system state
S = [];

nNeurons=5;

W=generateNetworkConnections(nNeurons);
S=generateNetworkState(nNeurons);












