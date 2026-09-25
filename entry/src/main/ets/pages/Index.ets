import { HomePage } from './HomePage';
import { DiscoverPage } from './DiscoverPage';
import { MessagePage } from './MessagePage';
import { ComponentsPage } from './ComponentsPage';
import { ProfilePage } from './ProfilePage';

@Entry
@Component
struct Index {
  @State currentTabIndex: number = 0;

  // Tab 配置
  private tabIconsNormal: Resource[] = [
    $r('sys.symbol.house'),
    $r('sys.symbol.heart'),
    $r('sys.symbol.bell'),
    $r('sys.symbol.bolt'),
    $r('sys.symbol.person'),
  ];
  private tabIconsSelected: Resource[] = [
    $r('sys.symbol.house_fill'),
    $r('sys.symbol.heart_fill'),
    $r('sys.symbol.bell_fill'),
    $r('sys.symbol.bolt_fill'),
    $r('sys.symbol.person_fill'),
  ];
  private tabLabels: ResourceStr[] = [
    $r('app.string.tab_home'),
    $r('app.string.tab_discover'),
    $r('app.string.tab_message'),
    $r('app.string.tab_components'),
    $r('app.string.tab_profile'),
  ];

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, index: this.currentTabIndex }) {
        TabContent() { HomePage() }.tabBar(this.TabBar(0))
        TabContent() { DiscoverPage() }.tabBar(this.TabBar(1))
        TabContent() { MessagePage() }.tabBar(this.TabBar(2))
        TabContent() { ComponentsPage() }.tabBar(this.TabBar(3))
        TabContent() { ProfilePage() }.tabBar(this.TabBar(4))
      }
      .barWidth('100%')
      .barHeight(64)
      .onChange((index: number) => { this.currentTabIndex = index; })
      .scrollable(true)
      .animationDuration(300)
    }
    .width('100%')
    .height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }

  @Builder
  TabBar(index: number) {
    Column() {
      SymbolGlyph(this.currentTabIndex === index ? this.tabIconsSelected[index] : this.tabIconsNormal[index])
        .fontSize(24)
        .fontColor([this.currentTabIndex === index ? $r('app.color.primary_color') : $r('app.color.text_hint')])

      Text(this.tabLabels[index])
        .fontSize(11)
        .fontColor(this.currentTabIndex === index ? $r('app.color.primary_color') : $r('app.color.text_hint'))
        .margin({ top: 2 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.tab_bar_background'))
  }
}
