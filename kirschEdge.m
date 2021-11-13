function [imageOut] = kirschEdge(imageIn)
% kirschEdge.m
% J. Jenkinson, UTSA ECE, SiViRT, May 5, 2015.
% 我们做了一些修改
% 2021-11-10
imageIn = double(imageIn);
[N M L] = size(imageIn);
g = double( (1/15)*[5 5 5;-3 0 -3; -3 -3 -3] );
kirschImage = zeros(N,M,8);

% figure,
% for j = 1:8
%     theta = (j-1)*45;
%     gDirection = imrotate(g,theta,'crop');
%     kirschImage(:,:,j) = conv2(imageIn,gDirection,'same');
%     figure,imshow(kirschImage(:,:,j),[]),title(num2str(theta))
% end

j=1;
theta = (j-1)*45;
gDirection = imrotate(g,theta,'crop');
kirschImage(:,:,1) = conv2(imageIn,gDirection,'same');
% %subplot(2,4,1),imshow(kirschImage(:,:,1),[]),title(num2str(theta))

j=5;
theta = (j-1)*45;
gDirection = imrotate(g,theta,'crop');
kirschImage(:,:,2) = conv2(imageIn,gDirection,'same');
%subplot(2,4,2),imshow(kirschImage(:,:,2),[]),title(num2str(theta))

imageOut = zeros(N,M);
for n = 1:N
    for m = 1:M
        imageOut(n,m) = max(kirschImage(n,m,:));
    end
end
