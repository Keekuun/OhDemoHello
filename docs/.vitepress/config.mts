import { defineConfig } from 'vitepress'

// VitePress 站点配置：把 docs/ 目录变成文档网站
export default defineConfig({
  lang: 'zh-CN',
  title: '鸿蒙百宝箱',
  description: 'HarmonyOS 开发学习文档：ArkTS 从入门到深入 + Electron 鸿蒙 PC 开发指南',
  // GitHub Pages 项目站点子路径（本地 dev 不受影响）
  base: process.env.VITEPRESS_BASE || '/',
  cleanUrls: true,
  lastUpdated: true,

  themeConfig: {
    // 顶部导航
    nav: [
      { text: '首页', link: '/' },
      { text: '学习路线', link: '/learning-path' },
      { text: 'Electron 鸿蒙', link: '/electron-harmony/' },
      { text: 'GitHub', link: 'https://github.com/Keekuun/OhDemoHello' }
    ],

    // 侧边栏：按学习阶段分组
    sidebar: {
      '/': [
        {
          text: '📚 学习路线',
          items: [
            { text: '总览', link: '/learning-path' }
          ]
        },
        {
          text: '🟢 阶段一：入门',
          collapsed: false,
          items: [
            { text: '01 环境搭建与第一个 App', link: '/stage1-beginner/01-环境搭建与第一个App' },
            { text: '02 ArkTS 语言速成', link: '/stage1-beginner/02-ArkTS语言速成' },
            { text: '03 声明式 UI 思维', link: '/stage1-beginner/03-声明式UI思维' },
            { text: '04 看懂项目结构', link: '/stage1-beginner/04-看懂项目结构' }
          ]
        },
        {
          text: '🔵 阶段二：进阶',
          collapsed: false,
          items: [
            { text: '05 常用组件大全', link: '/stage2-advanced/05-常用组件大全' },
            { text: '06 状态管理详解', link: '/stage2-advanced/06-状态管理详解' },
            { text: '07 路由与页面跳转', link: '/stage2-advanced/07-路由与页面跳转' },
            { text: '08 布局实战', link: '/stage2-advanced/08-布局实战' }
          ]
        },
        {
          text: '🟠 阶段三：高级',
          collapsed: false,
          items: [
            { text: '09 网络请求与数据', link: '/stage3-senior/09-网络请求与数据' },
            { text: '10 本地存储与数据库', link: '/stage3-senior/10-本地存储与数据库' },
            { text: '11 权限与安全', link: '/stage3-senior/11-权限与安全' },
            { text: '12 动画与手势', link: '/stage3-senior/12-动画与手势' }
          ]
        },
        {
          text: '🔴 阶段四：深入',
          collapsed: false,
          items: [
            { text: '13 生命周期与沉浸式', link: '/stage4-expert/13-生命周期与沉浸式' },
            { text: '14 主题与深色模式', link: '/stage4-expert/14-主题与深色模式' },
            { text: '15 性能优化', link: '/stage4-expert/15-性能优化' },
            { text: '16 测试、签名与发布', link: '/stage4-expert/16-测试签名与发布' }
          ]
        },
        {
          text: '🖥️ Electron 鸿蒙 PC 开发',
          collapsed: false,
          items: [
            { text: '总览', link: '/electron-harmony/' },
            { text: '01 认识鸿蒙 Electron', link: '/electron-harmony/01-认识鸿蒙Electron' },
            { text: '02 环境搭建与运行', link: '/electron-harmony/02-环境搭建与运行' },
            { text: '03 开发实战与适配要点', link: '/electron-harmony/03-开发实战与适配要点' },
            { text: '04 报错速查与避坑指南', link: '/electron-harmony/04-报错速查与避坑指南' },
            { text: '05 技术选型对比', link: '/electron-harmony/05-技术选型对比' }
          ]
        }
      ]
    },

    // 本地搜索（免部署搜索服务）
    search: {
      provider: 'local',
      options: {
        translations: {
          button: { buttonText: '搜索文档', buttonAriaLabel: '搜索文档' },
          modal: {
            noResultsText: '没有找到相关内容',
            resetButtonTitle: '清除搜索',
            footer: { selectText: '选择', navigateText: '切换', closeText: '关闭' }
          }
        }
      }
    },

    // 中文化界面文案
    outline: { label: '本页目录' },
    docFooter: { prev: '上一篇', next: '下一篇' },
    lastUpdatedText: '最后更新',
    returnToTopLabel: '回到顶部',
    darkModeSwitchLabel: '深色模式',

    socialLinks: [
      { icon: 'github', link: 'https://github.com/Keekuun/OhDemoHello' }
    ]
  }
})
