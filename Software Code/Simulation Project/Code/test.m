function test(ima, NM, NP, x)
% Generates random binary masks, applies them to the input image, and reconstructs the image using linear reconstruction

% Display the mask pattern
subplot(6, 3, 3*x+1), imga = imagesc(ima); title('mask pattern')

% Display the combined pattern
subplot(6, 3, 3*x+2), imgb = imagesc(ima); title('combined')

% Create the binary masks and apply them to the input image
MaskData = zeros(NM, NP*NP);
for i = 1:NM
    temp = rand(NP) > 0.5;
    MaskData(i, :) = temp(:);
    tempa = reshape(temp, NP, NP);
    set(imga, 'CData', tempa);
    tempb = tempa .* ima;
    set(imgb, 'CData', tempb);
end