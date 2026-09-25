# 01 环境搭建与第一个 App

> 学习目标：装好开发工具，把本项目跑起来，改掉第一行字。

## 一、鸿蒙是什么（大白话）

鸿蒙（HarmonyOS）是华为做的操作系统，装在手机、平板、手表、车机上。
我们写的 App，就是跑在这个系统上的软件。

写鸿蒙 App 需要三样东西：

| 东西 | 干嘛的 | 类比 |
|------|--------|------|
| **DevEco Studio** | 写代码的工具（IDE） | 就像写作文用 Word |
| **HarmonyOS SDK** | 系统能力的工具包 | 就像乐高积木块 |
| **模拟器或真机** | 运行 App 看效果 | 就像试衣间 |

## 二、安装 DevEco Studio

1. 打开官网下载页：
   https://developer.huawei.com/consumer/cn/deveco-studio/
2. 下载 macOS 版（看你电脑芯片选 ARM 或 x86，M 系列芯片选 ARM）。
3. 双击安装包，拖进「应用程序」。
4. 第一次打开会引导你下载 SDK，**一路点下一步**就行（它会自动装好 Node、Ohpm、Hvigor 这些工具，不用你管）。

> 本项目用的 SDK 版本是 **API 26（HarmonyOS 6.0）**，在 `build-profile.json5` 里写着。

## 三、打开本项目并跑起来

1. 打开 DevEco Studio → `Open` → 选择本项目文件夹 `OhDemoHello`。
2. 第一次打开它会自动同步依赖（底部进度条跑完）。
3. 准备一个运行设备，二选一：
   - **模拟器**：菜单 `Tools → Device Manager` → 新建一个手机模拟器 → 点启动。
   - **真机**：华为手机开「开发者模式」，USB 连电脑。
4. 点顶部绿色三角 ▶️（Run），等编译完成，App 就装进设备并自动打开了。

看到底部 5 个 Tab（首页/发现/消息/组件/我的），就说明跑起来了。

## 四、改第一行字（体验开发流程）

1. 在 DevEco Studio 里打开文件：
   `entry/src/main/resources/base/element/string.json`
2. 找到 `"welcome_title"`，把值改成你想要的话，比如：
   ```json
   { "name": "welcome_title", "value": "我的第一个鸿蒙 App" }
   ```
3. 按 `Ctrl + S` 保存，再点 ▶️ 重新运行。
4. 在首页看到你改的字——**恭喜，你完成第一次鸿蒙开发了！**

## 五、认识两个常用操作

| 操作 | 怎么做 |
|------|--------|
| 看日志 | 底部 `Log` 面板，代码里 `hilog.info(...)` 打的内容在这看 |
| 预览界面 | 打开任意 `.ets` 页面文件，右侧点 `Previewer`，不用跑真机就能看界面长什么样 |

## 动手练

1. 把首页欢迎语改成你的名字。
2. 打开 `entry/src/main/ets/pages/HomePage.ets`，随便改一个 `Text('...')` 里的字，用 Previewer 看变化。

## 小结

- 鸿蒙开发三件套：DevEco Studio + SDK + 设备
- 改代码 → 保存 → 重新运行，就是日常开发循环
- 字符串统一放在 `string.json` 里管理，不要写死在代码里（好习惯）

下一篇：[02 ArkTS 语言速成](02-ArkTS语言速成.md)
