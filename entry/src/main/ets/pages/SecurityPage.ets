import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct SecurityPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State pattern: string = '';
  @State savedPattern: string = '';
  @State mode: number = 0; // 0=设置 1=验证
  @State statusText: string = '请绘制手势密码';
  @State statusColor: ResourceColor = $r('app.color.text_secondary');

  private showToast(msg: string): void {
    promptAction.showToast({ message: msg, duration: 1500 });
  }

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24).fontColor([$r('app.color.text_primary')])
          .onClick(() => { router.back(); })
        Text('手势密码').fontSize(18).fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary')).layoutWeight(1).margin({ left: 12 })
      }
      .width('100%').height(56 + this.statusBarHeight)
      .padding({ left: 16, right: 16, top: this.statusBarHeight })
      .backgroundColor($r('app.color.card_background')).alignItems(VerticalAlign.Center)

      Column() {
        Text('PatternLock — 手势密码').fontSize(14).fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary')).margin({ bottom: 8 })

        // 模式切换
        Row() {
          Text(this.mode === 0 ? '设置密码' : '验证密码').fontSize(13)
            .padding({ left: 14, right: 14, top: 6, bottom: 6 })
            .borderRadius(16)
            .backgroundColor($r('app.color.primary_color')).fontColor(Color.White)
          if (this.savedPattern.length > 0) {
            Text(this.mode === 0 ? '切换到验证' : '切换到设置').fontSize(12)
              .fontColor($r('app.color.primary_color')).margin({ left: 12 })
              .onClick(() => {
                this.mode = this.mode === 0 ? 1 : 0;
                this.statusText = this.mode === 0 ? '请绘制新手势密码' : '请绘制手势密码验证';
                this.statusColor = $r('app.color.text_secondary');
              })
          }
        }.margin({ bottom: 8 })

        Text(this.statusText).fontSize(13).fontColor(this.statusColor).margin({ bottom: 16 })

        // PatternLock
        PatternLock()
          .sideLength(240)
          .circleRadius(9)
          .pathStrokeWidth(5)
          .activeColor($r('app.color.primary_color'))
          .selectedColor($r('app.color.primary_color'))
          .pathColor($r('app.color.primary_color'))
          .regularColor($r('app.color.divider_color'))
          .onPatternComplete((input: Array<number>) => {
            this.pattern = input.join('');
            if (this.pattern.length < 4) {
              this.statusText = '至少连接 4 个点';
              this.statusColor = $r('app.color.danger_color');
              return;
            }

            if (this.mode === 0) {
              // 设置密码
              this.savedPattern = this.pattern;
              this.mode = 1;
              this.statusText = '密码已设置，请再次绘制验证';
              this.statusColor = $r('app.color.success_color');
              this.showToast('密码已设置');
            } else {
              // 验证密码
              if (this.pattern === this.savedPattern) {
                this.statusText = '✅ 验证成功！';
                this.statusColor = $r('app.color.success_color');
                this.showToast('验证成功');
              } else {
                this.statusText = '❌ 密码不正确，请重试';
                this.statusColor = $r('app.color.danger_color');
                this.showToast('验证失败');
              }
            }
          })

        Blank().layoutWeight(1)

        if (this.savedPattern.length > 0) {
          Text(`已存密码: ${this.savedPattern}`).fontSize(11).fontColor($r('app.color.text_hint')).margin({ bottom: 8 })
        }

        Button('重置密码').fontSize(13).type(ButtonType.Capsule).width(120)
          .backgroundColor($r('app.color.page_background')).fontColor($r('app.color.text_secondary'))
          .onClick(() => {
            this.savedPattern = '';
            this.mode = 0;
            this.pattern = '';
            this.statusText = '请绘制手势密码';
            this.statusColor = $r('app.color.text_secondary');
          })
          .margin({ bottom: 20 })
      }
      .width('100%').layoutWeight(1).padding(16).backgroundColor($r('app.color.page_background'))
    }
    .width('100%').height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}
