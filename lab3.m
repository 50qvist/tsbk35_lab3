org_img = im2double(imread("image1.png"));

imgR = org_img(:,:,1);
imgG = org_img(:,:,2);
imgB = org_img(:,:,3);
imgSC = size(imgR, 2);
imgSR = size(imgR, 1);

imgYCrCb = rgb2ycbcr(org_img);

Y = imgYCrCb(:,:,1);
Cr = imgYCrCb(:,:,2);
Cb = imgYCrCb(:,:,3);

dctBlock = [8 8];
 
YDct = bdct(Y, dctBlock);

quantStepsize = 0.1;

YQuant = bquant(YDct, quantStepsize);
YBrec = brec(YQuant, quantStepsize);

YInvQuant = ibdct(YBrec, dct_block, [imgSR imgSC]);

imshow(YInvQuant)

%Y_dct_inv = ibdct(Y_dct, dct_block, [imgS_R imgS_C]);
