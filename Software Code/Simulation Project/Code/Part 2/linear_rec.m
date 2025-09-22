function [newimg] = linear_rec(THzData, MaskData)
% LINEAR_REC Reconstructs an image from THz measurement data and a set of binary masks using linear reconstruction

% Get dimensions of the data
[NM, NP2] = size(MaskData);
NP = sqrt(NP2);

% Check if the dimensions of the data are compatible
if length(THzData) ~= NM
    error('The length of THzData must equal the number of masks.');
end

% Compute the pseudoinverse of MaskData
MPinv = pinv(MaskData);

% Reconstruct the image using linear reconstruction
newimg = reshape(MPinv * THzData, NP, NP, []);
end