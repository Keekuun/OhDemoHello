import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

@Component
struct FormItem {
  @Prop label: string;
  @BuilderParam content: () => void;
  build() {
    Column() {
      Text(this.label).fontSize(14).fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.text_primary')).width('100%').margin({ bottom: 8 })
      this.content()
    }
    .width('100%').margin({ top: 16 })
  }
}

@Entry
@Component
struct FormPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State username: string = '';
  @State phone: string = '';
  @State email: string = '';
  @State password: string = '';
  @State showPassword: boolean = false;
  @State gender: number = 0;
  @State cityIndex: number = 0;
  @State bio: string = '';
  @State agree: boolean = false;
  @State interests: boolean[] = [false, false, false, false];
  @State usernameError: string = '';
  @State phoneError: string = '';
  @State emailError: string = '';
  @State passwordError: string = '';

  private showToast(msg: string): void {
    promptAction.showToast({ message: msg, duration: 2000 });
  }

  private validateUsername(): boolean {
    if (this.username.length === 0) { this.usernameError = '请输入用户名'; return false; }
    if (this.username.length < 3) { this.usernameError = '用户名至少3个字符'; return false; }
    this.usernameError = '';
    return true;
  }

  private validatePhone(): boolean {
    if (this.phone.length === 0) { this.phoneError = '请输入手机号'; return false; }
    if (!/^1[3-9]\d{9}$/.test(this.phone)) { this.phoneError = '手机号格式不正确'; return false; }
    this.phoneError = '';
    return true;
  }

  private validateEmail(): boolean {
    if (this.email.length === 0) { this.emailError = '请输入邮箱'; return false; }
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(this.email)) { this.emailError = '邮箱格式不正确'; return false; }
    this.emailError = '';
    return true;
  }

  private validatePassword(): boolean {
    if (this.password.length === 0) { this.passwordError = '请输入密码'; return false; }
    if (this.password.length < 6) { this.passwordError = '密码至少6位'; return false; }
    this.passwordError = '';
    return true;
  }

  private handleSubmit(): void {
    const valid = this.validateUsername() && this.validatePhone() &&
      this.validateEmail() && this.validatePassword();
    if (!valid) { this.showToast('请完善表单信息'); return; }
    if (!this.agree) { this.showToast('请同意用户协议'); return; }
    this.showToast('提交成功！');
    setTimeout(() => { router.back(); }, 1500);
  }

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24).fontColor([$r('app.color.text_primary')])
          .onClick(() => { router.back(); })
        Text('注册表单').fontSize(18).fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary')).layoutWeight(1).margin({ left: 12 })
      }
      .width('100%').height(56 + this.statusBarHeight)
      .padding({ left: 16, right: 16, top: this.statusBarHeight })
      .backgroundColor($r('app.color.card_background')).alignItems(VerticalAlign.Center)

      Scroll() {
        Column() {
          Column() {
            Column() {
              Text('📷').fontSize(40)
              Text('点击上传').fontSize(12).fontColor($r('app.color.text_hint')).margin({ top: 4 })
            }
            .width(80).height(80).borderRadius(40)
            .backgroundColor($r('app.color.primary_light'))
            .justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)
            .border({ width: 2, color: $r('app.color.divider_color') })
            .onClick(() => { this.showToast('选择头像'); })
          }.width('100%').margin({ top: 24 }).alignItems(HorizontalAlign.Center)

          FormItem({ label: '用户名' }) {
            TextInput({ placeholder: '请输入用户名', text: this.username })
              .width('100%').height(44).borderRadius(8)
              .border({ width: 1, color: this.usernameError ? $r('app.color.danger_color') : $r('app.color.divider_color') })
              .onChange((value: string) => { this.username = value; this.usernameError = ''; })
              .onBlur(() => { this.validateUsername(); })
            if (this.usernameError) {
              Text(this.usernameError).fontSize(12).fontColor($r('app.color.danger_color')).width('100%').margin({ top: 4 })
            }
          }

          FormItem({ label: '手机号' }) {
            TextInput({ placeholder: '请输入手机号', text: this.phone })
              .width('100%').height(44).borderRadius(8).type(InputType.PhoneNumber)
              .border({ width: 1, color: this.phoneError ? $r('app.color.danger_color') : $r('app.color.divider_color') })
              .onChange((value: string) => { this.phone = value; this.phoneError = ''; })
              .onBlur(() => { this.validatePhone(); })
            if (this.phoneError) {
              Text(this.phoneError).fontSize(12).fontColor($r('app.color.danger_color')).width('100%').margin({ top: 4 })
            }
          }

          FormItem({ label: '邮箱' }) {
            TextInput({ placeholder: '请输入邮箱', text: this.email })
              .width('100%').height(44).borderRadius(8).type(InputType.Email)
              .border({ width: 1, color: this.emailError ? $r('app.color.danger_color') : $r('app.color.divider_color') })
              .onChange((value: string) => { this.email = value; this.emailError = ''; })
              .onBlur(() => { this.validateEmail(); })
            if (this.emailError) {
              Text(this.emailError).fontSize(12).fontColor($r('app.color.danger_color')).width('100%').margin({ top: 4 })
            }
          }

          FormItem({ label: '密码' }) {
            Row() {
              TextInput({ placeholder: '请输入密码', text: this.password })
                .layoutWeight(1).height(44).borderRadius(8)
                .type(this.showPassword ? InputType.Normal : InputType.Password)
                .border({ width: 1, color: this.passwordError ? $r('app.color.danger_color') : $r('app.color.divider_color') })
                .onChange((value: string) => { this.password = value; this.passwordError = ''; })
              Text(this.showPassword ? '🙈' : '👁').fontSize(20).margin({ left: 8 })
                .onClick(() => { this.showPassword = !this.showPassword; })
            }.width('100%')
            if (this.passwordError) {
              Text(this.passwordError).fontSize(12).fontColor($r('app.color.danger_color')).width('100%').margin({ top: 4 })
            }
          }

          FormItem({ label: '性别' }) {
            Row() {
              ForEach(['男', '女'], (item: string, index: number) => {
                Row() {
                  Radio({ value: `g${index}`, group: 'genderGroup' })
                    .checked(this.gender === index)
                    .onChange((isChecked: boolean) => { if (isChecked) this.gender = index; })
                  Text(item).fontSize(14).fontColor($r('app.color.text_primary')).margin({ left: 6 })
                }.margin({ right: 24 })
              }, (item: string, index: number) => `gender_${index}`)
            }.width('100%')
          }

          FormItem({ label: '所在城市' }) {
            Select([
              { value: '北京' }, { value: '上海' }, { value: '广州' },
              { value: '深圳' }, { value: '杭州' }, { value: '成都' },
            ])
              .selected(this.cityIndex).value('请选择城市')
              .font({ size: 14 }).width('100%').height(44)
              .onSelect((index: number) => { this.cityIndex = index; })
          }

          FormItem({ label: '兴趣爱好' }) {
            Flex({ wrap: FlexWrap.Wrap }) {
              ForEach(['阅读', '运动', '音乐', '旅行'], (item: string, index: number) => {
                Row() {
                  Checkbox({ name: `interest${index}`, group: 'interestGroup' })
                    .select(this.interests[index])
                    .onChange((value: boolean) => { this.interests[index] = value; })
                  Text(item).fontSize(14).fontColor($r('app.color.text_primary')).margin({ left: 6 })
                }.margin({ right: 16, bottom: 8 })
              }, (item: string, index: number) => `interest_${index}`)
            }.width('100%')
          }

          FormItem({ label: '个人简介' }) {
            TextArea({ placeholder: '请输入个人简介...', text: this.bio })
              .width('100%').height(80).borderRadius(8)
              .border({ width: 1, color: $r('app.color.divider_color') })
              .onChange((value: string) => { this.bio = value; })
            Text(`${this.bio.length}/200`).fontSize(12).fontColor($r('app.color.text_hint')).width('100%').textAlign(TextAlign.RIGHT).margin({ top: 4 })
          }

          Row() {
            Checkbox({ name: 'agree', group: 'agreeGroup' })
              .select(this.agree)
              .onChange((value: boolean) => { this.agree = value; })
            Text() {
              Span('我已阅读并同意').fontSize(13).fontColor($r('app.color.text_secondary'))
              Span('《用户协议》').fontSize(13).fontColor($r('app.color.primary_color'))
              Span('和').fontSize(13).fontColor($r('app.color.text_secondary'))
              Span('《隐私政策》').fontSize(13).fontColor($r('app.color.primary_color'))
            }.margin({ left: 8 })
          }.width('100%').margin({ top: 16 })

          Row() {
            Button('重置').type(ButtonType.Capsule).fontSize(15).height(44)
              .layoutWeight(1).margin({ right: 8 })
              .backgroundColor($r('app.color.page_background')).fontColor($r('app.color.text_secondary'))
              .onClick(() => {
                this.username = ''; this.phone = ''; this.email = ''; this.password = '';
                this.bio = ''; this.agree = false; this.interests = [false, false, false, false];
                this.usernameError = ''; this.phoneError = ''; this.emailError = ''; this.passwordError = '';
              })
            Button('注册').type(ButtonType.Capsule).fontSize(15).height(44)
              .layoutWeight(1).backgroundColor($r('app.color.primary_color'))
              .onClick(() => { this.handleSubmit(); })
          }.width('100%').margin({ top: 24 })

          Blank().height(20)
        }
        .width('100%').padding({ left: 16, right: 16 })
      }
      .scrollBar(BarState.Off).edgeEffect(EdgeEffect.Spring)
      .layoutWeight(1).backgroundColor($r('app.color.page_background'))
    }
    .width('100%').height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}
