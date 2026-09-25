import { router } from '@kit.ArkUI';
import { i18n } from '@kit.LocalizationKit';
import { intl } from '@kit.LocalizationKit';

@Entry
@Component
struct I18nPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State currentLocale: string = 'zh-CN';
  @State formattedDate: string = '';
  @State formattedNumber: string = '';
  @State formattedCurrency: string = '';
  @State formattedPercent: string = '';
  @State systemInfo: string = '';

  aboutToAppear(): void {
    this.updateFormats();
  }

  private updateFormats(): void {
    try {
      // 日期格式化
      const dateFmt = new intl.DateTimeFormat(this.currentLocale, {
        year: 'numeric', month: 'long', day: 'numeric',
        weekday: 'long', hour: '2-digit', minute: '2-digit',
      });
      this.formattedDate = dateFmt.format(new Date());

      // 数字格式化
      const numFmt = new intl.NumberFormat(this.currentLocale, {});
      this.formattedNumber = numFmt.format(1234567.89);

      // 货币格式化
      const curFmt = new intl.NumberFormat(this.currentLocale, { style: 'currency', currency: 'CNY' });
      this.formattedCurrency = curFmt.format(9999.99);

      // 百分比格式化
      const pctFmt = new intl.NumberFormat(this.currentLocale, { style: 'percent' });
      this.formattedPercent = pctFmt.format(0.856);

      // 系统信息
      const sysLocale = i18n.System.getSystemLocale();
      const sysLanguage = i18n.System.getSystemLanguage();
      const sysRegion = i18n.System.getSystemRegion();
      const is24Hour = i18n.System.is24HourClock();
      this.systemInfo = `语言: ${sysLanguage}\n地区: ${sysRegion}\nLocale: ${sysLocale}\n24小时制: ${is24Hour}`;
    } catch (e) {
      this.formattedDate = '格式化失败';
    }
  }

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24).fontColor([$r('app.color.text_primary')])
          .onClick(() => { router.back(); })
        Text('国际化 i18n').fontSize(18).fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary')).layoutWeight(1).margin({ left: 12 })
      }
      .width('100%').height(56 + this.statusBarHeight)
      .padding({ left: 16, right: 16, top: this.statusBarHeight })
      .backgroundColor($r('app.color.card_background')).alignItems(VerticalAlign.Center)

      Scroll() {
        Column() {
          // Locale 切换
          Column() {
            Text('Locale 切换').fontSize(14).fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary')).width('100%').margin({ bottom: 12 })
            Row() {
              ForEach(['zh-CN', 'en-US', 'ja-JP', 'ko-KR'], (locale: string) => {
                Text(locale).fontSize(12).padding({ left: 10, right: 10, top: 5, bottom: 5 })
                  .borderRadius(14)
                  .backgroundColor(this.currentLocale === locale ? $r('app.color.primary_color') : $r('app.color.page_background'))
                  .fontColor(this.currentLocale === locale ? Color.White : $r('app.color.text_secondary'))
                  .margin({ right: 6 })
                  .onClick(() => { this.currentLocale = locale; this.updateFormats(); })
              }, (locale: string) => locale)
            }.width('100%')
          }
          .width('100%').padding(16).borderRadius(12).backgroundColor($r('app.color.card_background')).margin({ bottom: 12 })

          // 日期格式化
          this.FormatCard('日期格式化', this.formattedDate, `DateTimeFormat(${this.currentLocale})`)

          // 数字格式化
          this.FormatCard('数字格式化 (1,234,567.89)', this.formattedNumber, `NumberFormat(${this.currentLocale})`)

          // 货币格式化
          this.FormatCard('货币格式化 (9999.99)', this.formattedCurrency, `NumberFormat currency: CNY`)

          // 百分比格式化
          this.FormatCard('百分比格式化 (85.6%)', this.formattedPercent, `NumberFormat style: percent`)

          // 系统信息
          Column() {
            Text('系统 i18n 信息').fontSize(14).fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary')).width('100%').margin({ bottom: 12 })
            Text(this.systemInfo).fontSize(12).fontColor($r('app.color.text_secondary')).width('100%')
          }
          .width('100%').padding(16).borderRadius(12).backgroundColor($r('app.color.card_background')).margin({ bottom: 12 })

          // API 说明
          Column() {
            Text('i18n API 说明').fontSize(14).fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary')).width('100%').margin({ bottom: 8 })
            this.ApiRow('i18n.System.getSystemLanguage()', '获取系统语言')
            this.ApiRow('i18n.System.getSystemRegion()', '获取系统地区')
            this.ApiRow('i18n.System.getSystemLocale()', '获取系统 Locale')
            this.ApiRow('i18n.System.is24HourClock()', '是否 24 小时制')
            this.ApiRow('intl.DateTimeFormat', '日期时间格式化')
            this.ApiRow('intl.NumberFormat', '数字/货币/百分比格式化')
          }
          .width('100%').padding(16).borderRadius(12).backgroundColor($r('app.color.card_background')).margin({ bottom: 20 })
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
  FormatCard(title: string, value: string, api: string) {
    Column() {
      Text(title).fontSize(13).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 4 })
      Text(api).fontSize(10).fontColor($r('app.color.text_hint')).width('100%').margin({ bottom: 8 })
      Text(value).fontSize(16).fontColor($r('app.color.primary_color')).fontWeight(FontWeight.Medium).width('100%')
    }
    .width('100%').padding(16).borderRadius(12).backgroundColor($r('app.color.card_background')).margin({ bottom: 12 })
    .shadow({ radius: 4, color: 'rgba(0,0,0,0.04)', offsetY: 1 })
  }

  @Builder
  ApiRow(api: string, desc: string) {
    Row() {
      Text(api).fontSize(11).fontColor($r('app.color.primary_color')).layoutWeight(1)
      Text(desc).fontSize(11).fontColor($r('app.color.text_secondary')).width(140)
    }.width('100%').height(28)
  }
}
