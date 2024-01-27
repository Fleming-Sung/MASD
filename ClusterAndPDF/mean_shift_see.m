function [out,category] = mean_shift_see(radius,threshould,data)
% 均值漂移聚类分析
% 输入参数
% radius    聚类半径
% data      K-by-N    k个N维数据点集
% 输出参数
%%
r2 = radius*radius;
threshould2 = threshould*threshould;
[k,N] = size(data);
access_cnt = zeros(k,1);  %每个点被不同类访问次数计数
center = data(1,:);
dir = zeros(k,N);
cluster_cnt = 1;
density_l = 0;
cnt = 0;
 
theta = (0:1:360)/180*pi;
circle_x = radius*cos(theta);
circle_y = radius*sin(theta);
 
figure;
h = axes;
plot(h,data(:,1),data(:,2),'k.');
hold(h,'on');grid(h,'on');
 
while 1
    cnt = cnt + 1;
    
    for i = 1:N
        dir(:,i) = data(:,i)-center(i);
    end
    dis = sum(dir.^2,2);  %按行求和
 
    indx = find(dis < r2);  %找到半径r内的数据点
    density = length(indx);
    shift = sum(dir(indx,:))/density;  %求飘移值
    access_cnt(indx,cluster_cnt) = access_cnt(indx,cluster_cnt) + 1; %当前类访问次数累加
    
    if cnt > 1
        delete(h1);
        delete(h2);
    end
    h1 = plot(h,circle_x+center(1),circle_y+center(2),'g');
    h2 = plot(h,data(indx,1),data(indx,2),'r.');
    pause(0.1)
    
%      if shift*shift' < threshould2   %判断是否满足停止收敛条件
    if density_l >= density
        density_l = 0;
        if cluster_cnt == 1
            out(cluster_cnt,:) = center;
        else
            dir_t = out;
            for kk = 1:cluster_cnt-1
                dir_t(kk,:) = out(kk,:)-center;   %将当前的收敛中心于之前的计算距离
            end
            dis_t = sum(dir_t.^2,2);
            [min_dis,min_indx] = min(dis_t);
            if min_dis < threshould2        %判断当前的中心离之前已有的中心距离是否小于阈值
                access_cnt(:,min_indx)= access_cnt(:,min_indx) + access_cnt(:,cluster_cnt);
                access_cnt(:,cluster_cnt) = 0;   %清零之前的分类访问
                cluster_cnt = cluster_cnt - 1;
            else
                out(cluster_cnt,:) = center;
            end
        end
        cluster_cnt = cluster_cnt +1;      %类别计数
        acc_cnt_p = sum(access_cnt,2);     %求每个点已被访问的次数
        no_acc_p = find(acc_cnt_p == 0);   %找出还没有被访问的点
        if size(no_acc_p,1) > 0
            center = data(no_acc_p(1),:);  %初始化成没有被访问点
        else
            break;
        end
        if size(access_cnt,2) < cluster_cnt      %判断有没有新增的类，有的话添加一类
            access_cnt = [access_cnt,zeros(k,1)];
        end
     else
        density_l = density;
        center = center + shift;  %更新中心值
        pause(0.02);        
    end
end
category = zeros(k,1);
for kk = 1:k
    [max_acc,max_indx] = max(access_cnt(kk,:));  %找出当前点的最大访问次数及其类别
    category(kk) = max_indx;                     %将对应的点表上类别
end