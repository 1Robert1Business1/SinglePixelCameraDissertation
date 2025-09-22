% test_linear_rec.m
clear all;

% Sample pattern
NP = 40; % Number of pixels
image_pattern = create_sample_pattern(NP);
figure(1), subplot(6, 3, 1), imagesc(image_pattern), title('Original image(NM)')

% Simulate mask set data
num_masks = [100, 600, 1200, 1600, 1650];
for i = 1:length(num_masks)
    NM = num_masks(i);
    test(image_pattern, NM, NP, i);
end

% Functions
function [pattern] = create_sample_pattern(NP)
    pattern = zeros(NP);
    pattern(:, 1:3) = 1;
    pattern(:, 14:16) = 1;
    pattern(:, 24:26) = 1;
    pattern(:, 38:40) = 1;
    pattern(1:3, :) = 1;
    pattern(14:16, :) = 1;
    pattern(24:26, :) = 1;
    pattern(38:40, :) = 1;
end

function test(image_pattern, num_masks, num_pixels, idx)
    [mask_data, thz_data] = generate_data(image_pattern, num_masks, num_pixels);
    reconstructed_image = linear_rec(thz_data, mask_data);
    plot_results(image_pattern, idx, mask_data, thz_data, reconstructed_image);
end

function [mask_data, thz_data] = generate_data(image_pattern, num_masks, num_pixels)
    mask_data = randi([0, 1], num_masks, num_pixels * num_pixels);
    thz_data = mask_data * image_pattern(:);
end

function plot_results(image_pattern, idx, mask_data, thz_data, reconstructed_image)
    subplot(6, 3, 3 * idx + 1), imagesc(reshape(mask_data(end, :), size(image_pattern))), title('Mask pattern')
    subplot(6, 3, 3 * idx + 2), imagesc(image_pattern .* reshape(mask_data(end, :), size(image_pattern))), title('Combined')
    subplot(6, 3, 3 * idx + 3), imagesc(reconstructed_image), title(['Reconstruction(NM=', num2str(size(mask_data, 1)), ')']);
end

function [newimg] = linear_rec(THzData, MaskData)
    % LINEAR_REC Reconstructs an image from THz measurement data and a set of binary masks using linear reconstruction

    % Get dimensions of the data
    [NM, NP2] = size(MaskData);
    NP = sqrt(NP2);

    % Compute the pseudoinverse of MaskData
    MPinv = pinv(MaskData);

    % Reconstruct the image using linear reconstruction
    newimg = reshape(MPinv * THzData, NP, NP, []);
end
