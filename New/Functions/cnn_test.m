function [ test_Feature ] = cnn_test( ImR )


[H_Feature] = blpoc( ImR );
[conv9] = cnn( ImR );

test_Feature = [H_Feature conv9];
        
        
end

