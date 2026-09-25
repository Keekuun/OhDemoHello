import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

// 数据模型
class ListItemData {
  id: number;
  title: string;
  subtitle: string;
  tag: string;
  constructor(id: number, title: string, subtitle: string, tag: string) {
    this.id = id;
    this.title = title;
    this.subtitle = subtitle;
    this.tag = tag;
  }
}

// IDataSource 实现 — LazyForEach 的数据源
class ListDataSource implements IDataSource {
  private list: ListItemData[] = [];
  private listeners: DataChangeListener[] = [];

  totalCount(): number {
    return this.list.length;
  }

  getData(index: number): ListItemData {
    return this.list[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataReloaded();
    });
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataAdd(index);
    });
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataDelete(index);
    });
  }

  pushData(data: ListItemData): void {
    this.list.push(data);
    this.notifyDataAdd(this.list.length - 1);
  }

  reloadData(list: ListItemData[]): void {
    this.list = list;
    this.notifyDataReload();
  }

  deleteData(index: number): void {
    this.list.splice(index, 1);
    this.notifyDataDelete(index);
  }
}

// @Reusable 可复用列表项组件
@Reusable
@Component
struct ReusableListItem {
  @State item: ListItemData = new ListItemData(0, '', '', '');

  aboutToReuse(params: Record<string, Object>): void {
    this.item = params.item as ListItemData;
  }

  build() {
    Row() {
      Column() {
        Text(this.item.title).fontSize(15).fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary')).width('100%')
        Text(this.item.subtitle).fontSize(12).fontColor($r('app.color.text_secondary'))
          .width('100%').margin({ top: 4 }).maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
      }.layoutWeight(1).alignItems(HorizontalAlign.Start)

      Text(this.item.tag).fontSize(11).fontColor($r('app.color.primary_color'))
        .padding({ left: 8, right: 8, top: 3, bottom: 3 })
        .borderRadius(10).backgroundColor($r('app.color.primary_light'))
    }
    .width('100%').padding(12).borderRadius(12)
    .backgroundColor($r('app.color.card_background'))
    .shadow({ radius: 4, color: 'rgba(0,0,0,0.04)', offsetX: 0, offsetY: 1 })
  }
}

