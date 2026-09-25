import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

// 主题数据模型
class ThemeConfig {
  primaryColor: string;
  bgColor: string;
  cardBg: string;
  textColor: string;
  subTextColor: string;
  isDark: boolean;
  fontSize: number;

  constructor(primary: string, bg: string, card: string, text: string, sub: string, dark: boolean, font: number) {
    this.primaryColor = primary;
    this.bgColor = bg;
    this.cardBg = card;
    this.textColor = text;
    this.subTextColor = sub;
    this.isDark = dark;
    this.fontSize = font;
  }
}

// 父组件 — @Provide 主题数据
@Entry
@Component
struct ThemePage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @Provide theme: ThemeConfig = new ThemeConfig('#007DFF', '#F1F3F5', '#FFFFFF', '#182431', '#666666', false, 14);
  @State selectedColorIndex: number = 0;
  @State selectedFontIndex: number = 1;

  private primaryColors: string[] = ['#007DFF', '#36D372', '#FF9F0A', '#FF4D4F', '#9B59B6', '#1ABC9C'];
  private colorNames: string[] = ['经典蓝', '清新绿', '活力橙', '热情红', '优雅紫', '青绿'];
  private fontSizes: number[] = [12, 14, 16, 18];
  private fontNames: string[] = ['小', '标准', '大', '特大'];

  private switchTheme(dark: boolean): void {
    if (dark) {
      this.theme = new ThemeConfig(this.primaryColors[this.selectedColorIndex], '#181818', '#222222', '#E6E6E6', '#999999', true, this.fontSizes[this.selectedFontIndex]);
    } else {
      this.theme = new ThemeConfig(this.primaryColors[this.selectedColorIndex], '#F1F3F5', '#FFFFFF', '#182431', '#666666', false, this.fontSizes[this.selectedFontIndex]);
    }
  }

  private switchColor(index: number): void {
    this.selectedColorIndex = index;
    this.switchTheme(this.theme.isDark);
  }

  private switchFont(index: number): void {
    this.selectedFontIndex = index;
    this.switchTheme(this.theme.isDark);
  }

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24).fontColor([this.theme.textColor])
          .onClick(() => { router.back(); })
        Text('主题切换').fontSize(18).fontWeight(FontWeight.Bold)
          .fontColor(this.theme.textColor).layoutWeight(1).margin({ left: 12 })
      }
      .width('100%').height(56 + this.statusBarHeight)
      .padding({ left: 16, right: 16, top: this.statusBarHeight })
      .backgroundColor(this.theme.cardBg).alignItems(VerticalAlign.Center)

      Scroll() {
        Column() {
          // 深色/浅色切换
          Row() {
            Text('深色模式').fontSize(this.theme.fontSize).fontColor(this.theme.textColor).layoutWeight(1)
            Toggle({ type: ToggleType.Switch, isOn: this.theme.isDark })
              .selectedColor(this.theme.primaryColor)
              .onChange((isOn: boolean) => { this.switchTheme(isOn); })
          }
          .width('100%').padding(16).borderRadius(12)
          .backgroundColor(this.theme.cardBg).margin({ top: 12 })

          // 主色选择
          Column() {
            Text('主题色').fontSize(this.theme.fontSize).fontWeight(FontWeight.Bold)
              .fontColor(this.theme.textColor).width('100%').margin({ bottom: 12 })
            Flex({ wrap: FlexWrap.Wrap }) {
              ForEach(this.primaryColors, (color: string, index: number) => {
                Column() {
                  Column().width(40).height(40).borderRadius(20)
                    .backgroundColor(color)
                    .border({ width: this.selectedColorIndex === index ? 3 : 0, color: this.theme.textColor })
                  Text(this.colorNames[index]).fontSize(11).fontColor(this.theme.subTextColor).margin({ top: 6 })
                }
                .margin({ right: 12, bottom: 8 })
                .onClick(() => { this.switchColor(index); })
              }, (color: string) => color)
            }.width('100%')
          }
          .width('100%').padding(16).borderRadius(12)
          .backgroundColor(this.theme.cardBg).margin({ top: 12 })

          // 字体大小
          Column() {
            Text('字体大小').fontSize(this.theme.fontSize).fontWeight(FontWeight.Bold)
              .fontColor(this.theme.textColor).width('100%').margin({ bottom: 12 })
            Row() {
              ForEach(this.fontSizes, (size: number, index: number) => {
                Text(this.fontNames[index]).fontSize(size)
                  .padding({ left: 14, right: 14, top: 6, bottom: 6 })
                  .borderRadius(16)
                  .backgroundColor(this.selectedFontIndex === index ? this.theme.primaryColor : this.theme.bgColor)
                  .fontColor(this.selectedFontIndex === index ? Color.White : this.theme.subTextColor)
                  .layoutWeight(1)
                  .textAlign(TextAlign.Center)
                  .onClick(() => { this.switchFont(index); })
              }, (size: number) => `${size}`)
            }.width('100%')
          }
          .width('100%').padding(16).borderRadius(12)
          .backgroundColor(this.theme.cardBg).margin({ top: 12 })

          // 预览区域 — @Consume 消费主题
          ThemePreview()

          Blank().height(20)
        }
        .width('100%').padding({ left: 16, right: 16 })
      }
      .scrollBar(BarState.Off).edgeEffect(EdgeEffect.Spring)
      .layoutWeight(1).backgroundColor(this.theme.bgColor)
    }
    .width('100%').height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}

