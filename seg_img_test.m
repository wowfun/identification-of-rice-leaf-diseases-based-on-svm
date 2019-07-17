clear,clc,close all;
cc=int2str(3);
n=33;

imgName=['rice_leaf_diseases\',cc,'\',cc,' (',int2str(n),').jpg'];
I=imread(imgName);
figure,imshow(I),title('ԭͼ');

% I = imadjust(I,stretchlim(I));
% figure, imshow(I);title('Contrast Enhanced');


re_h=100;
re_w=342;

ycbcr=rgb2ycbcr(I);
cr=ycbcr(:,:,3);
cr(cr>142&cr<160)=255;
cr(cr~=255)=0;
bw=im2bw(cr);
bw=imopen(bw,strel('disk',2));
bw=imclose(bw,strel('disk',4));
bw=imdilate(bw,strel('disk',1));
bw=imerode(bw,strel('disk',2));
bw=imclose(bw,strel('disk',6));

figure,imshow(bw),title('bw');

bw_3l=uint8(cat(3,bw,bw,bw));

seg_img=I.*bw_3l;

bw_img=imresize(bw,[re_h,re_w]);

figure,imshow(bw_img),title('bw img disease');

figure,imshow(seg_img),title('seg img');

seg_img=imresize(seg_img,[re_h,re_w]);

figure,imshow(seg_img),title('resize seg img');

bw_seg_img=im2bw(255*seg_img);

figure,imshow(bw_seg_img),title('bw seg img');
