import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct SideBarPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State currentMenu: number = 0;
  @State sidebarWidth: number = 200;

  private menuItems: string[] = ['收件箱', '已发送', '草稿箱', '垃圾邮件', '星标邮件', '设置'];

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24).fontColor([$r('app.color.text_primary')])
          .onClick(() => { router.back(); })
        Text('侧边栏容器').fontSize(18).fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary')).layoutWeight(1).margin({ left: 12 })
      }
      .width('100%').height(56 + this.statusBarHeight)
      .padding({ left: 16, right: 16, top: this.statusBarHeight })
      .backgroundColor($r('app.color.card_background')).alignItems(VerticalAlign.Center)

      SideBarContainer(SideBarContainerType.Embed) {
        // 侧边栏内容
        Column() {
          Row() {
            Column()
              .width(48).height(48).borderRadius(24)
              .backgroundColor($r('app.color.primary_color'))
              .justifyContent(FlexAlign.Center)
            Column() {
              Text('用户名').fontSize(15).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_primary'))
              Text('user@example.com').fontSize(11).fontColor($r('app.color.text_secondary')).margin({ top: 2 })
            }.margin({ left: 12 }).layoutWeight(1).alignItems(HorizontalAlign.Start)
          }
          .width('100%').padding(16)

          ForEach(this.menuItems, (item: string, index: number) => {
            Row() {
              Text(item).fontSize(14)
                .fontColor(this.currentMenu === index ? $r('app.color.primary_color') : $r('app.color.text_primary'))
                .fontWeight(this.currentMenu === index ? FontWeight.Bold : FontWeight.Normal)
                .layoutWeight(1)
              if (this.currentMenu === index) {
                Column().width(3).height(16).borderRadius(2).backgroundColor($r('app.color.primary_color'))
              }
            }
            .width('100%').height(48).padding({ left: 16, right: 12 })
            .backgroundColor(this.currentMenu === index ? $r('app.color.primary_light') : Color.Transparent)
            .onClick(() => { this.currentMenu = index; })
          }, (item: string) => item)
        }
        .width('100%').height('100%')
        .backgroundColor($r('app.color.card_background'))

        // 主内容区
        Column() {
          Text(this.menuItems[this.currentMenu]).fontSize(20).fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary')).width('100%').margin({ bottom: 16 })

          Column() {
            Text(`当前选中: ${this.menuItems[this.currentMenu]}`).fontSize(14).fontColor($r('app.color.text_secondary')).margin({ bottom: 8 })
            Text('SideBarContainer 可以通过控制按钮或手势展开/收起侧边栏。').fontSize(13).fontColor($r('app.color.text_secondary')).margin({ bottom: 16 })

            ForEach([1, 2, 3, 4, 5], (i: number) => {
              Row() {
                Column().width(8).height(8).borderRadius(4).backgroundColor($r('app.color.primary_color')).margin({ right: 8 })
                Text(`${this.menuItems[this.currentMenu]} - 邮件 ${i}`).fontSize(13).fontColor($r('app.color.text_primary')).layoutWeight(1)
                Text(`${i}:00`).fontSize(11).fontColor($r('app.color.text_hint'))
              }
              .width('100%').height(44).padding({ left: 12, right: 12 })
              .borderRadius(8).backgroundColor($r('app.color.card_background')).margin({ bottom: 8 })
            }, (i: number) => `${i}`)
          }
          .width('100%').layoutWeight(1)
        }
        .width('100%').height('100%').padding(16)
        .backgroundColor($r('app.color.page_background'))
      }
      .sideBarWidth(this.sidebarWidth)
      .minSideBarWidth(160)
      .maxSideBarWidth(280)
      .controlButton({
        icons: {
          shown: $r('sys.symbol.bolt'),
          hidden: $r('sys.symbol.bolt'),
          switching: $r('sys.symbol.bolt'),
        },
      })
      .showControlButton(true)
      .autoHide(false)
      .layoutWeight(1)
    }
    .width('100%').height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}