// 子组件 — @Consume 消费主题
@Component
struct ThemePreview {
  @Consume theme: ThemeConfig;

  build() {
    Column() {
      Text('主题预览').fontSize(this.theme.fontSize).fontWeight(FontWeight.Bold)
        .fontColor(this.theme.textColor).width('100%').margin({ bottom: 12 })

      // 卡片预览
      Column() {
        Text('卡片标题示例').fontSize(this.theme.fontSize + 2).fontWeight(FontWeight.Bold)
          .fontColor(this.theme.textColor).width('100%')
        Text('这是卡片正文内容，颜色和字号会随主题变化。').fontSize(this.theme.fontSize)
          .fontColor(this.theme.subTextColor).width('100%').margin({ top: 8 })

        Row() {
          Button('主按钮').fontSize(this.theme.fontSize - 1).type(ButtonType.Capsule)
            .backgroundColor(this.theme.primaryColor).fontColor(Color.White).layoutWeight(1)
          Button('次按钮').fontSize(this.theme.fontSize - 1).type(ButtonType.Capsule)
            .backgroundColor(this.theme.bgColor).fontColor(this.theme.subTextColor).layoutWeight(1).margin({ left: 8 })
        }.width('100%').margin({ top: 12 })
      }
      .width('100%').padding(16).borderRadius(12)
      .backgroundColor(this.theme.cardBg)
      .shadow({ radius: 6, color: 'rgba(0,0,0,0.08)', offsetX: 0, offsetY: 2 })

      // 标签示例
      Row() {
        Text('标签一').fontSize(this.theme.fontSize - 2).padding({ left: 8, right: 8, top: 3, bottom: 3 })
          .borderRadius(10).backgroundColor(this.theme.primaryColor).fontColor(Color.White)
        Text('标签二').fontSize(this.theme.fontSize - 2).padding({ left: 8, right: 8, top: 3, bottom: 3 })
          .borderRadius(10).backgroundColor(this.theme.bgColor).fontColor(this.theme.subTextColor).margin({ left: 8 })
      }.width('100%').margin({ top: 12 })
    }
    .width('100%').padding(16).borderRadius(12)
    .backgroundColor(this.theme.cardBg).margin({ top: 12 })
    .shadow({ radius: 6, color: 'rgba(0,0,0,0.06)', offsetX: 0, offsetY: 2 })
  }
}
