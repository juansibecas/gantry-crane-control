function yc = get_yc0_at_x(profile, x_query)

    xc0 = profile(1,:);
    yc0 = profile(2,:);

    y1 = interp1(xc0, yc0, x_query, 'previous');
    y2 = interp1(xc0, yc0, x_query, 'next');
    yc = max(y1, y2);
end