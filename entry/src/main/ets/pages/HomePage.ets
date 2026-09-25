import { promptAction } from '@kit.ArkUI';
import { router } from '@kit.ArkUI';

// 特性列表项数据模型
class FeatureItem {
  icon: Resource;
  title: string;
  desc: string;
  color: ResourceColor;

  constructor(icon: Resource, title: string, desc: string, color: ResourceColor) {
    this.icon = icon;
    this.title = title;
    this.desc = desc;
    this.color = color;
  }
}

// 问候语数组
const GREETINGS: string[] = [
  'Hello World',
  '你好，HarmonyOS',
  '欢迎来到方舟世界',
  'ArkTS 让开发更简单',
  '一次开发，多端部署',
];

@Component
export struct HomePage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State currentGreetingIndex: number = 0;
  @State counter: number = 0;
  @State progressValue: number = 0;
  @State isProgressing: boolean = false;
  @State notificationEnabled: boolean = true;
  @State autoplayEnabled: boolean = false;
  @State darkModeEnabled: boolean = false;
  private progressTimerId: number = -1;

  @State featureList: FeatureItem[] = [
    new FeatureItem($r('sys.symbol.heart_fill'), '原生体验', 'ArkTS 带来极致原生性能',
      $r('app.color.danger_color')),
    new FeatureItem($r('sys.symbol.bolt_fill'), '高效开发', '声明式 UI，快速构建界面',
      $r('app.color.warning_color')),
    new FeatureItem($r('sys.symbol.ohos_wifi'), '多端部署', '一次开发，多端运行',
      $r('app.color.success_color')),
    new FeatureItem($r('sys.symbol.checkmark_circle'), '安全可靠', '端侧隐私，安全无忧',
      $r('app.color.primary_color')),
    new FeatureItem($r('sys.symbol.ohos_folder_badge_plus'), '智能互联', '分布式能力，万物互联',
      $r('app.color.primary_color')),
  ];

  private showToast(msg: string): void {
    promptAction.showToast({ message: msg, duration: 2000 });
  }

  private switchGreeting(): void {
    this.currentGreetingIndex = (this.currentGreetingIndex + 1) % GREETINGS.length;
  }

  private startProgress(): void {
    if (this.isProgressing) {
      return;
    }
    this.isProgressing = true;
    this.progressValue = 0;
    this.progressTimerId = setInterval(() => {
      if (this.progressValue >= 100) {
        clearInterval(this.progressTimerId);
        this.isProgressing = false;
        this.showToast('加载完成！');
      } else {
        this.progressValue += 2;
      }
    }, 50);
  }

  private resetProgress(): void {
    clearInterval(this.progressTimerId);
    this.isProgressing = false;
    this.progressValue = 0;
  }

  aboutToDisappear(): void {
    clearInterval(this.progressTimerId);
  }

  build() {
    Column() {
      // 固定顶部导航栏
      this.HeaderSection()

      // 可滚动内容区
      Scroll() {
        Column() {
          this.WelcomeCard()
          this.CounterSection()
          this.FeatureListSection()
          this.ProgressSection()
          this.SettingsSection()
          this.BottomActions()
          Blank().height(20)
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
      }
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .layoutWeight(1)
      .backgroundColor($r('app.color.page_background'))
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.page_background'))
  }

  @Builder
  HeaderSection() {
    Row() {
      Column() {
        Text($r('app.string.app_title'))
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .maxLines(1)

        Text($r('app.string.app_subtitle'))
          .fontSize(13)
          .fontColor($r('app.color.text_secondary'))
          .margin({ top: 4 })
          .maxLines(1)
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Row() {
        Text('H')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
      }
      .width(44)
      .height(44)
      .borderRadius(22)
      .backgroundColor($r('app.color.primary_color'))
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        this.showToast('点击了头像');
      })
    }
    .width('100%')
    .height(60 + this.statusBarHeight)
    .padding({ left: 16, right: 16, top: this.statusBarHeight })
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .backgroundColor($r('app.color.card_background'))
  }

  @Builder
  WelcomeCard() {
    Column() {
      Text(GREETINGS[this.currentGreetingIndex])
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Text($r('app.string.welcome_desc'))
        .fontSize(14)
        .fontColor('rgba(255,255,255,0.85)')
        .margin({ top: 12 })
        .maxLines(2)

      Row() {
        Text('ArkTS')
          .fontSize(12)
          .fontColor(Color.White)
          .padding({ left: 10, top: 4, right: 10, bottom: 4 })
          .border({ width: 1, color: 'rgba(255,255,255,0.5)', radius: 10 })

        Text('ArkUI')
          .fontSize(12)
          .fontColor(Color.White)
          .padding({ left: 10, top: 4, right: 10, bottom: 4 })
          .border({ width: 1, color: 'rgba(255,255,255,0.5)', radius: 10 })
          .margin({ left: 8 })

        Text('Stage 模型')
          .fontSize(12)
          .fontColor(Color.White)
          .padding({ left: 10, top: 4, right: 10, bottom: 4 })
          .border({ width: 1, color: 'rgba(255,255,255,0.5)', radius: 10 })
          .margin({ left: 8 })
      }
      .margin({ top: 20 })
    }
    .width('100%')
    .padding(24)
    .borderRadius(20)
    .linearGradient({
      angle: 135,
      colors: [[$r('app.color.gradient_start'), 0], [$r('app.color.gradient_end'), 1]]
    })
    .shadow({ radius: 12, color: 'rgba(0,125,255,0.3)', offsetX: 0, offsetY: 4 })
    .margin({ top: 16 })
    .alignItems(HorizontalAlign.Start)
    .onClick(() => {
      this.switchGreeting();
    })
  }

  @Builder
  CounterSection() {
    Column() {
      this.SectionTitle($r('app.string.counter_title'))

      Row() {
        Button() {
          Text('-')
            .fontSize(28)
            .fontColor($r('app.color.primary_color'))
        }
        .width(52)
        .height(52)
        .borderRadius(26)
        .backgroundColor($r('app.color.primary_light'))
        .onClick(() => {
          this.counter--;
        })

        Text(this.counter.toString())
          .fontSize(36)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Button() {
          Text('+')
            .fontSize(28)
            .fontColor(Color.White)
        }
        .width(52)
        .height(52)
        .borderRadius(26)
        .backgroundColor($r('app.color.primary_color'))
        .onClick(() => {
          this.counter++;
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .margin({ top: 16 })
    }
    .width('100%')
    .padding(20)
    .borderRadius(16)
    .backgroundColor($r('app.color.card_background'))
    .margin({ top: 16 })
    .shadow({ radius: 6, color: 'rgba(0,0,0,0.06)', offsetX: 0, offsetY: 2 })
  }

  @Builder
  FeatureListSection() {
    Column() {
      this.SectionTitle($r('app.string.features_title'))

      ForEach(this.featureList, (item: FeatureItem, index: number) => {
        Row() {
          Row() {
            SymbolGlyph(item.icon)
              .fontSize(24)
              .fontColor([item.color])
          }
          .width(48)
          .height(48)
          .borderRadius(12)
          .backgroundColor($r('app.color.primary_light'))
          .justifyContent(FlexAlign.Center)

          Column() {
            Text(item.title)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.text_primary'))

            Text(item.desc)
              .fontSize(13)
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 4 })
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
          .margin({ left: 12 })

          SymbolGlyph($r('sys.symbol.chevron_right'))
            .fontSize(16)
            .fontColor([$r('app.color.text_hint')])
        }
        .width('100%')
        .padding({ left: 16, top: 12, right: 16, bottom: 12 })
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
        .onClick(() => {
          router.pushUrl({ url: 'pages/DetailPage', params: { title: item.title, desc: item.desc } });
        })

        if (index < this.featureList.length - 1) {
          Divider()
            .color($r('app.color.divider_color'))
            .margin({ left: 16 })
        }
      }, (item: FeatureItem, index: number) => `${index}_${item.title}`)
    }
    .width('100%')
    .padding(20)
    .borderRadius(16)
    .backgroundColor($r('app.color.card_background'))
    .margin({ top: 16 })
    .shadow({ radius: 6, color: 'rgba(0,0,0,0.06)', offsetX: 0, offsetY: 2 })
  }

  @Builder
  ProgressSection() {
    Column() {
      this.SectionTitle($r('app.string.progress_title'))

      Progress({ value: this.progressValue, total: 100, type: ProgressType.Linear })
        .width('100%')
        .color($r('app.color.primary_color'))
        .backgroundColor($r('app.color.divider_color'))
        .margin({ top: 16 })

      Text(`${this.progressValue}%`)
        .fontSize(14)
        .fontColor($r('app.color.text_secondary'))
        .margin({ top: 8 })

      Row() {
        Button($r('app.string.btn_start'))
          .type(ButtonType.Capsule)
          .fontSize(14)
          .layoutWeight(1)
          .enabled(!this.isProgressing)
          .backgroundColor($r('app.color.primary_color'))
          .onClick(() => {
            this.startProgress();
          })

        Blank().width(12)

        Button($r('app.string.btn_reset'))
          .type(ButtonType.Capsule)
          .fontSize(14)
          .layoutWeight(1)
          .backgroundColor($r('app.color.primary_light'))
          .fontColor($r('app.color.primary_color'))
          .onClick(() => {
            this.resetProgress();
          })
      }
      .width('100%')
      .margin({ top: 16 })
    }
    .width('100%')
    .padding(20)
    .borderRadius(16)
    .backgroundColor($r('app.color.card_background'))
    .margin({ top: 16 })
    .shadow({ radius: 6, color: 'rgba(0,0,0,0.06)', offsetX: 0, offsetY: 2 })
  }

  @Builder
  SettingsSection() {
    Column() {
      this.SectionTitle($r('app.string.settings_title'))

      this.SettingItem($r('sys.symbol.bell_fill'), $r('app.string.setting_notification'),
        this.notificationEnabled, (isOn: boolean) => {
          this.notificationEnabled = isOn;
          this.showToast(isOn ? '已开启消息通知' : '已关闭消息通知');
        })

      Divider().color($r('app.color.divider_color')).margin({ left: 16 })

      this.SettingItem($r('sys.symbol.play_fill'), $r('app.string.setting_autoplay'),
        this.autoplayEnabled, (isOn: boolean) => {
          this.autoplayEnabled = isOn;
        })

      Divider().color($r('app.color.divider_color')).margin({ left: 16 })

      this.SettingItem($r('sys.symbol.moon_fill'), $r('app.string.setting_darkmode'),
        this.darkModeEnabled, (isOn: boolean) => {
          this.darkModeEnabled = isOn;
          this.showToast(isOn ? '深色模式已开启' : '深色模式已关闭');
        })
    }
    .width('100%')
    .padding(20)
    .borderRadius(16)
    .backgroundColor($r('app.color.card_background'))
    .margin({ top: 16 })
    .shadow({ radius: 6, color: 'rgba(0,0,0,0.06)', offsetX: 0, offsetY: 2 })
  }

  @Builder
  BottomActions() {
    Row() {
      Button('了解更多')
        .type(ButtonType.Capsule)
        .fontSize(16)
        .layoutWeight(1)
        .height(48)
        .backgroundColor($r('app.color.primary_light'))
        .fontColor($r('app.color.primary_color'))
        .onClick(() => {
          this.showToast('了解更多功能即将上线');
        })

      Blank().width(12)

      Button($r('app.string.btn_confirm'))
        .type(ButtonType.Capsule)
        .fontSize(16)
        .layoutWeight(1)
        .height(48)
        .backgroundColor($r('app.color.primary_color'))
        .onClick(() => {
          this.showToast('操作已确认');
        })
    }
    .width('100%')
    .margin({ top: 20 })
  }

  @Builder
  SectionTitle(title: ResourceStr) {
    Row() {
      Column()
        .width(4)
        .height(16)
        .borderRadius(2)
        .backgroundColor($r('app.color.primary_color'))

      Text(title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .margin({ left: 8 })
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  SettingItem(icon: Resource, label: ResourceStr, isOn: boolean,
    onChange: (isOn: boolean) => void) {
    Row() {
      SymbolGlyph(icon)
        .fontSize(20)
        .fontColor([$r('app.color.primary_color')])

      Text(label)
        .fontSize(16)
        .fontColor($r('app.color.text_primary'))
        .margin({ left: 12 })
        .layoutWeight(1)

      Toggle({ type: ToggleType.Switch, isOn: isOn })
        .selectedColor($r('app.color.primary_color'))
        .onChange((state: boolean) => {
          onChange(state);
        })
    }
    .width('100%')
    .padding({ left: 16, top: 14, right: 16, bottom: 14 })
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
  }
}
