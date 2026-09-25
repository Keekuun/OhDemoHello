import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

@Component
struct NavContent {
  @Prop title: string;
  @Prop depth: number;

  build() {
    Column() {
      Text(this.title).fontSize(20).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).margin({ bottom: 16 })
      Text(`当前层级: ${this.depth}`).fontSize(14).fontColor($r('app.color.text_secondary')).margin({ bottom: 24 })

      Column() {
        Text('Navigation 组件特点：').fontSize(13).fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary')).margin({ bottom: 8 })
        Text('• 支持路由栈管理（push/pop）').fontSize(12).fontColor($r('app.color.text_secondary')).margin({ bottom: 4 })
        Text('• 自带转场动画').fontSize(12).fontColor($r('app.color.text_secondary')).margin({ bottom: 4 })
        Text('• 支持 Split 模式（平板自适应）').fontSize(12).fontColor($r('app.color.text_secondary')).margin({ bottom: 4 })
        Text('• 支持自定义标题栏').fontSize(12).fontColor($r('app.color.text_secondary')).margin({ bottom: 4 })
        Text('• 替代 router 的官方推荐方案').fontSize(12).fontColor($r('app.color.text_secondary'))
      }
      .width('100%').padding(16).borderRadius(12).backgroundColor($r('app.color.card_background')).margin({ bottom: 16 })
    }
    .width('100%').padding(16)
  }
}

@Entry
@Component
struct NavPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @Provide('navPathStack') pathStack: NavPathStack = new NavPathStack();

  @Builder
  PageMap(name: string, param: ESObject) {
    if (name === 'page1') {
      NavContent({ title: '页面 1', depth: 1 })
    } else if (name === 'page2') {
      NavContent({ title: '页面 2', depth: 2 })
    } else if (name === 'page3') {
      NavContent({ title: '页面 3', depth: 3 })
    }
  }

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24).fontColor([$r('app.color.text_primary')])
          .onClick(() => { router.back(); })
        Text('Navigation 导航').fontSize(18).fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary')).layoutWeight(1).margin({ left: 12 })
      }
      .width('100%').height(56 + this.statusBarHeight)
      .padding({ left: 16, right: 16, top: this.statusBarHeight })
      .backgroundColor($r('app.color.card_background')).alignItems(VerticalAlign.Center)

      Navigation(this.pathStack) {
        // 首页内容
        Column() {
          Text('Navigation 容器首页').fontSize(18).fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary')).margin({ bottom: 16 })

          Text('点击下方按钮通过 NavPathStack 管理路由栈').fontSize(13)
            .fontColor($r('app.color.text_secondary')).margin({ bottom: 24 })

          Button('跳转页面 1').width('100%').fontSize(14).type(ButtonType.Capsule)
            .backgroundColor($r('app.color.primary_color')).fontColor(Color.White).height(42)
            .margin({ bottom: 8 })
            .onClick(() => { this.pathStack.pushPath({ name: 'page1' }); })

          Button('跳转页面 2').width('100%').fontSize(14).type(ButtonType.Capsule)
            .backgroundColor($r('app.color.success_color')).fontColor(Color.White).height(42)
            .margin({ bottom: 8 })
            .onClick(() => { this.pathStack.pushPath({ name: 'page2' }); })

          Button('跳转页面 3').width('100%').fontSize(14).type(ButtonType.Capsule)
            .backgroundColor($r('app.color.warning_color')).fontColor(Color.White).height(42)
            .margin({ bottom: 16 })
            .onClick(() => { this.pathStack.pushPath({ name: 'page3' }); })

          // 路由栈信息
          Column() {
            Text('路由栈信息').fontSize(13).fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary')).margin({ bottom: 8 })
            Text(`栈深度: ${this.pathStack.size()}`).fontSize(12).fontColor($r('app.color.text_secondary')).margin({ bottom: 4 })
            Text(`所有路由: ${this.pathStack.getAllPathName().join(' → ')}`).fontSize(12).fontColor($r('app.color.text_secondary'))
          }
          .width('100%').padding(16).borderRadius(12).backgroundColor($r('app.color.card_background'))

          Blank().layoutWeight(1)

          // 操作按钮
          Row() {
            Button('返回').fontSize(12).type(ButtonType.Capsule).layoutWeight(1)
              .backgroundColor($r('app.color.primary_light')).fontColor($r('app.color.primary_color'))
              .onClick(() => { this.pathStack.pop(); })
            Button('返回首页').fontSize(12).type(ButtonType.Capsule).layoutWeight(1).margin({ left: 8 })
              .backgroundColor($r('app.color.primary_light')).fontColor($r('app.color.primary_color'))
              .onClick(() => { this.pathStack.clear(); })
            Button('替换').fontSize(12).type(ButtonType.Capsule).layoutWeight(1).margin({ left: 8 })
              .backgroundColor($r('app.color.primary_light')).fontColor($r('app.color.primary_color'))
              .onClick(() => { this.pathStack.replacePath({ name: 'page1' }); })
          }.width('100%').margin({ bottom: 16 })
        }
        .width('100%').height('100%').padding(16)
      }
      .navDestination(this.PageMap)
      .mode(NavigationMode.Stack)
      .title('Navigation 导航容器')
      .titleMode(NavigationTitleMode.Mini)
      .hideNavBar(false)
      .layoutWeight(1)
    }
    .width('100%').height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}
