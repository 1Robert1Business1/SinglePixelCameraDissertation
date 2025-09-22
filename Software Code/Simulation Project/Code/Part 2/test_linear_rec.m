% test linear_rec(THzData, MaskData)
clear all;

o_ima=imread('5.jpg');

figure(1),subplot(2,3,1),imagesc(o_ima), title('original image')
% simulate mask set data

[a,b] = size(o_ima);
if a>b
   c=b;
else c=a;
end


H=im2double(o_ima);
ima=imresize(H,[c c]);
[m,n,l]=size(ima);



NP=c;
figure(1),subplot(2,4,1),imagesc(ima), title('original image')
% simulate mask set data
NM=200; % nunmber of masks
MaskData=zeros(NM,c*c);
subplot(2,4,2),im1=imagesc(ima);title('mask pattern')
subplot(2,4,3),im2=imagesc(ima);title('R combined')
subplot(2,4,4),im3=imagesc(ima);title('G combined')
subplot(2,4,5),im4=imagesc(ima);title('B combined')

for i=1:NM                                               
    temp=rand(c); temp=temp>0.5;
    MaskData(i,:)= temp(:);
    temp1=reshape(temp,c,c);%mask pattern
    set(im1,'CData',temp1);
    temp2=temp.*double(ima(:,:,1));%combined patten
    set(im2,'CData',temp2);
    temp3=temp.*double(ima(:,:,2));
    set(im3,'CData',temp3);
    temp4=temp.*double(ima(:,:,3));
    set(im4,'CData',temp4);


end
    temp5(:,:,1)=temp2;
    temp5(:,:,2)=temp3;
    temp5(:,:,3)=temp4;
    temp6=double(temp5);
    subplot(2,4,6),imagesc(temp6),title('combined');
   
    temp7=ima(:,:,1);
    THzData=double(MaskData)*double(temp7(:));
    newimg(:,:,1)=linear_rec(THzData, MaskData);
    temp7=ima(:,:,2);
    THzData=double(MaskData)*double(temp7(:));
    newimg(:,:,2)=linear_rec(THzData, MaskData);
    temp7=ima(:,:,3);
    THzData=double(MaskData)*double(temp7(:));
    newimg(:,:,3)=linear_rec(THzData, MaskData);
  
  

