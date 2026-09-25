import { router } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';

class InfoRowData {
  label: string;
  value: string;
  constructor(label: string, value: string) {
    this.label = label;
    this.value = value;
  }
}

@Entry
@Component
struct DeviceInfoPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State infoList: InfoRowData[] = [];

  aboutToAppear(): void {
    this.loadInfo();
  }

  private loadInfo(): void {
    const context = getContext(this) as common.UIAbilityContext;
    const items: InfoRowData[] = [];

    try {
      items.push(new InfoRowData('缓存目录', context.cacheDir));
    } catch (e) { items.push(new InfoRowData('缓存目录', 'N/A')); }

    try {
      items.push(new InfoRowData('文件目录', context.filesDir));
    } catch (e) { items.push(new InfoRowData('文件目录', 'N/A')); }

    try {
      items.push(new InfoRowData('临时目录', context.tempDir));
    } catch (e) { items.push(new InfoRowData('临时目录', 'N/A')); }

    try {
      items.push(new InfoRowData('资源目录', context.resourceDir));
    } catch (e) { items.push(new InfoRowData('资源目录', 'N/A')); }

    try {
      items.push(new InfoRowData('数据库目录', context.databaseDir));
    } catch (e) { items.push(new InfoRowData('数据库目录', 'N/A')); }

    try {
      items.push(new InfoRowData('分布式文件目录', context.distributedFilesDir));
    } catch (e) { items.push(new InfoRowData('分布式文件目录', 'N/A')); }

    try {
      items.push(new InfoRowData('偏好数据目录', context.preferencesDir));
    } catch (e) { items.push(new InfoRowData('偏好数据目录', 'N/A')); }

    items.push(new InfoRowData('状态栏高度', `${this.statusBarHeight} px`));

    this.infoList = items;
  }

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24).fontColor([$r('app.color.text_primary')])
          .onClick(() => { router.back(); })
        Text('设备 & 应用信息').fontSize(18).fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary')).layoutWeight(1).margin({ left: 12 })
        Text('刷新').fontSize(14).fontColor($r('app.color.primary_color'))
          .onClick(() => { this.loadInfo(); })
      }
      .width('100%').height(56 + this.statusBarHeight)
      .padding({ left: 16, right: 16, top: this.statusBarHeight })
      .backgroundColor($r('app.color.card_background')).alignItems(VerticalAlign.Center)

      Scroll() {
        Column() {
          Text('应用上下文信息').fontSize(15).fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary')).width('100%').margin({ bottom: 12 })

          Text('通过 getContext(this) 获取 UIAbilityContext，可访问应用各种目录和配置。')
            .fontSize(12).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 16 })

          ForEach(this.infoList, (item: InfoRowData) => {
            Column() {
              Text(item.label).fontSize(12).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 4 })
              Text(item.value).fontSize(11).fontColor($r('app.color.text_primary')).width('100%')
                .maxLines(2).textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .width('100%').padding(12).borderRadius(8)
            .backgroundColor($r('app.color.card_background')).margin({ bottom: 8 })
            .shadow({ radius: 2, color: 'rgba(0,0,0,0.04)', offsetY: 1 })
          }, (item: InfoRowData) => item.label)

          // 说明卡片
          Column() {
            Text('HarmonyOS 设备信息获取方式').fontSize(14).fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary')).margin({ bottom: 12 })
            this.TipRow('getContext(this)', '获取 UIAbilityContext')
            this.TipRow('context.cacheDir', '缓存目录')
            this.TipRow('context.filesDir', '文件目录')
            this.TipRow('context.databaseDir', '数据库目录')
            this.TipRow('context.preferencesDir', '偏好设置目录')
            this.TipRow('@kit.DeviceInfoKit', '设备硬件信息（需 API 支持）')
            this.TipRow('window API', '窗口属性和避让区域')
            this.TipRow('AppStorage', '全局状态（如 statusBarHeight）')
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

  @Builder
  TipRow(api: string, desc: string) {
    Row() {
      Text(api).fontSize(11).fontColor($r('app.color.primary_color')).width(160)
      Text(desc).fontSize(11).fontColor($r('app.color.text_secondary')).layoutWeight(1)
    }.width('100%').height(28)
  }
}
