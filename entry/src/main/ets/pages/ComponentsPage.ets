import { promptAction } from '@kit.ArkUI';
import { router } from '@kit.ArkUI';

@Component
struct CardBox {
  @BuilderParam content: () => void;
  build() {
    Column() { this.content() }
    .width('100%').padding(16).borderRadius(16)
    .backgroundColor($r('app.color.card_background')).margin({ top: 8 })
    .shadow({ radius: 6, color: 'rgba(0,0,0,0.06)', offsetX: 0, offsetY: 2 })
  }
}

@Component
export struct ComponentsPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State btnLoading: boolean = false;
  @State sliderValue: number = 30;
  @State progressValue: number = 0;
  @State ratingValue: number = 3;
  @State toggleOn: boolean = true;
  @State checkbox1: boolean = true;
  @State checkbox2: boolean = false;
  @State checkbox3: boolean = true;
  @State radioIndex: number = 0;
  @State selectIndex: number = 0;
  @State textInput: string = '';
  @State textArea: string = '';
  @State progressRunning: boolean = false;
  private progressTimer: number = -1;

  private showToast(msg: string): void {
    promptAction.showToast({ message: msg, duration: 2000 });
  }

  aboutToDisappear(): void {
    if (this.progressTimer !== -1) {
      clearInterval(this.progressTimer);
      this.progressTimer = -1;
    }
  }

  private startProgress(): void {
    this.progressRunning = true;
    this.progressValue = 0;
    this.progressTimer = setInterval(() => {
      this.progressValue += 2;
      if (this.progressValue >= 100) {
        this.progressValue = 100;
        this.progressRunning = false;
        clearInterval(this.progressTimer);
        this.progressTimer = -1;
      }
    }, 50);
  }

  build() {
    Column() {
      Text('组件展示')
        .fontSize(24).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_primary'))
        .width('100%').height(56 + this.statusBarHeight)
        .padding({ left: 16, top: this.statusBarHeight })
        .backgroundColor($r('app.color.card_background'))

      Scroll() {
        Column() {
          this.NavigationCards()
          this.ButtonSection()
          this.TextSection()
          this.TagSection()
          this.InputSection()
          this.SelectSection()
          this.ToggleSection()
          this.SliderSection()
          this.ProgressSection()
          this.RatingSection()
          this.CardShowcaseSection()
          this.DataPanelSection()
          Blank().height(20)
        }
        .width('100%').padding({ left: 16, right: 16 })
      }
      .scrollBar(BarState.Off).edgeEffect(EdgeEffect.Spring)
      .layoutWeight(1).backgroundColor($r('app.color.page_background'))
    }
    .width('100%').height('100%').backgroundColor($r('app.color.page_background'))
  }

  @Builder
  SectionTitle(title: string) {
    Text(title).fontSize(18).fontWeight(FontWeight.Bold)
      .fontColor($r('app.color.text_primary')).width('100%').margin({ top: 24, bottom: 8 })
  }

  @Builder
  NavigationCards() {
    this.SectionTitle('📄 页面导航')

    // 基础页面
    Row() {
      this.NavCard('📝', '表单页', '复杂表单验证', 'pages/FormPage')
      this.NavCard('📊', '表格页', '数据表格展示', 'pages/TablePage')
    }.width('100%').margin({ top: 12 }).justifyContent(FlexAlign.SpaceEvenly)

    Row() {
      this.NavCard('💬', '弹窗展示', '各种对话框', 'pages/DialogPage')
      this.NavCard('🔐', '系统权限', '权限管理测试', 'pages/PermissionPage')
    }.width('100%').margin({ top: 12 }).justifyContent(FlexAlign.SpaceEvenly)

    this.SectionTitle('🔄 列表 & 刷新')

    Row() {
      this.NavCard('⬇️', '下拉刷新', 'Refresh + List', 'pages/RefreshPage')
      this.NavCard('📋', '分组列表', 'ListItemGroup', 'pages/ListPage')
    }.width('100%').margin({ top: 12 }).justifyContent(FlexAlign.SpaceEvenly)

    Row() {
      this.NavCard('🌊', '瀑布流', 'WaterFlow 网格', 'pages/WaterFlowPage')
      this.NavCard('🔤', '字母索引', 'AlphabetIndexer', 'pages/IndexListPage')
    }.width('100%').margin({ top: 12 }).justifyContent(FlexAlign.SpaceEvenly)

    this.SectionTitle('🎨 动画 & 手势')

    Row() {
      this.NavCard('✨', '动画效果', '属性+显式动画', 'pages/AnimationPage')
      this.NavCard('👆', '手势识别', '点击/长按/拖拽', 'pages/GesturePage')
    }.width('100%').margin({ top: 12 }).justifyContent(FlexAlign.SpaceEvenly)

    Row() {
      this.NavCard('🌗', '主题切换', '明暗主题切换', 'pages/ThemePage')
      this.NavCard('📐', '相对布局', 'RelativeContainer', 'pages/LayoutPage')
    }.width('100%').margin({ top: 12 }).justifyContent(FlexAlign.SpaceEvenly)

    this.SectionTitle('🧩 高级组件')

    Row() {
      this.NavCard('📅', '选择器', '日期/时间/文本', 'pages/PickerPage')
      this.NavCard('👣', '步骤向导', 'Stepper 表单', 'pages/StepperPage')
    }.width('100%').margin({ top: 12 }).justifyContent(FlexAlign.SpaceEvenly)

    Row() {
      this.NavCard('📁', '侧边栏', 'SideBarContainer', 'pages/SideBarPage')
      this.NavCard('📥', '面板组件', 'Panel 拖拽面板', 'pages/PanelPage')
    }.width('100%').margin({ top: 12 }).justifyContent(FlexAlign.SpaceEvenly)

    this.SectionTitle('🖼️ 媒体 & 画布')

    Row() {
      this.NavCard('🎨', '画布绘图', 'Canvas 2D 绘图', 'pages/CanvasPage')
      this.NavCard('🕐', '时钟组件', 'TextClock 时钟', 'pages/ClockPage')
    }.width('100%').margin({ top: 12 }).justifyContent(FlexAlign.SpaceEvenly)

    Row() {
      this.NavCard('🔒', '手势密码', 'PatternLock', 'pages/SecurityPage')
      this.NavCard('🎬', '视频播放', 'Video 组件', 'pages/VideoPage')
    }.width('100%').margin({ top: 12 }).justifyContent(FlexAlign.SpaceEvenly)

    Row() {
      this.NavCard('🌐', 'WebView', '网页加载', 'pages/WebPage')
      this.NavCard('🧭', 'Navigation', '导航容器', 'pages/NavPage')
    }.width('100%').margin({ top: 12 }).justifyContent(FlexAlign.SpaceEvenly)

    this.SectionTitle('⚡ 系统能力')

    Row() {
      this.NavCard('💾', '数据存储', 'Preferences KV', 'pages/StoragePage')
      this.NavCard('🗄️', '关系数据库', 'RDB CRUD', 'pages/DatabasePage')
    }.width('100%').margin({ top: 12 }).justifyContent(FlexAlign.SpaceEvenly)

    Row() {
      this.NavCard('📱', '设备信息', 'Device & App Info', 'pages/DeviceInfoPage')
      this.NavCard('🌍', '国际化', 'i18n 格式化', 'pages/I18nPage')
    }.width('100%').margin({ top: 12 }).justifyContent(FlexAlign.SpaceEvenly)

    Row() {
      this.NavCard('🔗', '网络请求', 'HTTP 请求', 'pages/NetworkPage')
      this.NavCard('🔔', '通知管理', '本地通知', 'pages/NotificationPage')
    }.width('100%').margin({ top: 12 }).justifyContent(FlexAlign.SpaceEvenly)
  }

  @Builder
  NavCard(icon: string, title: string, desc: string, url: string) {
    Column() {
      Text(icon).fontSize(28)
      Text(title).fontSize(14).fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.text_primary')).margin({ top: 6 })
      Text(desc).fontSize(11).fontColor($r('app.color.text_secondary')).margin({ top: 2 })
    }
    .width('47%').padding(14).borderRadius(16)
    .backgroundColor($r('app.color.card_background'))
    .alignItems(HorizontalAlign.Center)
    .shadow({ radius: 6, color: 'rgba(0,0,0,0.06)', offsetX: 0, offsetY: 2 })
    .onClick(() => {
      router.pushUrl({ url: url }).catch(() => {
        this.showToast('页面跳转失败');
      });
    })
  }

  @Builder
  ButtonSection() {
    this.SectionTitle('按钮 Button')
    CardBox() {
      Text('按钮类型').fontSize(14).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 12 })
      Row() {
        Button('Capsule').type(ButtonType.Capsule).fontSize(14).layoutWeight(1).margin({ right: 6 })
        Button('Normal').type(ButtonType.Normal).fontSize(14).layoutWeight(1).margin({ right: 6 })
        Button('Circle').type(ButtonType.Circle).width(40).height(40)
      }.width('100%')
      Row() {
        Button('主按钮').type(ButtonType.Capsule).fontSize(14).backgroundColor($r('app.color.primary_color')).layoutWeight(1).margin({ right: 6 })
        Button('成功').type(ButtonType.Capsule).fontSize(14).backgroundColor($r('app.color.success_color')).layoutWeight(1).margin({ right: 6 })
        Button('警告').type(ButtonType.Capsule).fontSize(14).backgroundColor($r('app.color.warning_color')).layoutWeight(1).margin({ right: 6 })
        Button('危险').type(ButtonType.Capsule).fontSize(14).backgroundColor($r('app.color.danger_color')).layoutWeight(1)
      }.width('100%').margin({ top: 12 })
      Row() {
        Button('大').type(ButtonType.Capsule).fontSize(16).height(48).layoutWeight(1).margin({ right: 6 })
        Button('中').type(ButtonType.Capsule).fontSize(14).height(40).layoutWeight(1).margin({ right: 6 })
        Button('小').type(ButtonType.Capsule).fontSize(12).height(32).layoutWeight(1).margin({ right: 6 })
        Button('禁用').type(ButtonType.Capsule).fontSize(14).layoutWeight(1).enabled(false)
      }.width('100%').margin({ top: 12 })
      Row() {
        Button(this.btnLoading ? '加载中...' : '点击加载')
          .type(ButtonType.Capsule).fontSize(14).layoutWeight(1).margin({ right: 6 })
          .enabled(!this.btnLoading)
          .onClick(() => {
            this.btnLoading = true;
            setTimeout(() => { this.btnLoading = false; this.showToast('加载完成'); }, 2000);
          })
        Button('点击事件')
          .type(ButtonType.Capsule).fontSize(14).layoutWeight(1)
          .onClick(() => { this.showToast('按钮点击'); })
      }.width('100%').margin({ top: 12 })
    }
  }

  @Builder
  TextSection() {
    this.SectionTitle('文本 Text')
    CardBox() {
      Text('大标题 H1').fontSize(28).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_primary')).width('100%')
      Text('中标题 H2').fontSize(22).fontWeight(FontWeight.Medium).fontColor($r('app.color.text_primary')).width('100%').margin({ top: 8 })
      Text('正文内容 Body').fontSize(15).fontColor($r('app.color.text_secondary')).width('100%').margin({ top: 8 })
      Text('辅助文字 Caption').fontSize(12).fontColor($r('app.color.text_hint')).width('100%').margin({ top: 6 })
      Divider().color($r('app.color.divider_color')).margin({ top: 12, bottom: 12 })
      Text('这是一段很长的文本内容用于展示文本溢出省略效果当文本超过指定行数时会自动截断并显示省略号')
        .fontSize(14).fontColor($r('app.color.text_secondary')).maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis }).width('100%')
      Divider().color($r('app.color.divider_color')).margin({ top: 12, bottom: 12 })
      Text() {
        Span('富文本：').fontSize(14).fontColor($r('app.color.text_primary')).fontWeight(FontWeight.Bold)
        Span('红色').fontSize(14).fontColor(Color.Red)
        Span(' + ').fontSize(14).fontColor($r('app.color.text_secondary'))
        Span('蓝色斜体').fontSize(14).fontColor($r('app.color.primary_color')).fontStyle(FontStyle.Italic)
        Span(' + ').fontSize(14).fontColor($r('app.color.text_secondary'))
        Span('下划线').fontSize(14).fontColor($r('app.color.success_color'))
          .decoration({ type: TextDecorationType.Underline, color: $r('app.color.success_color') })
      }.width('100%')
    }
  }

  @Builder
  TagSection() {
    this.SectionTitle('标签 Tag & 徽章 Badge')
    CardBox() {
      Flex({ wrap: FlexWrap.Wrap }) {
        Text('默认').fontSize(12).fontColor(Color.White).backgroundColor('#999999').borderRadius(12).padding({ left: 12, top: 6, right: 12, bottom: 6 }).margin({ right: 8, bottom: 8 })
        Text('主要').fontSize(12).fontColor(Color.White).backgroundColor($r('app.color.primary_color')).borderRadius(12).padding({ left: 12, top: 6, right: 12, bottom: 6 }).margin({ right: 8, bottom: 8 })
        Text('成功').fontSize(12).fontColor(Color.White).backgroundColor($r('app.color.success_color')).borderRadius(12).padding({ left: 12, top: 6, right: 12, bottom: 6 }).margin({ right: 8, bottom: 8 })
        Text('警告').fontSize(12).fontColor(Color.White).backgroundColor($r('app.color.warning_color')).borderRadius(12).padding({ left: 12, top: 6, right: 12, bottom: 6 }).margin({ right: 8, bottom: 8 })
        Text('危险').fontSize(12).fontColor(Color.White).backgroundColor($r('app.color.danger_color')).borderRadius(12).padding({ left: 12, top: 6, right: 12, bottom: 6 }).margin({ right: 8, bottom: 8 })
      }.width('100%')
      Divider().color($r('app.color.divider_color')).margin({ top: 12, bottom: 12 })
      Flex({ wrap: FlexWrap.Wrap }) {
        Text('HarmonyOS').fontSize(12).fontColor($r('app.color.primary_color')).border({ width: 1, color: $r('app.color.primary_color') }).borderRadius(12).padding({ left: 12, top: 5, right: 12, bottom: 5 }).margin({ right: 8, bottom: 8 })
        Text('ArkTS').fontSize(12).fontColor($r('app.color.success_color')).border({ width: 1, color: $r('app.color.success_color') }).borderRadius(12).padding({ left: 12, top: 5, right: 12, bottom: 5 }).margin({ right: 8, bottom: 8 })
        Text('ArkUI').fontSize(12).fontColor($r('app.color.warning_color')).border({ width: 1, color: $r('app.color.warning_color') }).borderRadius(12).padding({ left: 12, top: 5, right: 12, bottom: 5 }).margin({ right: 8, bottom: 8 })
      }.width('100%')
      Divider().color($r('app.color.divider_color')).margin({ top: 12, bottom: 12 })
      Row() {
        Badge({ count: 5, position: BadgePosition.RightTop, style: { badgeSize: 16, badgeColor: $r('app.color.danger_color') } }) {
          Text('消息').fontSize(14).fontColor($r('app.color.text_primary')).padding({ left: 12, top: 8, right: 12, bottom: 8 }).backgroundColor($r('app.color.primary_light')).borderRadius(8)
        }
        Badge({ count: 99, position: BadgePosition.RightTop, style: { badgeSize: 16, badgeColor: $r('app.color.danger_color') } }) {
          Text('通知').fontSize(14).fontColor($r('app.color.text_primary')).padding({ left: 12, top: 8, right: 12, bottom: 8 }).backgroundColor($r('app.color.primary_light')).borderRadius(8)
        }.margin({ left: 24 })
      }.width('100%').justifyContent(FlexAlign.Center)
    }
  }

  @Builder
  InputSection() {
    this.SectionTitle('输入框 Input')
    CardBox() {
      Text('文本输入').fontSize(14).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 8 })
      TextInput({ placeholder: '请输入用户名' })
        .width('100%').height(44).borderRadius(8)
        .onChange((value: string) => { this.textInput = value; })
      Text('搜索框').fontSize(14).fontColor($r('app.color.text_secondary')).width('100%').margin({ top: 16, bottom: 8 })
      Search({ placeholder: '搜索内容...' })
        .width('100%').height(40)
        .onSubmit((value: string) => { this.showToast(`搜索: ${value}`); })
      Text('多行文本').fontSize(14).fontColor($r('app.color.text_secondary')).width('100%').margin({ top: 16, bottom: 8 })
      TextArea({ placeholder: '请输入描述信息...' })
        .width('100%').height(80).borderRadius(8)
        .onChange((value: string) => { this.textArea = value; })
    }
  }

  @Builder
  SelectSection() {
    this.SectionTitle('下拉选择 Select')
    CardBox() {
      Text('下拉框').fontSize(14).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 8 })
      Select([
        { value: '选项一' },
        { value: '选项二' },
        { value: '选项三' },
        { value: '选项四' },
        { value: '选项五' },
      ])
        .selected(this.selectIndex)
        .value('请选择')
        .font({ size: 14 })
        .selectedOptionFont({ size: 14 })
        .onSelect((index: number) => {
          this.selectIndex = index;
          this.showToast(`选择了第${index + 1}项`);
        })
        .width('100%')
    }
  }

  @Builder
  ToggleSection() {
    this.SectionTitle('开关 / 复选 / 单选')
    CardBox() {
      Row() {
        Text('开关 Toggle').fontSize(14).fontColor($r('app.color.text_primary')).layoutWeight(1)
        Toggle({ type: ToggleType.Switch, isOn: this.toggleOn })
          .onChange((isOn: boolean) => { this.toggleOn = isOn; })
      }.width('100%')
      Divider().color($r('app.color.divider_color')).margin({ top: 12, bottom: 12 })
      Row() {
        Checkbox({ name: 'cb1', group: 'cbg' })
          .select(this.checkbox1)
          .onChange((value: boolean) => { this.checkbox1 = value; })
        Text('选项 A').fontSize(14).fontColor($r('app.color.text_primary')).margin({ left: 8 })
      }.width('100%').margin({ bottom: 8 })
      Row() {
        Checkbox({ name: 'cb2', group: 'cbg' })
          .select(this.checkbox2)
          .onChange((value: boolean) => { this.checkbox2 = value; })
        Text('选项 B').fontSize(14).fontColor($r('app.color.text_primary')).margin({ left: 8 })
      }.width('100%').margin({ bottom: 8 })
      Row() {
        Checkbox({ name: 'cb3', group: 'cbg' })
          .select(this.checkbox3)
          .onChange((value: boolean) => { this.checkbox3 = value; })
        Text('选项 C').fontSize(14).fontColor($r('app.color.text_primary')).margin({ left: 8 })
      }.width('100%')
      Divider().color($r('app.color.divider_color')).margin({ top: 12, bottom: 12 })
      ForEach(['选项 1', '选项 2', '选项 3'], (item: string, index: number) => {
        Row() {
          Radio({ value: `r${index}`, group: 'radioGroup' })
            .checked(this.radioIndex === index)
            .onChange((isChecked: boolean) => { if (isChecked) this.radioIndex = index; })
          Text(item).fontSize(14).fontColor($r('app.color.text_primary')).margin({ left: 8 })
        }.width('100%').margin({ bottom: 8 })
      }, (item: string, index: number) => `radio_${index}`)
    }
  }

  @Builder
  SliderSection() {
    this.SectionTitle('滑块 Slider')
    CardBox() {
      Text(`当前值: ${this.sliderValue}`).fontSize(14).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 8 })
      Slider({ value: this.sliderValue, min: 0, max: 100, step: 1, style: SliderStyle.OutSet })
        .width('100%')
        .onChange((value: number) => { this.sliderValue = Math.round(value); })
    }
  }

  @Builder
  ProgressSection() {
    this.SectionTitle('进度 Progress')
    CardBox() {
      Text('线性进度条').fontSize(14).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 8 })
      Progress({ value: this.progressValue, total: 100, type: ProgressType.Linear })
        .width('100%').color($r('app.color.primary_color'))
      Text(`进度: ${this.progressValue}%`).fontSize(12).fontColor($r('app.color.text_hint')).width('100%').margin({ top: 4 })
      Row() {
        Button(this.progressRunning ? '运行中' : '开始进度')
          .type(ButtonType.Capsule).fontSize(14).layoutWeight(1).margin({ right: 6 })
          .enabled(!this.progressRunning)
          .onClick(() => { this.startProgress(); })
        Button('重置')
          .type(ButtonType.Capsule).fontSize(14).layoutWeight(1)
          .onClick(() => { this.progressValue = 0; })
      }.width('100%').margin({ top: 12 })
      Divider().color($r('app.color.divider_color')).margin({ top: 12, bottom: 12 })
      Text('环形进度条').fontSize(14).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 12 })
      Row() {
        Progress({ value: 65, total: 100, type: ProgressType.Ring }).width(64).height(64).color($r('app.color.primary_color'))
        Progress({ value: 85, total: 100, type: ProgressType.Ring }).width(64).height(64).color($r('app.color.success_color')).margin({ left: 24 })
        Progress({ value: 30, total: 100, type: ProgressType.Ring }).width(64).height(64).color($r('app.color.warning_color')).margin({ left: 24 })
      }.width('100%').justifyContent(FlexAlign.Center)
      Divider().color($r('app.color.divider_color')).margin({ top: 12, bottom: 12 })
      Text('胶囊进度条').fontSize(14).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 8 })
      Progress({ value: 45, total: 100, type: ProgressType.Eclipse }).width('100%').color($r('app.color.primary_color'))
    }
  }

  @Builder
  RatingSection() {
    this.SectionTitle('评分 Rating')
    CardBox() {
      Text(`评分: ${this.ratingValue} 星`).fontSize(14).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 8 })
      Rating({ rating: this.ratingValue, indicator: false })
        .stars(5)
        .onChange((value: number) => { this.ratingValue = value; })
    }
  }

  @Builder
  CardShowcaseSection() {
    this.SectionTitle('卡片 Card')
    CardBox() {
      Column() {
        Column() {
          Text('渐变卡片').fontSize(18).fontWeight(FontWeight.Bold).fontColor(Color.White)
          Text('带渐变背景的卡片组件').fontSize(13).fontColor('rgba(255,255,255,0.8)').margin({ top: 4 })
        }
        .width('100%').padding(16).borderRadius(12)
        .linearGradient({ angle: 135, colors: [[$r('app.color.gradient_start'), 0], [$r('app.color.gradient_end'), 1]] })
        .alignItems(HorizontalAlign.Start)
        Row() {
          Text('查看详情').fontSize(13).fontColor($r('app.color.primary_color'))
          Text('收藏').fontSize(13).fontColor($r('app.color.text_secondary')).margin({ left: 16 })
        }.width('100%').margin({ top: 12 }).justifyContent(FlexAlign.End)
      }.width('100%')
      Divider().color($r('app.color.divider_color')).margin({ top: 16, bottom: 16 })
      Row() {
        Column() { Text('📱').fontSize(36) }
        .width(64).height(64).borderRadius(12).backgroundColor($r('app.color.primary_light')).justifyContent(FlexAlign.Center)
        Column() {
          Text('左图右文卡片').fontSize(16).fontWeight(FontWeight.Medium).fontColor($r('app.color.text_primary'))
          Text('左侧图标右侧文字内容的卡片布局').fontSize(13).fontColor($r('app.color.text_secondary')).margin({ top: 4 })
          Row() {
            Text('标签1').fontSize(11).fontColor($r('app.color.primary_color')).backgroundColor($r('app.color.primary_light')).borderRadius(8).padding({ left: 8, top: 3, right: 8, bottom: 3 })
            Text('标签2').fontSize(11).fontColor($r('app.color.success_color')).backgroundColor('rgba(54,211,114,0.1)').borderRadius(8).padding({ left: 8, top: 3, right: 8, bottom: 3 }).margin({ left: 8 })
          }.margin({ top: 8 })
        }.layoutWeight(1).alignItems(HorizontalAlign.Start).margin({ left: 12 })
      }.width('100%')
      Divider().color($r('app.color.divider_color')).margin({ top: 16, bottom: 16 })
      Column() {
        Text('操作卡片').fontSize(16).fontWeight(FontWeight.Medium).fontColor($r('app.color.text_primary')).width('100%')
        Text('卡片底部带操作按钮的布局形式').fontSize(13).fontColor($r('app.color.text_secondary')).margin({ top: 4 }).width('100%')
        Row() {
          Button('确定').type(ButtonType.Capsule).fontSize(13).height(32).backgroundColor($r('app.color.primary_color')).layoutWeight(1).margin({ right: 6 })
          Button('取消').type(ButtonType.Capsule).fontSize(13).height(32).backgroundColor($r('app.color.page_background')).fontColor($r('app.color.text_secondary')).layoutWeight(1)
        }.width('100%').margin({ top: 12 })
      }.width('100%')
    }
  }

  @Builder
  DataPanelSection() {
    this.SectionTitle('数据面板 DataPanel')
    CardBox() {
      Text('环形数据面板').fontSize(14).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 12 })
      DataPanel({ values: [20, 40, 60, 80, 100], max: 300, type: DataPanelType.Circle })
        .width('100%').height(160)
      Divider().color($r('app.color.divider_color')).margin({ top: 12, bottom: 12 })
      Text('线性数据面板').fontSize(14).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 8 })
      DataPanel({ values: [30, 50, 70, 90], max: 300, type: DataPanelType.Line })
        .width('100%').height(40)
    }
  }
}
