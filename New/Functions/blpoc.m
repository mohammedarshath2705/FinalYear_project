function [ HOGfeature ] = blpoc( im )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

rows=size(im,1);
cols=size(im,2);

Ix=im;  
Iy=im;  

for i=1:rows-2
    Iy(i,:)=(im(i,:)-im(i+2,:));
end
for i=1:cols-2
    Ix(:,i)=(im(:,i)-im(:,i+2));
end
Ix=double(Ix);
Iy=double(Iy);
angle=atand(Ix./Iy);  
angle=imadd(angle,90);  
magnitude=sqrt(Ix.^2 + Iy.^2);

% figure(3);
% imshow(uint8(angle));
% title('Angle of each pixels');
% figure(4);
% imshow(uint8(magnitude));
% title('Magnitude of each pixels');

feature=[];
for i = 0: rows/8 - 2
    for j= 0: cols/8 -2
        %disp([i,j])
        
        mag_patch = magnitude(8*i+1 : 8*i+16 , 8*j+1 : 8*j+16);
        %mag_patch = imfilter(mag_patch,gauss);
        ang_patch = angle(8*i+1 : 8*i+16 , 8*j+1 : 8*j+16);
        
        block_feature=[];
        
        %Iterations for cells in a block
        for x= 0:1
            for y= 0:1
                angleA =ang_patch(8*x+1:8*x+8, 8*y+1:8*y+8);
                magA   =mag_patch(8*x+1:8*x+8, 8*y+1:8*y+8); 
                histr  =zeros(1,9);
                
                %Iterations for pixels in one cell
                for p=1:8
                    for q=1:8
%                       
                        alpha= angleA(p,q);
                        
                        % Binning Process (Bi-Linear Interpolation)
                        if alpha>10 && alpha<=30
                            histr(1)=histr(1)+ magA(p,q)*(30-alpha)/20;
                            histr(2)=histr(2)+ magA(p,q)*(alpha-10)/20;
                        elseif alpha>30 && alpha<=50
                            histr(2)=histr(2)+ magA(p,q)*(50-alpha)/20;                 
                            histr(3)=histr(3)+ magA(p,q)*(alpha-30)/20;
                        elseif alpha>50 && alpha<=70
                            histr(3)=histr(3)+ magA(p,q)*(70-alpha)/20;
                            histr(4)=histr(4)+ magA(p,q)*(alpha-50)/20;
                        elseif alpha>70 && alpha<=90
                            histr(4)=histr(4)+ magA(p,q)*(90-alpha)/20;
                            histr(5)=histr(5)+ magA(p,q)*(alpha-70)/20;
                        elseif alpha>90 && alpha<=110
                            histr(5)=histr(5)+ magA(p,q)*(110-alpha)/20;
                            histr(6)=histr(6)+ magA(p,q)*(alpha-90)/20;
                        elseif alpha>110 && alpha<=130
                            histr(6)=histr(6)+ magA(p,q)*(130-alpha)/20;
                            histr(7)=histr(7)+ magA(p,q)*(alpha-110)/20;
                        elseif alpha>130 && alpha<=150
                            histr(7)=histr(7)+ magA(p,q)*(150-alpha)/20;
                            histr(8)=histr(8)+ magA(p,q)*(alpha-130)/20;
                        elseif alpha>150 && alpha<=170
                            histr(8)=histr(8)+ magA(p,q)*(170-alpha)/20;
                            histr(9)=histr(9)+ magA(p,q)*(alpha-150)/20;
                        elseif alpha>=0 && alpha<=10
                            histr(1)=histr(1)+ magA(p,q)*(alpha+10)/20;
                            histr(9)=histr(9)+ magA(p,q)*(10-alpha)/20;
                        elseif alpha>170 && alpha<=180
                            histr(9)=histr(9)+ magA(p,q)*(190-alpha)/20;
                            histr(1)=histr(1)+ magA(p,q)*(alpha-170)/20;
                        end
                        
                
                    end
                end
                block_feature=[block_feature histr];  
                                
            end
        end
        % Normalize the values in the block using L1-Norm
        block_feature=block_feature/sqrt(norm(block_feature)^2+.01);
               
        feature=[feature block_feature];  
    end
end

feature(isnan(feature))=0;  

% Normalization of the feature vector using L2-Norm
feature=feature/sqrt(norm(feature)^2+.001);
for z=1:length(feature)
    if feature(z)>0.2
         feature(z)=0.2;
    end
end
HOGfeature=sqrt(feature/norm(feature)^2+.001);  
HOGfeature( :, ~any(HOGfeature,1)) = [];  %columns

HOGfeature = HOGfeature(1,1:255);

end

