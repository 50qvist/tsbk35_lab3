function Q = jpgqmtx
%jpgqmtx - Return an example JPEG quantization matrix
%------------------------------------------------------------------------------
%SYNOPSIS       Q = jpgqmtx
%                 The returned vector Q is the example luminance quantization
%                 matrix from Table K.1 in the JPEG standard document.
%                 The order of the quantization values is supposed to be
%                 corresponding to the dct2basemx() operation.
%
%
%RCSID          $Id: jpgqmtx.m,v 1.4 1998/11/22 23:57:52 harna Exp $
%------------------------------------------------------------------------------
%Harald Nautsch                        (C) 1998 Image Coding Group. LiU, SWEDEN

Q=[16  12  14  14  18  24  49  72 ...
   11  12  13  17  22  35  64  92 ...
   10  14  16  22  37  55  78  95 ...
   16  19  24  29  56  64  87  98 ...
   24  26  40  51  68  81 103 112 ...
   40  58  57  87 109 104 121 100 ...
   51  60  69  80 103 113 120 103 ...
   61  55  56  62  77  92 101  99]';

