function test(ima, NM, NP, x ) %[ ima, imga, imgb, imgc ] = 
subplot(6,3,3*x+1),imga=imagesc(ima);title('mask pattern')
subplot(6,3,3*x+2),imgb=imagesc(ima);title('combined')
a=3*x+1;
b=3*x+2;
c=3*x+3;
MaskData=zeros(NM,NP*NP);

for i=1:NM
    temp=rand(NP); temp=temp>0.5;
    MaskData(i,:)= temp(:);
    %pause(0.1)
    tempa=reshape(temp,NP,NP);%mask pattern
    set(imga,'CData',tempa);
    tempb=tempa.*ima; %combined patten
    set(imgb,'CData',tempb);
end
THzData=MaskData*ima(:); % simulate terahertz measurement data
% reconstruction
newimg=linear_rec(THzData, MaskData); % call the reconstruciton function
% reifne and plot
newimg=squeeze(newimg);
newimg=newimg.*(newimg>0);
subplot(6,3,3*x+3),imgc=imagesc(newimg);title(['Reconstruction(NM=' , num2str(NM), ')']); 


end