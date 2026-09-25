import { router } from '@kit.ArkUI';

class Contact {
  name: string;
  phone: string;
  initial: string;
  constructor(name: string, phone: string, initial: string) {
    this.name = name;
    this.phone = phone;
    this.initial = initial;
  }
}

@Entry
@Component
struct IndexListPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State contacts: Contact[] = [];
  @State groups: string[] = [];
  @State groupMap: Record<string, Contact[]> = {} as Record<string, Contact[]>;
  @State selectedIndex: string = 'A';

  aboutToAppear(): void {
    const names: Record<string, string[]> = {
      'A': ['安琪', '阿明', '艾米'],
      'B': ['白洁', '冰冰', '包拯'],
      'C': ['陈晨', '曹操', '成龙'],
      'D': ['杜甫', '丁丁', '董卓'],
      'E': ['鄂伦春'],
      'F': ['范冰冰', '冯绍峰'],
      'G': ['郭靖', '高圆圆', '葛优'],
      'H': ['黄晓明', '韩寒', '胡歌'],
      'L': ['李娜', '刘德华', '李白'],
      'M': ['马云', '杨幂', '梅西'],
      'N': ['牛顿', '哪吒'],
      'P': ['彭于晏', '潘金莲'],
      'Q': ['钱学森', '秦始皇'],
      'R': ['任正非'],
      'S': ['孙悟空', '苏轼', '史泰龙'],
      'T': ['唐僧', '特朗普'],
      'W': ['王宝强', '吴京', '武则天'],
      'X': ['谢霆锋', '徐悲鸿'],
      'Y': ['杨过', '姚明', '叶问'],
      'Z': ['张三丰', '周杰伦', '诸葛亮'],
    };

    const keys: string[] = Object.keys(names);
    this.groups = keys;
    const map: Record<string, Contact[]> = {} as Record<string, Contact[]>;
    const allContacts: Contact[] = [];

    for (const key of keys) {
      const items: Contact[] = [];
      for (const name of names[key]) {
        const phone = `1${3 + Math.floor(Math.random() * 7)}${String(Math.floor(Math.random() * 1000000000)).padStart(9, '0')}`;
        const c = new Contact(name, phone, key);
        items.push(c);
        allContacts.push(c);
      }
      map[key] = items;
    }
    this.groupMap = map;
    this.contacts = allContacts;
  }

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24).fontColor([$r('app.color.text_primary')])
          .onClick(() => { router.back(); })
        Text('字母索引列表').fontSize(18).fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary')).layoutWeight(1).margin({ left: 12 })
        Text(`${this.contacts.length} 位联系人`).fontSize(12).fontColor($r('app.color.text_secondary'))
      }
      .width('100%').height(56 + this.statusBarHeight)
      .padding({ left: 16, right: 16, top: this.statusBarHeight })
      .backgroundColor($r('app.color.card_background')).alignItems(VerticalAlign.Center)

      Stack({ alignContent: Alignment.End }) {
        List() {
          ForEach(this.groups, (group: string) => {
            ListItemGroup({ header: this.GroupHeader(group) }) {
              ForEach(this.groupMap[group], (contact: Contact) => {
                ListItem() {
                  Row() {
                    Column()
                      .width(40).height(40).borderRadius(20)
                      .backgroundColor($r('app.color.primary_light'))
                      .justifyContent(FlexAlign.Center)
                      .margin({ right: 12 })
                      // 头像首字
                    Column() {
                      Text(contact.name).fontSize(15).fontWeight(FontWeight.Medium)
                        .fontColor($r('app.color.text_primary')).width('100%')
                      Text(contact.phone).fontSize(12).fontColor($r('app.color.text_secondary')).width('100%').margin({ top: 2 })
                    }.layoutWeight(1).alignItems(HorizontalAlign.Start)
                  }
                  .width('100%').padding({ left: 16, right: 16, top: 8, bottom: 8 })
                }
              }, (contact: Contact) => contact.name)
            }
          }, (group: string) => group)
        }
        .width('100%')
        .backgroundColor($r('app.color.page_background'))

        // 字母索引侧边栏
        AlphabetIndexer({
          arrayValue: this.groups,
          selected: 0,
        })
          .selectedColor($r('app.color.primary_color'))
          .popupColor($r('app.color.primary_color'))
          .popupBackground($r('app.color.card_background'))
          .font({ size: 10 })
          .itemSize(16)
          .usingPopup(true)
          .margin({ right: 4, top: 60 })
          .onSelect((index: number) => {
            this.selectedIndex = this.groups[index];
          })
      }
      .layoutWeight(1)
    }
    .width('100%').height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }

  @Builder
  GroupHeader(letter: string) {
    Text(letter).fontSize(14).fontWeight(FontWeight.Bold)
      .fontColor($r('app.color.primary_color')).width('100%')
      .padding({ left: 16, top: 8, bottom: 4 })
      .backgroundColor($r('app.color.page_background'))
  }
}
