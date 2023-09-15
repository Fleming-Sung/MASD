function  [minTTC, traj]= cal_ttc(logsout)
   egoTraj = logsout{3}.Values;
   car1Tarj = logsout{4}.Values.Actors(1,:);
   car2Tarj = logsout{4}.Values.Actors(2,:);
   car3Tarj = logsout{4}.Values.Actors(3,:);
   traj = zeros(length(egoTraj.Position.Data), 8);

   [dist1, ttc1, traj] = calDistance(egoTraj.Position.Data, car1Tarj.Position.Data, traj, [3,4]);
   [dist2, ttc2, traj] = calDistance(egoTraj.Position.Data, car2Tarj.Position.Data, traj, [5,6]);
   [dist3, ttc3, traj] = calDistance(egoTraj.Position.Data, car3Tarj.Position.Data, traj ,[7,8]);
   ttc1(1) = min([ttc1(1), ttc2(1), ttc3(1)]); % 输出矩阵中ttc1的第一个值为整个场景的最小ttc
   minTTC = ttc1(1);
%    ttcList = [dist1, dist2, dist3, ttc1, ttc2, ttc3];
end

function [distanceList, ttcList, PosList] = calDistance(egoPos, bgPos, PosList, ActorColum)
num = length(egoPos);
distanceList = zeros(num,1);
ttcList = ones(num,1)*inf;

x11 = egoPos(1,1,1);
x12 = bgPos(1,1,1);
y11 = egoPos(1,2,1);
y12 = bgPos(1,2,1);
iniDist = sqrt((x11-x12)^2 + (y11-y12)^2);
distanceList(1) = iniDist;
PosList(1,1:2) = [x11, y11];
PosList(1,ActorColum) = [x12, y12];

minttc = inf;
for i=2:num
    x1 = egoPos(1,1,i);
    x2 = bgPos(1,1,i);
    y1 = egoPos(1,2,i);
    y2 = bgPos(1,2,i);
    distance = sqrt((x1-x2)^2 + (y1-y2)^2);
    lastDist = distanceList(i-1);
    relativeSpeed = (lastDist - distance)/0.1; % 当二者距离变近时为正值。0.1为仿真步长
    ttc = distance / relativeSpeed;
    if ttc > 0 && distance <= 12 % 只有正ttc才有效
%     if ttc > 0
        ttcList(i) = ttc;
        if ttcList(i) < minttc
            minttc = ttcList(i);
        end
    end
    distanceList(i) = distance;
    PosList(i, 1:2) = [x1, y1];
    PosList(i, ActorColum) = [x2, y2];
end
ttcList(1) = minttc;
end