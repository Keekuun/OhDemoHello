import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { curves } from '@kit.ArkUI';

@Entry
@Component
struct AnimationPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State currentDemo: number = 0;

  // 1. 属性动画
  @State animWidth: number = 100;
  @State animHeight: number = 100;
  @State animRadius: number = 12;
  @State animOpacity: number = 1;
  @State animRotate: number = 0;
  @State animScale: number = 1;
  @State animColor: number = 0;

  // 2. 显式动画
  @State explicitX: number = 16;
  @State explicitY: number = 0;

  // 3. 转场动画
  @State showItem: boolean = true;
  @State transitionList: number[] = [1, 2, 3];

  // 4. 弹簧动画
  @State springVal: number = 0;

  // 5. 循环动画
  @State loopRotate: number = 0;

  private colorList: string[] = ['#007DFF', '#36D372', '#FF9F0A', '#FF4D4F', '#9B59B6'];

  private showToast(msg: string): void {
    promptAction.showToast({ message: msg, duration: 1500 });
  }

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24).fontColor([$r('app.color.text_primary')])
          .onClick(() => { router.back(); })
        Text('动画演示').fontSize(18).fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary')).layoutWeight(1).margin({ left: 12 })
      }
      .width('100%').height(56 + this.statusBarHeight)
      .padding({ left: 16, right: 16, top: this.statusBarHeight })
      .backgroundColor($r('app.color.card_background')).alignItems(VerticalAlign.Center)

      // Demo 切换
      Scroll() {
        Row() {
          ForEach(['属性动画', '显式动画', '转场动画', '弹簧曲线', '循环旋转'], (label: string, index: number) => {
            Text(label).fontSize(12).padding({ left: 10, right: 10, top: 5, bottom: 5 })
              .borderRadius(14)
              .backgroundColor(this.currentDemo === index ? $r('app.color.primary_color') : $r('app.color.page_background'))
              .fontColor(this.currentDemo === index ? Color.White : $r('app.color.text_secondary'))
              .margin({ right: 6 })
              .onClick(() => { this.currentDemo = index; })
          }, (label: string) => label)
        }
        .padding({ left: 16, right: 16 })
      }
      .scrollBar(BarState.Off).scrollable(ScrollDirection.Horizontal)
      .height(40).backgroundColor($r('app.color.card_background'))

      // 内容区
      Stack() {
        if (this.currentDemo === 0) { this.PropertyAnimationDemo() }
        if (this.currentDemo === 1) { this.ExplicitAnimationDemo() }
        if (this.currentDemo === 2) { this.TransitionAnimationDemo() }
        if (this.currentDemo === 3) { this.SpringAnimationDemo() }
        if (this.currentDemo === 4) { this.LoopAnimationDemo() }
      }
      .layoutWeight(1).width('100%').backgroundColor($r('app.color.page_background'))
    }
    .width('100%').height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }

  // 1. 属性动画 — animation() 修饰器
  @Builder
  PropertyAnimationDemo() {
    Column() {
      Text('animation() 隐式属性动画').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).margin({ bottom: 20 })

      Column() {
        Text('尺寸/圆角/透明度/旋转/缩放/颜色').fontSize(12).fontColor($r('app.color.text_secondary')).margin({ bottom: 16 })

        Column()
          .width(this.animWidth).height(this.animHeight)
          .borderRadius(this.animRadius).opacity(this.animOpacity)
          .rotate({ angle: this.animRotate })
          .scale({ x: this.animScale, y: this.animScale })
          .backgroundColor(this.colorList[this.animColor % 5])
          .animation({ duration: 600, curve: Curve.EaseInOut })
          .margin({ bottom: 24 })
      }
      .justifyContent(FlexAlign.Center).layoutWeight(1)

      // 控制按钮
      Column() {
        Row() {
          Button('放大').layoutWeight(1).fontSize(13).type(ButtonType.Capsule)
            .backgroundColor($r('app.color.primary_light')).fontColor($r('app.color.primary_color'))
            .onClick(() => { this.animWidth = 200; this.animHeight = 200; this.animRadius = 100; })
          Button('缩小').layoutWeight(1).fontSize(13).type(ButtonType.Capsule).margin({ left: 8 })
            .backgroundColor($r('app.color.primary_light')).fontColor($r('app.color.primary_color'))
            .onClick(() => { this.animWidth = 80; this.animHeight = 80; this.animRadius = 8; })
          Button('还原').layoutWeight(1).fontSize(13).type(ButtonType.Capsule).margin({ left: 8 })
            .backgroundColor($r('app.color.primary_light')).fontColor($r('app.color.primary_color'))
            .onClick(() => { this.animWidth = 100; this.animHeight = 100; this.animRadius = 12; this.animOpacity = 1; this.animRotate = 0; this.animScale = 1; })
        }.width('100%').margin({ bottom: 8 })

        Row() {
          Button('旋转').layoutWeight(1).fontSize(13).type(ButtonType.Capsule)
            .backgroundColor($r('app.color.success_color')).fontColor(Color.White)
            .onClick(() => { this.animRotate += 180; })
          Button('缩放').layoutWeight(1).fontSize(13).type(ButtonType.Capsule).margin({ left: 8 })
            .backgroundColor($r('app.color.success_color')).fontColor(Color.White)
            .onClick(() => { this.animScale = this.animScale === 1 ? 1.5 : 1; })
          Button('变色').layoutWeight(1).fontSize(13).type(ButtonType.Capsule).margin({ left: 8 })
            .backgroundColor($r('app.color.success_color')).fontColor(Color.White)
            .onClick(() => { this.animColor++; })
        }.width('100%').margin({ bottom: 8 })

        Button('渐隐渐现').width('100%').fontSize(13).type(ButtonType.Capsule)
          .backgroundColor($r('app.color.warning_color')).fontColor(Color.White)
          .onClick(() => { this.animOpacity = this.animOpacity === 1 ? 0.3 : 1; })
      }
      .width('100%').padding(16)
    }
    .width('100%').height('100%').padding(16)
  }

  // 2. 显式动画 — animateTo()
  @Builder
  ExplicitAnimationDemo() {
    Column() {
      Text('animateTo() 显式动画 + 不同曲线').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).margin({ bottom: 20 })

      Stack() {
        Column()
          .width(60).height(60).borderRadius(30)
          .backgroundColor($r('app.color.primary_color'))
          .position({ x: this.explicitX, y: this.explicitY })
      }
      .width('100%').layoutWeight(1)

      Column() {
        Text(`位置: x=${this.explicitX.toFixed(0)}, y=${this.explicitY.toFixed(0)}`).fontSize(12)
          .fontColor($r('app.color.text_secondary')).margin({ bottom: 12 })

        Row() {
          Button('Linear').layoutWeight(1).fontSize(12).type(ButtonType.Capsule)
            .backgroundColor($r('app.color.primary_color')).fontColor(Color.White)
            .onClick(() => {
              animateTo({ duration: 800, curve: Curve.Linear }, () => {
                this.explicitX = this.explicitX < 200 ? 250 : 16;
              });
            })
          Button('EaseIn').layoutWeight(1).fontSize(12).type(ButtonType.Capsule).margin({ left: 6 })
            .backgroundColor($r('app.color.success_color')).fontColor(Color.White)
            .onClick(() => {
              animateTo({ duration: 800, curve: Curve.EaseIn }, () => {
                this.explicitY = this.explicitY === 0 ? 150 : 0;
              });
            })
          Button('EaseOut').layoutWeight(1).fontSize(12).type(ButtonType.Capsule).margin({ left: 6 })
            .backgroundColor($r('app.color.warning_color')).fontColor(Color.White)
            .onClick(() => {
              animateTo({ duration: 800, curve: Curve.EaseOut }, () => {
                this.explicitX = this.explicitX < 200 ? 250 : 16;
                this.explicitY = this.explicitY === 0 ? 100 : 0;
              });
            })
        }.width('100%')

        Button('EaseInOut 对角线').width('100%').fontSize(13).type(ButtonType.Capsule).margin({ top: 8 })
          .backgroundColor($r('app.color.danger_color')).fontColor(Color.White)
          .onClick(() => {
            animateTo({ duration: 1000, curve: Curve.EaseInOut }, () => {
              if (this.explicitX < 200) { this.explicitX = 250; this.explicitY = 150; }
              else { this.explicitX = 16; this.explicitY = 0; }
            });
          })

        Button('重置').width('100%').fontSize(13).type(ButtonType.Capsule).margin({ top: 8 })
          .backgroundColor($r('app.color.page_background')).fontColor($r('app.color.text_secondary'))
          .onClick(() => { this.explicitX = 16; this.explicitY = 0; })
      }
      .width('100%').padding(16)
    }
    .width('100%').height('100%').padding(16)
  }

  // 3. 转场动画 — transition
  @Builder
  TransitionAnimationDemo() {
    Column() {
      Text('transition 组件出现/消失转场').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).margin({ bottom: 20 })

      Column() {
        Button(this.showItem ? '隐藏元素' : '显示元素').fontSize(14).type(ButtonType.Capsule)
          .backgroundColor($r('app.color.primary_color')).fontColor(Color.White)
          .onClick(() => { this.showItem = !this.showItem; })
          .margin({ bottom: 20 })

        if (this.showItem) {
          Column() {
            Text('我会带动画出现/消失 ✨').fontSize(15).fontColor(Color.White)
          }
          .width('80%').height(80).borderRadius(16)
          .backgroundColor($r('app.color.primary_color'))
          .justifyContent(FlexAlign.Center)
          .transition({ type: TransitionType.Insert, opacity: 0, translate: { y: 50 } })
          .transition({ type: TransitionType.Delete, opacity: 0, translate: { y: -50 } })
        }
      }
      .layoutWeight(1).justifyContent(FlexAlign.Center).width('100%')

      // 列表项添加/删除转场
      Column() {
        Text('列表项添加/删除转场').fontSize(13).fontColor($r('app.color.text_secondary')).margin({ bottom: 12 })
        Row() {
          Button('添加').fontSize(13).type(ButtonType.Capsule).layoutWeight(1)
            .backgroundColor($r('app.color.success_color')).fontColor(Color.White)
            .onClick(() => { this.transitionList.push(this.transitionList.length + 1); })
          Button('删除').fontSize(13).type(ButtonType.Capsule).layoutWeight(1).margin({ left: 8 })
            .backgroundColor($r('app.color.danger_color')).fontColor(Color.White)
            .onClick(() => { if (this.transitionList.length > 0) this.transitionList.pop(); })
        }.width('100%').margin({ bottom: 12 })

        Column() {
          ForEach(this.transitionList, (item: number) => {
            Text(`Item ${item}`).fontSize(13).fontColor($r('app.color.text_primary'))
              .width('100%').height(36).borderRadius(8)
              .backgroundColor($r('app.color.card_background')).margin({ bottom: 6 })
              .textAlign(TextAlign.Center)
              .transition({ type: TransitionType.Insert, opacity: 0, scale: { x: 0.5, y: 0.5 } })
              .transition({ type: TransitionType.Delete, opacity: 0, scale: { x: 0, y: 0 } })
          }, (item: number) => `${item}`)
        }
      }
      .width('100%').padding(16)
    }
    .width('100%').height('100%').padding(16)
  }

  // 4. 弹簧动画
  @Builder
  SpringAnimationDemo() {
    Column() {
      Text('Spring 弹簧曲线动画').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).margin({ bottom: 20 })

      Stack() {
        Column()
          .width(70).height(70).borderRadius(35)
          .backgroundColor($r('app.color.success_color'))
          .position({ x: 140 + this.springVal, y: 100 })
      }
      .width('100%').layoutWeight(1)

      Column() {
        Text(`偏移: ${this.springVal.toFixed(0)}`).fontSize(12)
          .fontColor($r('app.color.text_secondary')).margin({ bottom: 12 })

        Button('弹簧左弹').width('100%').fontSize(13).type(ButtonType.Capsule).margin({ bottom: 8 })
          .backgroundColor($r('app.color.primary_color')).fontColor(Color.White)
          .onClick(() => {
            animateTo({ duration: 1000, curve: curves.springMotion(0.1, 0.5) }, () => {
              this.springVal = this.springVal === 0 ? -120 : 0;
            });
          })

        Button('弹簧右弹').width('100%').fontSize(13).type(ButtonType.Capsule).margin({ bottom: 8 })
          .backgroundColor($r('app.color.success_color')).fontColor(Color.White)
          .onClick(() => {
            animateTo({ duration: 1000, curve: curves.springMotion(0.2, 0.8) }, () => {
              this.springVal = this.springVal === 0 ? 120 : 0;
            });
          })

        Button('阻尼振荡').width('100%').fontSize(13).type(ButtonType.Capsule)
          .backgroundColor($r('app.color.warning_color')).fontColor(Color.White)
          .onClick(() => {
            animateTo({ duration: 1500, curve: curves.springMotion(0.05, 0.3) }, () => {
              this.springVal = this.springVal === 0 ? 100 : 0;
            });
          })
      }
      .width('100%').padding(16)
    }
    .width('100%').height('100%').padding(16)
  }

  // 5. 循环旋转动画
  @Builder
  LoopAnimationDemo() {
    Column() {
      Text('循环旋转 + 组合动画').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).margin({ bottom: 20 })

      Column() {
        // 持续旋转的方块
        Column()
          .width(80).height(80).borderRadius(16)
          .backgroundColor($r('app.color.primary_color'))
          .rotate({ angle: this.loopRotate })
          .animation({ duration: 2000, curve: Curve.Linear, iterations: -1 })
          .margin({ bottom: 30 })

        Text('↑ 无限循环旋转').fontSize(12).fontColor($r('app.color.text_secondary')).margin({ bottom: 30 })

        // 脉冲动画
        Column()
          .width(60).height(60).borderRadius(30)
          .backgroundColor($r('app.color.danger_color'))
          .scale({ x: this.loopRotate % 2 === 0 ? 1 : 1.3, y: this.loopRotate % 2 === 0 ? 1 : 1.3 })
          .opacity(this.loopRotate % 2 === 0 ? 1 : 0.5)
          .animation({ duration: 800, curve: Curve.EaseInOut, iterations: -1 })
          .margin({ bottom: 12 })

        Text('↑ 脉冲缩放+透明度').fontSize(12).fontColor($r('app.color.text_secondary'))
      }
      .layoutWeight(1).justifyContent(FlexAlign.Center)

      Column() {
        Button('开始/暂停').width('100%').fontSize(14).type(ButtonType.Capsule)
          .backgroundColor($r('app.color.primary_color')).fontColor(Color.White)
          .onClick(() => { this.loopRotate += 360; })
      }
      .width('100%').padding(16)
    }
    .width('100%').height('100%').padding(16)
  }
}
