import { promptAction } from '@kit.ArkUI';
import { router } from '@kit.ArkUI';

class ToolItem {
  icon: Resource;
  name: string;
  color: ResourceColor;

  constructor(icon: Resource, name: string, color: ResourceColor) {
    this.icon = icon;
    this.name = name;
    this.color = color;
  }
}

@Component
export struct ToolsPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State calcDisplay: string = '0';
  @State calcExpression: string = '';
  @State stopwatchTime: number = 0;
  @State stopwatchRunning: boolean = false;
  private stopwatchTimerId: number = -1;

  @State tools: ToolItem[] = [
    new ToolItem($r('sys.symbol.checkmark_circle'), '计算器', $r('app.color.primary_color')),
    new ToolItem($r('sys.symbol.bolt_fill'), '计时器', $r('app.color.warning_color')),
    new ToolItem($r('sys.symbol.bell_fill'), '提醒', $r('app.color.danger_color')),
    new ToolItem($r('sys.symbol.ohos_folder_badge_plus'), '记事本', $r('app.color.success_color')),
    new ToolItem($r('sys.symbol.ohos_wifi'), '网络检测', $r('app.color.primary_color')),
    new ToolItem($r('sys.symbol.checkmark_circle'), '单位换算', $r('app.color.warning_color')),
    new ToolItem($r('sys.symbol.moon_fill'), '日历', $r('app.color.danger_color')),
    new ToolItem($r('sys.symbol.play_fill'), '音乐', $r('app.color.success_color')),
  ];

  private showToast(msg: string): void {
    promptAction.showToast({ message: msg, duration: 2000 });
  }

  private toggleStopwatch(): void {
    if (this.stopwatchRunning) {
      clearInterval(this.stopwatchTimerId);
      this.stopwatchRunning = false;
    } else {
      this.stopwatchRunning = true;
      this.stopwatchTimerId = setInterval(() => {
        this.stopwatchTime += 10;
      }, 10);
    }
  }

  private resetStopwatch(): void {
    clearInterval(this.stopwatchTimerId);
    this.stopwatchRunning = false;
    this.stopwatchTime = 0;
  }

  private formatTime(ms: number): string {
    const totalSec = Math.floor(ms / 1000);
    const min = Math.floor(totalSec / 60);
    const sec = totalSec % 60;
    const milli = Math.floor((ms % 1000) / 10);
    return `${min.toString().padStart(2, '0')}:${sec.toString().padStart(2, '0')}.${milli.toString().padStart(2, '0')}`;
  }

  aboutToDisappear(): void {
    clearInterval(this.stopwatchTimerId);
  }

  build() {
    Column() {
      // 固定标题栏
      Text($r('app.string.tools_title'))
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .width('100%')
        .height(56 + this.statusBarHeight)
        .padding({ left: 16, top: this.statusBarHeight })
        .backgroundColor($r('app.color.card_background'))

      // 可滚动内容区
      Scroll() {
        Column() {
          this.ToolsGrid()
          this.CalculatorCard()
          this.StopwatchCard()
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
  ToolsGrid() {
    Grid() {
      ForEach(this.tools, (item: ToolItem) => {
        GridItem() {
          Column() {
            Row() {
              SymbolGlyph(item.icon)
                .fontSize(26)
                .fontColor([item.color])
            }
            .width(52)
            .height(52)
            .borderRadius(16)
            .backgroundColor($r('app.color.primary_light'))
            .justifyContent(FlexAlign.Center)

            Text(item.name)
              .fontSize(13)
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 8 })
          }
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            this.showToast(`${item.name}功能开发中`);
          })
        }
      }, (item: ToolItem) => item.name)
    }
    .columnsTemplate('1fr 1fr 1fr 1fr')
    .rowsGap(16)
    .columnsGap(8)
    .padding(20)
    .borderRadius(16)
    .backgroundColor($r('app.color.card_background'))
    .margin({ top: 16 })
    .shadow({ radius: 6, color: 'rgba(0,0,0,0.06)', offsetX: 0, offsetY: 2 })
  }

  @Builder
  CalculatorCard() {
    Column() {
      Row() {
        Column()
          .width(4)
          .height(16)
          .borderRadius(2)
          .backgroundColor($r('app.color.primary_color'))

        Text('计算器')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .margin({ left: 8 })
      }
      .width('100%')

      // 显示屏
      Text(this.calcDisplay)
        .fontSize(36)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .width('100%')
        .height(60)
        .textAlign(TextAlign.RIGHT)
        .padding({ right: 16 })
        .margin({ top: 12 })

      // 按钮网格
      Grid() {
        ForEach(['7', '8', '9', '4', '5', '6', '1', '2', '3', '0', '.', '='], (key: string) => {
          GridItem() {
            Text(key)
              .fontSize(22)
              .fontColor($r('app.color.text_primary'))
              .backgroundColor($r('app.color.primary_light'))
              .borderRadius(12)
              .width(48)
              .height(48)
              .shadow(ShadowStyle.OUTER_DEFAULT_SM)
              .textAlign(TextAlign.Center)
              .onClick(() => {
                if (this.calcDisplay === '0' && key !== '.') {
                  this.calcDisplay = key;
                } else {
                  this.calcDisplay += key;
                }
              })
          }
        }, (key: string) => key)

        GridItem() {
          Text('C')
            .fontSize(22)
            .fontColor($r('app.color.danger_color'))
            .backgroundColor($r('app.color.primary_light'))
            .borderRadius(12)
            .width(48)
            .height(48)
            .textAlign(TextAlign.Center)
            .onClick(() => {
              this.calcDisplay = '0';
            })
        }
      }
      .columnsTemplate('1fr 1fr 1fr')
      .rowsGap(8)
      .columnsGap(8)
      .margin({ top: 8 })
    }
    .width('100%')
    .padding(20)
    .borderRadius(16)
    .backgroundColor($r('app.color.card_background'))
    .margin({ top: 16 })
    .shadow({ radius: 6, color: 'rgba(0,0,0,0.06)', offsetX: 0, offsetY: 2 })
  }

  @Builder
  StopwatchCard() {
    Column() {
      Row() {
        Column()
          .width(4)
          .height(16)
          .borderRadius(2)
          .backgroundColor($r('app.color.warning_color'))

        Text('秒表')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .margin({ left: 8 })
      }
      .width('100%')

      // 时间显示
      Text(this.formatTime(this.stopwatchTime))
        .fontSize(48)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.warning_color'))
        .width('100%')
        .height(80)
        .textAlign(TextAlign.Center)
        .margin({ top: 16 })

      // 控制按钮
      Row() {
        Button(this.stopwatchRunning ? '暂停' : '开始')
          .type(ButtonType.Capsule)
          .fontSize(16)
          .layoutWeight(1)
          .height(44)
          .backgroundColor(this.stopwatchRunning ? $r('app.color.warning_color') : $r('app.color.primary_color'))
          .onClick(() => {
            this.toggleStopwatch();
          })

        Blank().width(12)

        Button('重置')
          .type(ButtonType.Capsule)
          .fontSize(16)
          .layoutWeight(1)
          .height(44)
          .backgroundColor($r('app.color.primary_light'))
          .fontColor($r('app.color.primary_color'))
          .onClick(() => {
            this.resetStopwatch();
          })
      }
      .width('100%')
      .margin({ top: 8 })
    }
    .width('100%')
    .padding(20)
    .borderRadius(16)
    .backgroundColor($r('app.color.card_background'))
    .margin({ top: 16 })
    .shadow({ radius: 6, color: 'rgba(0,0,0,0.06)', offsetX: 0, offsetY: 2 })
  }
}
