# 鸿蒙百宝箱 (OhDemo) - HarmonyOS 应用开发示例

> 基于 HarmonyOS ArkTS + ArkUI 的全功能演示应用，涵盖 UI 组件、表单、表格、弹窗、权限管理等核心场景。

## 📚 鸿蒙开发学习文档

本项目配套一套**从入门到深入**的学习教程（在 `docs/` 目录），全部结合本项目真实代码讲解：

| 阶段 | 篇章 | 目标 |
|------|------|------|
| **入门** | [01 环境搭建](docs/stage1-beginner/01-环境搭建与第一个App.md) · [02 ArkTS 速成](docs/stage1-beginner/02-ArkTS语言速成.md) · [03 声明式 UI](docs/stage1-beginner/03-声明式UI思维.md) · [04 项目结构](docs/stage1-beginner/04-看懂项目结构.md) | 能跑起来、能改界面 |
| **进阶** | [05 组件大全](docs/stage2-advanced/05-常用组件大全.md) · [06 状态管理](docs/stage2-advanced/06-状态管理详解.md) · [07 路由跳转](docs/stage2-advanced/07-路由与页面跳转.md) · [08 布局实战](docs/stage2-advanced/08-布局实战.md) | 能独立写页面 |
| **高级** | [09 网络请求](docs/stage3-senior/09-网络请求与数据.md) · [10 存储数据库](docs/stage3-senior/10-本地存储与数据库.md) · [11 权限安全](docs/stage3-senior/11-权限与安全.md) · [12 动画手势](docs/stage3-senior/12-动画与手势.md) | 能做出完整功能 |
| **深入** | [13 生命周期](docs/stage4-expert/13-生命周期与沉浸式.md) · [14 深色模式](docs/stage4-expert/14-主题与深色模式.md) · [15 性能优化](docs/stage4-expert/15-性能优化.md) · [16 测试发布](docs/stage4-expert/16-测试签名与发布.md) | 能发布上架 |

👉 从 [docs/learning-path.md 学习路线总览](docs/learning-path.md) 开始。

## 🖥️ Electron 鸿蒙开发（PC 端）

