import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct PickerPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State currentDemo: number = 0;

  @State selectedDate: string = '请选择日期';
  @State selectedTime: string = '请选择时间';
  @State selectedText: string = '请选择';
  @State textPickerIndex: number = 0;
  private textOptions: string[] = ['选项一', '选项二', '选项三', '选项四', '选项五'];
  @State selectedCalendar: string = '请选择日期';
  @State selectedProvince: string = '北京';
  @State selectedCity: string = '北京市';
  private provinceData: string[] = ['北京', '上海', '广东'];
  private cityData: Record<string, string[]> = {
    '北京': ['北京市', '朝阳区', '海淀区'],
    '上海': ['上海市', '浦东新区', '徐汇区'],
    '广东': ['广州市', '深圳市', '珠海市'],
  };

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24).fontColor([$r('app.color.text_primary')])
          .onClick(() => { router.back(); })
        Text('选择器组件').fontSize(18).fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary')).layoutWeight(1).margin({ left: 12 })
      }
      .width('100%').height(56 + this.statusBarHeight)
      .padding({ left: 16, right: 16, top: this.statusBarHeight })
      .backgroundColor($r('app.color.card_background')).alignItems(VerticalAlign.Center)

      Scroll() {
        Row() {
          ForEach(['日期', '时间', '文本', '日历', '多列'], (label: string, index: number) => {
            Text(label).fontSize(12).padding({ left: 10, right: 10, top: 5, bottom: 5 })
              .borderRadius(14)
              .backgroundColor(this.currentDemo === index ? $r('app.color.primary_color') : $r('app.color.page_background'))
              .fontColor(this.currentDemo === index ? Color.White : $r('app.color.text_secondary'))
              .margin({ right: 6 })
              .onClick(() => { this.currentDemo = index; })
          }, (label: string) => label)
        }.padding({ left: 16, right: 16 })
      }
      .scrollBar(BarState.Off).scrollable(ScrollDirection.Horizontal)
      .height(40).backgroundColor($r('app.color.card_background'))

      Column() {
        if (this.currentDemo === 0) { this.DatePickerDemo() }
        if (this.currentDemo === 1) { this.TimePickerDemo() }
        if (this.currentDemo === 2) { this.TextPickerDemo() }
        if (this.currentDemo === 3) { this.CalendarPickerDemo() }
        if (this.currentDemo === 4) { this.MultiPickerDemo() }
      }
      .layoutWeight(1).width('100%').backgroundColor($r('app.color.page_background'))
    }
    .width('100%').height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }

  @Builder
  DatePickerDemo() {
    Column() {
      Text('DatePicker — 日期选择器').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).margin({ bottom: 8 })
      Text(`当前选择: ${this.selectedDate}`).fontSize(13).fontColor($r('app.color.text_secondary')).margin({ bottom: 16 })

      DatePicker({
        start: new Date('2020-01-01'),
        end: new Date('2030-12-31'),
        selected: new Date('2024-06-15'),
      })
        .onChange((value: DatePickerResult) => {
          this.selectedDate = `${value.year}年${(value.month ?? 0) + 1}月${value.day}日`;
        })
        .layoutWeight(1)
    }
    .width('100%').height('100%').padding(16).alignItems(HorizontalAlign.Center)
  }

  @Builder
  TimePickerDemo() {
    Column() {
      Text('TimePicker — 时间选择器').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).margin({ bottom: 8 })
      Text(`当前选择: ${this.selectedTime}`).fontSize(13).fontColor($r('app.color.text_secondary')).margin({ bottom: 16 })

      TimePicker({ selected: new Date() })
        .onChange((value: TimePickerResult) => {
          this.selectedTime = `${String(value.hour).padStart(2, '0')}:${String(value.minute).padStart(2, '0')}:${String(value.second ?? 0).padStart(2, '0')}`;
        })
        .layoutWeight(1)
    }
    .width('100%').height('100%').padding(16).alignItems(HorizontalAlign.Center)
  }

  @Builder
  TextPickerDemo() {
    Column() {
      Text('TextPicker — 文本选择器').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).margin({ bottom: 8 })
      Text(`当前选择: ${this.selectedText} (索引 ${this.textPickerIndex})`).fontSize(13)
        .fontColor($r('app.color.text_secondary')).margin({ bottom: 16 })

      TextPicker({ range: this.textOptions, selected: 0 })
        .onChange((value: string | string[], index: number | number[]) => {
          this.textPickerIndex = index as number;
          this.selectedText = value as string;
        })
        .layoutWeight(1)
    }
    .width('100%').height('100%').padding(16).alignItems(HorizontalAlign.Center)
  }

  @Builder
  CalendarPickerDemo() {
    Column() {
      Text('CalendarPicker — 日历选择器').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).margin({ bottom: 8 })
      Text(`当前选择: ${this.selectedCalendar}`).fontSize(13).fontColor($r('app.color.text_secondary')).margin({ bottom: 16 })

      CalendarPicker({
        selected: new Date('2024-06-15'),
        start: new Date('2020-01-01'),
        end: new Date('2030-12-31'),
      })
        .onChange((value: Date) => {
          this.selectedCalendar = `${value.getFullYear()}年${value.getMonth() + 1}月${value.getDate()}日`;
        })
        .layoutWeight(1)
    }
    .width('100%').height('100%').padding(16).alignItems(HorizontalAlign.Center)
  }

  @Builder
  MultiPickerDemo() {
    Column() {
      Text('多列联动选择器').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).margin({ bottom: 8 })
      Text(`已选: ${this.selectedProvince} - ${this.selectedCity}`).fontSize(13)
        .fontColor($r('app.color.text_secondary')).margin({ bottom: 16 })

      Column() {
        Text('省份').fontSize(12).fontColor($r('app.color.text_hint')).width('100%').margin({ bottom: 4 })
        TextPicker({ range: this.provinceData, selected: 0 })
          .onChange((value: string | string[], index: number | number[]) => {
            this.selectedProvince = value as string;
            this.selectedCity = this.cityData[this.selectedProvince][0];
          })
          .height(120)
      }.width('100%').margin({ bottom: 16 })

      Column() {
        Text('城市/区').fontSize(12).fontColor($r('app.color.text_hint')).width('100%').margin({ bottom: 4 })
        TextPicker({ range: this.cityData[this.selectedProvince], selected: 0 })
          .onChange((value: string | string[], index: number | number[]) => {
            this.selectedCity = value as string;
          })
          .height(120)
      }.width('100%')
    }
    .width('100%').height('100%').padding(16).alignItems(HorizontalAlign.Center)
  }
}
