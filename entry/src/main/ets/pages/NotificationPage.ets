import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { notificationManager } from '@kit.NotificationKit';

@Entry
@Component
struct NotificationPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State notifTitle: string = '测试通知';
  @State notifText: string = '这是一条来自 OhDemoHello 的通知';
  @State notifCount: number = 0;
  @State logs: string[] = [];

  private addLog(text: string): void {
    this.logs = [...this.logs, `${new Date().toLocaleTimeString()} - ${text}`];
  }

  private async sendNotification(): Promise<void> {
    try {
      const request: notificationManager.NotificationRequest = {
        id: ++this.notifCount,
        content: {
          contentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
          normal: {
            title: this.notifTitle,
            text: this.notifText,
            additionalText: `通知 #${this.notifCount}`,
          },
        } as notificationManager.NotificationContent,
        deliveryTime: new Date().getTime(),
      };
      await notificationManager.publish(request);
      this.addLog(`发送通知 #${this.notifCount}: ${this.notifTitle}`);
      promptAction.showToast({ message: '通知已发送' });
    } catch (e) {
      this.addLog(`发送失败: ${(e as Error).message}`);
      promptAction.showToast({ message: '发送失败，可能需要通知权限' });
    }
  }

  private async cancelAllNotifications(): Promise<void> {
    try {
      await notificationManager.cancelAll();
      this.addLog('已取消所有通知');
      promptAction.showToast({ message: '已清除全部通知' });
    } catch (e) {
      this.addLog(`取消失败: ${(e as Error).message}`);
    }
  }

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24).fontColor([$r('app.color.text_primary')])
          .onClick(() => { router.back(); })
        Text('通知管理').fontSize(18).fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary')).layoutWeight(1).margin({ left: 12 })
      }
      .width('100%').height(56 + this.statusBarHeight)
      .padding({ left: 16, right: 16, top: this.statusBarHeight })
      .backgroundColor($r('app.color.card_background')).alignItems(VerticalAlign.Center)

      Scroll() {
        Column() {
          Text('NotificationKit — 本地通知').fontSize(14).fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary')).width('100%').margin({ bottom: 12 })
          Text('通过 notificationManager.publish() 发送本地通知。')
            .fontSize(12).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 16 })

          Column() {
            Text('通知标题').fontSize(12).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 4 })
            TextInput({ text: this.notifTitle, placeholder: '标题' })
              .width('100%').height(40).borderRadius(8)
              .border({ width: 1, color: $r('app.color.divider_color') })
              .onChange((v: string) => { this.notifTitle = v; })
              .margin({ bottom: 12 })
            Text('通知内容').fontSize(12).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 4 })
            TextArea({ text: this.notifText, placeholder: '内容' })
              .width('100%').height(80).borderRadius(8)
              .border({ width: 1, color: $r('app.color.divider_color') })
              .onChange((v: string) => { this.notifText = v; })
          }
          .width('100%').padding(16).borderRadius(12).backgroundColor($r('app.color.card_background')).margin({ bottom: 16 })

          Button('发送通知').width('100%').fontSize(14).type(ButtonType.Capsule)
            .backgroundColor($r('app.color.primary_color')).fontColor(Color.White).height(42)
            .onClick(() => { this.sendNotification(); }).margin({ bottom: 8 })

          Button('连续发送 3 条').width('100%').fontSize(14).type(ButtonType.Capsule)
            .backgroundColor($r('app.color.success_color')).fontColor(Color.White).height(42)
            .onClick(() => {
              for (let i = 0; i < 3; i++) {
                setTimeout(() => { this.sendNotification(); }, i * 500);
              }
            })
            .margin({ bottom: 8 })

          Button('取消所有通知').width('100%').fontSize(14).type(ButtonType.Capsule)
            .backgroundColor($r('app.color.danger_color')).fontColor(Color.White).height(42)
            .onClick(() => { this.cancelAllNotifications(); }).margin({ bottom: 16 })

          Row() {
            Text(`已发送: ${this.notifCount} 条`).fontSize(12).fontColor($r('app.color.text_secondary')).layoutWeight(1)
          }
          .width('100%').padding(12).borderRadius(8).backgroundColor($r('app.color.card_background')).margin({ bottom: 12 })

          Column() {
            Text('操作日志').fontSize(13).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_primary')).margin({ bottom: 8 })
            if (this.logs.length === 0) {
              Text('暂无日志').fontSize(11).fontColor($r('app.color.text_hint')).margin({ top: 8 })
            } else {
              ForEach(this.logs, (log: string) => {
                Text(log).fontSize(10).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 4 })
              }, (log: string) => log)
            }
          }
          .width('100%').padding(16).borderRadius(12).backgroundColor($r('app.color.card_background')).margin({ bottom: 20 })
        }
        .width('100%').padding(16)
      }
      .scrollBar(BarState.Off).edgeEffect(EdgeEffect.Spring)
      .layoutWeight(1).backgroundColor($r('app.color.page_background'))
    }
    .width('100%').height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}
