%ʵ������ݲ��˲���
clear;clc;

%% ��ȡͼ��
img = imread('data\origin1.png');
if size(img, 3) == 3
    img = rgb2gray(img);
end
figure;
imshow(img);

%% ���ٸ���Ҷ�任
IMG = fft2(img);                        %���и���Ҷ�任
figure;
imshow(log(abs(IMG) + 1), []);

%% Ƶ��ͼ�����
IMGCenter = fftshift(IMG);              %�Ը���Ҷ�任�Ľ�����о��д���
figure;
imshow(log(abs(IMGCenter) + 1), []);

IMGCenterOut = log(abs(IMGCenter) + 1);
IMGCenterOut = IMGCenterOut * 255 / max(IMGCenterOut(:));
IMGCenterOut = uint8(IMGCenterOut);
imwrite(IMGCenterOut, 'data\origin1FT.png');

%% Butterworth ��ͨ�˲���
lengthOfSide = 35;
halfLengthOfSide = ceil(lengthOfSide / 2);
Duv = zeros(lengthOfSide);
for i = 1 : lengthOfSide
    for j = 1 : lengthOfSide
        Duv(i, j) = norm([i - halfLengthOfSide, j - halfLengthOfSide]);
    end
end

D0 = floor(halfLengthOfSide / 3);
n = 2;
Huv = zeros(lengthOfSide);
for i = 1 : lengthOfSide
    for j = 1 : lengthOfSide
        Huv(i, j) = 1 / (1 + (Duv(i, j) / D0) .^ (2 * n));
    end
end
figure;
mesh(Huv);
figure;
imshow(Huv, []);

%% ������ͨģ��
HNPuv = zeros(size(IMGCenter));




%% ����


%% �任�ؿռ���



