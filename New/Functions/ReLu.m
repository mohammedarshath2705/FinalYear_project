function [ normalized_voxel ] = ReLu(voxel)

[r,c,d]=size(voxel);
alpha=0.333;
normalized_voxel=size(voxel);
for ch=1:d
    for row=1:r
        for col=1:c
            F=voxel(row,col,ch);
            normalized_voxel(row,col,ch)=max(0,F)+alpha*min(0,F);
        end
    end
end

end