想用 HTML/CSS/JS 开发**鸿蒙 PC** 应用，或把存量 Electron 应用迁移到鸿蒙？看这套深入研究文档（基于 [openharmony-sig/electron](https://gitcode.com/openharmony-sig/electron) 官方适配项目）：

| 篇章 | 内容 |
|------|------|
| [01 认识鸿蒙 Electron](docs/electron-harmony/01-认识鸿蒙Electron.md) | 架构原理（libelectron + libadapter 适配层）、与桌面版差异、能力边界 |
| [02 环境搭建与运行](docs/electron-harmony/02-环境搭建与运行.md) | 预编译包/源码编译两条路线、工程结构、签名、权限 |
| [03 开发实战与适配要点](docs/electron-harmony/03-开发实战与适配要点.md) | 入口模板、必关硬件加速、单窗口策略、沙箱路径、三方库适配 |
| [04 报错速查与避坑指南](docs/electron-harmony/04-报错速查与避坑指南.md) | 白屏/801/napi_unwrap 等高频报错对照表 |
| [05 技术选型对比](docs/electron-harmony/05-技术选型对比.md) | ArkTS vs Electron vs Qt vs Flutter，决策流程图 |

👉 从 [docs/electron-harmony/README.md](docs/electron-harmony/README.md) 开始。

## 目录

- [1. 项目概览](#1-项目概览)
- [2. 项目架构](#2-项目架构)
- [3. 目录结构详解](#3-目录结构详解)
- [4. 配置文件说明](#4-配置文件说明)
- [5. 页面与导航体系](#5-页面与导航体系)
- [6. ArkTS 核心概念](#6-arkts-核心概念)
- [7. ArkUI 组件体系](#7-arkui-组件体系)
- [8. 状态管理详解](#8-状态管理详解)
- [9. 沉浸式模式与安全区域](#9-沉浸式模式与安全区域)
- [10. 权限管理](#10-权限管理)
- [11. 资源系统](#11-资源系统)
- [12. 构建系统](#12-构建系统)
- [13. HarmonyOS 开发知识库](#13-harmonyos-开发知识库)

---

## 1. 项目概览

| 属性 | 值 |
|------|-----|
| **应用名称** | 鸿蒙百宝箱 (OhDemo) |
| **应用包名** | `com.example.ohdemohello` |
| **版本** | 1.0.0 (versionCode: 1000000) |
| **SDK 版本** | HarmonyOS 6.0 (API 26) |
| **开发语言** | ArkTS (TypeScript 超集) |
| **UI 框架** | ArkUI 声明式范式 |
| **构建工具** | Hvigor |
| **IDE** | DevEco Studio |

### 功能页面一览

| 页面 | 类型 | 说明 |
|------|------|------|
| `Index.ets` | @Entry Tab 页 | 底部 5 Tab 导航壳 |
| `HomePage.ets` | Tab 子页 | 首页：轮播图、功能卡片、快捷入口 |
| `DiscoverPage.ets` | Tab 子页 | 发现页：搜索栏、分类标签、瀑布流内容 |
| `MessagePage.ets` | Tab 子页 | 消息页：Tab 切换、消息列表 |
| `ComponentsPage.ets` | Tab 子页 | 组件展示：按钮/文本/标签/输入/选择/开关/滑块/进度/评分/卡片/数据面板 |
| `ProfilePage.ets` | Tab 子页 | 我的页：用户信息、设置列表 |
| `DetailPage.ets` | @Entry 路由页 | 详情页：参数传递、富文本展示 |
| `FormPage.ets` | @Entry 路由页 | 注册表单：多类型输入 + 实时验证 |
| `TablePage.ets` | @Entry 路由页 | 数据表格：排序/选择/分页/搜索 |
| `DialogPage.ets` | @Entry 路由页 | 弹窗展示：系统弹窗/自定义弹窗/底部 Sheet/Loading |
| `PermissionPage.ets` | @Entry 路由页 | 权限管理：15 项系统权限检测与请求 |
| `AboutPage.ets` | @Entry 路由页 | 关于我们：Logo/版本号/检查更新/法律条款入口 |
| `FeedbackPage.ets` | @Entry 路由页 | 意见反馈：内容输入 + 联系方式 + 提交 |
| `LegalPage.ets` | @Entry 路由页 | 法律条款：隐私政策 / 用户服务协议（占位文案） |

### 应用基础件（标配）

| 项目 | 位置 | 说明 |
|------|------|------|
| 应用名称 | `AppScope/resources/{base,zh_CN,en_US}/element/string.json` | 中文「鸿蒙百宝箱」/ 英文「OhDemo」 |
| 应用图标 | `*/resources/base/media/layered_image.json` | 分层图标：`background.png`(渐变蓝底) + `foreground.png`(透明宝箱图形) |
| 启动图标 | `entry/.../media/startIcon.png` | 圆角合成图标，用于启动窗口 |
| 关于页 | `AboutPage.ets` | 版本、版权、更新、条款入口 |
| 反馈页 | `FeedbackPage.ets` | 用户意见收集（演示为本地模拟提交） |
| 法律页 | `LegalPage.ets` | 隐私政策 / 服务协议，路由参数 `type` 区分 |

---

## 2. 项目架构

```
AppScope/                    # 应用级配置
  app.json5                  # bundleName, version, icon, label
  resources/                 # 应用级资源

entry/                       # 主模块 (HAP)
  src/main/
    ets/
      entryability/          # UIAbility 生命周期
        EntryAbility.ets
      pages/                 # 页面组件
        Index.ets            # @Entry Tab 壳 (5 Tab)
        ├── HomePage         # Tab 1: 首页
        ├── DiscoverPage     # Tab 2: 发现
        ├── MessagePage      # Tab 3: 消息
        ├── ComponentsPage   # Tab 4: 组件展示
        └── ProfilePage      # Tab 5: 我的
        ├── DetailPage       # 路由: 详情
        ├── FormPage         # 路由: 表单
        ├── TablePage        # 路由: 表格
        ├── DialogPage       # 路由: 弹窗
        └── PermissionPage   # 路由: 权限
    resources/
      base/                  # 默认资源 (亮色)
        element/             # string.json, color.json
        media/               # 图片资源
        profile/             # main_pages.json (路由注册)
      dark/                  # 深色模式资源
        element/color.json   # 深色颜色覆盖
      rawfile/               # 原始文件
    module.json5             # 模块配置 (权限/能力/页面)

build-profile.json5          # 项目级构建配置 (签名/SDK/产物)
hvigorfile.ts                # Hvigor 构建任务配置
oh-package.json5             # 依赖管理
```

### 架构设计原则

1. **单 HAP 架构** — 所有功能集中在 entry 模块，适合中小型应用
2. **Tab + 路由混合导航** — 5 个 Tab 页承载主要功能，路由页承载深度功能
3. **组件复用** — `CardBox`、`FormItem` 等通过 `@Component` + `@BuilderParam` 实现内容投影
4. **沉浸式全局生效** — `EntryAbility` 设置全屏布局，各页面通过 `expandSafeArea` + `statusBarHeight` 适配
5. **资源驱动 UI** — 颜色/字符串全部通过 `$r()` 引用，支持深色模式自动切换

---

## 3. 目录结构详解

```
OhDemoHello/
├── AppScope/                          # 应用级配置
│   ├── app.json5                      # 应用全局配置（包名、版本、图标）
│   └── resources/
│       └── base/element/
│           └── string.json            # 应用级字符串（app_name）
│
├── entry/                             # 主模块（HAP）
│   ├── src/
│   │   ├── main/
│   │   │   ├── ets/                   # ArkTS 源码
│   │   │   │   ├── entryability/
│   │   │   │   │   └── EntryAbility.ets  # UIAbility 生命周期
│   │   │   │   └── pages/             # 页面组件 (11 个页面)
│   │   │   │
│   │   │   ├── resources/             # 模块资源
│   │   │   │   ├── base/              # 默认资源（亮色模式）
│   │   │   │   │   ├── element/
│   │   │   │   │   │   ├── string.json    # 字符串资源
│   │   │   │   │   │   └── color.json     # 颜色资源
│   │   │   │   │   ├── media/             # 图片资源
│   │   │   │   │   │   ├── startIcon.png      # 启动图标
│   │   │   │   │   │   ├── background.png     # 背景图
│   │   │   │   │   │   ├── foreground.png     # 前景图
│   │   │   │   │   │   └── layered_image.json # 分层图标配置
│   │   │   │   │   └── profile/
│   │   │   │   │       └── main_pages.json   # 页面路由注册
│   │   │   │   ├── dark/              # 深色模式资源
│   │   │   │   │   └── element/
│   │   │   │   │       └── color.json     # 深色模式颜色覆盖
│   │   │   │   └── rawfile/           # 原始文件（不参与编译）
│   │   │   │
│   │   │   └── module.json5           # 模块配置（权限、能力、页面）
│   │   │
│   │   ├── oh_modules/                # 依赖模块（自动生成）
│   │   └── test/                      # 单元测试
│   │
│   ├── hvigorfile.ts                 # 模块级 Hvigor 构建配置
│   └── oh-package.json5              # 模块级依赖管理
│
├── build-profile.json5               # 项目级构建配置
├── hvigorfile.ts                     # 项目级 Hvigor 构建配置
├── oh-package.json5                  # 项目级依赖管理
└── README.md                         # 本文档
```

---

## 4. 配置文件说明

### 4.1 `AppScope/app.json5` — 应用全局配置

```json5
{
  "app": {
    "bundleName": "com.example.ohdemohello",  // 应用唯一标识（反向域名格式）
    "vendor": "example",                       // 开发者名称
    "versionCode": 1000000,                    // 版本号（整数，用于升级判断）
    "versionName": "1.0.0",                    // 版本名（展示给用户）
    "buildVersion": "1",                       // 构建版本
    "icon": "$media:layered_image",            // 应用图标（引用 media 资源）
    "label": "$string:app_name"                // 应用名称（引用 string 资源）
  }
}
```

**关键概念：**
- `bundleName` 是应用的唯一标识，上传应用商店后不可更改
- `versionCode` 必须为整数，每次发布必须递增
- `icon` 和 `label` 使用 `$资源类型:资源名` 语法引用资源

### 4.2 `entry/src/main/module.json5` — 模块配置

```json5
{
  "module": {
    "name": "entry",                    // 模块名称
    "type": "entry",                    // 模块类型：entry / feature / shared
    "mainElement": "EntryAbility",      // 入口 Ability 名称
    "deviceTypes": ["phone", "tablet", "2in1", "car", "wearable", "tv"],
    "pages": "$profile:main_pages",     // 页面路由配置文件引用

    "requestPermissions": [             // 需要申请的系统权限
      {
        "name": "ohos.permission.CAMERA",
        "reason": "$string:perm_camera_reason",   // 权限申请理由
        "usedScene": {
          "abilities": ["EntryAbility"],          // 使用该权限的 Ability
          "when": "inuse"                         // inuse(使用时) / always(始终)
        }
      }
      // ... 共 15 项权限
    ],

    "abilities": [{                     // Ability 列表
      "name": "EntryAbility",
      "srcEntry": "./ets/entryability/EntryAbility.ets",
      "startWindowIcon": "$media:startIcon",
      "startWindowBackground": "$color:start_window_background",
      "exported": true,
      "skills": [{                      // 意图过滤器
        "actions": ["action.system.home"],
        "entities": ["entity.system.home"],
        "uris": [{ "scheme": "ohdemohello" }]
      }]
    }]
  }
}
```

**关键概念：**
- **Ability** 是 HarmonyOS 的能力抽象，UIAbility 管理界面生命周期
- **requestPermissions** 声明应用需要的系统权限，`reason` 必须提供以向用户解释
- **skills** 类似 Android IntentFilter，定义 Ability 的响应范围
- **when: "inuse"** 表示仅在使用时请求权限，`"always"` 表示后台也保持权限

### 4.3 `build-profile.json5` — 项目级构建配置

```json5
{
  "app": {
    "signingConfigs": [{               // 签名配置
      "name": "default",
      "type": "HarmonyOS",
      "material": {
        "certpath": "...cer",          // 证书文件
        "keyAlias": "debugKey",        // 密钥别名
        "signAlg": "SHA256withECDSA",  // 签名算法
        "storeFile": "...p12",         // 密钥库文件
      }
    }],
    "products": [{                     // 产品配置
      "name": "default",
      "signingConfig": "default",
      "targetSdkVersion": "26.0.0",    // 目标 SDK 版本
      "compatibleSdkVersion": "26.0.0",// 最低兼容 SDK 版本
      "runtimeOS": "HarmonyOS"
    }],
    "buildModeSet": [                  // 构建模式
      { "name": "debug" },
      { "name": "release" }
    ]
  },
  "modules": [{                        // 模块列表
    "name": "entry",
    "srcPath": "./entry"
  }]
}
```

### 4.4 `main_pages.json` — 页面路由注册

```json
{
  "src": [
    "pages/Index",            // @Entry 主入口（Tab 壳）
    "pages/DetailPage",       // 路由页
    "pages/FormPage",
    "pages/TablePage",
    "pages/DialogPage",
    "pages/PermissionPage"
  ]
}
```

> **重要：** 每新增一个 `@Entry` 路由页面，必须在此文件注册，否则 `router.pushUrl()` 会报错。

### 4.5 `oh-package.json5` — 依赖管理

```json5
// 项目级 (根目录)
{
  "modelVersion": "26.0.0",
  "devDependencies": {
    "@ohos/hypium": "1.0.25",            // 单元测试框架
    "@ohos/hamock": "1.0.0"              // Mock 框架
  }
}
```

### 4.6 `hvigorfile.ts` — 构建任务配置

```typescript
// 项目级
import { appTasks } from '@ohos/hvigor-ohos-plugin';
export default {
  system: appTasks,   // 内置构建任务
  plugins: []          // 自定义插件
}

// 模块级 (entry/)
import { hapTasks } from '@ohos/hvigor-ohos-plugin';
export default {
  system: hapTasks,   // HAP 构建任务
  plugins: []
}
```

---

## 5. 页面与导航体系

### 5.1 导航架构

```
                    ┌─────────────────────────┐
                    │    EntryAbility          │
                    │    (UIAbility 生命周期)   │
                    └────────────┬────────────┘
                                 │ 加载
                    ┌────────────┴────────────┐
                    │    Index.ets (@Entry)    │
                    │    Tabs(5 Tab) 底部导航   │
                    └────────────┬────────────┘
                                 │
          ┌──────────┬──────────┼──────────┬──────────┐
          │          │          │          │          │
     HomePage  DiscoverPage MessagePage CompPage  ProfilePage
          │          │          │          │
          │ router.pushUrl()    │          │ router.pushUrl()
          ▼                     │          ▼
     DetailPage                 │     FormPage
                               │          TablePage
                               │          DialogPage
                               ▼          PermissionPage
                          (Tab 内导航)
```

### 5.2 Tab 导航 (Index.ets)

```typescript
@Entry
@Component
struct Index {
  @State currentTabIndex: number = 0;

  build() {
    Tabs({ barPosition: BarPosition.End, index: this.currentTabIndex }) {
      TabContent() { HomePage() }.tabBar(this.TabBar(0))
      TabContent() { DiscoverPage() }.tabBar(this.TabBar(1))
      // ...
    }
    .onChange((index: number) => { this.currentTabIndex = index; })
  }
}
```

- Tab 页使用 `@Component` 导出，被 Index 引用
- Tab 切换不销毁页面，保持状态

### 5.3 路由导航 (router.pushUrl)

```typescript
import { router } from '@kit.ArkUI';

// 跳转（无参数）
router.pushUrl({ url: 'pages/FormPage' });

// 跳转（带参数）
router.pushUrl({
  url: 'pages/DetailPage',
  params: { id: 1, title: '示例' }
});

// 接收参数
const params = router.getParams() as Record<string, Object>;

// 返回
router.back();
```

- 路由页使用 `@Entry @Component` 声明
- 必须在 `main_pages.json` 注册路由路径

---

## 6. ArkTS 核心概念

### 6.1 ArkTS 与 TypeScript 的区别

ArkTS 是 TypeScript 的严格子集，专为 HarmonyOS 设计：

| 特性 | TypeScript | ArkTS |
|------|-----------|-------|
| 类型推断 | 宽松 | 严格（禁用 any） |
| 结构体 | 无 | `struct` 关键字 |
| 装饰器 | 标准 | 专用（@Entry, @Component, @State 等） |
| UI 描述 | JSX | 声明式 DSL（build() 方法） |
| 动态属性 | 允许 | 禁止（不允许运行时添加属性） |

### 6.2 struct 组件

```typescript
@Component
export struct MyComponent {
  build() {
    Text('Hello')
  }
}
```

- `struct` 是 ArkTS 的组件声明关键字（非 TS 的 struct）
- 每个组件必须有 `build()` 方法，返回且仅返回一个根容器
- `@Component` 标记为自定义组件

### 6.3 @Entry 装饰器

```typescript
@Entry
@Component
struct MyPage {
  build() { /* ... */ }
}
```

- `@Entry` 标记页面入口组件
- 每个 `@Entry` 对应一个路由页面
- 必须在 `main_pages.json` 注册

### 6.4 import 语法

```typescript
// HarmonyOS Kit 导入
import { router, promptAction } from '@kit.ArkUI';
import { abilityAccessCtrl, bundleManager, Permissions, common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

// 组件导入
import { HomePage } from './HomePage';
```

**HarmonyOS Kit 体系：**
| Kit 名称 | 说明 |
|----------|------|
| `@kit.ArkUI` | UI 组件、路由、弹窗 |
| `@kit.AbilityKit` | Ability 生命周期、权限管理 |
| `@kit.BasicServicesKit` | 基础服务（错误处理等） |
| `@kit.PerformanceAnalysisKit` | 性能分析（hilog 日志） |

---

## 7. ArkUI 组件体系

### 7.1 基础组件

| 组件 | 说明 | 示例 |
|------|------|------|
| `Text` | 文本显示 | `Text('Hello').fontSize(16)` |
| `Span` | 富文本片段 | `Span('红色').fontColor(Color.Red)` |
| `Image` | 图片显示 | `Image($r('app.media.startIcon'))` |
| `Button` | 按钮 | `Button('点击').type(ButtonType.Capsule)` |
| `TextInput` | 文本输入 | `TextInput({ placeholder: '请输入' })` |
| `TextArea` | 多行输入 | `TextArea({ placeholder: '描述' })` |
| `Search` | 搜索框 | `Search({ placeholder: '搜索' })` |
| `Select` | 下拉选择 | `Select([{ value: '选项1' }])` |
| `Toggle` | 开关 | `Toggle({ type: ToggleType.Switch })` |
| `Checkbox` | 复选框 | `Checkbox({ name: 'cb' })` |
| `Radio` | 单选框 | `Radio({ value: 'r1', group: 'g' })` |
| `Slider` | 滑块 | `Slider({ value: 30, min: 0, max: 100 })` |
| `Progress` | 进度条 | `Progress({ value: 50, type: ProgressType.Linear })` |
| `Rating` | 评分 | `Rating({ rating: 3 })` |
| `Badge` | 徽章 | `Badge({ count: 5 })` |
| `Divider` | 分割线 | `Divider().color('#E5E5E5')` |
| `DataPanel` | 数据面板 | `DataPanel({ values: [20, 40], max: 100 })` |
| `LoadingProgress` | 加载动画 | `LoadingProgress().width(48)` |
| `Marquee` | 跑马灯 | `Marquee({ value: '滚动文字' })` |
| `SymbolGlyph` | 符号图标 | `SymbolGlyph($r('sys.symbol.house'))` |

### 7.2 容器组件

| 组件 | 说明 |
|------|------|
| `Column` | 垂直线性布局 |
| `Row` | 水平线性布局 |
| `Stack` | 层叠布局 |
| `Flex` | 弹性布局（支持换行） |
| `Scroll` | 滚动容器 |
| `List` / `ListItem` | 列表（懒加载） |
| `Grid` / `GridItem` | 网格布局 |
| `Tabs` / `TabContent` | 标签页 |
| `Swiper` | 轮播图 |
| `Navigation` | 导航容器 |

### 7.3 常用属性方法

```typescript
Text('示例')
  .fontSize(16)                    // 字体大小
  .fontWeight(FontWeight.Bold)     // 字体粗细
  .fontColor('#333333')            // 字体颜色
  .width('100%')                   // 宽度 (百分比或 vp)
  .height(44)                      // 高度
  .padding({ left: 16, right: 16 })// 内边距
  .margin({ top: 8 })              // 外边距
  .borderRadius(12)                // 圆角
  .backgroundColor('#FFFFFF')      // 背景色
  .border({ width: 1, color: '#E5E5E5' })  // 边框
  .shadow({ radius: 6, color: 'rgba(0,0,0,0.1)' })  // 阴影
  .layoutWeight(1)                 // 布局权重（类似 flex: 1）
  .justifyContent(FlexAlign.Center)// 主轴对齐
  .alignItems(HorizontalAlign.Center)  // 交叉轴对齐
  .onClick(() => {})               // 点击事件
```

### 7.4 @Builder — UI 构建复用

```typescript
@Builder
SectionTitle(title: string) {
  Text(title).fontSize(18).fontWeight(FontWeight.Bold)
}

// 调用
this.SectionTitle('按钮展示')
```

- `@Builder` 用于在组件内复用 UI 片段
- 支持简单参数（string, number）
- **不支持函数类型参数**（`() => void`），需用 `@BuilderParam` 替代

### 7.5 @BuilderParam — 内容投影

```typescript
@Component
struct CardBox {
  @BuilderParam content: () => void;   // 接收外部 UI 内容
  build() {
    Column() { this.content() }
      .padding(16).borderRadius(16)
  }
}

// 使用（尾随闭包语法）
CardBox() {
  Text('卡片内容')
  Button('操作')
}
```

---

## 8. 状态管理详解

### 8.1 状态装饰器一览

| 装饰器 | 作用域 | 说明 |
|--------|--------|------|
| `@State` | 组件内 | 组件内部状态，变化触发 UI 重新渲染 |
| `@Prop` | 父→子 | 单向同步，父组件修改会同步到子组件 |
| `@Link` | 父↔子 | 双向同步，父子组件修改互相同步 |
| `@Provide` | 祖先→后代 | 跨层级向下传递，所有后代可消费 |
| `@Consume` | 后代←祖先 | 消费祖先组件 `@Provide` 的数据 |
| `@StorageLink` | AppStorage | 双向绑定到 AppStorage（全局存储） |
| `@StorageProp` | AppStorage | 单向读取 AppStorage（只读） |
| `@ObjectLink` | @Observed 对象 | 用于嵌套对象的响应式 |

### 8.2 @State — 组件内状态

```typescript
@State count: number = 0;
@State title: string = '标题';
@State items: string[] = ['a', 'b', 'c'];

build() {
  Column() {
    Text(`${this.count}`)
    Button('增加').onClick(() => { this.count++; })
  }
}
```

- `@State` 变量变化时，引用该变量的 UI 自动刷新
- 对于数组/对象，需要重新赋值才能触发更新（不能只修改属性）

### 8.3 @StorageProp — 全局存储读取

```typescript
// EntryAbility 中写入
AppStorage.setOrCreate('statusBarHeight', topRect.height);

// 各页面读取
@StorageProp('statusBarHeight') statusBarHeight: number = 0;
```

- `@StorageProp` 只读，UI 会响应变化
- `@StorageLink` 可读可写，修改会同步回 AppStorage

### 8.4 状态管理最佳实践

```typescript
// ❌ 错误：直接修改对象属性不触发更新
@State user: User = new User('张三');
this.user.name = '李四';  // UI 不会刷新

// ✅ 正确：重新赋值触发更新
this.user = new User('李四');

// ✅ 正确：使用 @Observed + @ObjectLink 实现嵌套响应式
@Observed
class User { name: string; }

@Component
struct UserItem {
  @ObjectLink user: User;  // 属性修改自动触发更新
}
```

---

## 9. 沉浸式模式与安全区域

### 9.1 实现原理

```
┌─────────────────────────────────┐
│        状态栏 (安全区域)         │ ← 系统状态栏
├─────────────────────────────────┤
│                                 │
│         应用内容区域              │ ← 内容延伸到状态栏下方
│                                 │
├─────────────────────────────────┤
│        导航栏 (安全区域)         │ ← 系统导航栏
└─────────────────────────────────┘
```

### 9.2 EntryAbility 中设置全屏

```typescript
onWindowStageCreate(windowStage: window.WindowStage): void {
  windowStage.loadContent('pages/Index', (err) => {
    const mainWindow = windowStage.getMainWindowSync();
    // 1. 设置全屏布局
    mainWindow.setWindowLayoutFullScreen(true);
    // 2. 获取安全区域高度并存储
    const avoidArea = mainWindow.getWindowAvoidArea();
    const topRect = avoidArea.topRect;
    AppStorage.setOrCreate('statusBarHeight', topRect.height);
  });
}
```

### 9.3 页面中适配

```typescript
@StorageProp('statusBarHeight') statusBarHeight: number = 0;

build() {
  Column() {
    // 标题栏：高度 = 内容高度 + 状态栏高度
    Text('标题')
      .height(56 + this.statusBarHeight)         // 总高度
      .padding({ top: this.statusBarHeight })     // 顶部留出状态栏空间

    // 内容区域
    Scroll() { /* ... */ }
  }
  .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])  // 延伸到状态栏
}
```

- `expandSafeArea` 让内容延伸到安全区域
- `SafeAreaEdge.TOP` — 延伸到状态栏（沉浸式）
- 不设置 `SafeAreaEdge.BOTTOM` — 底部 Tab 栏保持在导航栏上方

---

## 10. 权限管理

### 10.1 权限分类

| 类型 | 说明 | 示例 |
|------|------|------|
| **normal** | 普通权限，安装时自动授予 | `ohos.permission.INTERNET` |
| **user_grant** | 敏感权限，需用户运行时授权 | `ohos.permission.CAMERA` |

### 10.2 声明权限 (module.json5)

```json5
"requestPermissions": [
  {
    "name": "ohos.permission.CAMERA",
    "reason": "$string:perm_camera_reason",     // 必填：向用户解释为什么需要
    "usedScene": {
      "abilities": ["EntryAbility"],
      "when": "inuse"                            // inuse: 使用时请求
    }
  }
]
```

### 10.3 检查与请求权限 (PermissionPage.ets)

```typescript
import { abilityAccessCtrl, bundleManager, Permissions, common } from '@kit.AbilityKit';

// 1. 创建权限管理器
private atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();

// 2. 获取应用 Token ID
const bundleInfo = bundleManager.getBundleInfoForSelfSync(
  bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION
);
const tokenId = bundleInfo.appInfo.accessTokenId;

// 3. 检查权限状态 (同步)
const status = this.atManager.checkAccessTokenSync(tokenId, 'ohos.permission.CAMERA');
// status: -1=未声明, 0=已拒绝, 1=已授权

// 4. 请求权限 (异步，弹出系统授权弹窗)
const context = getContext(this) as common.UIAbilityContext;
const result = await this.atManager.requestPermissionsFromUser(
  context, ['ohos.permission.CAMERA']
);
// result.authResults[0]: 0=授权, -1=拒绝
```

### 10.4 本项目已声明权限 (15 项)

| 分组 | 权限 |
|------|------|
| 相机麦克风 | CAMERA, MICROPHONE |
| 媒体存储 | READ_MEDIA, WRITE_MEDIA, READ_IMAGEVIDEO, WRITE_IMAGEVIDEO, READ_AUDIO |
| 位置信息 | LOCATION, APPROXIMATELY_LOCATION |
| 联系人 | READ_CONTACTS, WRITE_CONTACTS |
| 日历 | READ_CALENDAR, WRITE_CALENDAR |
| 其他 | DISTRIBUTED_DATASYNC, ACCESS_BLUETOOTH |

---

## 11. 资源系统

### 11.1 资源目录结构

```
resources/
├── base/                    # 默认资源（亮色模式）
│   ├── element/
│   │   ├── string.json      # 字符串
│   │   └── color.json       # 颜色
│   ├── media/               # 图片/图标
│   └── profile/             # 配置文件 (main_pages.json)
├── dark/                    # 深色模式覆盖
│   └── element/
│       └── color.json       # 仅覆盖颜色
└── rawfile/                 # 原始文件（不参与编译）
```

### 11.2 资源引用方式

```typescript
// 引用字符串
Text($r('app.string.app_title'))

// 引用颜色
.fontColor($r('app.color.primary_color'))

// 引用图片
Image($r('app.media.startIcon'))

// 引用系统符号图标
SymbolGlyph($r('sys.symbol.house'))

// 在 JSON5 配置中引用
"label": "$string:app_name"      // 注意：无 app. 前缀
"icon": "$media:layered_image"   // 使用冒号分隔
```

### 11.3 颜色资源 (color.json)

```json
// base/element/color.json (亮色)
{
  "color": [
    { "name": "page_background", "value": "#F1F3F5" },
    { "name": "primary_color", "value": "#007DFF" },
    { "name": "card_background", "value": "#FFFFFF" },
    { "name": "text_primary", "value": "#182431" },
    { "name": "success_color", "value": "#36D372" },
    { "name": "warning_color", "value": "#FF9F0A" },
    { "name": "danger_color", "value": "#FF4D4F" }
  ]
}

// dark/element/color.json (深色 - 仅覆盖需要变化的)
{
  "color": [
    { "name": "page_background", "value": "#181818" },
    { "name": "card_background", "value": "#222222" },
    { "name": "text_primary", "value": "#E6E6E6" }
  ]
}
```

- 系统切换深色模式时，自动使用 `dark/` 目录下的同名资源
- 未在 `dark/` 中定义的资源继续使用 `base/` 中的值

### 11.4 字符串资源 (string.json)

```json
{
  "string": [
    { "name": "app_title", "value": "HarmonyOS Demo" },
    { "name": "tab_home", "value": "首页" },
    { "name": "perm_camera_reason", "value": "用于拍照和录像功能" }
  ]
}
```

---

## 12. 构建系统

### 12.1 Hvigor 构建工具

Hvigor 是 HarmonyOS 专用构建工具，基于 TypeScript：

```typescript
// hvigorfile.ts (项目级)
import { appTasks } from '@ohos/hvigor-ohos-plugin';
export default {
  system: appTasks,   // 内置任务：编译、打包、签名
  plugins: []          // 可扩展自定义插件
}

// entry/hvigorfile.ts (模块级)
import { hapTasks } from '@ohos/hvigor-ohos-plugin';
export default {
  system: hapTasks,   // HAP 模块构建任务
  plugins: []
}
```

### 12.2 构建产物

| 产物 | 说明 |
|------|------|
| `.hap` | HarmonyOS Ability Package，应用安装包 |
| `.hsp` | HarmonyOS Shared Package，共享包 |
| `.har` | HarmonyOS Archive，静态库 |

### 12.3 模块类型

| 类型 | 说明 | 使用场景 |
|------|------|----------|
| `entry` | 主模块 | 应用入口，包含 EntryAbility |
| `feature` | 特性模块 | 动态加载的功能模块 |
| `shared` | 共享模块 | 多模块共享的组件/逻辑 |

---

## 13. HarmonyOS 开发知识库

### 13.1 UIAbility 生命周期

```
onCreate → onWindowStageCreate → onForeground → onBackground → onWindowStageDestroy → onDestroy
```

| 回调 | 触发时机 |
|------|----------|
| `onCreate` | Ability 创建（冷启动） |
| `onWindowStageCreate` | 窗口创建，加载页面 |
| `onForeground` | 进入前台 |
| `onBackground` | 进入后台 |
| `onWindowStageDestroy` | 窗口销毁 |
| `onDestroy` | Ability 销毁 |

### 13.2 组件生命周期

```typescript
@Component
struct MyComponent {
  aboutToAppear() {
    // 组件创建后、build() 前调用
    // 适合：初始化数据、订阅事件
  }

  aboutToDisappear() {
    // 组件销毁前调用
    // 适合：取消订阅、清理定时器
  }

  build() { /* ... */ }
}
```

### 13.3 页面生命周期

```typescript
@Entry
@Component
struct MyPage {
  onPageShow() {
    // 页面显示时（包括路由返回重新显示）
  }

  onPageHide() {
    // 页面隐藏时
  }

  onBackPress(): boolean {
    // 返回键按下，return true 表示已处理（不执行默认返回）
    return false;
  }
}
```

### 13.4 ArkUI 布局单位

| 单位 | 说明 |
|------|------|
| `vp` | 虚拟像素（默认单位），随屏幕密度缩放 |
| `fp` | 字体像素，随字体大小设置缩放 |
| `px` | 物理像素，不缩放 |
| `%` | 百分比，相对父容器 |

```typescript
Text('示例')
  .width('100%')    // 100% 父容器宽度
  .height(44)       // 44vp（默认单位）
  .fontSize(16)     // 16fp
```

### 13.5 常用 API 速查

```typescript
// 路由
router.pushUrl({ url: 'pages/X' });
router.replaceUrl({ url: 'pages/X' });  // 替换当前页（不可返回）
router.back();
router.getParams();

// 弹窗
promptAction.showToast({ message: '提示' });
promptAction.showDialog({ title: '标题', message: '内容', buttons: [...] });

// 日志
hilog.info(0x0000, 'tag', '%{public}s', 'message');

// 获取上下文
const context = getContext(this) as common.UIAbilityContext;

// 全局存储
AppStorage.setOrCreate('key', value);
AppStorage.get('key');
```

### 13.6 ForEach 列表渲染

```typescript
ForEach(this.dataList, (item: DataType, index: number) => {
  Text(item.name)
}, (item: DataType, index: number) => `${item.id}`)  // 键值生成器（必须唯一）
```

- 第三个参数（键值生成器）必须返回唯一字符串
- 键值用于 Diff 算法，正确设置可避免渲染异常

### 13.7 条件渲染

```typescript
// if/else 条件渲染
if (this.isLoading) {
  LoadingProgress()
} else {
  Text('加载完成')
}

// 在 build() 中使用 if 需放在容器内
build() {
  Column() {
    if (this.showHeader) {
      Text('标题')
    }
    Text('内容')
  }
}
```

### 13.8 开发注意事项

1. **`@Builder` 不支持函数参数** — 使用 `@Component` + `@BuilderParam` 替代
2. **`@Entry` 的 build() 只能有一个根容器** — 多个根节点需用 `Stack`/`Column` 包裹
3. **数组/对象状态更新** — 必须重新赋值，不能只修改属性
4. **路由页面必须注册** — `main_pages.json` 中添加路径
5. **权限必须先声明** — `module.json5` 的 `requestPermissions` 中添加
6. **资源引用** — 代码中用 `$r('app.color.xxx')`，配置文件中用 `$color:xxx`
7. **深色模式** — 仅需在 `dark/element/` 中覆盖变化的资源
8. **TextAlign 枚举** — 使用 `TextAlign.Center`（非 `CENTER`）
