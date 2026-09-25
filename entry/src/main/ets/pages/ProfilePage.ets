import { promptAction } from '@kit.ArkUI';
import { router } from '@kit.ArkUI';

class MenuGroup {
  items: MenuItem[];

  constructor(items: MenuItem[]) {
    this.items = items;
  }
}

class MenuItem {
  icon: Resource;
  name: string;
  badge: string;
  route: string;

  constructor(icon: Resource, name: string, badge: string, route: string = '') {
    this.icon = icon;
    this.name = name;
    this.badge = badge;
    this.route = route;
  }
}

@Component
export struct ProfilePage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State editMode: boolean = false;

  @State menuGroups: MenuGroup[] = [
    new MenuGroup([
      new MenuItem($r('sys.symbol.heart_fill'), '我的收藏', ''),
      new MenuItem($r('sys.symbol.ohos_folder_badge_plus'), '浏览历史', ''),
      new MenuItem($r('sys.symbol.checkmark_circle'), '我的订单', '2'),
    ]),
    new MenuGroup([
      new MenuItem($r('sys.symbol.ohos_folder_badge_plus'), '钱包', ''),
      new MenuItem($r('sys.symbol.bell_fill'), '帮助与反馈', '', 'pages/FeedbackPage'),
      new MenuItem($r('sys.symbol.info_circle'), '关于我们', '', 'pages/AboutPage'),
    ]),
  ];

  private showToast(msg: string): void {
    promptAction.showToast({ message: msg, duration: 2000 });
  }

  build() {
    Column() {
      // 固定标题栏
      Text($r('app.string.profile_title'))
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .width('100%')
        .height(56 + this.statusBarHeight)
        .padding({ left: 16, top: this.statusBarHeight })
        .backgroundColor($r('app.color.card_background'))

      // 可滚动内容区
      Scroll() {
        Column() {
          this.ProfileHeader()
          this.StatsSection()

          ForEach(this.menuGroups, (group: MenuGroup, groupIndex: number) => {
            this.MenuGroupSection(group, groupIndex)
          }, (group: MenuGroup, groupIndex: number) => `group_${groupIndex}`)

          Button('退出登录')
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width('100%')
            .height(48)
            .backgroundColor($r('app.color.primary_light'))
            .fontColor($r('app.color.danger_color'))
            .margin({ top: 24 })
            .onClick(() => {
              this.showToast('已退出登录');
            })

          Blank().height(20)
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
      }
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .layoutWeight(1)
      .backgroundColor($r('app.color.page_background'))
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.page_background'))
  }

  @Builder
  ProfileHeader() {
    Column() {
      Row() {
        // 头像
        Column() {
          Text('H')
            .fontSize(36)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
        }
        .width(72)
        .height(72)
        .borderRadius(36)
        .linearGradient({ angle: 135, colors: [[$r('app.color.gradient_start'), 0], [$r('app.color.gradient_end'), 1]] })
        .justifyContent(FlexAlign.Center)

        Column() {
          Row() {
            Text($r('app.string.profile_name'))
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text('官方认证')
              .fontSize(11)
              .fontColor(Color.White)
              .backgroundColor($r('app.color.warning_color'))
              .borderRadius(4)
              .padding({ left: 6, top: 2, right: 6, bottom: 2 })
              .margin({ left: 8 })
          }

          Text($r('app.string.profile_desc'))
            .fontSize(13)
            .fontColor($r('app.color.text_secondary'))
            .margin({ top: 6 })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
        .margin({ left: 16 })

        // 编辑按钮
        Text('···')
          .fontSize(24)
          .fontColor($r('app.color.text_secondary'))
          .onClick(() => {
            this.editMode = !this.editMode;
            this.showToast(this.editMode ? '进入编辑模式' : '退出编辑模式');
          })
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .padding({ top: 24, bottom: 24, left: 20, right: 20 })
    .borderRadius(16)
    .backgroundColor($r('app.color.card_background'))
    .margin({ top: 16 })
    .shadow({ radius: 6, color: 'rgba(0,0,0,0.06)', offsetX: 0, offsetY: 2 })
  }

  @Builder
  StatsSection() {
    Row() {
      this.StatItem('128', $r('app.string.profile_stat_posts'))
      this.StatDivider()
      this.StatItem('5.2万', $r('app.string.profile_stat_followers'))
      this.StatDivider()
      this.StatItem('326', $r('app.string.profile_stat_following'))
    }
    .width('100%')
    .padding({ top: 20, bottom: 20 })
    .borderRadius(16)
    .backgroundColor($r('app.color.card_background'))
    .margin({ top: 16 })
    .shadow({ radius: 6, color: 'rgba(0,0,0,0.06)', offsetX: 0, offsetY: 2 })
    .justifyContent(FlexAlign.SpaceEvenly)
  }

  @Builder
  StatItem(value: string, label: ResourceStr) {
    Column() {
      Text(value)
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))

      Text(label)
        .fontSize(13)
        .fontColor($r('app.color.text_secondary'))
        .margin({ top: 4 })
    }
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.showToast(`查看${label}`);
    })
  }

  @Builder
  StatDivider() {
    Column()
      .width(1)
      .height(32)
      .backgroundColor($r('app.color.divider_color'))
  }

  @Builder
  MenuGroupSection(group: MenuGroup, groupIndex: number) {
    Column() {
      ForEach(group.items, (item: MenuItem, index: number) => {
        Row() {
          SymbolGlyph(item.icon)
            .fontSize(20)
            .fontColor([$r('app.color.primary_color')])

          Text(item.name)
            .fontSize(16)
            .fontColor($r('app.color.text_primary'))
            .margin({ left: 12 })
            .layoutWeight(1)

          if (item.badge.length > 0) {
            Text(item.badge)
              .fontSize(11)
              .fontColor(Color.White)
              .backgroundColor($r('app.color.badge_color'))
              .borderRadius(10)
              .height(18)
              .minFontSize(9)
              .padding({ left: 5, right: 5 })
              .textAlign(TextAlign.Center)
              .margin({ right: 8 })
          }

          SymbolGlyph($r('sys.symbol.chevron_right'))
            .fontSize(16)
            .fontColor([$r('app.color.text_hint')])
        }
        .width('100%')
        .padding({ left: 16, top: 14, right: 16, bottom: 14 })
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
        .onClick(() => {
          if (item.route.length > 0) {
            router.pushUrl({ url: item.route });
          } else {
            this.showToast(item.name);
          }
        })

        if (index < group.items.length - 1) {
          Divider().color($r('app.color.divider_color')).margin({ left: 16 })
        }
      }, (item: MenuItem, index: number) => `${groupIndex}_${index}_${item.name}`)
    }
    .width('100%')
    .borderRadius(16)
    .backgroundColor($r('app.color.card_background'))
    .margin({ top: 16 })
    .shadow({ radius: 6, color: 'rgba(0,0,0,0.06)', offsetX: 0, offsetY: 2 })
  }
}
