分别跑 `csim / csynth / cosim`

在 `baseline_int16_p16_full` 目录下依次执行下面三个命令：

- C 仿真（csim）
`vitis-run --mode hls --csim --config hls_config.cfg --work_dir work`

- 综合（csynth）
`v++ -c --mode hls --config hls_config.cfg --work_dir work`

- 协同仿真（cosim）
`vitis-run --mode hls --cosim --config hls_config.cfg --work_dir work`
