import { promptAction } from '@kit.ArkUI';
import { router } from '@kit.ArkUI';

class MessageItem {
  avatar: string;
  name: string;
  preview: string;
  time: string;
  unread: number;
  isOfficial: boolean;

  constructor(avatar: string, name: string, preview: string, time: string,
    unread: number, isOfficial: boolean) {
    this.avatar = avatar;
    this.name = name;
    this.preview = preview;
    this.time = time;
    this.unread = unread;
    this.isOfficial = isOfficial;
  }
}

@Component
export struct MessagePage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State activeTab: number = 0;

  @State messages: MessageItem[] = [
    new MessageItem('H', 'HarmonyOS 官方', 'HarmonyOS NEXT 已正式发布，快来体验！', '10:30', 3, true),
    new MessageItem('D', '开发者社区', '您发表的文章已通过审核', '09:15', 1, true),
    new MessageItem('A', 'ArkTS 学习小组', '今晚8点直播：声明式UI最佳实践', '昨天', 0, false),
    new MessageItem('W', '王同学', '这个分布式能力太强了！', '昨天', 5, false),
    new MessageItem('L', '李工程师', '关于性能优化的几个建议...', '周一', 0, false),
    new MessageItem('S', '设计团队', '新的UI设计稿已上传，请查收', '周一', 2, false),
    new MessageItem('O', '运维通知', '系统将于今晚23:00进行维护', '上周', 0, true),
  ];

  private showToast(msg: string): void {
    promptAction.showToast({ message: msg, duration: 2000 });
  }

  build() {
    Column() {
      this.HeaderSection()

      List({ space: 0 }) {
        ForEach(this.messages, (item: MessageItem, index: number) => {
          ListItem() {
            this.MessageRow(item)
          }
          .onClick(() => {
            router.pushUrl({ url: 'pages/DetailPage', params: { title: item.name, desc: item.preview } });
          })
        }, (item: MessageItem, index: number) => `${index}_${item.name}`)
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .divider({ strokeWidth: 0.5, color: $r('app.color.divider_color'), startMargin: 76, endMargin: 16 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.page_background'))
  }

  @Builder
  HeaderSection() {
    Column() {
      Row() {
        Text($r('app.string.message_title'))
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .layoutWeight(1)

        Text('🔍')
          .fontSize(20)
          .fontColor($r('app.color.text_secondary'))
          .margin({ right: 16 })
          .onClick(() => {
            this.showToast('搜索消息');
          })

        Text('···')
          .fontSize(20)
          .fontColor($r('app.color.text_secondary'))
          .onClick(() => {
            this.showToast('更多操作');
          })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .alignItems(VerticalAlign.Center)

      Row() {
        Text('全部')
          .fontSize(15)
          .fontWeight(this.activeTab === 0 ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.activeTab === 0 ? $r('app.color.primary_color') : $r('app.color.text_secondary'))
          .padding({ left: 16, right: 16 })
          .onClick(() => { this.activeTab = 0; })

        Text('官方')
          .fontSize(15)
          .fontWeight(this.activeTab === 1 ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.activeTab === 1 ? $r('app.color.primary_color') : $r('app.color.text_secondary'))
          .padding({ left: 16, right: 16 })
          .onClick(() => { this.activeTab = 1; })

        Text('未读')
          .fontSize(15)
          .fontWeight(this.activeTab === 2 ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.activeTab === 2 ? $r('app.color.primary_color') : $r('app.color.text_secondary'))
          .padding({ left: 16, right: 16 })
          .onClick(() => { this.activeTab = 2; })
      }
      .width('100%')
      .height(44)
      .alignItems(VerticalAlign.Center)

      Divider().color($r('app.color.divider_color'))
    }
    .width('100%')
    .padding({ top: this.statusBarHeight })
    .backgroundColor($r('app.color.card_background'))
  }

  @Builder
  MessageRow(item: MessageItem) {
    Row() {
      Stack({ alignContent: Alignment.TopEnd }) {
        Text(item.avatar)
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .width(52)
          .height(52)
          .borderRadius(26)
          .backgroundColor(item.isOfficial ? $r('app.color.primary_color') : $r('app.color.success_color'))
          .textAlign(TextAlign.Center)

        if (item.unread > 0) {
          Text(item.unread > 99 ? '99+' : item.unread.toString())
            .fontSize(11)
            .fontColor(Color.White)
            .backgroundColor($r('app.color.badge_color'))
            .borderRadius(10)
            .height(20)
            .minFontSize(9)
            .padding({ left: 5, right: 5 })
            .textAlign(TextAlign.Center)
            .markAnchor({ x: 24, y: 0 })
        }
      }
      .width(52)
      .height(52)
      .margin({ right: 12 })

      Column() {
        Row() {
          Text(item.name)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.text_primary'))
            .maxLines(1)
            .layoutWeight(1)

          Text(item.time)
            .fontSize(12)
            .fontColor($r('app.color.text_hint'))
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        Text(item.preview)
          .fontSize(13)
          .fontColor($r('app.color.text_secondary'))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 6 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
    }
    .width('100%')
    .padding({ left: 16, top: 14, right: 16, bottom: 14 })
    .alignItems(VerticalAlign.Center)
  }
}
