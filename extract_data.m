function [laser, odometry] = extract_data(file)
    fid = fopen(file);
    tline = fgetl(fid);
    while ischar(tline)
        ans = strsplit(tline);
        disp(ans(1))
        tline = fgetl(fid);
    end
end