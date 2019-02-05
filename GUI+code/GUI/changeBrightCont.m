function [ J ] = changeBrightCont( I, cont, bright )

I2 = double(I) + 255*bright;

I2(I2>255)=255;
I2(I2<0)=0;

contr = (I2 - mean(mean(I2))) .* 10*cont;
J = I2(:,:) + round(contr);

J(J>255)=255;
J(J<0)=0;

J = uint8(J);

end

