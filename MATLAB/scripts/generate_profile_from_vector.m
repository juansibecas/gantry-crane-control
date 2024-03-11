function profile = generate_profile_from_vector(v, Hc)
    dims = size(v);
    if dims(1) ~= 1
        disp('error. vector must have a single row')
        x = [];
        y = [];
        return
    end
    cols = length(v);
    s = 100*Hc;
    N = cols*100*Hc;
    x = linspace(0, cols*Hc, N);
    
    for i=1:cols
        for j=1:s
            if i==1 && j==1
                y = v(i)*Hc;
            else
                y = [y, v(i)*Hc];
            end
        end
    end
    profile = zeros(2, N);
    profile(1,:) = x;
    profile(2,:) = y;
end