# 基于Matlab实现A*算法

## 参考

1. https://paul.pub/a-star-algorithm/

* 初始化open_set和close_set；
* 将起点加入open_set中，并设置优先级为0（优先级最高）；
* 如果open_set不为空，则从open_set中选取优先级最高的节点n：
    * 如果节点n为终点，则：
        * 从终点开始逐步追踪parent节点，一直达到起点；
        * 返回找到的结果路径，算法结束；
    * 如果节点n不是终点，则：
        * 将节点n从open_set中删除，并加入close_set中；
        * 遍历节点n所有的邻近节点：
            * 如果邻近节点m在close_set中，则：
                * 跳过，选取下一个邻近节点
            * 如果邻近节点m也不在open_set中，则：
                * 设置节点m的parent为节点n
                * 计算节点m的优先级
                * 将节点m加入open_set中

2. https://blog.csdn.net/hitwhylz/article/details/23089415
* A. 把起点加入 open list 。
* B. 重复如下过程：
    * a. 遍历 open list ，查找 F 值最小的节点，把它作为当前要处理的节点。
    * b. 把这个节点移到 close list 。
    * c. 对当前方格的 8 个相邻方格的每一个方格？
       * 如果它是不可抵达的或者它在 close list 中，忽略它。否则，做如下操作。
       * 如果它不在 open list 中，把它加入 open list ，并且把当前方格设置为它的父亲，记录该方格的 F ， G 和 H 值。
       * 如果它已经在 open list 中，检查这条路径 ( 即经由当前方格到达它那里 ) 是否更好，用 G 值作参考。更小的 G 值表示这是更好的路径。如果是这样，把它的父亲设置为当前方格，并重新计算它的 G 和 F 值。如果你的 open list 是按 F 值排序的话，改变后你可能需要重新排序。
       (与上述算法的不同之处)
    * d. 停止，当你
       * 把终点加入到了 open list 中，此时路径已经找到了，或者
       * 查找终点失败，并且 open list 是空的，此时没有路径。
* D. 保存路径。从终点开始，每个方格沿着父节点移动直至起点，这就是你的路径。