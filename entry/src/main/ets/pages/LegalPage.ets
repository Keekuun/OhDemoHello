import { router } from '@kit.ArkUI';

/**
 * 法律条款页（隐私政策 / 用户服务协议）
 * 通过路由参数 type 区分展示内容：privacy=隐私政策，terms=用户服务协议。
 * 演示环境使用占位文案，正式发布前需替换为真实法务文本。
 */
@Entry
@Component
struct LegalPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State title: string = '';
  @State body: string = '';

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, string>;
    const type = params?.type ?? 'privacy';
    if (type === 'terms') {
      this.title = '用户服务协议';
      this.body = this.buildTerms();
    } else {
      this.title = '隐私政策';
      this.body = this.buildPrivacy();
    }
  }

  private buildPrivacy(): string {
    return '更新日期：2026 年 9 月\n\n' +
      '鸿蒙百宝箱（OhDemo）是一款鸿蒙系统功能演示应用。本隐私政策说明我们如何处理你的信息。\n\n' +
      '一、信息收集\n' +
      '本应用为演示性质，默认不主动收集、上传任何个人身份信息。仅在你主动使用以下功能时，系统会请求对应权限：\n' +
      '· 相机 / 麦克风：用于拍照、录像、录音演示；\n' +
      '· 位置信息：用于定位功能演示；\n' +
      '· 媒体文件：用于读写相册、文件演示。\n\n' +
      '二、信息使用\n' +
      '所有演示数据均保存在你的设备本地，不会上传至任何服务器。\n\n' +
      '三、信息共享\n' +
      '我们不会向任何第三方共享、出售你的个人信息。\n\n' +
      '四、权限管理\n' +
      '你可随时在系统“设置-应用管理”中关闭相关权限，关闭后对应演示功能将无法使用。\n\n' +
      '五、联系我们\n' +
      '如对本政策有任何疑问，可通过“意见反馈”页面与我们联系。\n\n' +
      '（本政策为演示占位文本，正式发布前请替换为经法务审核的正式版本。）';
  }

  private buildTerms(): string {
    return '生效日期：2026 年 9 月\n\n' +
      '欢迎使用鸿蒙百宝箱（OhDemo）。使用本应用即表示你同意以下条款。\n\n' +
      '一、服务说明\n' +
      '本应用为鸿蒙系统（HarmonyOS）开发学习与功能演示工具，所展示内容仅供学习交流。\n\n' +
      '二、使用规范\n' +
      '你承诺不利用本应用从事任何违法违规行为，不干扰应用正常运行。\n\n' +
      '三、知识产权\n' +
      '本应用及其界面、代码的知识产权归开发者所有，未经授权不得用于商业用途。\n\n' +
      '四、免责声明\n' +
      '本应用按“现状”提供，不对因使用本应用造成的任何直接或间接损失承担责任。\n\n' +
      '五、条款变更\n' +
      '我们可能适时更新本协议，更新后将在应用内公示。\n\n' +
      '（本协议为演示占位文本，正式发布前请替换为经法务审核的正式版本。）';
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

        Text(this.title)
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
        Text(this.body)
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))
          .lineHeight(24)
          .width('100%')
          .padding({ left: 20, right: 20, top: 20, bottom: 32 })
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      .backgroundColor($r('app.color.card_background'))
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.page_background'))
  }
}
