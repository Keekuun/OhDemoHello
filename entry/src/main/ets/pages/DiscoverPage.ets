import { promptAction } from '@kit.ArkUI';
import { router } from '@kit.ArkUI';

// 分类项
class CategoryItem {
  icon: Resource;
  name: string;
  color: ResourceColor;

  constructor(icon: Resource, name: string, color: ResourceColor) {
    this.icon = icon;
    this.name = name;
    this.color = color;
  }
}

// 热门推荐项
class HotItem {
  title: string;
  tag: string;
  hot: number;
  gradient: [ResourceColor, ResourceColor];

  constructor(title: string, tag: string, hot: number, gradient: [ResourceColor, ResourceColor]) {
    this.title = title;
    this.tag = tag;
    this.hot = hot;
    this.gradient = gradient;
  }
}

@Component
export struct DiscoverPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State currentBanner: number = 0;
  private bannerTimerId: number = -1;

  @State categories: CategoryItem[] = [
    new CategoryItem($r('sys.symbol.heart_fill'), '生活', $r('app.color.danger_color')),
    new CategoryItem($r('sys.symbol.bolt_fill'), '科技', $r('app.color.warning_color')),
    new CategoryItem($r('sys.symbol.ohos_wifi'), '旅行', $r('app.color.success_color')),
    new CategoryItem($r('sys.symbol.checkmark_circle'), '健康', $r('app.color.primary_color')),
    new CategoryItem($r('sys.symbol.bell_fill'), '资讯', $r('app.color.danger_color')),
    new CategoryItem($r('sys.symbol.play_fill'), '娱乐', $r('app.color.warning_color')),
    new CategoryItem($r('sys.symbol.moon_fill'), '阅读', $r('app.color.primary_color')),
    new CategoryItem($r('sys.symbol.ohos_folder_badge_plus'), '更多', $r('app.color.text_hint')),
  ];

  @State hotList: HotItem[] = [
    new HotItem('HarmonyOS NEXT 开发指南', '热门', 9865,
      [$r('app.color.gradient_start'), $r('app.color.gradient_end')]),
    new HotItem('ArkTS 声明式语法详解', '新课', 7521,
      [$r('app.color.banner_orange_start'), $r('app.color.banner_orange_end')]),
    new HotItem('分布式跨端开发实践', '推荐', 6320,
      [$r('app.color.banner_green_start'), $r('app.color.banner_green_end')]),
    new HotItem('元服务开发从入门到精通', '精品', 5188,
      [$r('app.color.banner_purple_start'), $r('app.color.banner_purple_end')]),
  ];

  aboutToAppear(): void {
    this.bannerTimerId = setInterval(() => {
      this.currentBanner = (this.currentBanner + 1) % 3;
    }, 3000);
  }

  aboutToDisappear(): void {
    clearInterval(this.bannerTimerId);
  }

  private showToast(msg: string): void {
    promptAction.showToast({ message: msg, duration: 2000 });
  }

  build() {
    Column() {
      // 固定搜索栏
      this.SearchBar()

      // 可滚动内容区
      Scroll() {
        Column() {
          this.BannerSection()
          this.CategoryGrid()
          this.HotListSection()
          this.RankingSection()
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
  SearchBar() {
    Column() {
      Text($r('app.string.discover_title'))
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .width('100%')
        .margin({ top: 8 })

      Row() {
        Text('🔍')
          .fontSize(18)
          .fontColor($r('app.color.text_hint'))

        Text($r('app.string.discover_search_hint'))
          .fontSize(14)
          .fontColor($r('app.color.text_hint'))
          .margin({ left: 8 })
          .layoutWeight(1)
      }
      .width('100%')
      .height(44)
      .padding({ left: 16, right: 16 })
      .borderRadius(22)
      .backgroundColor($r('app.color.page_background'))
      .margin({ top: 8 })
      .onClick(() => {
        this.showToast('搜索功能开发中');
      })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: this.statusBarHeight, bottom: 8 })
    .backgroundColor($r('app.color.card_background'))
  }

  @Builder
  BannerSection() {
    Swiper() {
      // Banner 1
      Column() {
        Text('🎉 HarmonyOS NEXT')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
        Text('纯血鸿蒙，正式发布')
          .fontSize(14)
          .fontColor('rgba(255,255,255,0.9)')
          .margin({ top: 8 })
      }
      .width('100%')
      .height(160)
      .borderRadius(16)
      .linearGradient({ angle: 135, colors: [[$r('app.color.gradient_start'), 0], [$r('app.color.gradient_end'), 1]] })
      .justifyContent(FlexAlign.Center)

      // Banner 2
      Column() {
        Text('🚀 ArkTS 2.0')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
        Text('更强大的类型系统')
          .fontSize(14)
          .fontColor('rgba(255,255,255,0.9)')
          .margin({ top: 8 })
      }
      .width('100%')
      .height(160)
      .borderRadius(16)
      .linearGradient({ angle: 135, colors: [[$r('app.color.banner_orange_start'), 0], [$r('app.color.banner_orange_end'), 1]] })
      .justifyContent(FlexAlign.Center)

      // Banner 3
      Column() {
        Text('🌟 开发者社区')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
        Text('加入我们，共建生态')
          .fontSize(14)
          .fontColor('rgba(255,255,255,0.9)')
          .margin({ top: 8 })
      }
      .width('100%')
      .height(160)
      .borderRadius(16)
      .linearGradient({ angle: 135, colors: [[$r('app.color.banner_green_start'), 0], [$r('app.color.banner_green_end'), 1]] })
      .justifyContent(FlexAlign.Center)
    }
    .autoPlay(true)
    .interval(3000)
    .indicator(true)
    .indicatorStyle({ size: 6, color: 'rgba(255,255,255,0.4)', selectedColor: Color.White })
    .borderRadius(16)
    .margin({ top: 16 })
  }

  @Builder
  CategoryGrid() {
    Column() {
      this.SectionTitle($r('app.string.discover_categories'))

      Grid() {
        ForEach(this.categories, (item: CategoryItem) => {
          GridItem() {
            Column() {
              Row() {
                SymbolGlyph(item.icon)
                  .fontSize(24)
                  .fontColor([item.color])
              }
              .width(48)
              .height(48)
              .borderRadius(24)
              .backgroundColor($r('app.color.primary_light'))
              .justifyContent(FlexAlign.Center)

              Text(item.name)
                .fontSize(13)
                .fontColor($r('app.color.text_secondary'))
                .margin({ top: 8 })
            }
            .justifyContent(FlexAlign.Center)
            .onClick(() => {
              this.showToast(`分类：${item.name}`);
            })
          }
        }, (item: CategoryItem) => item.name)
      }
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .rowsGap(16)
      .columnsGap(8)
      .height(180)
      .margin({ top: 16 })
    }
    .width('100%')
    .padding(20)
    .borderRadius(16)
    .backgroundColor($r('app.color.card_background'))
    .margin({ top: 16 })
    .shadow({ radius: 6, color: 'rgba(0,0,0,0.06)', offsetX: 0, offsetY: 2 })
  }

  @Builder
  HotListSection() {
    Column() {
      this.SectionTitle($r('app.string.discover_hot'))

      ForEach(this.hotList, (item: HotItem, index: number) => {
        Row() {
          // 排名
          Text(`${index + 1}`)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(index < 3 ? $r('app.color.danger_color') : $r('app.color.text_hint'))
            .width(32)
            .textAlign(TextAlign.Center)

          // 卡片
          Column() {
            Text(item.title)
              .fontSize(15)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.text_primary'))
              .maxLines(1)

            Row() {
              Text(item.tag)
                .fontSize(11)
                .fontColor(Color.White)
                .padding({ left: 6, top: 2, right: 6, bottom: 2 })
                .borderRadius(4)
                .backgroundColor(item.gradient[0])

              Text(`${item.hot} 热度`)
                .fontSize(12)
                .fontColor($r('app.color.text_hint'))
                .margin({ left: 8 })
            }
            .margin({ top: 6 })
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
          .margin({ left: 12 })
        }
        .width('100%')
        .padding({ top: 12, bottom: 12 })
        .alignItems(VerticalAlign.Center)
        .onClick(() => {
          router.pushUrl({ url: 'pages/DetailPage', params: { title: item.title, desc: `热度：${item.hot}` } });
        })

        if (index < this.hotList.length - 1) {
          Divider().color($r('app.color.divider_color'))
        }
      }, (item: HotItem, index: number) => `${index}_${item.title}`)
    }
    .width('100%')
    .padding(20)
    .borderRadius(16)
    .backgroundColor($r('app.color.card_background'))
    .margin({ top: 16 })
    .shadow({ radius: 6, color: 'rgba(0,0,0,0.06)', offsetX: 0, offsetY: 2 })
  }

  @Builder
  RankingSection() {
    Column() {
      this.SectionTitle($r('app.string.discover_ranking'))

      ForEach(['🥇 鸿蒙原生应用大赛', '🥈 最佳开源项目评选', '🥉 开发者故事征集'], (item: string, index: number) => {
        Row() {
          Text(item)
            .fontSize(15)
            .fontColor($r('app.color.text_primary'))
            .layoutWeight(1)

          Text('参与')
            .fontSize(13)
            .fontColor($r('app.color.primary_color'))
        }
        .width('100%')
        .padding({ top: 14, bottom: 14 })
        .justifyContent(FlexAlign.SpaceBetween)
        .onClick(() => {
          this.showToast(item);
        })

        if (index < 2) {
          Divider().color($r('app.color.divider_color'))
        }
      }, (item: string) => item)
    }
    .width('100%')
    .padding(20)
    .borderRadius(16)
    .backgroundColor($r('app.color.card_background'))
    .margin({ top: 16 })
    .shadow({ radius: 6, color: 'rgba(0,0,0,0.06)', offsetX: 0, offsetY: 2 })
  }

  @Builder
  SectionTitle(title: ResourceStr) {
    Row() {
      Column()
        .width(4)
        .height(16)
        .borderRadius(2)
        .backgroundColor($r('app.color.primary_color'))

      Text(title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .margin({ left: 8 })
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
  }
}
