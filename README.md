# Vortex-Panel-Method·涡面元法

对NACA4415翼型使用涡面元法进行气动问题求解的MATLAB实例。

### 程序结构

- `NACA4415`计算程序用户执行调用主函数
- `angleChange`攻角调整函数
- `Calc`面源影响数值积分程序
- `rSolver	`涡量求解器
- `flowSim	`流动时间线模拟函数

### 使用简介

用户调用时需使用函数`NACA4415(n,a,v)`命令，其中`n`为网格分段数（测试使用时建议不大于100节省计算时间，实际计算时建议大于100提高计算精度）、`a`为机翼攻角（角度制）、`v`为来流速度。

> 一个较为适合的测试用例为：NACA4415(30,5,2);

