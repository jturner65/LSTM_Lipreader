
files = dir('alignedImgSmallMats/*.mat');
for file = files'
    t = file.name(end-11:end);
    dirName = strcat('alignedImgs/', num2str(t(1:3)));
    mkdir(dirName);
    a = load(strcat('alignedImgSmallMats/', file.name));
    for i=1 : size(a.imgSmallMat,2)
        b = reshape(a.imgSmallMat(:,i), 40, 40);
        %disp(size(b));
        %imshow(b);
        name = strcat('alignedImgs/', num2str(t(1:3)), '/', num2str(i), '.jpg'); 
        imwrite(b, name);  
    end
end
