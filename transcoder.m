function []=transcoder(im, transformMethod,quantMethod, sourceMethod, subsampleBool, blockSize, k1, k2)

dctBlock = [blockSize blockSize];
blockSize
sqrt(blockSize)
sqrtDctBlock = [sqrt(blockSize) sqrt(blockSize)]

qy = k1;
qc = k2;

imy=rgb2ycbcr(im);

bits=0;

imyr=zeros(size(im));

if transformMethod == "dct"
    tmp = bdct(imy(:,:,1), dctBlock); % DCT
else
    tmp = bdwht(imy(:,:,1), dctBlock);
end

usedQuantizer = 0;
if quantMethod == "linear"
    QL = repmat(1:8, 8,1);
    QL = (QL+QL'-9)/8;
    usedQuantizer = k1*(1+k2*QL);  
else
    usedQuantizer = qy;
end

tmp = bquant(tmp, usedQuantizer);

p = ihist(tmp(:));                 
bits = bits + huffman(p);          
			
if sourceMethod == "huffman_loop"
    for k=1:size(tmp, 1)
        p = ihist(tmp(k,:));
        bits = bits + huffman(p);
    end
elseif sourceMethod == "jpg"
    bits = sum(jpgrate(tmp, dctBlock));
else
    p = ihist(tmp(:));                
    bits = bits + huffman(p);  
end                               

tmp = brec(tmp, usedQuantizer); 

if transformMethod == "dct"
    imyr(:,:,1) = ibdct(tmp, dctBlock, [512 768]); 
else
    imyr(:,:,1) = ibdwht(imy(:,:,1), sqrtDctBlock, [512 768]);
end


for c=2:3


  tmp = imy(:,:,c);
  
    if transformMethod == "dct"
        tmp = bdct(tmp, dctBlock); % DCT
    else
        tmp = bdwht(tmp, dctBlock);
    end
  
  
  
  usedQuantizer = 0;
    if quantMethod == "linear"
        QL = repmat(1:8, 8,1);
        QL = (QL+QL'-9)/8;
        usedQuantizer = k1*(1+k2*QL);  
    else
        usedQuantizer = qy;
    end

    tmp = bquant(tmp, usedQuantizer);

    p = ihist(tmp(:));                 
    bits = bits + huffman(p);          

    if sourceMethod == "huffman_loop"
        for k=1:size(tmp, 1)
            p = ihist(tmp(k,:));
            bits = bits + huffman(p);
        end
    elseif sourceMethod == "jpg"
        bits = sum(jpgrate(tmp, dctBlock));
    else
        p = ihist(tmp(:));                
        bits = bits + huffman(p);  
    end                               
    tmp = brec(tmp, usedQuantizer);
    
    if transformMethod == "dct"
        tmp = ibdct(tmp, dctBlock, [512 768]);
    else
        tmp = ibdwht(tmp, sqrtDctBlock, size(tmp));
    end
    
    imyr(:,:,c) = tmp;

end


bits
bpp = bits/(size(im,1)*size(im,2))

imr=ycbcr2rgb(imyr);

dist = mean((im(:)-imr(:)).^2)
psnr = 10*log10(1/dist)

figure, imshow(im)
title('Original image')

figure, imshow(imr);
title(sprintf('Decoded image, %5.2f bits/pixel, PSNR %5.2f dB', bpp, psnr))

