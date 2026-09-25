import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct PanelPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State panelMode: number = 0;
  @State customPanelVisible: boolean = false;
  @State dragValue: number = 0;

  build() {
    Stack() {
      Column() {
        Row() {
          SymbolGlyph($r('sys.symbol.chevron_left'))
            .fontSize(24).fontColor([$r('app.color.text_primary')])
            .onClick(() => { router.back(); })
          Text('面板组件').fontSize(18).fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary')).layoutWeight(1).margin({ left: 12 })
        }
        .width('100%').height(56 + this.statusBarHeight)
        .padding({ left: 16, right: 16, top: this.statusBarHeight })
        .backgroundColor($r('app.color.card_background')).alignItems(VerticalAlign.Center)

        Column() {
          Text('Panel — 底部可拖拽面板').fontSize(14).fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary')).width('100%').margin({ bottom: 12 })
          Text('Panel 组件支持三种模式：Mini(收起) / Half(半屏) / Full(全屏)，可拖拽切换。')
            .fontSize(12).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 20 })

          Row() {
            ForEach(['Mini', 'Half', 'Full'], (label: string, index: number) => {
              Text(label).fontSize(13).padding({ left: 14, right: 14, top: 6, bottom: 6 })
                .borderRadius(16)
                .backgroundColor(this.panelMode === index ? $r('app.color.primary_color') : $r('app.color.page_background'))
                .fontColor(this.panelMode === index ? Color.White : $r('app.color.text_secondary'))
                .layoutWeight(1).textAlign(TextAlign.Center)
                .onClick(() => { this.panelMode = index; })
            }, (label: string) => label)
          }.width('100%').margin({ bottom: 20 })

          Text('自定义底部弹出面板').fontSize(14).fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary')).width('100%').margin({ top: 20, bottom: 12 })

          Button('弹出底部面板').width('100%').fontSize(14).type(ButtonType.Capsule)
            .backgroundColor($r('app.color.primary_color')).fontColor(Color.White).height(44)
            .onClick(() => { this.customPanelVisible = true; })

          Blank().layoutWeight(1)

          Column() {
            Text('拖拽进度').fontSize(13).fontColor($r('app.color.text_secondary')).width('100%')
            Progress({ value: this.dragValue, total: 100, type: ProgressType.Linear })
              .width('100%').color($r('app.color.primary_color')).margin({ top: 8 })
            Text(`${this.dragValue}%`).fontSize(12).fontColor($r('app.color.text_hint')).margin({ top: 4 })
          }
          .width('100%').padding(16).borderRadius(12).backgroundColor($r('app.color.card_background')).margin({ bottom: 16 })
        }
        .width('100%').layoutWeight(1).padding(16).backgroundColor($r('app.color.page_background'))

        // Panel 面板
        Panel(true) {
          Column() {
            Text('可拖拽面板').fontSize(16).fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary')).width('100%').textAlign(TextAlign.Center).margin({ bottom: 16 })

            ForEach(['面板内容项 1', '面板内容项 2', '面板内容项 3', '面板内容项 4'], (item: string) => {
              Row() {
                Text(item).fontSize(14).fontColor($r('app.color.text_primary')).layoutWeight(1)
                Text('›').fontSize(18).fontColor($r('app.color.text_hint'))
              }
              .width('100%').height(48).padding({ left: 16, right: 16 })
              .border({ width: { bottom: 1 }, color: $r('app.color.divider_color') })
            }, (item: string) => item)

            Blank().layoutWeight(1)
            Text('↑ 拖拽面板边缘可切换模式').fontSize(11)
              .fontColor($r('app.color.text_hint')).margin({ bottom: 16 })
          }
          .width('100%').height('100%').padding({ top: 16 })
        }
        .mode(PanelMode.Full)
        .halfHeight(300)
        .miniHeight(80)
        .onChange((width: number, height: number, mode: PanelMode) => {
          if (mode === PanelMode.Mini) { this.panelMode = 0; this.dragValue = 10; }
          else if (mode === PanelMode.Half) { this.panelMode = 1; this.dragValue = 50; }
          else if (mode === PanelMode.Full) { this.panelMode = 2; this.dragValue = 100; }
        })
      }
      .width('100%').height('100%')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])

      // 自定义底部面板
      if (this.customPanelVisible) {
        Stack({ alignContent: Alignment.Bottom }) {
          Column() {
            Column() {
              Column().width(40).height(4).borderRadius(2).backgroundColor($r('app.color.text_hint')).margin({ bottom: 16 })
              Text('自定义底部面板').fontSize(16).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_primary')).width('100%').margin({ bottom: 16 })

              ForEach(['选项 A', '选项 B', '选项 C'], (item: string) => {
                Row() {
                  Text(item).fontSize(14).fontColor($r('app.color.text_primary')).layoutWeight(1)
                  Radio({ value: item, group: 'panel' })
                }.width('100%').height(48).padding({ left: 16, right: 16 })
                .border({ width: { bottom: 1 }, color: $r('app.color.divider_color') })
              }, (item: string) => item)

              Button('关闭').width('100%').fontSize(14).type(ButtonType.Capsule).margin({ top: 16 })
                .backgroundColor($r('app.color.page_background')).fontColor($r('app.color.text_secondary'))
                .onClick(() => { this.customPanelVisible = false; })
            }
            .width('100%').padding({ top: 16, bottom: 32, left: 16, right: 16 })
            .borderRadius({ topLeft: 20, topRight: 20 })
            .backgroundColor($r('app.color.card_background'))
          }
          .width('100%').height('100%')
        }
        .width('100%').height('100%').backgroundColor('rgba(0,0,0,0.5)')
        .onClick(() => { this.customPanelVisible = false; })
      }
    }
    .width('100%').height('100%')
  }
}
