org_img = im2double(imread("image1.png"));

imgR = org_img(:,:,1);
imgG = org_img(:,:,2);
imgB = org_img(:,:,3);
imgSC = size(imgR, 2);
imgSR = size(imgR, 1);

imgYCrCb = rgb2ycbcr(org_img);

Y = imgYCrCb(:,:,1);
Cb = imgYCrCb(:,:,2);
Cr = imgYCrCb(:,:,3);

dctBlock = [8 8];
 
YDct = bdct(Y, dctBlock);
CrDct = bdct(Cb, dctBlock);
CbDct = bdct(Cr, dctBlock);

quantStepsize = 0.1;
QL = repmat(1:8, 8,1);
QL = (QL+QL'-9)/8;
k1 = 0.01;
k2 = 0.5;
quantLinear = k1*(1+k2*QL);

usedQuantizer = quantLinear;

YQuant = bquant(YDct, usedQuantizer);
CrQuant = bquant(CrDct, usedQuantizer);
CbQuant = bquant(CbDct, usedQuantizer);

YBrec = brec(YQuant, usedQuantizer);
CrBrec = brec(CrQuant, usedQuantizer);
CbBrec = brec(CbQuant, usedQuantizer);

YInvQuant = ibdct(YBrec, dctBlock, [imgSR imgSC]);
CrInvQuant = ibdct(CrBrec, dctBlock, [imgSR imgSC]);
CbInvQuant = ibdct(CbBrec, dctBlock, [imgSR imgSC]);

reconStructedImage = zeros(size(org_img));

reconStructedImage(:,:,1) = YInvQuant;
reconStructedImage(:,:,2) = CrInvQuant;
reconStructedImage(:,:,3) = CbInvQuant;

reconStructedImage = ycbcr2rgb(reconStructedImage);
imshow(reconStructedImage)

recR = reconStructedImage(:,:,1);
recG = reconStructedImage(:,:,2);
recB = reconStructedImage(:,:,3);

RDist = mean((imgR(:)-recR(:)).^2);
GDist = mean((imgG(:)-recG(:)).^2);
BDist = mean((imgB(:)-recB(:)).^2);

psnr = (10*log10(1/RDist) + 10*log10(1/GDist) + 10*log10(1/BDist))

%p = ihist(YQuant(:));
%bits = huffman(p);
%bits_per_pixel = bits/(imgSR*imgSC)
bits=0;
for k=1:size(YQuant, 1)
    p = ihist(YQuant(k,:));
    bits = bits + huffman(p);
end
bits_per_pixel = bits/(imgSR*imgSC)

bits = sum(jpgrate(YQuant, dctBlock));
bits_per_pixel_jpg = bits/(imgSR*imgSC)


















