clc
clear
close all

%% 绘制地图
% 栅格行数、列数
rows = 25;
columns = 27;
% 起点、终点、障碍物
start_node = [2, 3];
target_node = [23, 23];
obs = [4, 2;4, 3;4, 4;5, 6;22, 21;10, 11; 10, 12;10, 13; 10, 7;22, 23];

% 绘制栅格
for i = 0 : rows
    plot([0, columns], [i, i], 'k');  % k-黑色
    hold on
end
for i = 0 : columns
    plot([i, i], [0, rows], 'k');
    hold on
end
axis equal  % 横纵坐标同比例
xlim([0, columns])
ylim([0, rows])

% 绘制起点、终点、障碍物
fill([start_node(1), start_node(1), start_node(1)-1, start_node(1)-1],...
    [start_node(2), start_node(2)-1, start_node(2)-1, start_node(2)], 'g');

fill([target_node(1), target_node(1), target_node(1)-1, target_node(1)-1],...
    [target_node(2), target_node(2)-1, target_node(2)-1, target_node(2)], 'r');

for i = 1 : size(obs, 1)
    obs_node = obs(i, :);
    fill([obs_node(1), obs_node(1), obs_node(1)-1, obs_node(1)-1],...
    [obs_node(2), obs_node(2)-1, obs_node(2)-1, obs_node(2)], 'b');
end

%% 预处理：将起点加入open list
open_list = {start_node, 0, 0, 0, [start_node; ]};  % 每行表示一个节点
                                                    % 第一列 该节点坐标；第二列 F值；第三列 G值；
                                                    % 第四列 H值；第五列 到该点的路径
close_list = cell(0);

%% 寻找最优路径
while true
    % 遍历open_list，找到F值最小的节点作为父节点
    [~, idx_par] = min([open_list{:, 2}]);  % 需要将open_list{:, 2}的结果转为数组
    node_par = open_list(idx_par, :);

    % 将父节点加入close_list
    close_list(end+1, :) = node_par;

    % 寻找父节点的可行子节点(在地图上，不是障碍物，不在close_list中)
    child_nodes = child_nodes_cal(node_par, rows, columns, obs, close_list);

    % 遍历子节点，判断子节点是否在open_list中，若在，则比较更新；没在则追加到open_list中
    num_child = size(child_nodes, 1);
    for i = 1 : num_child
        child_node = child_nodes(i,:);
        
        open_list_temp = [];
        for k = 1 : size(open_list, 1)
            open_list_temp = [open_list_temp; open_list{k, 1}]; % 将open_list{k, 1}转为数组
        end
        [in_flag, open_list_idx] = ismember(child_node, open_list_temp, "rows");
        G = node_par{3} + norm(node_par{1} - child_node);
        H = abs(child_node(1) - target_node(1)) + abs(child_node(2) - target_node(2));
        F = G+H;
        
        if in_flag   % 若在，比较更新G和F (H不变)       
            if G < open_list{open_list_idx, 3}
                open_list{open_list_idx, 2} = F;
                open_list{open_list_idx, 3} = G;
                % 更新到该点的路径
                open_list{open_list_idx, 5} = [node_par{5}; child_node];
            end
        else         % 若不在，追加到openList
            open_list(end+1,:) = {child_node, F, G, H, [node_par{5}; child_node]};

        end
    end
    
    % 之所以不在 将父节点加入close_list 时在open_list中删除父节点，是为了防止ismember和空比较
    open_list(idx_par, :) = []; % cell增删元素 参考：https://blog.csdn.net/weixin_44100850/article/details/106455404

    % 判断是否停止
    open_list_temp = [];
    for k = 1 : size(open_list, 1)
        open_list_temp = [open_list_temp; open_list{k, 1}];
    end
    [in_flag, idx] = ismember(target_node, open_list_temp, "rows");
    if in_flag  % 终点已加入open_list
        fprintf("路径已找到!\n")
        open_list{idx, 5};

        % 绘制路线
        path = open_list{idx, 5};
        num_nodes = length(path);
        path_x = [];
        path_y = [];
        for i = 1 : num_nodes
            path_x = [path_x; path(i, 1)];
            path_y = [path_y; path(i, 2)];
        end
        scatter(path_x-0.5, path_y-0.5);
        plot(path_x-0.5, path_y-0.5);
        hold on

        break
    end
    if isempty(open_list)   % 没找到终点，且open_list为空，查找失败
        fprintf("查找失败")
    end


end
