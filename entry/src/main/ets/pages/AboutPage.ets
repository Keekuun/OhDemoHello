import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

/**
 * 关于我们页
 * 展示应用 Logo、名称、版本号、版权信息，并提供检查更新、隐私政策、服务协议入口。
 */
@Entry
@Component
struct AboutPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State versionName: string = '1.0.0';
  @State buildVersion: string = '1000000';

  private showToast(msg: string): void {
    promptAction.showToast({ message: msg, duration: 2000 });
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24)
          .fontColor([$r('app.color.text_primary')])
          .onClick(() => {
            router.back();
          })

        Text($r('app.string.about_title'))
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .layoutWeight(1)
          .margin({ left: 12 })
      }
      .width('100%')
      .height(56 + this.statusBarHeight)
      .padding({ left: 16, right: 16, top: this.statusBarHeight })
      .backgroundColor($r('app.color.card_background'))

      Scroll() {
        Column() {
          // Logo + 名称 + 版本
          Column() {
            Image($r('app.media.startIcon'))
              .width(88)
              .height(88)
              .borderRadius(20)
              .shadow({ radius: 10, color: 'rgba(0,0,0,0.12)', offsetX: 0, offsetY: 4 })

            Text($r('app.string.app_title'))
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .margin({ top: 16 })

            Text($r('app.string.about_slogan'))
              .fontSize(13)
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 6 })

            Text(`${$r('app.string.about_version')} ${this.versionName} (${this.buildVersion})`)
              .fontSize(13)
              .fontColor($r('app.color.text_hint'))
              .margin({ top: 10 })
          }
          .width('100%')
          .padding({ top: 40, bottom: 32 })

          // 功能菜单
          Column() {
            this.AboutMenuItem($r('sys.symbol.arrow_up_circle'), $r('app.string.about_check_update'), () => {
              this.showToast($r('app.string.about_update_latest').value.toString());
            })
            Divider().color($r('app.color.divider_color')).margin({ left: 52 })
            this.AboutMenuItem($r('sys.symbol.shield_checkered'), $r('app.string.about_privacy'), () => {
              router.pushUrl({ url: 'pages/LegalPage', params: { type: 'privacy' } });
            })
            Divider().color($r('app.color.divider_color')).margin({ left: 52 })
            this.AboutMenuItem($r('sys.symbol.doc_text'), $r('app.string.about_terms'), () => {
              router.pushUrl({ url: 'pages/LegalPage', params: { type: 'terms' } });
            })
            Divider().color($r('app.color.divider_color')).margin({ left: 52 })
            this.AboutMenuItem($r('sys.symbol.bubble_left'), $r('app.string.about_feedback'), () => {
              router.pushUrl({ url: 'pages/FeedbackPage' });
            })
          }
          .width('100%')
          .borderRadius(16)
          .backgroundColor($r('app.color.card_background'))
          .shadow({ radius: 6, color: 'rgba(0,0,0,0.06)', offsetX: 0, offsetY: 2 })

          // 版权信息
          Text($r('app.string.about_copyright'))
            .fontSize(12)
            .fontColor($r('app.color.text_hint'))
            .margin({ top: 40, bottom: 24 })
            .textAlign(TextAlign.Center)
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      .backgroundColor($r('app.color.page_background'))
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.page_background'))
  }

  @Builder
  AboutMenuItem(icon: Resource, name: ResourceStr, onTap: () => void) {
    Row() {
      SymbolGlyph(icon)
        .fontSize(22)
        .fontColor([$r('app.color.primary_color')])

      Text(name)
        .fontSize(16)
        .fontColor($r('app.color.text_primary'))
        .margin({ left: 14 })
        .layoutWeight(1)

      SymbolGlyph($r('sys.symbol.chevron_right'))
        .fontSize(16)
        .fontColor([$r('app.color.text_hint')])
    }
    .width('100%')
    .padding({ left: 16, top: 15, right: 16, bottom: 15 })
    .alignItems(VerticalAlign.Center)
    .onClick(onTap)
  }
}
