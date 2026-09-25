import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { abilityAccessCtrl, bundleManager, Permissions, common } from '@kit.AbilityKit';

class PermItem {
  name: Permissions;
  label: string;
  desc: string;
  group: string;
  granted: number = -1;

  constructor(name: Permissions, label: string, desc: string, group: string) {
    this.name = name;
    this.label = label;
    this.desc = desc;
    this.group = group;
  }
}

@Entry
@Component
struct PermissionPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State permList: PermItem[] = [];
  @State refreshing: boolean = false;

  private atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
  private tokenId: number = 0;

  private showToast(msg: string): void {
    promptAction.showToast({ message: msg, duration: 2000 });
  }

  aboutToAppear(): void {
    const bundleInfo = bundleManager.getBundleInfoForSelfSync(
      bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION
    );
    this.tokenId = bundleInfo.appInfo.accessTokenId;
    this.initPermList();
    this.checkAllPermissions();
  }

  private initPermList(): void {
    this.permList = [
      new PermItem('ohos.permission.CAMERA', '相机', '允许应用使用相机拍照或录像', '相机麦克风'),
      new PermItem('ohos.permission.MICROPHONE', '麦克风', '允许应用录制音频', '相机麦克风'),
      new PermItem('ohos.permission.READ_MEDIA', '读取媒体文件', '允许应用读取媒体文件', '媒体存储'),
      new PermItem('ohos.permission.WRITE_MEDIA', '写入媒体文件', '允许应用修改或删除媒体文件', '媒体存储'),
      new PermItem('ohos.permission.LOCATION', '精确位置', '允许应用获取精确地理位置信息', '位置信息'),
      new PermItem('ohos.permission.APPROXIMATELY_LOCATION', '模糊位置', '允许应用获取大致地理位置信息', '位置信息'),
    ];
  }

  private checkAllPermissions(): void {
    this.refreshing = true;
    const newList: PermItem[] = [];
    for (const perm of this.permList) {
      let status = -1;
      try {
        status = this.atManager.checkAccessTokenSync(this.tokenId, perm.name);
      } catch (e) {
        status = -1;
      }
      const item = new PermItem(perm.name, perm.label, perm.desc, perm.group);
      item.granted = status;
      newList.push(item);
    }
    this.permList = newList;
    this.refreshing = false;
  }

  private async requestPermission(perm: PermItem): Promise<void> {
    const context = getContext(this) as common.UIAbilityContext;
    try {
      const result = await this.atManager.requestPermissionsFromUser(context, [perm.name]);
      if (result.authResults[0] === 0) {
        this.showToast(`${perm.label} 权限已授予`);
      } else {
        this.showToast(`${perm.label} 权限被拒绝`);
      }
      this.checkAllPermissions();
    } catch (e) {
      this.showToast(`请求权限失败: ${(e as Error).message}`);
    }
  }

  private async requestAllPermissions(): Promise<void> {
    const context = getContext(this) as common.UIAbilityContext;
    const allPerms: Permissions[] = this.permList.map((p: PermItem) => p.name);
    try {
      const result = await this.atManager.requestPermissionsFromUser(context, allPerms);
      let grantedCount = 0;
      for (const auth of result.authResults) {
        if (auth === 0) grantedCount++;
      }
      this.showToast(`已授权 ${grantedCount}/${allPerms.length} 项权限`);
      this.checkAllPermissions();
    } catch (e) {
      this.showToast('批量请求权限失败');
    }
  }

  private getGroups(): string[] {
    const groups: string[] = [];
    for (const perm of this.permList) {
      if (!groups.includes(perm.group)) {
        groups.push(perm.group);
      }
    }
    return groups;
  }

  private getGroupPerms(group: string): PermItem[] {
    return this.permList.filter((p: PermItem) => p.group === group);
  }

  private getStatusText(status: number): string {
    if (status === -1) return '未声明';
    if (status === 0) return '已拒绝';
    return '已授权';
  }

  private getStatusColor(status: number): ResourceColor {
    if (status === -1) return $r('app.color.text_hint');
    if (status === 0) return $r('app.color.danger_color');
    return $r('app.color.success_color');
  }

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24).fontColor([$r('app.color.text_primary')])
          .onClick(() => { router.back(); })
        Text('系统权限').fontSize(18).fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary')).layoutWeight(1).margin({ left: 12 })
        Text('刷新').fontSize(14).fontColor($r('app.color.primary_color'))
          .onClick(() => { this.checkAllPermissions(); })
      }
      .width('100%').height(56 + this.statusBarHeight)
      .padding({ left: 16, right: 16, top: this.statusBarHeight })
      .backgroundColor($r('app.color.card_background')).alignItems(VerticalAlign.Center)

      // 统计栏
      Row() {
        Text(`共 ${this.permList.length} 项权限`).fontSize(13).fontColor($r('app.color.text_secondary')).layoutWeight(1)
        Text(`已授权 ${this.permList.filter((p: PermItem) => p.granted === 1).length} 项`)
          .fontSize(13).fontColor($r('app.color.success_color'))
        Text(` · 已拒绝 ${this.permList.filter((p: PermItem) => p.granted === 0).length} 项`)
          .fontSize(13).fontColor($r('app.color.danger_color'))
        Text(` · 未声明 ${this.permList.filter((p: PermItem) => p.granted === -1).length} 项`)
          .fontSize(13).fontColor($r('app.color.text_hint'))
      }
      .width('100%').padding({ left: 16, right: 16, top: 12, bottom: 8 })
      .backgroundColor($r('app.color.card_background'))

      // 权限列表
      Scroll() {
        Column() {
          // 批量请求按钮
          Button('一键请求所有权限').type(ButtonType.Capsule).fontSize(15).height(44)
            .width('100%').backgroundColor($r('app.color.primary_color'))
            .onClick(() => { this.requestAllPermissions(); })
            .margin({ top: 12, bottom: 12 })

          // 按分组展示
          ForEach(this.getGroups(), (group: string) => {
            Column() {
              Text(group).fontSize(15).fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary')).width('100%').margin({ bottom: 8 })

              ForEach(this.getGroupPerms(group), (perm: PermItem) => {
                Row() {
                  Column() {
                    Text(perm.label).fontSize(14).fontWeight(FontWeight.Medium)
                      .fontColor($r('app.color.text_primary')).width('100%')
                    Text(perm.desc).fontSize(12).fontColor($r('app.color.text_secondary'))
                      .width('100%').margin({ top: 2 })
                    Text(perm.name).fontSize(10).fontColor($r('app.color.text_hint'))
                      .width('100%').margin({ top: 2 }).maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
                  }.layoutWeight(1).alignItems(HorizontalAlign.Start)

                  Column() {
                    Text(this.getStatusText(perm.granted))
                      .fontSize(12).fontColor(this.getStatusColor(perm.granted))
                    Button(perm.granted === 1 ? '已授权' : '请求')
                      .type(ButtonType.Capsule).fontSize(12).height(28)
                      .margin({ top: 6 })
                      .backgroundColor(perm.granted === 1 ? $r('app.color.primary_light') : $r('app.color.primary_color'))
                      .fontColor(perm.granted === 1 ? $r('app.color.success_color') : Color.White)
                      .enabled(perm.granted !== 1)
                      .onClick(() => { this.requestPermission(perm); })
                  }.alignItems(HorizontalAlign.End)
                }
                .width('100%').padding(12).borderRadius(12)
                .backgroundColor($r('app.color.card_background')).margin({ bottom: 8 })
                .shadow({ radius: 4, color: 'rgba(0,0,0,0.04)', offsetX: 0, offsetY: 1 })
              }, (perm: PermItem) => perm.name)
            }
            .width('100%').margin({ top: 12 })
          }, (group: string) => group)

          Blank().height(20)
        }
        .width('100%').padding({ left: 16, right: 16 })
      }
      .scrollBar(BarState.Off).edgeEffect(EdgeEffect.Spring)
      .layoutWeight(1).backgroundColor($r('app.color.page_background'))
    }
    .width('100%').height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}
