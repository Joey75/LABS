function [ x,y ] = localization( likelihood,theta)
    xs=1:1:100;
    ys=1:1:100;
    objFunction = zeros(length(xs), length(ys));
    max_value=-1*1e9;
    for i=1:length(xs)
        for j=1:length(ys)
            objFunction(i,j)=compute_obj(likelihood,theta,xs{i},ys{j});
            if objFunction(i,j)<max_value
                x=xs{i};
                y=ys{j};
                max_value=objFunction(i,j);
            end
        end
    end
end
function obj=compute_obj(likelihood,theta,x,y)
    target_x=20;
    target_y=20;
    obj=0;
    for i=1:length(likeliood)
        obj=obj+likelihood{i}*(atan((target_y-y)/(target_x-x))-theta)^2;
    end
end

