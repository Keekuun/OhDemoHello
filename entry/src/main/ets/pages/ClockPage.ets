import { router } from '@kit.ArkUI';

@Entry
@Component
struct ClockPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State currentDemo: number = 0;

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24).fontColor([$r('app.color.text_primary')])
          .onClick(() => { router.back(); })
        Text('时钟组件').fontSize(18).fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary')).layoutWeight(1).margin({ left: 12 })
      }
      .width('100%').height(56 + this.statusBarHeight)
      .padding({ left: 16, right: 16, top: this.statusBarHeight })
      .backgroundColor($r('app.color.card_background')).alignItems(VerticalAlign.Center)

      Row() {
        ForEach(['大号时钟', '日期时间', '多种格式'], (label: string, index: number) => {
          Text(label).fontSize(13).padding({ left: 14, right: 14, top: 6, bottom: 6 })
            .borderRadius(16)
            .backgroundColor(this.currentDemo === index ? $r('app.color.primary_color') : $r('app.color.page_background'))
            .fontColor(this.currentDemo === index ? Color.White : $r('app.color.text_secondary'))
            .margin({ right: 8 })
            .onClick(() => { this.currentDemo = index; })
        }, (label: string) => label)
      }
      .width('100%').padding({ left: 16, top: 8, bottom: 8 })
      .backgroundColor($r('app.color.card_background'))

      Scroll() {
        Column() {
          if (this.currentDemo === 0) { this.BigClockDemo() }
          if (this.currentDemo === 1) { this.DateTimeDemo() }
          if (this.currentDemo === 2) { this.MultiFormatDemo() }
        }
        .width('100%').padding(16)
      }
      .scrollBar(BarState.Off).edgeEffect(EdgeEffect.Spring)
      .layoutWeight(1).backgroundColor($r('app.color.page_background'))
    }
    .width('100%').height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }

  @Builder
  BigClockDemo() {
    Column() {
      Text('TextClock — 大号数字时钟').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).width('100%').margin({ bottom: 24 })

      Column() {
        TextClock().format('HH:mm:ss')
          .fontSize(56).fontColor($r('app.color.primary_color')).fontWeight(FontWeight.Bold)
        Text('实时更新，无需定时器').fontSize(12).fontColor($r('app.color.text_hint')).margin({ top: 12 })
      }
      .width('100%').padding(40).borderRadius(16)
      .backgroundColor($r('app.color.card_background')).shadow({ radius: 6, color: 'rgba(0,0,0,0.06)', offsetY: 2 })

      // 带秒的紧凑时钟
      Column() {
        Row() {
          TextClock().format('HH:mm').fontSize(36).fontColor($r('app.color.text_primary')).fontWeight(FontWeight.Bold)
          TextClock().format('ss').fontSize(20).fontColor($r('app.color.text_hint')).margin({ left: 4, bottom: 4 })
        }
      }
      .width('100%').padding(24).borderRadius(16)
      .backgroundColor($r('app.color.card_background')).margin({ top: 16 })

      Blank().height(20)
    }.width('100%')
  }

  @Builder
  DateTimeDemo() {
    Column() {
      Text('TextClock — 日期 + 时间组合').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).width('100%').margin({ bottom: 24 })

      Column() {
        TextClock().format('yyyy年MM月dd日').fontSize(22).fontColor($r('app.color.text_primary')).margin({ bottom: 8 })
        Divider().color($r('app.color.divider_color')).margin({ bottom: 8 })
        TextClock().format('HH:mm:ss').fontSize(28).fontColor($r('app.color.success_color')).fontWeight(FontWeight.Bold)
      }
      .width('100%').padding(28).borderRadius(16)
      .backgroundColor($r('app.color.card_background')).margin({ bottom: 16 })

      Column() {
        Text('星期显示').fontSize(13).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 8 })
        TextClock().format('EEEE').fontSize(20).fontColor($r('app.color.primary_color'))
      }
      .width('100%').padding(20).borderRadius(16)
      .backgroundColor($r('app.color.card_background')).margin({ bottom: 16 })

      Column() {
        Text('上午/下午').fontSize(13).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 8 })
        TextClock().format('a hh:mm:ss').fontSize(20).fontColor($r('app.color.warning_color'))
      }
      .width('100%').padding(20).borderRadius(16)
      .backgroundColor($r('app.color.card_background'))

      Blank().height(20)
    }.width('100%')
  }

  @Builder
  MultiFormatDemo() {
    Column() {
      Text('TextClock — 多种格式展示').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).width('100%').margin({ bottom: 24 })

      this.FormatCard('完整日期时间', 'yyyy-MM-dd HH:mm:ss')
      this.FormatCard('斜杠日期', 'yyyy/MM/dd')
      this.FormatCard('中文日期', 'yyyy年MM月dd日 EEEE')
      this.FormatCard('12小时制', 'hh:mm:ss a')
      this.FormatCard('月日时分', 'MM月dd日 HH:mm')
      this.FormatCard('ISO 格式', 'yyyy-MM-dd\'T\'HH:mm:ss')

      Blank().height(20)
    }.width('100%')
  }

  @Builder
  FormatCard(label: string, format: string) {
    Column() {
      Text(label).fontSize(12).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 4 })
      Text(`格式: ${format}`).fontSize(10).fontColor($r('app.color.text_hint')).width('100%').margin({ bottom: 8 })
      TextClock().format(format).fontSize(16).fontColor($r('app.color.primary_color')).fontWeight(FontWeight.Medium)
    }
    .width('100%').padding(16).borderRadius(12)
    .backgroundColor($r('app.color.card_background')).margin({ bottom: 12 })
    .shadow({ radius: 4, color: 'rgba(0,0,0,0.04)', offsetY: 1 })
  }
}
