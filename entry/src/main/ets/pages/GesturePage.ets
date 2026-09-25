import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct GesturePage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State currentDemo: number = 0;

  // Tap
  @State tapCount: number = 0;
  @State doubleTapCount: number = 0;

  // Long press
  @State longPressActive: boolean = false;
  @State longPressDuration: string = '未触发';

  // Pan
  @State panX: number = 0;
  @State panY: number = 0;

  // Pinch
  @State pinchScale: number = 1;

  // Rotation
  @State rotateAngle: number = 0;

  // Swipe
  @State swipeDirection: string = '滑动查看方向';
  @State swipeColor: ResourceColor = $r('app.color.text_secondary');

  private showToast(msg: string): void {
    promptAction.showToast({ message: msg, duration: 1000 });
  }

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24).fontColor([$r('app.color.text_primary')])
          .onClick(() => { router.back(); })
        Text('手势识别').fontSize(18).fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary')).layoutWeight(1).margin({ left: 12 })
      }
      .width('100%').height(56 + this.statusBarHeight)
      .padding({ left: 16, right: 16, top: this.statusBarHeight })
      .backgroundColor($r('app.color.card_background')).alignItems(VerticalAlign.Center)

      Scroll() {
        Row() {
          ForEach(['点击', '长按', '拖拽', '缩放', '旋转', '滑动'], (label: string, index: number) => {
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

      Stack() {
        if (this.currentDemo === 0) { this.TapDemo() }
        if (this.currentDemo === 1) { this.LongPressDemo() }
        if (this.currentDemo === 2) { this.PanDemo() }
        if (this.currentDemo === 3) { this.PinchDemo() }
        if (this.currentDemo === 4) { this.RotationDemo() }
        if (this.currentDemo === 5) { this.SwipeDemo() }
      }
      .layoutWeight(1).width('100%').backgroundColor($r('app.color.page_background'))
    }
    .width('100%').height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }

  // 1. 点击 / 双击
  @Builder
  TapDemo() {
    Column() {
      Text('TapGesture — 单击 & 双击').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).margin({ bottom: 8 })
      Text(`单击 ${this.tapCount} 次 | 双击 ${this.doubleTapCount} 次`).fontSize(12)
        .fontColor($r('app.color.text_secondary')).margin({ bottom: 24 })

      Column() {
        Text('👆').fontSize(48)
        Text('点击或双击此区域').fontSize(13).fontColor($r('app.color.text_hint')).margin({ top: 8 })
      }
      .width('80%').height(200).borderRadius(16)
      .backgroundColor($r('app.color.card_background'))
      .justifyContent(FlexAlign.Center)
      .gesture(
        GestureGroup(GestureMode.Exclusive,
          TapGesture({ count: 2 })
            .onAction(() => { this.doubleTapCount++; this.showToast('双击！'); }),
          TapGesture({ count: 1 })
            .onAction(() => { this.tapCount++; })
        )
      )

      Blank().layoutWeight(1)
      Button('重置').fontSize(13).type(ButtonType.Capsule).width(120)
        .backgroundColor($r('app.color.page_background')).fontColor($r('app.color.text_secondary'))
        .onClick(() => { this.tapCount = 0; this.doubleTapCount = 0; })
        .margin({ bottom: 20 })
    }
    .width('100%').height('100%').padding(16).alignItems(HorizontalAlign.Center)
  }

  // 2. 长按
  @Builder
  LongPressDemo() {
    Column() {
      Text('LongPressGesture — 长按识别').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).margin({ bottom: 8 })
      Text(`状态: ${this.longPressDuration}`).fontSize(12)
        .fontColor($r('app.color.text_secondary')).margin({ bottom: 24 })

      Column() {
        Text(this.longPressActive ? '✅' : '✋').fontSize(48)
        Text(this.longPressActive ? '长按中...' : '长按此区域 1.5 秒').fontSize(13)
          .fontColor(this.longPressActive ? $r('app.color.success_color') : $r('app.color.text_hint'))
          .margin({ top: 8 })
      }
      .width('80%').height(200).borderRadius(16)
      .backgroundColor(this.longPressActive ? $r('app.color.primary_light') : $r('app.color.card_background'))
      .justifyContent(FlexAlign.Center)
      .gesture(
        LongPressGesture({ repeat: false, duration: 1500 })
          .onAction(() => { this.longPressActive = true; this.longPressDuration = '已触发'; this.showToast('长按触发！'); })
          .onActionEnd(() => { this.longPressActive = false; this.longPressDuration = '已结束'; })
      )

      Blank().layoutWeight(1)
      Button('重置').fontSize(13).type(ButtonType.Capsule).width(120)
        .backgroundColor($r('app.color.page_background')).fontColor($r('app.color.text_secondary'))
        .onClick(() => { this.longPressActive = false; this.longPressDuration = '未触发'; })
        .margin({ bottom: 20 })
    }
    .width('100%').height('100%').padding(16).alignItems(HorizontalAlign.Center)
  }

  // 3. 拖拽 Pan
  @Builder
  PanDemo() {
    Column() {
      Text('PanGesture — 拖拽移动').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).margin({ bottom: 8 })
      Text(`偏移: x=${this.panX.toFixed(0)}, y=${this.panY.toFixed(0)}`).fontSize(12)
        .fontColor($r('app.color.text_secondary')).margin({ bottom: 24 })

      Stack() {
        Column()
          .width(70).height(70).borderRadius(12)
          .backgroundColor($r('app.color.primary_color'))
          .position({ x: 120 + this.panX, y: 80 + this.panY })
          .gesture(
            PanGesture()
              .onActionUpdate((event: GestureEvent) => {
                this.panX = event.offsetX;
                this.panY = event.offsetY;
              })
          )
      }
      .width('100%').layoutWeight(1)

      Button('重置位置').fontSize(13).type(ButtonType.Capsule).width(120)
        .backgroundColor($r('app.color.page_background')).fontColor($r('app.color.text_secondary'))
        .onClick(() => { this.panX = 0; this.panY = 0; })
        .margin({ bottom: 20 })
    }
    .width('100%').height('100%').padding(16).alignItems(HorizontalAlign.Center)
  }

  // 4. 缩放 Pinch
  @Builder
  PinchDemo() {
    Column() {
      Text('PinchGesture — 双指缩放').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).margin({ bottom: 8 })
      Text(`缩放比例: ${this.pinchScale.toFixed(2)}x`).fontSize(12)
        .fontColor($r('app.color.text_secondary')).margin({ bottom: 24 })

      Column()
        .width(150 * this.pinchScale).height(150 * this.pinchScale).borderRadius(20)
        .backgroundColor($r('app.color.success_color'))
        .gesture(
          PinchGesture()
            .onActionUpdate((event: GestureEvent) => {
              this.pinchScale = Math.max(0.3, Math.min(3, this.pinchScale * event.scale));
            })
        )
        .margin({ bottom: 24 })

      Text('双指捏合缩小 / 张开放大').fontSize(12).fontColor($r('app.color.text_hint'))

      Blank().layoutWeight(1)
      Button('重置').fontSize(13).type(ButtonType.Capsule).width(120)
        .backgroundColor($r('app.color.page_background')).fontColor($r('app.color.text_secondary'))
        .onClick(() => { this.pinchScale = 1; })
        .margin({ bottom: 20 })
    }
    .width('100%').height('100%').padding(16).alignItems(HorizontalAlign.Center)
  }

  // 5. 旋转 Rotation
  @Builder
  RotationDemo() {
    Column() {
      Text('RotationGesture — 双指旋转').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).margin({ bottom: 8 })
      Text(`旋转角度: ${this.rotateAngle.toFixed(0)}°`).fontSize(12)
        .fontColor($r('app.color.text_secondary')).margin({ bottom: 24 })

      Column()
        .width(120).height(120).borderRadius(16)
        .backgroundColor($r('app.color.warning_color'))
        .rotate({ angle: this.rotateAngle })
        .gesture(
          RotationGesture()
            .onActionUpdate((event: GestureEvent) => {
              this.rotateAngle = event.angle;
            })
        )
        .margin({ bottom: 24 })

      Text('双指旋转可转动方块').fontSize(12).fontColor($r('app.color.text_hint'))

      Blank().layoutWeight(1)
      Button('重置').fontSize(13).type(ButtonType.Capsule).width(120)
        .backgroundColor($r('app.color.page_background')).fontColor($r('app.color.text_secondary'))
        .onClick(() => { this.rotateAngle = 0; })
        .margin({ bottom: 20 })
    }
    .width('100%').height('100%').padding(16).alignItems(HorizontalAlign.Center)
  }

  // 6. 滑动 Swipe
  @Builder
  SwipeDemo() {
    Column() {
      Text('SwipeGesture — 快速滑动方向检测').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).margin({ bottom: 8 })
      Text(`方向: ${this.swipeDirection}`).fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor(this.swipeColor).margin({ bottom: 24 })

      Column() {
        Text('⇅⇄').fontSize(48)
        Text('在此区域快速滑动').fontSize(13).fontColor($r('app.color.text_hint')).margin({ top: 8 })
      }
      .width('85%').height(250).borderRadius(16)
      .backgroundColor($r('app.color.card_background'))
      .justifyContent(FlexAlign.Center)
      .gesture(
        SwipeGesture({ speed: 100 })
          .onAction((event: GestureEvent) => {
            const angle = event.angle;
            if (angle > -45 && angle < 45) {
              this.swipeDirection = '→ 向右滑动';
              this.swipeColor = $r('app.color.primary_color');
            } else if (angle >= 45 && angle < 135) {
              this.swipeDirection = '↓ 向下滑动';
              this.swipeColor = $r('app.color.success_color');
            } else if (angle >= 135 || angle < -135) {
              this.swipeDirection = '← 向左滑动';
              this.swipeColor = $r('app.color.warning_color');
            } else {
              this.swipeDirection = '↑ 向上滑动';
              this.swipeColor = $r('app.color.danger_color');
            }
          })
      )

      Blank().layoutWeight(1)
      Button('重置').fontSize(13).type(ButtonType.Capsule).width(120)
        .backgroundColor($r('app.color.page_background')).fontColor($r('app.color.text_secondary'))
        .onClick(() => { this.swipeDirection = '滑动查看方向'; this.swipeColor = $r('app.color.text_secondary'); })
        .margin({ bottom: 20 })
    }
    .width('100%').height('100%').padding(16).alignItems(HorizontalAlign.Center)
  }
}
