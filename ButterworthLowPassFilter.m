%ʵ�� Butterworth �˲���
clear;clc;

%% ��ȡͼ��
img = imread('data\origin1.png');
if size(img, 3) == 3
    img = rgb2gray(img);
end
figure('Name', 'ԭͼ');
imshow(img);

%% ���ٸ���Ҷ�任
IMG = fft2(img);                            %���и���Ҷ�任
% figure('Name', 'ԭͼ����Ҷ��');
% imshow(log(abs(IMG) + 1), []);

%% Ƶ��ͼ�����
Guv = fftshift(IMG);                        %�Ը���Ҷ�任�Ľ�����о��д���
% figure('Name', 'ԭͼƽ�ƺ���Ҷ��');
% mesh(abs(Guv));
figure('Name', 'ԭͼƽ�ƺ���Ҷ��');
imshow(log(abs(Guv) + 1), []);

%% Butterworth ��ͨ�˲���
lengthOfSide = size(img, 1);
halfLengthOfSideCeil = ceil(lengthOfSide / 2);
halfLengthOfSideFloor = floor(lengthOfSide / 2);
Duv = zeros(lengthOfSide);
for i = 1 : lengthOfSide
    for j = 1 : lengthOfSide
        Duv(i, j) = norm([i - halfLengthOfSideCeil, j - halfLengthOfSideCeil]);
    end
end

D0 = floor(halfLengthOfSideCeil / 3);
n = 2;
Huv = zeros(lengthOfSide);
for i = 1 : lengthOfSide
    for j = 1 : lengthOfSide
        Huv(i, j) = 1 / (1 + (Duv(i, j) / D0) .^ (2 * n));
    end
end
% figure('Name', 'Butterworth��ͨ�˲���');
% mesh(Huv);
figure('Name', 'Butterworth��ͨ�˲���');
imshow(Huv, []);

%% ����
Nuv = Huv .* Guv;

figure('Name', '�����ͼ����Ҷ��');
imshow(log(abs(Nuv)), []);

%% �任�ؿռ���
NuvShift = ifftshift(Nuv);                 %�Ծ��еĸ���Ҷ�任������л�ԭ
fxy = real(ifft2(NuvShift));               %���и���Ҷ��任

figure('Name', '�����ͼ��');
imshow(uint8(fxy));

%% �����˵��Ĳ���
DFuv = (1 - Huv) .* Guv;

figure('Name', '������ͼ����Ҷ��');
imshow(log(abs(DFuv)), []);

DFuvShift = ifftshift(DFuv);                 %�Ծ��еĸ���Ҷ�任������л�ԭ
dfxy = real(ifft2(DFuvShift));               %���и���Ҷ��任

figure('Name', '������ͼ��');
imshow(uint8(dfxy));


