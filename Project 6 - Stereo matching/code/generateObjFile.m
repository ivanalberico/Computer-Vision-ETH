function generateObjFile (objName,imName,coords,mask)

% mask determines for which pixels triangles are created

% specifies the resolution of your mesh
% the larger res, the less vertices you get
res = 2;

fnObj = [objName '.obj'];
fnMtl = [objName '.mtl'];

fid = fopen(fnMtl, 'w');
fprintf(fid, ['newmtl imgTex\n' ...
    'Ka 1.000 1.000 1.000\n' ...
    'Kd 1.000 1.000 1.000\n' ...
    'Ks 0.000 0.000 0.000\n' ...
    'map_Ka %s\n' ...
    'map_Kd %s\n' ...
    'map_Ks %s\n'], ...
    imName,imName,imName);
fclose(fid);

fid = fopen(fnObj, 'w');

fprintf(fid, 'mtllib %s\nusemtl imgTex\n',fnMtl);

for y=1:size(coords,1)
    for x=1:size(coords,2)
        fprintf(fid, 'v %f %f %f\n', coords(y,x,1), coords(y,x,2), coords(y,x,3));
    end
end

for y=1:size(coords,1)
    for x=1:size(coords,2)
        fprintf(fid, 'vt %f %f \n', (x-1)/size(coords,2), (size(coords,1)-y)/size(coords,1));
    end
end

vIds = zeros(size(coords,1),size(coords,2));
vertexId = 1;
for y=1:size(coords,1)
    for x=1:size(coords,2)
        vIds(y,x) = vertexId;
        vertexId = vertexId+1;
    end
end

for y=size(coords,1):-res:1+res
    for x=1:res:size(coords,2)-res
        if (mask(y,x)==1&&mask(y,x+res)==1&&mask(y-res,x)==1)
            fprintf(fid, 'f %d/%d %d/%d %d/%d\n', vIds(y,x),vIds(y,x),vIds(y,x+res),vIds(y,x+res),vIds(y-res,x),vIds(y-res,x));
        end
        if (mask(y,x+res)==1&&mask(y-res,x+res)==1&&mask(y-res,x)==1)
            fprintf(fid, 'f %d/%d %d/%d %d/%d\n', vIds(y,x+res),vIds(y,x+res),vIds(y-res,x+res),vIds(y-res,x+res),vIds(y-res,x),vIds(y-res,x));
        end
    end
end

fclose(fid);