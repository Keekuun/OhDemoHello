import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

@Component
struct DialogCardBox {
  @Prop cardTitle: string;
  @BuilderParam content: () => void;
  build() {
    Column() {
      Text(this.cardTitle).fontSize(16).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).width('100%').margin({ bottom: 12 })
      Column() { this.content() }.width('100%')
    }
    .width('100%').padding(16).borderRadius(16).backgroundColor($r('app.color.card_background')).margin({ top: 12 })
    .shadow({ radius: 6, color: 'rgba(0,0,0,0.06)', offsetX: 0, offsetY: 2 })
  }
}

@Entry
@Component
struct DialogPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State customDialogVisible: boolean = false;
  @State bottomSheetVisible: boolean = false;
  @State loadingVisible: boolean = false;
  @State inputDialogVisible: boolean = false;
  @State dialogInput: string = '';

  private showToast(msg: string): void {
    promptAction.showToast({ message: msg, duration: 2000 });
  }

  private showAlertDialog(): void {
    promptAction.showDialog({
      title: '提示',
      message: '这是一个警告提示对话框，确定要继续操作吗？',
      buttons: [
        { text: '取消', color: $r('app.color.text_secondary') },
        { text: '确定', color: $r('app.color.primary_color') },
      ],
    }).then((result: promptAction.ShowDialogSuccessResponse) => {
      if (result.index === 1) { this.showToast('已确定'); }
      else { this.showToast('已取消'); }
    });
  }

  private showConfirmDialog(): void {
    promptAction.showDialog({
      title: '确认删除',
      message: '删除后不可恢复，确认要删除这条数据吗？',
      buttons: [
        { text: '取消', color: $r('app.color.text_secondary') },
        { text: '删除', color: $r('app.color.danger_color') },
      ],
    }).then((result: promptAction.ShowDialogSuccessResponse) => {
      if (result.index === 1) { this.showToast('已删除'); }
    });
  }

  private showActionMenu(): void {
    promptAction.showDialog({
      title: '请选择操作',
      message: '1. 分享\n2. 收藏\n3. 举报',
      buttons: [
        { text: '分享', color: $r('app.color.primary_color') },
        { text: '收藏', color: $r('app.color.success_color') },
        { text: '举报', color: $r('app.color.danger_color') },
      ],
    }).then((result: promptAction.ShowDialogSuccessResponse) => {
      const actions = ['分享', '收藏', '举报'];
      this.showToast(`选择了: ${actions[result.index]}`);
    });
  }

  private showLoading(): void {
    this.loadingVisible = true;
    setTimeout(() => { this.loadingVisible = false; this.showToast('加载完成'); }, 2000);
  }

  build() {
    Stack() {
      Column() {
        Row() {
          SymbolGlyph($r('sys.symbol.chevron_left'))
            .fontSize(24).fontColor([$r('app.color.text_primary')])
            .onClick(() => { router.back(); })
          Text('弹窗展示').fontSize(18).fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary')).layoutWeight(1).margin({ left: 12 })
        }
        .width('100%').height(56 + this.statusBarHeight)
        .padding({ left: 16, right: 16, top: this.statusBarHeight })
        .backgroundColor($r('app.color.card_background')).alignItems(VerticalAlign.Center)

        Scroll() {
          Column() {
            DialogCardBox({ cardTitle: '系统弹窗' }) {
              this.DlgBtn('提示对话框', () => { this.showAlertDialog(); })
              this.DlgBtn('确认对话框', () => { this.showConfirmDialog(); })
              this.DlgBtn('操作菜单', () => { this.showActionMenu(); })
            }

            DialogCardBox({ cardTitle: '自定义弹窗' }) {
              this.DlgBtn('自定义内容弹窗', () => { this.customDialogVisible = true; })
              this.DlgBtn('输入弹窗', () => { this.inputDialogVisible = true; this.dialogInput = ''; })
              this.DlgBtn('底部弹窗 Sheet', () => { this.bottomSheetVisible = true; })
            }

            DialogCardBox({ cardTitle: '提示 & 加载' }) {
              this.DlgBtn('Toast 短提示', () => { this.showToast('操作成功！'); })
              this.DlgBtn('Loading 加载', () => { this.showLoading(); })
            }

            DialogCardBox({ cardTitle: '弹窗组合示例' }) {
              Text('点击下方按钮体验组合弹窗流程').fontSize(13).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 12 })
              this.DlgBtn('提交审核流程', () => {
                promptAction.showDialog({
                  title: '提交审核',
                  message: '确认提交本次编辑内容进行审核？',
                  buttons: [
                    { text: '取消', color: $r('app.color.text_secondary') },
                    { text: '提交', color: $r('app.color.primary_color') },
                  ],
                }).then((result: promptAction.ShowDialogSuccessResponse) => {
                  if (result.index === 1) {
                    this.loadingVisible = true;
                    setTimeout(() => { this.loadingVisible = false; this.showToast('提交成功'); }, 1500);
                  }
                });
              })
            }

            Blank().height(20)
          }
          .width('100%').padding({ left: 16, right: 16 })
        }
        .scrollBar(BarState.Off).edgeEffect(EdgeEffect.Spring)
        .layoutWeight(1).backgroundColor($r('app.color.page_background'))
      }
      .width('100%').height('100%')

      if (this.customDialogVisible) { this.CustomDialog() }
      if (this.inputDialogVisible) { this.InputDialog() }
      if (this.bottomSheetVisible) { this.BottomSheet() }
      if (this.loadingVisible) { this.LoadingOverlay() }
    }
    .width('100%').height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }

  @Builder
  DlgBtn(label: string, action: () => void) {
    Button(label).type(ButtonType.Capsule).fontSize(14).width('100%').height(40).margin({ bottom: 8 })
      .backgroundColor($r('app.color.primary_light')).fontColor($r('app.color.primary_color'))
      .onClick(() => { action(); })
  }

  @Builder
  CustomDialog() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        Text('自定义弹窗').fontSize(18).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_primary')).width('100%')
        Text('这是一个完全自定义的弹窗组件，可以放置任意内容。').fontSize(14).fontColor($r('app.color.text_secondary')).margin({ top: 12 }).width('100%')
        Image($r('app.media.startIcon')).width(60).height(60).margin({ top: 16 })
        Row() {
          Button('关闭').type(ButtonType.Capsule).fontSize(14).layoutWeight(1).margin({ right: 8 })
            .backgroundColor($r('app.color.page_background')).fontColor($r('app.color.text_secondary'))
            .onClick(() => { this.customDialogVisible = false; })
          Button('确定').type(ButtonType.Capsule).fontSize(14).layoutWeight(1)
            .backgroundColor($r('app.color.primary_color'))
            .onClick(() => { this.customDialogVisible = false; this.showToast('已确定'); })
        }.width('100%').margin({ top: 20 })
      }
      .width('80%').padding(24).borderRadius(20).backgroundColor($r('app.color.card_background'))
    }
    .width('100%').height('100%').backgroundColor('rgba(0,0,0,0.5)')
    .onClick(() => { this.customDialogVisible = false; })
  }

  @Builder
  InputDialog() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        Text('输入内容').fontSize(18).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_primary')).width('100%')
        TextInput({ placeholder: '请输入...', text: this.dialogInput })
          .width('100%').height(44).borderRadius(8).margin({ top: 16 })
          .border({ width: 1, color: $r('app.color.divider_color') })
          .onChange((value: string) => { this.dialogInput = value; })
        Row() {
          Button('取消').type(ButtonType.Capsule).fontSize(14).layoutWeight(1).margin({ right: 8 })
            .backgroundColor($r('app.color.page_background')).fontColor($r('app.color.text_secondary'))
            .onClick(() => { this.inputDialogVisible = false; })
          Button('确定').type(ButtonType.Capsule).fontSize(14).layoutWeight(1)
            .backgroundColor($r('app.color.primary_color'))
            .onClick(() => { this.inputDialogVisible = false; this.showToast(`输入了: ${this.dialogInput}`); })
        }.width('100%').margin({ top: 20 })
      }
      .width('80%').padding(24).borderRadius(20).backgroundColor($r('app.color.card_background'))
    }
    .width('100%').height('100%').backgroundColor('rgba(0,0,0,0.5)')
    .onClick(() => { this.inputDialogVisible = false; })
  }

  @Builder
  BottomSheet() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        Text('底部弹窗').fontSize(18).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_primary')).width('100%').margin({ bottom: 8 })
        ForEach(['拍照', '从相册选择', '从文件选择'], (item: string, index: number) => {
          Row() {
            Text(item).fontSize(15).fontColor($r('app.color.text_primary')).layoutWeight(1)
            Text('›').fontSize(20).fontColor($r('app.color.text_hint'))
          }
          .width('100%').height(52).padding({ left: 16, right: 16 })
          .border({ width: { bottom: 1 }, color: $r('app.color.divider_color') })
          .onClick(() => { this.bottomSheetVisible = false; this.showToast(`选择了: ${item}`); })
        }, (item: string, index: number) => `sheet_${index}`)
        Button('取消').type(ButtonType.Capsule).fontSize(15).width('100%').height(44).margin({ top: 12 })
          .backgroundColor($r('app.color.page_background')).fontColor($r('app.color.text_secondary'))
          .onClick(() => { this.bottomSheetVisible = false; })
      }
      .width('100%').padding({ top: 16, bottom: 32, left: 16, right: 16 })
      .borderRadius({ topLeft: 20, topRight: 20 })
      .backgroundColor($r('app.color.card_background'))
    }
    .width('100%').height('100%').backgroundColor('rgba(0,0,0,0.5)')
    .onClick(() => { this.bottomSheetVisible = false; })
  }

  @Builder
  LoadingOverlay() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        LoadingProgress().width(48).height(48).color($r('app.color.primary_color'))
        Text('加载中...').fontSize(14).fontColor(Color.White).margin({ top: 12 })
      }
      .padding(24).borderRadius(16).backgroundColor('rgba(0,0,0,0.7)')
    }
    .width('100%').height('100%')
  }
}
