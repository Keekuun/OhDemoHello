import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { preferences } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';

class PrefItem {
  key: string;
  value: string;
  constructor(key: string, value: string) {
    this.key = key;
    this.value = value;
  }
}

@Entry
@Component
struct StoragePage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State currentDemo: number = 0;
  @State prefData: PrefItem[] = [];
  @State prefKey: string = '';
  @State prefValue: string = '';
  @State persistName: string = '';
  @State persistAge: number = 0;
  @State persistTheme: string = 'light';

  aboutToAppear(): void {
    this.loadPreferences();
  }

  private async loadPreferences(): Promise<void> {
    try {
      const context = getContext(this) as common.UIAbilityContext;
      const pref = await preferences.getPreferences(context, 'my_pref_store');
      const all = await pref.getAll();
      const items: PrefItem[] = [];
      const keys = Object.keys(all);
      for (const key of keys) {
        items.push(new PrefItem(key, String((all as Record<string, Object>)[key])));
      }
      this.prefData = items;
    } catch (e) {
      promptAction.showToast({ message: '读取失败' });
    }
  }

  private async savePreference(): Promise<void> {
    if (this.prefKey.length === 0 || this.prefValue.length === 0) {
      promptAction.showToast({ message: '请输入键和值' });
      return;
    }
    try {
      const context = getContext(this) as common.UIAbilityContext;
      const pref = await preferences.getPreferences(context, 'my_pref_store');
      await pref.put(this.prefKey, this.prefValue);
      await pref.flush();
      promptAction.showToast({ message: '保存成功' });
      this.prefKey = '';
      this.prefValue = '';
      this.loadPreferences();
    } catch (e) {
      promptAction.showToast({ message: '保存失败' });
    }
  }

  private async deletePreference(key: string): Promise<void> {
    try {
      const context = getContext(this) as common.UIAbilityContext;
      const pref = await preferences.getPreferences(context, 'my_pref_store');
      await pref.delete(key);
      await pref.flush();
      promptAction.showToast({ message: '已删除' });
      this.loadPreferences();
    } catch (e) {}
  }

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24).fontColor([$r('app.color.text_primary')])
          .onClick(() => { router.back(); })
        Text('数据存储').fontSize(18).fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary')).layoutWeight(1).margin({ left: 12 })
      }
      .width('100%').height(56 + this.statusBarHeight)
      .padding({ left: 16, right: 16, top: this.statusBarHeight })
      .backgroundColor($r('app.color.card_background')).alignItems(VerticalAlign.Center)

      Row() {
        ForEach(['Preferences', '说明'], (label: string, index: number) => {
          Text(label).fontSize(12).padding({ left: 10, right: 10, top: 5, bottom: 5 })
            .borderRadius(14)
            .backgroundColor(this.currentDemo === index ? $r('app.color.primary_color') : $r('app.color.page_background'))
            .fontColor(this.currentDemo === index ? Color.White : $r('app.color.text_secondary'))
            .margin({ right: 6 })
            .onClick(() => { this.currentDemo = index; })
        }, (label: string) => label)
      }
      .width('100%').padding({ left: 16, top: 8, bottom: 8 })
      .backgroundColor($r('app.color.card_background'))

      Scroll() {
        Column() {
          if (this.currentDemo === 0) { this.PreferencesDemo() }
          if (this.currentDemo === 1) { this.ExplainDemo() }
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
  PreferencesDemo() {
    Column() {
      Text('Preferences — 轻量级 KV 存储').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).width('100%').margin({ bottom: 8 })
      Text('基于文件的键值对存储，支持异步读写，适合存储配置项。')
        .fontSize(12).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 16 })

      Column() {
        Text('添加/更新').fontSize(13).fontColor($r('app.color.text_primary')).margin({ bottom: 8 })
        Row() {
          TextInput({ text: this.prefKey, placeholder: '键' })
            .layoutWeight(1).height(38).borderRadius(8)
            .border({ width: 1, color: $r('app.color.divider_color') })
            .onChange((v: string) => { this.prefKey = v; })
          TextInput({ text: this.prefValue, placeholder: '值' })
            .layoutWeight(1).height(38).borderRadius(8).margin({ left: 8 })
            .border({ width: 1, color: $r('app.color.divider_color') })
            .onChange((v: string) => { this.prefValue = v; })
        }.width('100%').margin({ bottom: 8 })
        Button('保存').width('100%').fontSize(13).type(ButtonType.Capsule)
          .backgroundColor($r('app.color.primary_color')).fontColor(Color.White).height(38)
          .onClick(() => { this.savePreference(); })
      }
      .width('100%').padding(16).borderRadius(12).backgroundColor($r('app.color.card_background')).margin({ bottom: 12 })

      Column() {
        Text(`已存储数据 (${this.prefData.length} 项)`).fontSize(13).fontColor($r('app.color.text_primary')).margin({ bottom: 8 })
        if (this.prefData.length === 0) {
          Text('暂无数据，请添加键值对').fontSize(12).fontColor($r('app.color.text_hint')).margin({ top: 12, bottom: 12 })
        } else {
          ForEach(this.prefData, (item: PrefItem) => {
            Row() {
              Text(item.key).fontSize(12).fontColor($r('app.color.primary_color')).width(80)
              Text(item.value).fontSize(12).fontColor($r('app.color.text_secondary')).layoutWeight(1)
              Text('删除').fontSize(11).fontColor($r('app.color.danger_color'))
                .onClick(() => { this.deletePreference(item.key); })
            }
            .width('100%').height(36).padding({ left: 8, right: 8 })
            .border({ width: { bottom: 1 }, color: $r('app.color.divider_color') })
          }, (item: PrefItem) => item.key)
        }
      }
      .width('100%').padding(16).borderRadius(12).backgroundColor($r('app.color.card_background'))
    }.width('100%')
  }

  @Builder
  ExplainDemo() {
    Column() {
      Text('HarmonyOS 数据存储方案').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).width('100%').margin({ bottom: 16 })

      this.StorageCard('PersistentStorage', '全局持久化存储',
        '将数据写入磁盘，应用重启后自动恢复。\n配合 @StorageLink 使用。\n适合：主题、语言、登录状态')

      this.StorageCard('Preferences', '轻量级 KV 存储',
        '基于 XML 文件的键值对存储。\n异步 API，需 flush() 刷盘。\n适合：配置项、用户偏好')

      this.StorageCard('AppStorage', '全局内存存储',
        '应用级内存存储，重启后丢失。\n配合 @StorageLink / @StorageProp。\n适合：跨页面共享状态')

      this.StorageCard('LocalStorage', '页面级内存存储',
        '页面级隔离存储。\n配合 @LocalStorageLink / @LocalStorageProp。\n适合：页面独立状态')

      this.StorageCard('RDB', '关系型数据库',
        '@kit.ArkData relationalStore。\n支持 SQL 查询、事务。\n适合：大量结构化数据')

      this.StorageCard('DistributedDB', '分布式数据',
        '跨设备数据同步存储。\n适合：多端协同场景')

      Blank().height(20)
    }.width('100%')
  }

  @Builder
  StorageCard(title: string, subtitle: string, desc: string) {
    Column() {
      Text(title).fontSize(14).fontWeight(FontWeight.Bold).fontColor($r('app.color.primary_color')).width('100%')
      Text(subtitle).fontSize(12).fontColor($r('app.color.text_secondary')).margin({ top: 2 }).width('100%')
      Text(desc).fontSize(11).fontColor($r('app.color.text_hint')).margin({ top: 8 }).width('100%')
    }
    .width('100%').padding(16).borderRadius(12)
    .backgroundColor($r('app.color.card_background')).margin({ bottom: 12 })
    .shadow({ radius: 4, color: 'rgba(0,0,0,0.04)', offsetY: 1 })
  }
}