@Entry
@Component
struct ListPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State currentMode: number = 0; // 0=懒加载 1=分组列表 2=滑动删除
  @State groupData: Record<string, ListItemData[]> = {} as Record<string, ListItemData[]>;
  private dataSrc: ListDataSource = new ListDataSource();
  @State deleteList: ListItemData[] = [];

  aboutToAppear(): void {
    this.loadLazyData();
    this.loadGroupData();
    this.loadDeleteData();
  }

  private loadLazyData(): void {
    const list: ListItemData[] = [];
    for (let i = 1; i <= 100; i++) {
      list.push(new ListItemData(i, `懒加载项 ${i}`, `这是第 ${i} 个通过 LazyForEach 渲染的列表项`, `#${i}`));
    }
    this.dataSrc.reloadData(list);
  }

  private loadGroupData(): void {
    const groups: string[] = ['字母 A', '字母 B', '字母 C'];
    const data: Record<string, ListItemData[]> = {} as Record<string, ListItemData[]>;
    for (const g of groups) {
      const items: ListItemData[] = [];
      for (let i = 1; i <= 5; i++) {
        items.push(new ListItemData(i, `${g} - 项 ${i}`, `分组 ${g} 下的第 ${i} 条`, g));
      }
      data[g] = items;
    }
    this.groupData = data;
  }

  private loadDeleteData(): void {
    const list: ListItemData[] = [];
    for (let i = 1; i <= 20; i++) {
      list.push(new ListItemData(i, `可删除项 ${i}`, `左滑或右滑可删除此条目`, `ID:${i}`));
    }
    this.deleteList = list;
  }

  private getGroupKeys(): string[] {
    return Object.keys(this.groupData);
  }

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24).fontColor([$r('app.color.text_primary')])
          .onClick(() => { router.back(); })
        Text('列表 & 懒加载').fontSize(18).fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary')).layoutWeight(1).margin({ left: 12 })
      }
      .width('100%').height(56 + this.statusBarHeight)
      .padding({ left: 16, right: 16, top: this.statusBarHeight })
      .backgroundColor($r('app.color.card_background')).alignItems(VerticalAlign.Center)

      // 模式切换
      Row() {
        ForEach(['LazyForEach', '分组列表', '滑动删除'], (label: string, index: number) => {
          Text(label).fontSize(13).padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .borderRadius(16)
            .backgroundColor(this.currentMode === index ? $r('app.color.primary_color') : $r('app.color.page_background'))
            .fontColor(this.currentMode === index ? Color.White : $r('app.color.text_secondary'))
            .onClick(() => { this.currentMode = index; })
        }, (label: string) => label)
      }
      .width('100%').padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor($r('app.color.card_background')).justifyContent(FlexAlign.Center)

      // 内容区
      if (this.currentMode === 0) {
        this.LazyListContent()
      } else if (this.currentMode === 1) {
        this.GroupListContent()
      } else {
        this.SwipeDeleteContent()
      }
    }
    .width('100%').height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }

  @Builder
  LazyListContent() {
    Scroll() {
      Column() {
        Text('LazyForEach + @Reusable — 100 条数据仅渲染可见项').fontSize(12)
          .fontColor($r('app.color.text_hint')).width('100%').padding({ top: 8, bottom: 8 })

        List({ space: 8 }) {
          LazyForEach(this.dataSrc, (item: ListItemData) => {
            ListItem() {
              ReusableListItem({ item: item })
            }
          }, (item: ListItemData) => `${item.id}`)
        }
        .width('100%').padding({ left: 16, right: 16, bottom: 16 })
        .cachedCount(5) // 缓存 5 个屏幕外的项
      }
      .width('100%')
    }
    .scrollBar(BarState.Off).edgeEffect(EdgeEffect.Spring)
    .layoutWeight(1).backgroundColor($r('app.color.page_background'))
  }

  @Builder
  GroupListContent() {
    Scroll() {
      Column() {
        Text('ListItemGroup — 分组列表带粘性标题').fontSize(12)
          .fontColor($r('app.color.text_hint')).width('100%').padding({ top: 8, bottom: 8 })

        List({ space: 8 }) {
          ForEach(this.getGroupKeys(), (key: string) => {
            ListItemGroup({ header: this.GroupHeader(key) }) {
              ForEach(this.groupData[key], (item: ListItemData) => {
                ListItem() {
                  Row() {
                    Column() {
                      Text(item.title).fontSize(14).fontColor($r('app.color.text_primary')).width('100%')
                      Text(item.subtitle).fontSize(12).fontColor($r('app.color.text_secondary')).width('100%').margin({ top: 2 })
                    }.layoutWeight(1).alignItems(HorizontalAlign.Start)
                    Text(item.tag).fontSize(11).fontColor($r('app.color.success_color'))
                  }
                  .width('100%').padding(12).borderRadius(8)
                  .backgroundColor($r('app.color.card_background'))
                }
              }, (item: ListItemData) => `${key}_${item.id}`)
            }
          }, (key: string) => key)
        }
        .width('100%').padding({ left: 16, right: 16, bottom: 16 })
      }
      .width('100%')
    }
    .scrollBar(BarState.Off).edgeEffect(EdgeEffect.Spring)
    .layoutWeight(1).backgroundColor($r('app.color.page_background'))
  }

  @Builder
  GroupHeader(title: string) {
    Text(title).fontSize(14).fontWeight(FontWeight.Bold)
      .fontColor($r('app.color.primary_color')).width('100%')
      .padding({ left: 12, top: 8, bottom: 4 })
  }

  @Builder
  SwipeDeleteContent() {
    Scroll() {
      Column() {
        Text('左滑/右滑列表项可删除 — 剩余 ' + this.deleteList.length + ' 条').fontSize(12)
          .fontColor($r('app.color.text_hint')).width('100%').padding({ top: 8, bottom: 8 })

        List({ space: 8 }) {
          ForEach(this.deleteList, (item: ListItemData, index: number) => {
            ListItem() {
              Row() {
                Column() {
                  Text(item.title).fontSize(14).fontWeight(FontWeight.Medium).fontColor($r('app.color.text_primary')).width('100%')
                  Text(item.subtitle).fontSize(12).fontColor($r('app.color.text_secondary')).width('100%').margin({ top: 2 })
                }.layoutWeight(1).alignItems(HorizontalAlign.Start)
                Text(item.tag).fontSize(11).fontColor($r('app.color.text_hint'))
              }
              .width('100%').padding(12).borderRadius(12)
              .backgroundColor($r('app.color.card_background'))
            }
            .swipeAction({
              start: {
                builder: () => {
                  Button('删除').type(ButtonType.Capsule).fontSize(13).height(40)
                    .backgroundColor($r('app.color.danger_color'))
                    .onClick(() => {
                      this.deleteList = this.deleteList.filter((d: ListItemData) => d.id !== item.id);
                      promptAction.showToast({ message: `已删除 ${item.title}` });
                    })
                }
              }
            })
          }, (item: ListItemData) => `${item.id}`)
        }
        .width('100%').padding({ left: 16, right: 16, bottom: 16 })
      }
      .width('100%')
    }
    .scrollBar(BarState.Off).edgeEffect(EdgeEffect.Spring)
    .layoutWeight(1).backgroundColor($r('app.color.page_background'))
  }
}
