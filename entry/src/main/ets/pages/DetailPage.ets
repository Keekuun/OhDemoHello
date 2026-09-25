import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct DetailPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State title: string = '详情';
  @State desc: string = '';
  @State liked: boolean = false;
  @State likeCount: number = 326;
  @State collected: boolean = false;

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, string>;
    if (params) {
      if (params.title) {
        this.title = params.title;
      }
      if (params.desc) {
        this.desc = params.desc;
      }
    }
  }

  private showToast(msg: string): void {
    promptAction.showToast({ message: msg, duration: 2000 });
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
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text('···')
          .fontSize(24)
          .fontColor($r('app.color.text_primary'))
          .onClick(() => {
            this.showToast('更多操作');
          })
      }
      .width('100%')
      .height(56 + this.statusBarHeight)
      .padding({ left: 16, right: 16, top: this.statusBarHeight })
      .backgroundColor($r('app.color.card_background'))
      .alignItems(VerticalAlign.Center)

      // 内容区
      Scroll() {
        Column() {
          // 主图区域
          Column() {
            Text('🖼️')
              .fontSize(64)
            Text(this.title)
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
              .margin({ top: 12 })
              .textAlign(TextAlign.Center)
          }
          .width('100%')
          .height(200)
          .borderRadius(16)
          .linearGradient({ angle: 135, colors: [[$r('app.color.gradient_start'), 0], [$r('app.color.gradient_end'), 1]] })
          .justifyContent(FlexAlign.Center)

          // 描述卡片
          Column() {
            Text('简介')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text(this.desc.length > 0 ? this.desc : '这是详情页面，展示内容的详细信息。您可以在此查看完整内容、进行点赞、收藏等操作。')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 12 })
              .lineHeight(22)
          }
          .width('100%')
          .padding(20)
          .borderRadius(16)
          .backgroundColor($r('app.color.card_background'))
          .margin({ top: 16 })
          .alignItems(HorizontalAlign.Start)
          .shadow({ radius: 6, color: 'rgba(0,0,0,0.06)', offsetX: 0, offsetY: 2 })

          // 信息标签
          Row() {
            Text('HarmonyOS')
              .fontSize(12)
              .fontColor($r('app.color.primary_color'))
              .backgroundColor($r('app.color.primary_light'))
              .borderRadius(12)
              .padding({ left: 12, top: 6, right: 12, bottom: 6 })

            Text('ArkTS')
              .fontSize(12)
              .fontColor($r('app.color.primary_color'))
              .backgroundColor($r('app.color.primary_light'))
              .borderRadius(12)
              .padding({ left: 12, top: 6, right: 12, bottom: 6 })
              .margin({ left: 8 })

            Text('推荐')
              .fontSize(12)
              .fontColor($r('app.color.success_color'))
              .backgroundColor('rgba(54,211,114,0.1)')
              .borderRadius(12)
              .padding({ left: 12, top: 6, right: 12, bottom: 6 })
              .margin({ left: 8 })
          }
          .width('100%')
          .margin({ top: 16 })

          // 操作按钮区
          Row() {
            // 点赞
            Column() {
              SymbolGlyph(this.liked ? $r('sys.symbol.heart_fill') : $r('sys.symbol.heart'))
                .fontSize(24)
                .fontColor([this.liked ? $r('app.color.danger_color') : $r('app.color.text_secondary')])
              Text(`${this.likeCount}`)
                .fontSize(12)
                .fontColor($r('app.color.text_secondary'))
                .margin({ top: 4 })
            }
            .layoutWeight(1)
            .onClick(() => {
              this.liked = !this.liked;
              this.likeCount += this.liked ? 1 : -1;
            })

            // 收藏
            Column() {
              SymbolGlyph(this.collected ? $r('sys.symbol.checkmark_circle') : $r('sys.symbol.ohos_folder_badge_plus'))
                .fontSize(24)
                .fontColor([this.collected ? $r('app.color.warning_color') : $r('app.color.text_secondary')])
              Text(this.collected ? '已收藏' : '收藏')
                .fontSize(12)
                .fontColor($r('app.color.text_secondary'))
                .margin({ top: 4 })
            }
            .layoutWeight(1)
            .onClick(() => {
              this.collected = !this.collected;
              this.showToast(this.collected ? '已收藏' : '已取消收藏');
            })

            // 分享
            Column() {
              SymbolGlyph($r('sys.symbol.ohos_wifi'))
                .fontSize(24)
                .fontColor([$r('app.color.text_secondary')])
              Text('分享')
                .fontSize(12)
                .fontColor($r('app.color.text_secondary'))
                .margin({ top: 4 })
            }
            .layoutWeight(1)
            .onClick(() => {
              this.showToast('分享功能开发中');
            })
          }
          .width('100%')
          .padding(20)
          .borderRadius(16)
          .backgroundColor($r('app.color.card_background'))
          .margin({ top: 16 })
          .shadow({ radius: 6, color: 'rgba(0,0,0,0.06)', offsetX: 0, offsetY: 2 })

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
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}
