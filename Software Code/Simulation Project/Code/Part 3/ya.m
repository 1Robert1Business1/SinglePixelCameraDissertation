function [Im]=ya(Img, f, g ,x)

a = f-mod(f,x);
b = g-mod(g,x);
H=im2double(Img);

Im=imresize(H,[a b]);
end