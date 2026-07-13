# CommFormaBench v1.0

通信算法公式→Verilog 基准测试集

## 标准来源覆盖

| 标准体系 | 具体文档 | 覆盖领域 |
|----------|----------|----------|
| 3GPP LTE (4G) | TS 36.211/212/213 R15 | OFDM、Turbo、SC-FDMA |
| 3GPP NR (5G) | TS 38.211/212/213/214 V17 | LDPC、Polar、OFDM、MIMO |
| IEEE 802.11 (WiFi) | 802.11a/n/ac/ax/be | OFDM、LDPC、BCC |
| IEEE 802.16 (WiMAX) | 802.16e/m | OFDM、Turbo、LDPC |
| DVB (数字电视) | DVB-S2 EN 302 307、DVB-T2 EN 302 755 | LDPC+BCH、OFDM |
| CCSDS (航天) | CCSDS 131.0-B-4 | Turbo、LDPC、卷积码 |
| ITU-T (语音) | G.711、G.729 | μ律/A律、LPC |
| ETSI (数字集群) | TETRA/DMR | 4FSK、AMBE |
| SDR 参考 | GNU Radio、Analog Devices AD9361 | 通用 DSP 链路 |
| 数学基础 | Proakis "Digital Communications" 5th Ed | 基础算法公式 |

## 总计统计

| 类别 | 文件 | kernels | 配置 |
|------|------|---------|------|
| Cat01 基础数学运算 | cat01_basic_math.md | 25 | 100+ |
| Cat02 数字滤波器 | cat02_filters.md | 20 | 120+ |
| Cat03 变换域运算 | cat03_transforms.md | 15 | 90+ |
| Cat04 调制解调 | cat04_modulation.md | 18 | 110+ |
| Cat05 信道编译码 | cat05_channel_coding.md | 25 | 150+ |
| Cat06 同步与估计 | cat06_sync_estimation.md | 18 | 100+ |
| Cat07 均衡与检测 | cat07_equalization.md | 15 | 80+ |
| Cat08 扩频与多址 | cat08_spread_spectrum.md | 10 | 40+ |
| Cat09 信源编码 | cat09_source_coding.md | 12 | 35+ |
| Cat10 5G NR 特有 | cat10_5g_nr.md | 15 | 55+ |
| Cat11 4G LTE 特有 | cat11_4g_lte.md | 12 | 40+ |
| Cat12 WiFi 802.11 | cat12_wifi.md | 12 | 50+ |
| Cat13 DVB 卫星/地面 | cat13_dvb.md | 10 | 35+ |
| Cat14 SDR 通用模块 | cat14_sdr_common.md | 10 | 35+ |
| **合计** | **14 files** | **217** | **1040+** |

## Benchmark 组织结构

```
benchmark/
├── README.md
├── cat01_basic_math.md          # 基础数学运算 (25 kernels)
├── cat02_filters.md             # 数字滤波器 (20 kernels)
├── cat03_transforms.md          # 变换域运算 (15 kernels)
├── cat04_modulation.md          # 调制解调 (18 kernels)
├── cat05_channel_coding.md      # 信道编译码 (25 kernels)
├── cat06_sync_estimation.md     # 同步与估计 (18 kernels)
├── cat07_equalization.md        # 均衡与检测 (15 kernels)
├── cat08_spread_spectrum.md     # 扩频与多址 (10 kernels)
├── cat09_source_coding.md       # 信源编码 (12 kernels)
├── cat10_5g_nr.md               # 5G NR 特有 (15 kernels)
├── cat11_4g_lte.md              # 4G LTE 特有 (12 kernels)
├── cat12_wifi.md                # WiFi 802.11 (12 kernels)
├── cat13_dvb.md                 # DVB 卫星/地面 (10 kernels)
├── cat14_sdr_common.md          # SDR 通用模块 (10 kernels)
└── golden_models/               # Python 参考实现
```
