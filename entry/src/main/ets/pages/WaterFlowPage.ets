import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

class FlowItemData {
  id: number;
  height: number;
  color: string;
  label: string;
  constructor(id: number, height: number, color: string, label: string) {
    this.id = id;
    this.height = height;
    this.color = color;
    this.label = label;
  }
}

@Entry
@Component
struct WaterFlowPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State flowData: FlowItemData[] = [];
  @State columns: number = 2;
  @State loadingMore: boolean = false;

  private colorPalette: string[] = [
    '#007DFF', '#36D372', '#FF9F0A', '#FF4D4F', '#9B59B6',
    '#1ABC9C', '#E74C3C', '#3498DB', '#F39C12', '#2ECC71',
  ];

  aboutToAppear(): void {
    this.generateData(20);
  }

  private generateData(count: number): void {
    const newItems: FlowItemData[] = [];
    const startId = this.flowData.length;
    for (let i = 0; i < count; i++) {
      const id = startId + i + 1;
      const height = 80 + Math.floor(Math.random() * 160); // 80~240vp
      const color = this.colorPalette[id % 10];
      newItems.push(new FlowItemData(id, height, color, `#${id}`));
    }
    this.flowData = [...this.flowData, ...newItems];
  }

  private onLoadMore(): void {
    if (this.loadingMore) return;
    this.loadingMore = true;
    setTimeout(() => {
      this.generateData(10);
      this.loadingMore = false;
    }, 800);
  }

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24).fontColor([$r('app.color.text_primary')])
          .onClick(() => { router.back(); })
        Text('瀑布流布局').fontSize(18).fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary')).layoutWeight(1).margin({ left: 12 })
      }
      .width('100%').height(56 + this.statusBarHeight)
      .padding({ left: 16, right: 16, top: this.statusBarHeight })
      .backgroundColor($r('app.color.card_background')).alignItems(VerticalAlign.Center)

      // 列数切换
      Row() {
        Text('列数：').fontSize(13).fontColor($r('app.color.text_secondary'))
        ForEach([2, 3, 4], (col: number) => {
          Text(`${col} 列`).fontSize(13).padding({ left: 10, right: 10, top: 5, bottom: 5 })
            .borderRadius(14)
            .backgroundColor(this.columns === col ? $r('app.color.primary_color') : $r('app.color.page_background'))
            .fontColor(this.columns === col ? Color.White : $r('app.color.text_secondary'))
            .margin({ left: 6 })
            .onClick(() => { this.columns = col; })
        }, (col: number) => `${col}`)
        Text(`  共 ${this.flowData.length} 项`).fontSize(12).fontColor($r('app.color.text_hint')).margin({ left: 8 })
      }
      .width('100%').padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor($r('app.color.card_background')).alignItems(VerticalAlign.Center)

      // 瀑布流
      WaterFlow() {
        ForEach(this.flowData, (item: FlowItemData) => {
          FlowItem() {
            Column() {
              Text(item.label).fontSize(14).fontWeight(FontWeight.Bold).fontColor(Color.White)
              Text(`${item.height}vp`).fontSize(11).fontColor(Color.White).margin({ top: 4 }).opacity(0.8)
              // 模拟图片占位
              Column().width('100%').layoutWeight(1).borderRadius(8)
                .backgroundColor('rgba(255,255,255,0.15)').margin({ top: 8 })
            }
            .width('100%').height(item.height).padding(8).borderRadius(12)
            .backgroundColor(item.color)
            .shadow({ radius: 4, color: 'rgba(0,0,0,0.1)', offsetX: 0, offsetY: 2 })
          }
        }, (item: FlowItemData) => `${item.id}`)
      }
      .columnsTemplate(this.columns === 2 ? '1fr 1fr' : this.columns === 3 ? '1fr 1fr 1fr' : '1fr 1fr 1fr 1fr')
      .columnsGap(8).rowsGap(8)
      .padding({ left: 16, right: 16, top: 8, bottom: 16 })
      .layoutWeight(1).backgroundColor($r('app.color.page_background'))
      .onReachEnd(() => { this.onLoadMore(); })
    }
    .width('100%').height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}
