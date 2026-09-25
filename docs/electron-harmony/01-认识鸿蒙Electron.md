# 01 认识鸿蒙 Electron

> 学习目标：搞清楚鸿蒙 Electron 到底是什么、怎么跑起来的、能干什么不能干什么。

## 一、它是什么

**Electron** 本来是做桌面应用的框架（VS Code、微信开发者工具都是它做的）：一个 App = Chromium 浏览器内核（画界面）+ Node.js（调系统能力）。

**鸿蒙 Electron** 是 OpenHarmony SIG 把 Electron 移植到鸿蒙 PC 上的产物：
- 仓库：[gitcode.com/openharmony-sig/electron](https://gitcode.com/openharmony-sig/electron)
- 基线：Electron 34/37（对应 Chromium 132）
- 意义：**前端开发者不用学 ArkTS，也能给鸿蒙 PC 写应用**；存量 Electron 应用（如建模工具、编辑器）可以低成本迁移到鸿蒙。

## 二、架构原理（重点理解）

普通桌面 Electron：操作系统直接提供窗口、文件、网络能力。

鸿蒙 Electron 多了一层「翻译官」：

```
┌─────────────────────────────────────────┐
│  你的 Electron 应用（main.js + 网页）      │
├─────────────────────────────────────────┤
│  libelectron.so                         │
│  （Chromium 渲染 + Node 运行时，鸿蒙改造版）│
├─────────────────────────────────────────┤
│  libadapter.so  ← 鸿蒙适配层（翻译官）     │
│  把 Electron API 翻译成鸿蒙系统调用        │
├─────────────────────────────────────────┤
│  HarmonyOS（窗口管理/沙箱文件/权限/通知）   │
└─────────────────────────────────────────┘
```

`libadapter.so` 是关键：你在 JS 里调 `new BrowserWindow()`，它去调鸿蒙的窗口管理；你读写文件，它走鸿蒙的沙箱文件系统。

## 三、和桌面 Electron 的关键差异

| 差异点 | 桌面版（Win/Mac） | 鸿蒙版 | 影响 |
|--------|------------------|--------|------|
| 载体 | 独立可执行文件 | 必须打进鸿蒙 **HAP 包** | 要有 DevEco 工程和签名 |
| 运行设备 | Windows/macOS/Linux | **仅鸿蒙 PC（2in1）** | 手机上跑会报错 801 |
| 硬件加速 | 默认开启 | **必须关闭**（否则白屏） | `app.disableHardwareAcceleration()` |
| electron 依赖 | `npm install electron` | **不允许**，运行时由系统提供 | package.json 里删掉 electron |
| 文件系统 | 自由读写 | 鸿蒙**沙箱**，路径有映射 | 见第 03 篇沙箱章节 |
| 原生模块 | node-gyp 编译 | 必须用鸿蒙工具链交叉编译 | better-sqlite3 这类不能直接用 |
| 多窗口 | 随便开 | 受限，推荐**单窗口 + loadURL 切换** | 架构设计要注意 |
| 部分三方库 | 直接可用 | `@electron/remote` 等有兼容问题 | 需要 patch 或降级方案 |

## 四、能力边界：能干什么

✅ **能做到的**：
- 完整 Chromium 渲染能力（复杂网页、Canvas、WebGL 软件渲染）
- Node.js 大部分 API（fs/path/crypto 等）
- 鸿蒙系统能力：窗口管理、通知、剪贴板、打印、文件访问（按权限）
- 调用 ArkTS 原生能力（通过 AKI / NAPI 桥接，进阶）
- 适配鸿蒙 PC 特性：多任务分屏、全局菜单

❌ **做不到 / 要小心的**：
- 不能在手机/平板上运行（仅 2in1）
- 带 C++ addon 的 npm 库（better-sqlite3、esbuild 等）直接用不了
- `process.platform` 返回 `'ohos'`，不认识这个值的三方库会出错
- GPU 硬件加速（当前版本必须关，纯软件渲染，特别吃性能的场景要评估）

## 五、运行时长什么样

跑起来的鸿蒙 Electron 应用，在系统眼里就是一个普通鸿蒙 App：
- 有自己的 HAP 包、签名、权限声明（`module.json5`）
- 入口是鸿蒙的 `EntryAbility`（新版基于 **WebAbility** 基类拉起 Electron 运行时）
- 数据存在鸿蒙沙箱：`/data/storage/el2/base/files`（Electron 的 `userData` 默认指向这里）

## 六、版本选择建议

| 版本 | 说明 | 建议 |
|------|------|------|
| Electron 34 预编译包 | 华为早期发布，资料最多 | 学习可用 |
| Electron 37 预编译包 | 较新稳定版 | **新项目推荐** |
| 源码自编译 | Ubuntu 22.04 + 8 小时编译 | 仅需要改底层时才做 |

> ⚠️ 注意：旧版 `libelectron`（走 XComponent 渲染路径）在 API 23+ / HarmonyOS 6.1 设备上启动即闪退（`napi_unwrap fail`）。**新设备必须用新版 libelectron**（WebAbility 方案，双模块：electron 主模块 + web_engine HSP）。

## 小结

- 鸿蒙 Electron = Chromium/Node 运行时（libelectron.so）+ 鸿蒙翻译层（libadapter.so）+ HAP 壳
- 只跑鸿蒙 PC，必须关硬件加速，必须签名，不能装 electron npm 包
- 适合：存量 Electron 应用迁移、前端团队做鸿蒙桌面工具

下一篇：[02 环境搭建与运行](02-环境搭建与运行.md)
