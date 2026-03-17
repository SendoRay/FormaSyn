分别跑 csim / csynth / cosim
在同一个目录下依次执行下面三个命令，就可以测试 Vitis HLS 的三个阶段是否都能跑通：


- C 仿真（csim）
v++ -c --mode hls --config hls_cofig.cfg --work_dir work --csim


- 综合（csynth / csyn）
v++ -c --mode hls --config hls_cofig.cfg --work_dir work --csynth


- 协同仿真（cosim）
v++ -c --mode hls --config hls_cofig.cfg --work_dir work --cosim
