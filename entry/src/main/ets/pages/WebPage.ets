import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct WebPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State currentUrl: string = 'https://developer.huawei.com';
  @State inputUrl: string = 'https://developer.huawei.com';
  @State canGoBack: boolean = false;
  @State canGoForward: boolean = false;
  @State pageTitle: string = '';
  @State loading: boolean = false;
  private controller: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24).fontColor([$r('app.color.text_primary')])
          .onClick(() => { router.back(); })
        Text('WebView').fontSize(18).fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary')).layoutWeight(1).margin({ left: 12 })
      }
      .width('100%').height(56 + this.statusBarHeight)
      .padding({ left: 16, right: 16, top: this.statusBarHeight })
      .backgroundColor($r('app.color.card_background')).alignItems(VerticalAlign.Center)

      // URL 输入栏
      Row() {
        TextInput({ text: this.inputUrl, placeholder: '输入网址' })
          .layoutWeight(1).height(36).borderRadius(8)
          .border({ width: 1, color: $r('app.color.divider_color') })
          .onChange((v: string) => { this.inputUrl = v; })
        Button('前往').fontSize(13).type(ButtonType.Capsule).margin({ left: 8 })
          .backgroundColor($r('app.color.primary_color')).fontColor(Color.White)
          .onClick(() => {
            if (this.inputUrl.length > 0) {
              this.currentUrl = this.inputUrl;
            }
          })
      }
      .width('100%').padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor($r('app.color.card_background'))

      // 导航按钮
      Row() {
        Button('后退').fontSize(12).type(ButtonType.Capsule).layoutWeight(1)
          .backgroundColor(this.canGoBack ? $r('app.color.primary_light') : $r('app.color.page_background'))
          .fontColor(this.canGoBack ? $r('app.color.primary_color') : $r('app.color.text_hint'))
          .enabled(this.canGoBack)
          .onClick(() => { try { this.controller.backward(); } catch (e) {} })
        Button('前进').fontSize(12).type(ButtonType.Capsule).layoutWeight(1).margin({ left: 6 })
          .backgroundColor(this.canGoForward ? $r('app.color.primary_light') : $r('app.color.page_background'))
          .fontColor(this.canGoForward ? $r('app.color.primary_color') : $r('app.color.text_hint'))
          .enabled(this.canGoForward)
          .onClick(() => { try { this.controller.forward(); } catch (e) {} })
        Button('刷新').fontSize(12).type(ButtonType.Capsule).layoutWeight(1).margin({ left: 6 })
          .backgroundColor($r('app.color.primary_light')).fontColor($r('app.color.primary_color'))
          .onClick(() => { try { this.controller.refresh(); } catch (e) {} })
        Button('首页').fontSize(12).type(ButtonType.Capsule).layoutWeight(1).margin({ left: 6 })
          .backgroundColor($r('app.color.primary_light')).fontColor($r('app.color.primary_color'))
          .onClick(() => { this.currentUrl = 'https://developer.huawei.com'; })
      }
      .width('100%').padding({ left: 16, right: 16, bottom: 8 })
      .backgroundColor($r('app.color.card_background'))

      // 状态栏
      Row() {
        if (this.loading) {
          LoadingProgress().width(16).height(16).color($r('app.color.primary_color'))
        }
        Text(this.loading ? '加载中...' : (this.pageTitle || '就绪')).fontSize(11)
          .fontColor($r('app.color.text_secondary')).margin({ left: 4 }).layoutWeight(1)
        Text(this.currentUrl).fontSize(10).fontColor($r('app.color.text_hint')).maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis }).width('50%')
      }
      .width('100%').padding({ left: 16, right: 16, bottom: 8 })
      .backgroundColor($r('app.color.card_background'))

      // WebView
      Web({ src: this.currentUrl, controller: this.controller })
        .width('100%').layoutWeight(1)
        .javaScriptAccess(true)
        .domStorageAccess(true)
        .fileAccess(true)
        .imageAccess(true)
        .onPageBegin(() => { this.loading = true; })
        .onPageEnd(() => {
          this.loading = false;
          try {
            this.canGoBack = this.controller.accessBackward();
            this.canGoForward = this.controller.accessForward();
            this.pageTitle = this.controller.getTitle();
          } catch (e) {}
        })
        .onErrorReceive((error) => {
          this.loading = false;
          promptAction.showToast({ message: '加载失败' });
        })
    }
    .width('100%').height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}
