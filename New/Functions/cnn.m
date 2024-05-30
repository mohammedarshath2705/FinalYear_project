function [ conv9 ] = cnn( Input )
% CNN
%   Detailed explanation goes here

% Input=I3;
% IM=imresize(IM,[40,40]);
[row,col,chan]=size(Input);
w=rand(5,5,64);

conv1=zeros(row,col,64);
for ii=1:size(w,3)
    
    conv1(:,:,ii)=imfilter(Input,w(:,:,ii));
    
end

disp('First Convolution layer is constructed');
disp('---------------------------------');
disp('size of the Convolution layer 1 is ');
disp(size(conv1));
disp('---------------------------------');
[conv1] = ReLu(conv1);
conv2_temp=zeros(size(conv1));

for kk=1:size(conv1,3)
for ii=1:2:size(conv1,1)-2
    for jj=1:2:size(conv1,2)-2
        temp=conv1(ii:ii+2,jj:jj+2,kk);
        t=max(temp(:));
        conv2_temp(ii,jj,kk)=t;  
    end
end
end


conv2=conv2_temp(1:2:end,1:2:end,:);
disp('Max-pooling was done with 2X2 stride');
disp('Second Convolution layer is constructed');
disp('---------------------------------');
disp('size of the Convolution layer 2 is ');
disp(size(conv2));
disp('---------------------------------');
[conv2] = ReLu(conv2);
conv3_temp=zeros(size(conv2));

for kk=1:size(conv2,3)
for ii=1:2:size(conv2,1)-2
    for jj=1:2:size(conv2,2)-2
        temp=conv2(ii:ii+2,jj:jj+2,kk);
        t=max(temp(:));
        conv3_temp(ii,jj,kk)=t;  
    end
end
end


conv3_max=conv3_temp(1:2:end,1:2:end,:);
disp('Max-pooling was done with 2X2 stride');

w=rand(3,3,2);
conv3=zeros(size(conv3_max,1),size(conv3_max,2),size(conv3_max,3)*2);
for ll=1:size(w,3)-1
  for kk=1:size(conv3_max,3)
  
           temp=conv3_max(:,:,kk);
           conv3(:,:,kk+64*ll)=imfilter(temp,w(:,:,ll+1));              
           
  
  end
end


disp('Third Convolution layer is constructed');
disp('---------------------------------');
disp('size of the Convolution layer 3 is ');
disp(size(conv3));
[conv3] = ReLu(conv3);
w=rand(3,3);
 
conv4=zeros(size(conv3));

for ii=1:size(conv3,3)
    
    temp=conv3(:,:,ii);
    conv4(:,:,ii)=imfilter(temp,w);
end


disp('Fourth Convolution layer is constructed');
disp('---------------------------------');
disp('size of the Convolution layer 4 is ');
disp(size(conv4));
[conv4] = ReLu(conv4);

conv4_temp=zeros(size(conv4));

for kk=1:size(conv4,3)
for ii=1:2:size(conv4,1)-2
    for jj=1:2:size(conv4,2)-2
        temp=conv4(ii:ii+2,jj:jj+2,kk);
        t=max(temp(:));
        conv4_temp(ii,jj,kk)=t;  
    end
end
end


conv5=conv4_temp(1:2:end,1:2:end,:);
disp('Max-pooling was done with 2X2 stride');
disp('Fifth Convolution layer is constructed');
disp('---------------------------------');
disp('size of the Convolution layer 5 is ');
disp(size(conv5));
[conv5] = ReLu(conv5);
  conv6=[];
  for ii=1:size(conv5,3)
      t=conv5(:,:,ii);
      t1=t(:)';
      conv6=[conv6 t1];
  end
  [conv6] = ReLu(conv6);
  disp('Sixth Convolution layer is constructed');
disp('---------------------------------');
disp('size of the Convolution layer 6 is ');
disp(size(conv6));
  FC=1024;
conv7=zeros(1,FC);
for ii=1:FC
   conv7_temp=conv6*rand;
   conv7_temp1=sum(conv7_temp);
   
   conv7(ii)=conv7_temp1;
      
end
disp('size of the Convolution layer 7 is (FC1)');
disp(size(conv7));
disp('---------------------------------');
[conv7] = ReLu(conv7);

conv8=zeros(1,FC);
for ii=1:FC
   conv8_temp=conv7(ii)*rand;
   
   
   conv8(ii)=conv8_temp;
      
end
disp('size of the Convolution layer 8 is (FC2)');
disp(size(conv8));
disp('---------------------------------');
[conv8] = ReLu(conv8);
  FC=7;
conv9=zeros(1,FC);
for ii=1:FC
   conv9_temp=conv8*rand;
   conv9_temp1=sum(conv9_temp);
   
   conv9(ii)=conv9_temp1;
      
end
disp('size of the Convolution layer 9 is (FC3)');
disp(size(conv9));
disp('---------------------------------');
[conv9] = ReLu(conv9);

end

