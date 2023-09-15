% 二维场景下将结果列表还原为矩阵
function tableTTC = list2table(list, step)
    tableTTC = zeros(sqrt(length(list)));
    for i=1:length(list)
        jj = ceil(i / step);
        ii = i - step*(jj-1);
        nowttc = list(i);
        tableTTC(ii,jj) = nowttc;
    end
end