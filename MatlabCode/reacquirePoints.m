%separate image into 4 quadrants, get points in each quadrant
%to keep balance around head - otherwise may lose points on 1 side or
%another, causing bounding box to grow or shrink inappropriately
function points = reacquirePoints(img, bboxPoints)
    halfHeight = (bboxPoints(3,1)-bboxPoints(1,1)) * .5;
    halfWide = (bboxPoints(3,2)-bboxPoints(1,2)) * .5;
    halfRowSt = bboxPoints(1,1) + halfHeight;
    halfColSt = bboxPoints(1,2) + halfWide;
    %find points in each of 4 quadrants
    
    %upper left
    bbox = [bboxPoints(1,1),bboxPoints(1,2),halfHeight,halfWide];
    newPoints1 = detectMinEigenFeatures(img, 'ROI', bbox);

   %upper right
    bbox = [bboxPoints(1,1),halfColSt,halfHeight,halfWide];
    newPoints2 = detectMinEigenFeatures(img, 'ROI', bbox);

   %lower left
    bbox = [halfRowSt,bboxPoints(1,2),halfHeight,halfWide];
    newPoints3 = detectMinEigenFeatures(img, 'ROI', bbox);

   %lower right
    bbox = [halfRowSt,halfColSt,halfHeight,halfWide];
    newPoints4 = detectMinEigenFeatures(img, 'ROI', bbox);

    points = vertcat(newPoints1,newPoints2,newPoints3,newPoints4);
    points = points.Location;
    
end