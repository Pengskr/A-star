function child_nodes = child_nodes_cal(node_par, rows, columns, obs, close_list)
    child_nodes_temp = cell(3,3);  % 理想情况下有八个子节点，将父节点计入其中便于for循环编写代码
    child_nodes = [];

    % 父节点坐标
    X_par = node_par{1}(1);
    Y_par = node_par{1}(2);

    % 遍历行
    for i = 1: -1: -1  
        % 遍历列
        for j = -1 : 1: 1
            X = X_par + j;
            Y = Y_par + i;
            child_nodes_temp{-i + 2, j + 2} = [X, Y];
            
            % 如果该点在地图上
            if (X>=1 && X<=columns)&&(Y>=1 && Y<=rows)
                % 如果该点不是障碍物
                if ~ismember([X, Y], obs, "rows")   % 一定要用参数"rows"
                    close_list_temp = [];
                    for k = 1 : size(close_list, 1)
                        close_list_temp = [close_list_temp; close_list{k, 1}];  % 将open_list{k, 1}转为数组
                    end
                    % 如果该点不在close_list中
                    if ~ismember([X, Y], close_list_temp, "rows")
                        %那么该点是一个可行子节点
                        child_nodes = [child_nodes; [X, Y]];
                    end
                end
            end

        end

    end

end

