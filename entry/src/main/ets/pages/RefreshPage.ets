import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

class DataItem {
  id: number;
  title: string;
  desc: string;
  time: string;
  color: ResourceColor;

  constructor(id: number, title: string, desc: string, time: string, color: ResourceColor) {
    this.id = id;
    this.title = title;
    this.desc = desc;
    this.time = time;
    this.color = color;
  }
}

@Entry
@Component
struct RefreshPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State isRefreshing: boolean = false;
  @State isLoadingMore: boolean = false;
  @State dataList: DataItem[] = [];
  @State page: number = 1;
  @State hasMore: boolean = true;
  @State loadState: string = 'loading'; // loading | success | empty | error
  @State refreshCount: number = 0;

  private colors: ResourceColor[] = [
    $r('app.color.primary_color'),
    $r('app.color.success_color'),
    $r('app.color.warning_color'),
    $r('app.color.danger_color'),
  ];

  aboutToAppear(): void {
    this.loadData(true);
  }

  private loadData(isRefresh: boolean): void {
    if (isRefresh) {
      this.loadState = 'loading';
    } else {
      this.isLoadingMore = true;
    }

    // 模拟网络请求延迟
    setTimeout(() => {
      // 模拟 20% 概率出错
      if (Math.random() < 0.15 && this.refreshCount > 0) {
        if (isRefresh) {
          this.loadState = 'error';
          this.isRefreshing = false;
        } else {
          this.isLoadingMore = false;
          promptAction.showToast({ message: '加载更多失败' });
        }
        return;
      }

      const newItems: DataItem[] = [];
      const startId = isRefresh ? 0 : this.dataList.length;
      const count = isRefresh ? 10 : 5;

      for (let i = 0; i < count; i++) {
        const id = startId + i + 1;
        newItems.push(new DataItem(
          id,
          `数据条目 ${id}`,
          `这是第 ${id} 条数据的描述信息，包含一些示例文本内容。`,
          `${String(new Date().getHours()).padStart(2, '0')}:${String(new Date().getMinutes()).padStart(2, '0')}`,
          this.colors[id % 4]
        ));
      }

      if (isRefresh) {
        this.dataList = newItems;
        this.page = 1;
        this.refreshCount++;
        this.loadState = this.dataList.length === 0 ? 'empty' : 'success';
        this.isRefreshing = false;
        promptAction.showToast({ message: `刷新成功，共 ${this.dataList.length} 条` });
      } else {
        this.dataList = [...this.dataList, ...newItems];
        this.page++;
        this.isLoadingMore = false;
        // 超过 50 条不再加载
        if (this.dataList.length >= 50) {
          this.hasMore = false;
        }
      }
    }, isRefresh ? 1500 : 1000);
  }

  private onRefresh(): void {
    this.isRefreshing = true;
    this.hasMore = true;
    this.loadData(true);
  }

  private onLoadMore(): void {
    if (this.isLoadingMore || !this.hasMore) return;
    this.loadData(false);
  }

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24).fontColor([$r('app.color.text_primary')])
          .onClick(() => { router.back(); })
        Text('下拉刷新 & 列表').fontSize(18).fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary')).layoutWeight(1).margin({ left: 12 })
        Text(`${this.dataList.length} 条`).fontSize(13).fontColor($r('app.color.text_secondary'))
      }
      .width('100%').height(56 + this.statusBarHeight)
      .padding({ left: 16, right: 16, top: this.statusBarHeight })
      .backgroundColor($r('app.color.card_background')).alignItems(VerticalAlign.Center)

      // 状态统计
      Row() {
        Text(`刷新 ${this.refreshCount} 次`).fontSize(12).fontColor($r('app.color.text_secondary')).layoutWeight(1)
        Text(this.hasMore ? '可加载更多' : '已加载全部').fontSize(12)
          .fontColor(this.hasMore ? $r('app.color.primary_color') : $r('app.color.text_hint'))
      }
      .width('100%').padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor($r('app.color.card_background'))

      // 主内容区
      if (this.loadState === 'loading') {
        this.LoadingState()
      } else if (this.loadState === 'error') {
        this.ErrorState()
      } else if (this.loadState === 'empty') {
        this.EmptyState()
      } else {
        Refresh({ refreshing: $$this.isRefreshing }) {
          List({ space: 8 }) {
            ForEach(this.dataList, (item: DataItem) => {
              ListItem() {
                this.DataCard(item)
              }
            }, (item: DataItem) => `${item.id}`)

            // 上拉加载更多
            if (this.isLoadingMore) {
              ListItem() {
                Row() {
                  LoadingProgress().width(24).height(24).color($r('app.color.primary_color'))
                  Text('加载中...').fontSize(13).fontColor($r('app.color.text_secondary')).margin({ left: 8 })
                }.width('100%').height(50).justifyContent(FlexAlign.Center)
              }
            } else if (!this.hasMore) {
              ListItem() {
                Row() {
                  Divider().layoutWeight(1).color($r('app.color.divider_color'))
                  Text('没有更多了').fontSize(12).fontColor($r('app.color.text_hint')).margin({ left: 12, right: 12 })
                  Divider().layoutWeight(1).color($r('app.color.divider_color'))
                }.width('100%').height(40).justifyContent(FlexAlign.Center)
              }
            }
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 8, bottom: 16 })
          .onReachEnd(() => { this.onLoadMore(); })
        }
        .onRefreshing(() => { this.onRefresh(); })
        .layoutWeight(1)
        .backgroundColor($r('app.color.page_background'))
      }
    }
    .width('100%').height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }

  @Builder
  DataCard(item: DataItem) {
    Row() {
      // 左侧色条
      Column().width(4).height(48).borderRadius(2).backgroundColor(item.color).margin({ right: 12 })

      Column() {
        Text(item.title).fontSize(15).fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary')).width('100%')
        Text(item.desc).fontSize(12).fontColor($r('app.color.text_secondary'))
          .width('100%').margin({ top: 4 }).maxLines(2).textOverflow({ overflow: TextOverflow.Ellipsis })
      }.layoutWeight(1).alignItems(HorizontalAlign.Start)

      Text(item.time).fontSize(12).fontColor($r('app.color.text_hint'))
    }
    .width('100%').padding(12).borderRadius(12)
    .backgroundColor($r('app.color.card_background'))
    .shadow({ radius: 4, color: 'rgba(0,0,0,0.04)', offsetX: 0, offsetY: 1 })
  }

  @Builder
  LoadingState() {
    Column() {
      LoadingProgress().width(48).height(48).color($r('app.color.primary_color'))
      Text('加载中...').fontSize(14).fontColor($r('app.color.text_secondary')).margin({ top: 12 })
    }
    .width('100%').layoutWeight(1).justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.page_background'))
  }

  @Builder
  ErrorState() {
    Column() {
      SymbolGlyph($r('sys.symbol.exclamationmark_triangle'))
        .fontSize(48).fontColor([$r('app.color.danger_color')])
      Text('加载失败').fontSize(16).fontColor($r('app.color.text_primary')).margin({ top: 16 })
      Text('网络异常，请稍后重试').fontSize(13).fontColor($r('app.color.text_secondary')).margin({ top: 8 })
      Button('重新加载').type(ButtonType.Capsule).fontSize(14).height(40).width(120)
        .backgroundColor($r('app.color.primary_color')).margin({ top: 20 })
        .onClick(() => { this.loadData(true); })
    }
    .width('100%').layoutWeight(1).justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.page_background'))
  }

  @Builder
  EmptyState() {
    Column() {
      Text('📭').fontSize(48)
      Text('暂无数据').fontSize(16).fontColor($r('app.color.text_primary')).margin({ top: 16 })
      Button('刷新').type(ButtonType.Capsule).fontSize(14).height(40).width(120)
        .backgroundColor($r('app.color.primary_color')).margin({ top: 20 })
        .onClick(() => { this.onRefresh(); })
    }
    .width('100%').layoutWeight(1).justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.page_background'))
  }
}
