function [feat_disease,seg_img] = get_features(I,resize_h,resize_w)

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

% figure,imshow(bw),title('bw');

bw_3l=uint8(cat(3,bw,bw,bw));

seg_img=I.*bw_3l;

% bw_img=imresize(bw,[resize_h,resize_w]);

% figure,imshow(bw_img),title('bw img disease');

seg_img=imresize(seg_img,[resize_h,resize_w]);

disease_img=seg_img;

% figure,imshow(seg_img),title('rec img');

img_gray=rgb2gray(seg_img);

% 灰度共生矩阵 GLCMs
glcms = graycomatrix(img_gray);

% 获取对比度、互相关、能量、齐次性（同质性）
stats = graycoprops(glcms,'Contrast Correlation Energy Homogeneity');
Contrast = stats.Contrast; % 对比度
Correlation = stats.Correlation; % 互相关
Energy = stats.Energy; % 能量
Homogeneity = stats.Homogeneity; % 齐次性（同质性）

% 均值和标准差
Mean = mean2(disease_img);
Standard_Deviation = std2(disease_img);

% 熵
Entropy = entropy(disease_img);

% 均方根
RMS = mean2(rms(seg_img));

% 方差
Variance = mean2(var(double(disease_img)));

% 平滑度
a = sum(double(disease_img(:)));
Smoothness = 1-(1/(1+a));

% 峰度
Kurtosis = kurtosis(double(disease_img(:)));

% 偏度
Skewness = skewness(double(disease_img(:)));

% 逆差矩 Inverse Difference Moment 测量图像的局部均匀性
m = size(disease_img,1);
n = size(disease_img,2);
in_diff = 0;
for i = 1:m
    for j = 1:n
        temp = disease_img(i,j)./(1+(i-j).^2);
        in_diff = in_diff+temp;
    end
end
IDM = double(in_diff);
    
feat_disease = [Contrast,Correlation,Energy,Homogeneity, Mean, Standard_Deviation, Entropy,RMS, Variance, Smoothness, Kurtosis, Skewness, IDM];
end
