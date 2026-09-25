import { router } from '@kit.ArkUI';

@Entry
@Component
struct LayoutPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State currentDemo: number = 0;

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24).fontColor([$r('app.color.text_primary')])
          .onClick(() => { router.back(); })
        Text('相对布局').fontSize(18).fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary')).layoutWeight(1).margin({ left: 12 })
      }
      .width('100%').height(56 + this.statusBarHeight)
      .padding({ left: 16, right: 16, top: this.statusBarHeight })
      .backgroundColor($r('app.color.card_background')).alignItems(VerticalAlign.Center)

      Scroll() {
        Row() {
          ForEach(['居中', '四角', '链式', '表单'], (label: string, index: number) => {
            Text(label).fontSize(12).padding({ left: 10, right: 10, top: 5, bottom: 5 })
              .borderRadius(14)
              .backgroundColor(this.currentDemo === index ? $r('app.color.primary_color') : $r('app.color.page_background'))
              .fontColor(this.currentDemo === index ? Color.White : $r('app.color.text_secondary'))
              .margin({ right: 6 })
              .onClick(() => { this.currentDemo = index; })
          }, (label: string) => label)
        }.padding({ left: 16, right: 16 })
      }
      .scrollBar(BarState.Off).scrollable(ScrollDirection.Horizontal)
      .height(40).backgroundColor($r('app.color.card_background'))

      Stack() {
        if (this.currentDemo === 0) { this.CenterDemo() }
        if (this.currentDemo === 1) { this.CornersDemo() }
        if (this.currentDemo === 2) { this.ChainDemo() }
        if (this.currentDemo === 3) { this.FormDemo() }
      }
      .layoutWeight(1).width('100%').backgroundColor($r('app.color.page_background'))
    }
    .width('100%').height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }

  // 1. 居中对齐
  @Builder
  CenterDemo() {
    Column() {
      Text('RelativeContainer — 居中对齐').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).margin({ bottom: 16 })

      RelativeContainer() {
        Text('水平+垂直居中').fontSize(14).fontColor(Color.White)
          .padding(16).borderRadius(12).backgroundColor($r('app.color.primary_color'))
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center },
          })
          .id('center_item')
      }
      .width('100%').height(300).borderRadius(16)
      .backgroundColor($r('app.color.card_background'))
      .padding(16)

      Blank().layoutWeight(1)
      Text('使用 center + middle 锚点实现居中').fontSize(12).fontColor($r('app.color.text_hint')).margin({ bottom: 20 })
    }
    .width('100%').height('100%').padding(16)
  }

  // 2. 四角对齐
  @Builder
  CornersDemo() {
    Column() {
      Text('RelativeContainer — 四角对齐').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).margin({ bottom: 16 })

      RelativeContainer() {
        // 左上
        Text('左上').fontSize(12).fontColor(Color.White).padding(10).borderRadius(8)
          .backgroundColor($r('app.color.primary_color'))
          .alignRules({ top: { anchor: '__container__', align: VerticalAlign.Top }, start: { anchor: '__container__', align: HorizontalAlign.Start } })
          .id('tl')

        // 右上
        Text('右上').fontSize(12).fontColor(Color.White).padding(10).borderRadius(8)
          .backgroundColor($r('app.color.success_color'))
          .alignRules({ top: { anchor: '__container__', align: VerticalAlign.Top }, end: { anchor: '__container__', align: HorizontalAlign.End } })
          .id('tr')

        // 左下
        Text('左下').fontSize(12).fontColor(Color.White).padding(10).borderRadius(8)
          .backgroundColor($r('app.color.warning_color'))
          .alignRules({ bottom: { anchor: '__container__', align: VerticalAlign.Bottom }, start: { anchor: '__container__', align: HorizontalAlign.Start } })
          .id('bl')

        // 右下
        Text('右下').fontSize(12).fontColor(Color.White).padding(10).borderRadius(8)
          .backgroundColor($r('app.color.danger_color'))
          .alignRules({ bottom: { anchor: '__container__', align: VerticalAlign.Bottom }, end: { anchor: '__container__', align: HorizontalAlign.End } })
          .id('br')

        // 中心
        Text('中心').fontSize(12).fontColor(Color.White).padding(10).borderRadius(8)
          .backgroundColor($r('app.color.text_primary'))
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center },
          })
          .id('center')
      }
      .width('100%').height(300).borderRadius(16)
      .backgroundColor($r('app.color.card_background'))
      .padding(16)

      Blank().layoutWeight(1)
      Text('top/bottom/start/end 锚点定位四角').fontSize(12).fontColor($r('app.color.text_hint')).margin({ bottom: 20 })
    }
    .width('100%').height('100%').padding(16)
  }

  // 3. 链式依赖
  @Builder
  ChainDemo() {
    Column() {
      Text('RelativeContainer — 链式依赖').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).margin({ bottom: 16 })

      RelativeContainer() {
        Text('A').fontSize(16).fontColor(Color.White).textAlign(TextAlign.Center)
          .width(50).height(50).borderRadius(12).backgroundColor($r('app.color.primary_color'))
          .alignRules({ start: { anchor: '__container__', align: HorizontalAlign.Start }, center: { anchor: '__container__', align: VerticalAlign.Center } })
          .id('box_a')

        Text('B').fontSize(16).fontColor(Color.White).textAlign(TextAlign.Center)
          .width(50).height(50).borderRadius(12).backgroundColor($r('app.color.success_color'))
          .alignRules({ start: { anchor: 'box_a', align: HorizontalAlign.End }, center: { anchor: 'box_a', align: VerticalAlign.Center } })
          .margin({ left: 12 })
          .id('box_b')

        Text('C').fontSize(16).fontColor(Color.White).textAlign(TextAlign.Center)
          .width(50).height(50).borderRadius(12).backgroundColor($r('app.color.warning_color'))
          .alignRules({ start: { anchor: 'box_b', align: HorizontalAlign.End }, center: { anchor: 'box_b', align: VerticalAlign.Center } })
          .margin({ left: 12 })
          .id('box_c')

        // D 在 B 下方
        Text('D').fontSize(16).fontColor(Color.White).textAlign(TextAlign.Center)
          .width(50).height(50).borderRadius(12).backgroundColor($r('app.color.danger_color'))
          .alignRules({ top: { anchor: 'box_b', align: VerticalAlign.Bottom }, middle: { anchor: 'box_b', align: HorizontalAlign.Center } })
          .margin({ top: 12 })
          .id('box_d')
      }
      .width('100%').height(300).borderRadius(16)
      .backgroundColor($r('app.color.card_background'))
      .padding(16)

      Blank().layoutWeight(1)
      Text('B 依赖 A，C 依赖 B，D 依赖 B — 链式锚定').fontSize(12).fontColor($r('app.color.text_hint')).margin({ bottom: 20 })
    }
    .width('100%').height('100%').padding(16)
  }

  // 4. 表单布局
  @Builder
  FormDemo() {
    Column() {
      Text('RelativeContainer — 表单布局').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).margin({ bottom: 16 })

      RelativeContainer() {
        Text('用户名').fontSize(13).fontColor($r('app.color.text_secondary'))
          .alignRules({ start: { anchor: '__container__', align: HorizontalAlign.Start }, center: { anchor: 'input1', align: VerticalAlign.Center } })
          .id('label1')

        TextInput({ placeholder: '请输入用户名' }).height(40).borderRadius(8)
          .border({ width: 1, color: $r('app.color.divider_color') })
          .alignRules({ start: { anchor: 'label1', align: HorizontalAlign.End }, end: { anchor: '__container__', align: HorizontalAlign.End } })
          .margin({ left: 12 })
          .id('input1')

        Text('密码').fontSize(13).fontColor($r('app.color.text_secondary'))
          .alignRules({ start: { anchor: '__container__', align: HorizontalAlign.Start }, center: { anchor: 'input2', align: VerticalAlign.Center } })
          .margin({ top: 12 })
          .id('label2')

        TextInput({ placeholder: '请输入密码' }).height(40).borderRadius(8).type(InputType.Password)
          .border({ width: 1, color: $r('app.color.divider_color') })
          .alignRules({ start: { anchor: 'label2', align: HorizontalAlign.End }, end: { anchor: '__container__', align: HorizontalAlign.End }, top: { anchor: 'input1', align: VerticalAlign.Bottom } })
          .margin({ left: 12, top: 12 })
          .id('input2')

        Button('登录').fontSize(14).type(ButtonType.Capsule)
          .backgroundColor($r('app.color.primary_color')).fontColor(Color.White)
          .alignRules({ middle: { anchor: '__container__', align: HorizontalAlign.Center }, top: { anchor: 'input2', align: VerticalAlign.Bottom } })
          .margin({ top: 20 })
          .id('btn')
      }
      .width('100%').borderRadius(16)
      .backgroundColor($r('app.color.card_background'))
      .padding(16)

      Blank().layoutWeight(1)
      Text('标签与输入框通过锚点对齐').fontSize(12).fontColor($r('app.color.text_hint')).margin({ bottom: 20 })
    }
    .width('100%').height('100%').padding(16)
  }
}
