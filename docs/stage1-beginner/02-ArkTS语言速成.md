# 02 ArkTS 语言速成

> 学习目标：看懂鸿蒙代码的「语法零件」，不再一脸懵。

## 一、ArkTS 是什么

ArkTS 是鸿蒙的开发语言，它是 **TypeScript 的超集**——就是 TypeScript 加了点鸿蒙专属功能。
TypeScript 又是 JavaScript 加了「类型」。所以关系是：

```
JavaScript ⊂ TypeScript ⊂ ArkTS
```

你只要学 ArkTS 这一层就够了。

## 二、变量与类型

```typescript
let name: string = '小明';      // 字符串，可以改
const age: number = 18;         // 数字，不能改（const）
let isVip: boolean = true;      // 布尔
let tags: string[] = ['a', 'b']; // 字符串数组
let score = 100;                // 不写类型也行，它能自己推断
```

**类型**就是给变量贴标签：贴了 `string` 就不能塞数字，写错了编辑器当场红线提醒，不用等运行才发现。

## 三、函数

```typescript
// 普通函数
function add(a: number, b: number): number {
  return a + b;
}

// 箭头函数（更常用，尤其是回调）
const greet = (name: string): string => {
  return `你好，${name}`;   // 反引号里可以用 ${} 拼变量
};
```

项目里大量这样的写法，比如 `Index.ets` 里：

```typescript
.onChange((index: number) => { this.currentTabIndex = index; })
```

意思就是：「Tab 切换时，把新的序号存进 `currentTabIndex`」。

## 四、类（class）与对象

类就是「图纸」，对象是「按图纸造出来的东西」。看项目 `ProfilePage.ets` 里的真实例子：

```typescript
class MenuItem {
  icon: Resource;    // 图标
  name: string;      // 名字
  badge: string;     // 角标
  route: string;     // 点击跳去哪

  constructor(icon: Resource, name: string, badge: string, route: string = '') {
    this.icon = icon;
    this.name = name;
    this.badge = badge;
    this.route = route;
  }
}

// 造一个对象来用：
new MenuItem($r('sys.symbol.heart_fill'), '我的收藏', '', 'pages/AboutPage')
```

`constructor` 是「构造函数」：`new` 的时候自动执行，负责把参数装进对象。

## 五、装饰器（@开头的东西）—— ArkTS 的灵魂

装饰器就是「给代码贴魔法标签」，鸿蒙靠它知道你的意图：

| 装饰器 | 贴在哪 | 作用 |
|--------|--------|------|
| `@Entry` | 结构体 | 这是一个**页面入口** |
| `@Component` | 结构体 | 这是一个**UI 组件** |
| `@State` | 变量 | 这个变量变了，**界面自动刷新** |
| `@Builder` | 函数 | 这是一段**可复用的 UI 片段** |

看 `Index.ets` 的开头：

```typescript
@Entry                          // 我是个页面
@Component                      // 我也是个组件
struct Index {
  @State currentTabIndex: number = 0;   // 它一变，界面自动更新

  build() {
    // 这里描述界面长什么样
  }
}
```

## 六、import 导入

要用别处的代码，先导入：

```typescript
import { router } from '@kit.ArkUI';        // 系统kit里的功能
import { HomePage } from './HomePage';      // 同目录下的文件
```

## 七、interface 接口（约定形状）

```typescript
interface User {
  name: string;
  age: number;
}
// 约定：只要是 User，就必须有 name 和 age
```

## 动手练

1. 打开 `entry/src/main/ets/pages/ProfilePage.ets`，找到 `MenuItem` 类，给它加一个字段 `desc: string`，看看编辑器哪里报错了，照着报错把 `new MenuItem(...)` 的地方补上参数。
2. 在任意页面里写一句 `let test: number = 'abc';`，看编辑器是不是立刻红线——这就是类型检查在保护你。

## 小结

- 变量有类型，函数有箭头写法，类是图纸
- `@Entry` `@Component` `@State` 三个装饰器先记住，后面天天见
- 看不懂语法时，把代码复制下来问 AI：「这段 ArkTS 逐行解释一下」

下一篇：[03 声明式 UI 思维](03-声明式UI思维.md)
