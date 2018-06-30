%ʵ������ݲ��˲���
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
% figure;
% imshow(log(abs(IMG) + 1), []);

%% Ƶ��ͼ�����
Guv = fftshift(IMG);                        %�Ը���Ҷ�任�Ľ�����о��д���
% figure;
% mesh(abs(Guv));
figure('Name', 'ԭͼƽ�ƺ���Ҷ��');
imshow(log(abs(Guv) + 1), []);
%�������
GvuOut = log(abs(Guv) + 1);
GvuOut = GvuOut * 255 / max(GvuOut(:));
GvuOut = uint8(GvuOut);
imwrite(GvuOut, 'data\origin1FT.png');

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
figure('Name', 'С�ߴ� Butterworth ��ͨ�˲���');
imshow(Huv, []);

%% �����ݲ���ͨģ��
HNPuv = zeros(size(Guv, 1) + 2 * halfLengthOfSideFloor);

POINTS = [370 317; 371 345; 363 368; 308 360; 363 79; 370 28; 316 20; 370 220; ...
    198 288; 220 295; 211 60; ...
    208 11; 209 15; 210 57; 211 61; 213 106; 226 135; 215 153; 250 143; 209 141; 274 149; 210 152; 220 152; 215 152; ...
    256 154; 238 159; 278 160; 296 155; 319 161; 217 201; 233 193; 233 197; 216 201; 262 213; 232 232; 214 237; 253 237; ...
    196 242; 219 248; 237 243; 259 249; 276 245; 300 250; 282 255; 241 253; 242 278; 220 293; 222 297; 244 303; 266 308; ...
    198 288; 198 290; 198 334; 200 338; 198 375; 202 382; 228 52; 234 66; 246 49; 251 59; 269 54; 274 66; 235 111; ...
    283 90; 314 73; 366 76; 370 81; 384 115; 349 119; 348 126; 300 167; 316 175; 380 185; 375 178; 374 171; 381 209; ...
    253 106; 258 118; 251 191; 311 365; 217 329; 221 340; 257 331; 263 343; 312 306; 234 324; 241 340; ...
    207 120; 216 117; 356 296; 227 281; 238 291; 284 219; 290 224; 200 253; 313 183];

HLINES = [196 135 159; 196 275 304];
VLINES = [287 195 220; 290 195 216];
% HLINES = [370 307 327; 363 361 375; 363 73 85; 370 11 45; 194 1 170; 194 218 386];
% VLINES = [184 218 386; 208 218 386; 193 218 386; 195 218 386];
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

figure('Name', '�ݲ���ͨģ��');
imshow(HNPuv, []);
imwrite(HNPuv,'data\mask.png');
%% ����
Nuv = (1 - HNPuv) .* Guv;

figure('Name', '�����ͼ����Ҷ��');
imshow(log(abs(Nuv)), []);

%% �任�ؿռ���
NuvShift = ifftshift(Nuv);                 %�Ծ��еĸ���Ҷ�任������л�ԭ
fxy = real(ifft2(NuvShift));               %���и���Ҷ��任

figure('Name', '�����ͼ��');
imshow(uint8(fxy));

%% �����˵��Ĳ���
DFuv = HNPuv .* Guv;

figure('Name', '������ͼ����Ҷ��');
imshow(log(abs(DFuv)), []);

DFuvShift = ifftshift(DFuv);                 %�Ծ��еĸ���Ҷ�任������л�ԭ
dfxy = real(ifft2(DFuvShift));               %���и���Ҷ��任

figure('Name', '������ͼ��');
imshow(log(abs(dfxy)), []);

%% ʵ������˲���






