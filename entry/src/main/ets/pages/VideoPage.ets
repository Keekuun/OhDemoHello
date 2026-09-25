import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct VideoPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State isPlaying: boolean = false;
  @State currentTime: number = 0;
  @State duration: number = 0;
  @State showControls: boolean = true;
  private videoController: VideoController = new VideoController();

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24).fontColor([$r('app.color.text_primary')])
          .onClick(() => { router.back(); })
        Text('视频播放').fontSize(18).fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary')).layoutWeight(1).margin({ left: 12 })
      }
      .width('100%').height(56 + this.statusBarHeight)
      .padding({ left: 16, right: 16, top: this.statusBarHeight })
      .backgroundColor($r('app.color.card_background')).alignItems(VerticalAlign.Center)

      Scroll() {
        Column() {
          Text('Video — 视频播放组件').fontSize(14).fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary')).width('100%').margin({ bottom: 12 })

          Text('Video 组件支持本地/网络视频播放、全屏、循环、控制条等功能。需在 rawfile 中放置视频文件。')
            .fontSize(12).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 16 })

          // 视频播放器
          Column() {
            Video({
              src: $r('app.media.startIcon'),
              controller: this.videoController,
            })
              .width('100%').height(220)
              .borderRadius(12)
              .controls(this.showControls)
              .autoPlay(false)
              .loop(false)
              .muted(false)
              .objectFit(ImageFit.Contain)
              .onStart(() => { this.isPlaying = true; })
              .onPause(() => { this.isPlaying = false; })
              .onFinish(() => { this.isPlaying = false; promptAction.showToast({ message: '播放完成' }); })
          }
          .width('100%').borderRadius(12)
          .backgroundColor('#000000').margin({ bottom: 16 })

          // 播放控制
          Row() {
            Button(this.isPlaying ? '暂停' : '播放').fontSize(13).type(ButtonType.Capsule)
              .backgroundColor($r('app.color.primary_color')).fontColor(Color.White).layoutWeight(1)
              .onClick(() => {
                if (this.isPlaying) { this.videoController.pause(); }
                else { this.videoController.start(); }
              })
            Button('停止').fontSize(13).type(ButtonType.Capsule).margin({ left: 8 })
              .backgroundColor($r('app.color.page_background')).fontColor($r('app.color.text_secondary')).layoutWeight(1)
              .onClick(() => { this.videoController.stop(); this.isPlaying = false; })
            Button(this.showControls ? '隐藏控制' : '显示控制').fontSize(13).type(ButtonType.Capsule).margin({ left: 8 })
              .backgroundColor($r('app.color.page_background')).fontColor($r('app.color.text_secondary')).layoutWeight(1)
              .onClick(() => { this.showControls = !this.showControls; })
          }.width('100%').margin({ bottom: 16 })

          // 进度信息
          Column() {
            Row() {
              Text(this.formatTime(this.currentTime)).fontSize(11).fontColor($r('app.color.text_secondary'))
              Progress({
                value: this.duration > 0 ? (this.currentTime / this.duration) * 100 : 0,
                total: 100,
                type: ProgressType.Linear,
              }).layoutWeight(1).margin({ left: 8, right: 8 }).color($r('app.color.primary_color'))
              Text(this.formatTime(this.duration)).fontSize(11).fontColor($r('app.color.text_secondary'))
            }.width('100%')
          }
          .width('100%').padding(12).borderRadius(12).backgroundColor($r('app.color.card_background'))

          // API 说明
          Column() {
            Text('Video 组件 API').fontSize(13).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_primary')).margin({ bottom: 8, top: 16 })
            this.ApiRow('src', '视频源（Resource 或 string URI）')
            this.ApiRow('controller', 'VideoController 控制器')
            this.ApiRow('controls', '是否显示系统控制条')
            this.ApiRow('autoPlay', '是否自动播放')
            this.ApiRow('loop', '是否循环播放')
            this.ApiRow('muted', '是否静音')
            this.ApiRow('objectFit', '填充模式 Contain/Cover/Fill')
          }
          .width('100%').padding(16).borderRadius(12)
          .backgroundColor($r('app.color.card_background')).margin({ bottom: 20 })
        }
        .width('100%').padding(16)
      }
      .scrollBar(BarState.Off).edgeEffect(EdgeEffect.Spring)
      .layoutWeight(1).backgroundColor($r('app.color.page_background'))
    }
    .width('100%').height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }

  private formatTime(ms: number): string {
    const seconds = Math.floor(ms / 1000);
    const m = Math.floor(seconds / 60);
    const s = seconds % 60;
    return `${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`;
  }

  @Builder
  ApiRow(api: string, desc: string) {
    Row() {
      Text(api).fontSize(12).fontColor($r('app.color.primary_color')).width(80)
      Text(desc).fontSize(11).fontColor($r('app.color.text_secondary')).layoutWeight(1)
    }.width('100%').height(28)
  }
}
