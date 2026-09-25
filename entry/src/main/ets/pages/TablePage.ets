import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

class TableData {
  id: number;
  name: string;
  age: number;
  city: string;
  score: number;
  status: string;

  constructor(id: number, name: string, age: number, city: string, score: number, status: string) {
    this.id = id;
    this.name = name;
    this.age = age;
    this.city = city;
    this.score = score;
    this.status = status;
  }
}

@Entry
@Component
struct TablePage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State searchKey: string = '';
  @State sortField: string = 'id';
  @State sortAsc: boolean = true;
  @State currentPage: number = 1;
  @State selectedIds: number[] = [];
  @State allChecked: boolean = false;
  private pageSize: number = 5;

  private allData: TableData[] = [
    new TableData(1, '张三', 25, '北京', 92, '活跃'),
    new TableData(2, '李四', 30, '上海', 85, '活跃'),
    new TableData(3, '王五', 28, '广州', 78, ' inactive'),
    new TableData(4, '赵六', 35, '深圳', 95, '活跃'),
    new TableData(5, '钱七', 22, '杭州', 68, ' inactive'),
    new TableData(6, '孙八', 27, '成都', 88, '活跃'),
    new TableData(7, '周九', 31, '北京', 73, '活跃'),
    new TableData(8, '吴十', 29, '上海', 91, '活跃'),
    new TableData(9, '郑十一', 26, '广州', 82, ' inactive'),
    new TableData(10, '王十二', 33, '深圳', 76, '活跃'),
    new TableData(11, '刘十三', 24, '杭州', 89, '活跃'),
    new TableData(12, '陈十四', 32, '成都', 71, ' inactive'),
  ];

  private showToast(msg: string): void {
    promptAction.showToast({ message: msg, duration: 2000 });
  }

  @State filteredData: TableData[] = [];
  @State totalPages: number = 0;
  @State pageData: TableData[] = [];

  aboutToAppear(): void {
    this.updateData();
  }

  private updateData(): void {
    let data = this.allData;
    if (this.searchKey.length > 0) {
      data = data.filter((item: TableData) =>
        item.name.includes(this.searchKey) || item.city.includes(this.searchKey));
    }
    data = data.slice().sort((a: TableData, b: TableData) => {
      let cmp = 0;
      if (this.sortField === 'id') cmp = a.id - b.id;
      else if (this.sortField === 'name') cmp = a.name.localeCompare(b.name);
      else if (this.sortField === 'age') cmp = a.age - b.age;
      else if (this.sortField === 'score') cmp = a.score - b.score;
      return this.sortAsc ? cmp : -cmp;
    });
    this.filteredData = data;
    this.totalPages = Math.ceil(data.length / this.pageSize);
    const start = (this.currentPage - 1) * this.pageSize;
    this.pageData = data.slice(start, start + this.pageSize);
  }

  private toggleSort(field: string): void {
    if (this.sortField === field) {
      this.sortAsc = !this.sortAsc;
    } else {
      this.sortField = field;
      this.sortAsc = true;
    }
    this.updateData();
  }

  private toggleSelect(id: number): void {
    if (this.selectedIds.includes(id)) {
      this.selectedIds = this.selectedIds.filter((i: number) => i !== id);
    } else {
      this.selectedIds = [...this.selectedIds, id];
    }
  }

  private toggleAll(): void {
    if (this.allChecked) {
      this.selectedIds = [];
    } else {
      this.selectedIds = this.pageData.map((item: TableData) => item.id);
    }
    this.allChecked = !this.allChecked;
  }

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24).fontColor([$r('app.color.text_primary')])
          .onClick(() => { router.back(); })
        Text('数据表格').fontSize(18).fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary')).layoutWeight(1).margin({ left: 12 })
      }
      .width('100%').height(56 + this.statusBarHeight)
      .padding({ left: 16, right: 16, top: this.statusBarHeight })
      .backgroundColor($r('app.color.card_background')).alignItems(VerticalAlign.Center)

      // 搜索栏
      Row() {
        Search({ placeholder: '搜索姓名/城市...' })
          .width('100%').height(40)
          .onChange((value: string) => { this.searchKey = value; this.currentPage = 1; this.updateData(); })
      }.width('100%').padding({ left: 16, right: 16, top: 12 })

      // 选中操作栏
      Row() {
        Checkbox({ name: 'selectAll', group: 'tableGroup' })
          .select(this.allChecked)
          .onChange(() => { this.toggleAll(); })
        Text(`已选 ${this.selectedIds.length} 项`).fontSize(13).fontColor($r('app.color.text_secondary')).margin({ left: 8 }).layoutWeight(1)
        if (this.selectedIds.length > 0) {
          Text('批量删除').fontSize(13).fontColor($r('app.color.danger_color'))
            .onClick(() => { this.showToast(`删除 ${this.selectedIds.length} 项`); this.selectedIds = []; this.allChecked = false; })
        }
      }.width('100%').padding({ left: 16, right: 16, top: 8 })

      // 表格
      Scroll() {
        Column() {
          // 表头
          Row() {
            Text('ID').fontSize(13).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_secondary')).width(50).textAlign(TextAlign.Center)
            this.SortHeader('姓名', 'name', 80)
            this.SortHeader('年龄', 'age', 50)
            Text('城市').fontSize(13).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_secondary')).width(70).textAlign(TextAlign.Center)
            this.SortHeader('分数', 'score', 60)
            Text('状态').fontSize(13).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_secondary')).width(60).textAlign(TextAlign.Center)
            Text('操作').fontSize(13).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_secondary')).layoutWeight(1).textAlign(TextAlign.Center)
          }
          .width('100%').height(44).backgroundColor($r('app.color.card_background'))
          .border({ width: { bottom: 1 }, color: $r('app.color.divider_color') })

          // 数据行
          ForEach(this.pageData, (item: TableData) => {
            Row() {
              Row() {
                Checkbox({ name: `row${item.id}`, group: 'tableRowGroup' })
                  .select(this.selectedIds.includes(item.id))
                  .onChange(() => { this.toggleSelect(item.id); })
                Text(`${item.id}`).fontSize(13).fontColor($r('app.color.text_primary')).margin({ left: 4 })
              }.width(50).justifyContent(FlexAlign.Center)

              Text(item.name).fontSize(13).fontColor($r('app.color.text_primary')).width(80).textAlign(TextAlign.Center)
              Text(`${item.age}`).fontSize(13).fontColor($r('app.color.text_primary')).width(50).textAlign(TextAlign.Center)
              Text(item.city).fontSize(13).fontColor($r('app.color.text_primary')).width(70).textAlign(TextAlign.Center)
              Text(`${item.score}`).fontSize(13).fontColor(item.score >= 80 ? $r('app.color.success_color') : $r('app.color.warning_color')).width(60).textAlign(TextAlign.Center).fontWeight(FontWeight.Medium)
              Text(item.status.trim()).fontSize(12).fontColor(item.status.trim() === '活跃' ? $r('app.color.success_color') : $r('app.color.text_hint')).width(60).textAlign(TextAlign.Center)
              Row() {
                Text('查看').fontSize(12).fontColor($r('app.color.primary_color')).onClick(() => { this.showToast(`查看 ${item.name}`); })
                Text('删除').fontSize(12).fontColor($r('app.color.danger_color')).margin({ left: 8 }).onClick(() => { this.showToast(`删除 ${item.name}`); })
              }.layoutWeight(1).justifyContent(FlexAlign.Center)
            }
            .width('100%').height(48)
            .backgroundColor(this.selectedIds.includes(item.id) ? $r('app.color.primary_light') : $r('app.color.card_background'))
            .border({ width: { bottom: 1 }, color: $r('app.color.divider_color') })
          }, (item: TableData) => `row_${item.id}`)

          // 汇总行
          Row() {
            Text(`共 ${this.filteredData.length} 条`).fontSize(13).fontColor($r('app.color.text_secondary')).layoutWeight(1)
            Text(`平均分: ${(this.filteredData.reduce((sum: number, d: TableData) => sum + d.score, 0) / this.filteredData.length).toFixed(1)}`).fontSize(13).fontColor($r('app.color.text_primary')).fontWeight(FontWeight.Medium)
          }
          .width('100%').height(40).padding({ left: 16, right: 16 })
          .backgroundColor($r('app.color.card_background'))

          Blank().height(20)
        }
        .width('100%')
      }
      .scrollBar(BarState.Off).edgeEffect(EdgeEffect.Spring)
      .layoutWeight(1).backgroundColor($r('app.color.page_background'))

      // 分页栏
      Row() {
        Button('上一页').type(ButtonType.Capsule).fontSize(13).height(32)
          .enabled(this.currentPage > 1)
          .backgroundColor($r('app.color.card_background')).fontColor($r('app.color.text_primary'))
          .onClick(() => { if (this.currentPage > 1) { this.currentPage--; this.updateData(); } })
        Text(` ${this.currentPage} / ${this.totalPages} `).fontSize(14).fontColor($r('app.color.text_primary')).margin({ left: 12, right: 12 })
        Button('下一页').type(ButtonType.Capsule).fontSize(13).height(32)
          .enabled(this.currentPage < this.totalPages)
          .backgroundColor($r('app.color.card_background')).fontColor($r('app.color.text_primary'))
          .onClick(() => { if (this.currentPage < this.totalPages) { this.currentPage++; this.updateData(); } })
      }
      .width('100%').height(52).justifyContent(FlexAlign.Center)
      .backgroundColor($r('app.color.card_background'))
      .border({ width: { top: 1 }, color: $r('app.color.divider_color') })
    }
    .width('100%').height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }

  @Builder
  SortHeader(title: string, field: string, w: number) {
    Row() {
      Text(title).fontSize(13).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_secondary'))
      Text(this.sortField === field ? (this.sortAsc ? '↑' : '↓') : '').fontSize(13).fontColor($r('app.color.primary_color')).margin({ left: 2 })
    }
    .width(w).justifyContent(FlexAlign.Center)
    .onClick(() => { this.toggleSort(field); })
  }
}
