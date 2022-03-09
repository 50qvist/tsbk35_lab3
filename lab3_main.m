img = im2double(imread("image1.png"));

transcoder(img, 'dwht', 'linear', 'huffman', false, 16, 0.1, 0.5)