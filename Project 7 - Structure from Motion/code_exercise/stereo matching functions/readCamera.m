function [K R C] = readCamera(fn)

    fid = fopen(fn, 'r');
    
    K = zeros(3);
    K(1,1:3) = fscanf(fid,'%f',3);
    K(2,1:3) = fscanf(fid,'%f',3);
    K(3,1:3) = fscanf(fid,'%f',3);
    
    dummy = zeros(3,1);
    dummy(:) = fscanf(fid,'%f',3);
    
    R = zeros(3);
    R(:) = fscanf(fid,'%f',9);
    
    C = zeros(3,1);
    C(:) = fscanf(fid,'%f',3);
    
    fclose(fid);
    
end