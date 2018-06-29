%�۲������ĸ���Ҷͼ�������ݲ��ĵ�

clear;clc;

%% ��ȡͼ��
img = imread('data\noise1.png');
if size(img, 3) == 3
    img = rgb2gray(img);
end
figure;
imshow(img);

%% ���ٸ���Ҷ�任
IMG = fft2(img);                            %���и���Ҷ�任

% figure;
% imshow(log(abs(IMG) + 1), []);

%% Ƶ��ͼ�����
Guv = fftshift(IMG);                        %�Ը���Ҷ�任�Ľ�����о��д���
figure;
mesh(abs(Guv));
figure;
imshow(log(abs(Guv) + 1), []);
%�������
GvuOut = log(abs(Guv) + 1);
GvuOut = GvuOut * 255 / max(GvuOut(:));
GvuOut = uint8(GvuOut);
imwrite(GvuOut, 'data\noise1FT.png');

%% С�ߴ� Butterworth ��ͨ�˲���
lengthOfSide = 35;
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
% figure;
% mesh(Huv);
figure;
imshow(Huv, []);

%% �����ݲ���ͨģ��
HNPuv = zeros(size(Guv, 1) + 2 * halfLengthOfSideFloor);

POINTS = [370 317; 371 345; 363 368; 308 360; 363 79; 370 28; 316 20; 370 220; ...
    198 288; 220 295; 211 60];
HLINES = [370 307 327; 363 361 375; 363 73 85; 370 11 45; 194 1 170; 194 218 386];
VLINES = [184 218 386; 208 218 386; 193 218 386; 195 218 386];
for i = 1 : size(HLINES, 1)
    tempR = repmat(HLINES(i, 1), HLINES(i, 3) -  HLINES(i, 2) + 1, 1);
    tempC = HLINES(i, 2) :  HLINES(i, 3);
    tempC = tempC';
    temp = [tempR, tempC];
    POINTS = [POINTS; temp];
end
for i = 1 : size(VLINES, 1)
    tempC = repmat(VLINES(i, 1), VLINES(i, 3) -  VLINES(i, 2) + 1, 1);
    tempR = VLINES(i, 2) :  VLINES(i, 3);
    tempR = tempR';
    temp = [tempR, tempC];
    POINTS = [POINTS; temp];
end

for i = 1 : size(POINTS, 1)
    HNPuv(POINTS(i, 1) : POINTS(i, 1) + 2 * halfLengthOfSideFloor, POINTS(i, 2) : POINTS(i, 2) + 2 * halfLengthOfSideFloor) =  ...
        max(Huv, HNPuv(POINTS(i, 1) : POINTS(i, 1) + 2 * halfLengthOfSideFloor, POINTS(i, 2) : POINTS(i, 2) + 2 * halfLengthOfSideFloor));
end

HNPuv = HNPuv(1 + halfLengthOfSideFloor : end - halfLengthOfSideFloor, 1 + halfLengthOfSideFloor : end - halfLengthOfSideFloor);
HNPuv = max(HNPuv, rot90(HNPuv, 2));

figure;
imshow(HNPuv, []);

%% ����
Nuv = (1 - HNPuv) .* Guv;

figure;
imshow(log(abs(Nuv)), []);

%% �任�ؿռ���
NuvShift = ifftshift(Nuv);                 %�Ծ��еĸ���Ҷ�任������л�ԭ
fxy = real(ifft2(NuvShift));               %���и���Ҷ��任

figure;
imshow(uint8(fxy))


