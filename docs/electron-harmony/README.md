# Electron 鸿蒙开发深入研究

> 用你熟悉的 HTML/CSS/JavaScript（Electron 技术栈），开发跑在**鸿蒙 PC（HarmonyOS 2in1 设备）**上的桌面应用。
> 本套文档基于 OpenHarmony SIG 官方 Electron 适配项目（[gitcode.com/openharmony-sig/electron](https://gitcode.com/openharmony-sig/electron)）和真实适配案例整理。

## 先搞清楚一件事

**Electron 鸿蒙版 ≠ 手机开发**。它面向的是**鸿蒙 PC**（如 MateBook Pro 鸿蒙版、2in1 设备）。
你的 Electron 应用最终被打包成一个鸿蒙 **HAP 安装包**，由鸿蒙系统里的 Electron 运行时（`libelectron.so`）拉起来跑。

```
你的代码（main.js / index.html）
        ↓ 被打包进
鸿蒙 HAP 工程（ohos_hap）
        ↓ 运行时由
libelectron.so（Chromium + Node 改造）执行
        ↓ 通过
libadapter.so（鸿蒙适配层）调用系统能力（窗口/文件/权限）
```

## 文档目录

| 篇章 | 内容 | 什么时候看 |
|------|------|-----------|
| [01 认识鸿蒙 Electron](01-认识鸿蒙Electron.md) | 是什么、架构原理、和桌面版的差异、能力边界 | 最先看 |
| [02 环境搭建与运行](02-环境搭建与运行.md) | 预编译包获取、工程结构、签名、跑起来 | 动手时看 |
| [03 开发实战与适配要点](03-开发实战与适配要点.md) | 入口编写、必改项、窗口/沙箱/三方库适配、调试 | 写代码时看 |
| [04 报错速查与避坑指南](04-报错速查与避坑指南.md) | 白屏、801、模块找不到等高频报错对照表 | 卡住了看 |
| [05 技术选型对比](05-技术选型对比.md) | ArkTS 原生 vs Electron vs Qt，怎么选 | 立项前看 |

## 与本项目（鸿蒙百宝箱）的关系

| | 鸿蒙百宝箱（本项目） | Electron 鸿蒙版 |
|---|---|---|
| 技术栈 | ArkTS + ArkUI | HTML/CSS/JS + Electron API |
| 目标设备 | 手机/平板/2in1 | **仅 2in1（鸿蒙 PC）** |
| 适合场景 | 移动应用、全场景原生体验 | 桌面生产力工具、存量 Electron 应用迁移 |

两条路线不冲突：**移动端用 ArkTS，桌面端存量 Web 技术栈用 Electron**。

## 核心事实速览（先有个底）

- 官方仓库：`gitcode.com/openharmony-sig/electron`（开源，SIG 维护）
- 当前基线：Electron 34 / 37（Chromium 132），华为提供**预编译包**，不用自己编译
- 应用代码放在 HAP 工程的 `web_engine/src/main/resources/resfile/resources/app/`
- **必须** `app.disableHardwareAcceleration()`，否则白屏
- **只能跑在鸿蒙 PC**，手机上运行会报错 801
- 必须配置签名才能安装运行
- `package.json` 里**不能**有 `electron` 依赖（运行时由系统侧 `libelectron.so` 提供）

👉 从 [01 认识鸿蒙 Electron](01-认识鸿蒙Electron.md) 开始。
