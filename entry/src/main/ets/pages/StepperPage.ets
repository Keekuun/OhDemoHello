import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct StepperPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State currentStep: number = 0;
  @State account: string = '';
  @State password: string = '';
  @State nickname: string = '';
  @State gender: string = '男';
  @State agreeTerms: boolean = false;

  private showToast(msg: string): void {
    promptAction.showToast({ message: msg, duration: 1500 });
  }

  private validateStep(index: number): boolean {
    if (index === 0) {
      if (this.account.length < 3) { this.showToast('账号至少 3 个字符'); return false; }
      if (this.password.length < 6) { this.showToast('密码至少 6 位'); return false; }
    } else if (index === 1) {
      if (this.nickname.length === 0) { this.showToast('请输入昵称'); return false; }
    } else if (index === 2) {
      if (!this.agreeTerms) { this.showToast('请同意用户协议'); return false; }
    }
    return true;
  }

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24).fontColor([$r('app.color.text_primary')])
          .onClick(() => { router.back(); })
        Text('步骤向导').fontSize(18).fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary')).layoutWeight(1).margin({ left: 12 })
      }
      .width('100%').height(56 + this.statusBarHeight)
      .padding({ left: 16, right: 16, top: this.statusBarHeight })
      .backgroundColor($r('app.color.card_background')).alignItems(VerticalAlign.Center)

      Stepper({
        index: this.currentStep,
      }) {
        // Step 1: 账号密码
        StepperItem() {
          Column() {
            Text('创建账号').fontSize(18).fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary')).width('100%').margin({ bottom: 20 })

            Text('账号').fontSize(13).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 6 })
            TextInput({ placeholder: '请输入账号', text: this.account })
              .width('100%').height(44).borderRadius(8)
              .border({ width: 1, color: $r('app.color.divider_color') })
              .onChange((v: string) => { this.account = v; })
              .margin({ bottom: 16 })

            Text('密码').fontSize(13).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 6 })
            TextInput({ placeholder: '请输入密码', text: this.password })
              .width('100%').height(44).borderRadius(8).type(InputType.Password)
              .border({ width: 1, color: $r('app.color.divider_color') })
              .onChange((v: string) => { this.password = v; })

            Blank().layoutWeight(1)
            Text('步骤 1/3 — 账号信息').fontSize(12).fontColor($r('app.color.text_hint'))
          }
          .width('100%').height('100%').padding(20)
        }
        .nextLabel('下一步')

        // Step 2: 个人信息
        StepperItem() {
          Column() {
            Text('完善信息').fontSize(18).fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary')).width('100%').margin({ bottom: 20 })

            Text('昵称').fontSize(13).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 6 })
            TextInput({ placeholder: '请输入昵称', text: this.nickname })
              .width('100%').height(44).borderRadius(8)
              .border({ width: 1, color: $r('app.color.divider_color') })
              .onChange((v: string) => { this.nickname = v; })
              .margin({ bottom: 16 })

            Text('性别').fontSize(13).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 6 })
            Row() {
              ForEach(['男', '女'], (g: string) => {
                Row() {
                  Radio({ value: g, group: 'gender' }).checked(this.gender === g)
                  Text(g).fontSize(14).fontColor($r('app.color.text_primary')).margin({ left: 4 })
                }.margin({ right: 20 })
                .onClick(() => { this.gender = g; })
              }, (g: string) => g)
            }.width('100%')

            Blank().layoutWeight(1)
            Text('步骤 2/3 — 个人信息').fontSize(12).fontColor($r('app.color.text_hint'))
          }
          .width('100%').height('100%').padding(20)
        }
        .nextLabel('下一步')
        .prevLabel('上一步')

        // Step 3: 确认
        StepperItem() {
          Column() {
            Text('确认信息').fontSize(18).fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary')).width('100%').margin({ bottom: 20 })

            Column() {
              this.InfoRow('账号', this.account)
              this.InfoRow('昵称', this.nickname)
              this.InfoRow('性别', this.gender)
            }
            .width('100%').borderRadius(12).backgroundColor($r('app.color.page_background')).padding(12)

            Row() {
              Checkbox({ name: 'terms', group: 'termsGroup' }).select(this.agreeTerms)
                .onChange((v: boolean) => { this.agreeTerms = v; })
                .selectedColor($r('app.color.primary_color'))
              Text('我已阅读并同意《用户协议》').fontSize(13).fontColor($r('app.color.text_secondary')).margin({ left: 8 })
            }.width('100%').margin({ top: 16 })

            Blank().layoutWeight(1)
            Text('步骤 3/3 — 确认并完成').fontSize(12).fontColor($r('app.color.text_hint'))
          }
          .width('100%').height('100%').padding(20)
        }
        .nextLabel('完成')
        .prevLabel('上一步')
      }
      .onNext((index: number, pendingIndex: number) => {
        if (this.validateStep(index)) {
          if (index === 2) {
            this.showToast('注册成功！');
            setTimeout(() => { router.back(); }, 1500);
          } else {
            this.currentStep = index + 1;
          }
        }
      })
      .onPrevious((index: number, pendingIndex: number) => {
        this.currentStep = index - 1;
      })
      .onFinish(() => { this.showToast('完成！'); })
      .layoutWeight(1)
    }
    .width('100%').height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }

  @Builder
  InfoRow(label: string, value: string) {
    Row() {
      Text(label).fontSize(13).fontColor($r('app.color.text_secondary')).width(60)
      Text(value).fontSize(14).fontColor($r('app.color.text_primary')).layoutWeight(1)
    }.width('100%').height(36)
  }
}
