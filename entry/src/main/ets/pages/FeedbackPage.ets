import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

/**
 * 意见反馈页
 * 提供反馈内容输入、联系方式（选填）与提交功能。
 */
@Entry
@Component
struct FeedbackPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State content: string = '';
  @State contact: string = '';

  private showToast(msg: string): void {
    promptAction.showToast({ message: msg, duration: 2000 });
  }

  private submitFeedback(): void {
    if (this.content.trim().length === 0) {
      this.showToast($r('app.string.feedback_empty').value.toString());
      return;
    }
    // 演示环境：本地模拟提交，实际项目应调用后端接口
    this.showToast($r('app.string.feedback_success').value.toString());
    this.content = '';
    this.contact = '';
    setTimeout(() => {
      router.back();
    }, 800);
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

        Text($r('app.string.feedback_title'))
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

      Column() {
        // 反馈内容输入
        TextArea({ placeholder: $r('app.string.feedback_hint'), text: this.content })
          .width('100%')
          .height(180)
          .fontSize(15)
          .fontColor($r('app.color.text_primary'))
          .placeholderColor($r('app.color.text_hint'))
          .backgroundColor($r('app.color.card_background'))
          .borderRadius(12)
          .padding(14)
          .margin({ top: 16 })
          .onChange((value: string) => {
            this.content = value;
          })

        // 联系方式（选填）
        TextInput({ placeholder: $r('app.string.feedback_contact'), text: this.contact })
          .width('100%')
          .height(48)
          .fontSize(15)
          .fontColor($r('app.color.text_primary'))
          .placeholderColor($r('app.color.text_hint'))
          .backgroundColor($r('app.color.card_background'))
          .borderRadius(12)
          .padding({ left: 14, right: 14 })
          .margin({ top: 14 })
          .onChange((value: string) => {
            this.contact = value;
          })

        // 提交按钮
        Button($r('app.string.feedback_submit'))
          .type(ButtonType.Capsule)
          .fontSize(16)
          .width('100%')
          .height(48)
          .backgroundColor($r('app.color.primary_color'))
          .fontColor(Color.White)
          .margin({ top: 28 })
          .onClick(() => {
            this.submitFeedback();
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.page_background'))
  }
}
