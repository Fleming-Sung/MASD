function series = test_space(dim, step)
    if size(dim, 2) == 5
        series = test_space5(dim ,step);
    elseif size(dim ,2) == 2
        series = test_space2(dim, step);
    end
end

function series = test_space5(dim, step)
    series = ones(step^size(dim,1), size(dim,1));
    yu5 = 0; yu4 = yu5; yu3 = yu4; yu2 = yu3; yu1 = yu2;
    for i=1:size(series,1)
        
        if yu1 == step
            yu1 = 0;
            yu2 = yu2 + 1;
            if yu2 == step
                yu2 = 0;
                yu3 = yu3 + 1;
                if yu3 == step
                    yu3 = 0;
                    yu4 = yu4 + 1;
                    if yu4 == step
                        yu4 = 0;
                        yu5 = yu5 +1;
                    end
                end
            end
        end
        
        series(i,1) = dim(5,1) + (yu5)*(dim(5,2)-dim(5,1))/(step-1);
        series(i,2) = dim(4,1) + (yu4)*(dim(4,2)-dim(4,1))/(step-1);
        series(i,3) = dim(3,1) + (yu3)*(dim(3,2)-dim(3,1))/(step-1);
        series(i,4) = dim(2,1) + (yu2)*(dim(2,2)-dim(2,1))/(step-1);
        series(i,5) = dim(1,1) + (yu1)*(dim(1,2)-dim(1,1))/(step-1);

        yu1 = yu1 + 1;
    end
end

function series = test_space2(dim, step)
    series = ones(step^size(dim,1), size(dim,1));
    yu5 = 0; yu4 = yu5; yu3 = yu4; yu2 = yu3; yu1 = yu2;
    for i=1:size(series,1)
        
        if yu1 == step
            yu1 = 0;
            yu2 = yu2 + 1;            
        end
        series(i,end -1) = dim(2,1) + (yu2)*(dim(2,2)-dim(2,1))/(step-1);
        series(i,end) = dim(1,1) + (yu1)*(dim(1,2)-dim(1,1))/(step-1);
        yu1 = yu1 + 1;
    end
end