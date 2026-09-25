import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { relationalStore } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';

class UserRecord {
  id: number;
  name: string;
  age: number;
  email: string;
  constructor(id: number, name: string, age: number, email: string) {
    this.id = id;
    this.name = name;
    this.age = age;
    this.email = email;
  }
}

@Entry
@Component
struct DatabasePage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State users: UserRecord[] = [];
  @State inputName: string = '';
  @State inputAge: string = '';
  @State inputEmail: string = '';
  @State dbReady: boolean = false;
  @State logs: string[] = [];
  private rdbStore: relationalStore.RdbStore | null = null;

  aboutToAppear(): void {
    this.initDB();
  }

  private addLog(text: string): void {
    this.logs = [...this.logs, `${new Date().toLocaleTimeString()} - ${text}`];
  }

  private async initDB(): Promise<void> {
    try {
      const context = getContext(this) as common.UIAbilityContext;
      const config: relationalStore.StoreConfig = {
        name: 'UserDatabase.db',
        securityLevel: relationalStore.SecurityLevel.S1,
      };
      this.rdbStore = await relationalStore.getRdbStore(context, config);

      const sql = `CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER,
        email TEXT
      )`;
      await this.rdbStore.executeSql(sql);

      this.dbReady = true;
      this.addLog('数据库初始化成功');
      await this.queryAll();
    } catch (e) {
      this.addLog(`初始化失败: ${(e as Error).message}`);
    }
  }

  private async queryAll(): Promise<void> {
    if (!this.rdbStore) return;
    try {
      const resultSet = await this.rdbStore.querySql('SELECT * FROM users ORDER BY id DESC');
      const list: UserRecord[] = [];
      while (resultSet.goToNextRow()) {
        const id = resultSet.getLong(resultSet.getColumnIndex('id'));
        const name = resultSet.getString(resultSet.getColumnIndex('name'));
        const age = resultSet.getLong(resultSet.getColumnIndex('age'));
        const email = resultSet.getString(resultSet.getColumnIndex('email'));
        list.push(new UserRecord(id, name, age, email));
      }
      resultSet.close();
      this.users = list;
      this.addLog(`查询到 ${list.length} 条记录`);
    } catch (e) {
      this.addLog(`查询失败: ${(e as Error).message}`);
    }
  }

  private async insertUser(): Promise<void> {
    if (!this.rdbStore || this.inputName.length === 0) {
      promptAction.showToast({ message: '请输入姓名' });
      return;
    }
    try {
      const valueBucket: relationalStore.ValuesBucket = {
        name: this.inputName,
        age: parseInt(this.inputAge) || 0,
        email: this.inputEmail,
      };
      const rowId = await this.rdbStore.insert('users', valueBucket);
      this.addLog(`插入成功, rowId=${rowId}`);
      promptAction.showToast({ message: '添加成功' });
      this.inputName = '';
      this.inputAge = '';
      this.inputEmail = '';
      await this.queryAll();
    } catch (e) {
      this.addLog(`插入失败: ${(e as Error).message}`);
    }
  }

  private async deleteUser(id: number): Promise<void> {
    if (!this.rdbStore) return;
    try {
      const predicates = new relationalStore.RdbPredicates('users');
      predicates.equalTo('id', id);
      const count = await this.rdbStore.delete(predicates);
      this.addLog(`删除 ${count} 条记录 (id=${id})`);
      promptAction.showToast({ message: '已删除' });
      await this.queryAll();
    } catch (e) {
      this.addLog(`删除失败: ${(e as Error).message}`);
    }
  }

  private async updateAge(id: number): Promise<void> {
    if (!this.rdbStore) return;
    try {
      const predicates = new relationalStore.RdbPredicates('users');
      predicates.equalTo('id', id);
      const valueBucket: relationalStore.ValuesBucket = {
        age: Math.floor(Math.random() * 50) + 18,
      };
      const count = await this.rdbStore.update(valueBucket, predicates);
      this.addLog(`更新 ${count} 条记录 (id=${id})`);
      await this.queryAll();
    } catch (e) {
      this.addLog(`更新失败: ${(e as Error).message}`);
    }
  }

  private async clearTable(): Promise<void> {
    if (!this.rdbStore) return;
    try {
      await this.rdbStore.executeSql('DELETE FROM users');
      this.addLog('清空表');
      promptAction.showToast({ message: '已清空' });
      await this.queryAll();
    } catch (e) {
      this.addLog(`清空失败: ${(e as Error).message}`);
    }
  }

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24).fontColor([$r('app.color.text_primary')])
          .onClick(() => { router.back(); })
        Text('关系型数据库').fontSize(18).fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary')).layoutWeight(1).margin({ left: 12 })
        Row() {
          Text(this.dbReady ? 'DB ✓' : 'DB...').fontSize(11)
            .fontColor(this.dbReady ? $r('app.color.success_color') : $r('app.color.text_hint'))
        }
      }
      .width('100%').height(56 + this.statusBarHeight)
      .padding({ left: 16, right: 16, top: this.statusBarHeight })
      .backgroundColor($r('app.color.card_background')).alignItems(VerticalAlign.Center)

      Scroll() {
        Column() {
          Text('RDB — 关系型数据库 (relationalStore)').fontSize(14).fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary')).width('100%').margin({ bottom: 12 })
          Text('SQLite 封装，支持 SQL 查询、谓词条件、事务操作。')
            .fontSize(12).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 16 })

          // 添加表单
          Column() {
            Text('添加用户').fontSize(13).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_primary')).margin({ bottom: 8 })
            Row() {
              TextInput({ text: this.inputName, placeholder: '姓名' })
                .layoutWeight(1).height(38).borderRadius(8)
                .border({ width: 1, color: $r('app.color.divider_color') })
                .onChange((v: string) => { this.inputName = v; })
              TextInput({ text: this.inputAge, placeholder: '年龄' }).type(InputType.Number)
                .width(70).height(38).borderRadius(8).margin({ left: 6 })
                .border({ width: 1, color: $r('app.color.divider_color') })
                .onChange((v: string) => { this.inputAge = v; })
            }.width('100%').margin({ bottom: 6 })
            TextInput({ text: this.inputEmail, placeholder: '邮箱' })
              .width('100%').height(38).borderRadius(8)
              .border({ width: 1, color: $r('app.color.divider_color') })
              .onChange((v: string) => { this.inputEmail = v; })
              .margin({ bottom: 8 })
            Button('插入记录').width('100%').fontSize(13).type(ButtonType.Capsule)
              .backgroundColor($r('app.color.primary_color')).fontColor(Color.White).height(38)
              .onClick(() => { this.insertUser(); })
          }
          .width('100%').padding(16).borderRadius(12).backgroundColor($r('app.color.card_background')).margin({ bottom: 12 })

          // 数据列表
          Column() {
            Row() {
              Text(`用户列表 (${this.users.length})`).fontSize(13).fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary')).layoutWeight(1)
              if (this.users.length > 0) {
                Text('清空').fontSize(11).fontColor($r('app.color.danger_color'))
                  .onClick(() => { this.clearTable(); })
              }
            }.width('100%').margin({ bottom: 8 })

            if (this.users.length === 0) {
              Text('暂无数据，请添加用户').fontSize(12).fontColor($r('app.color.text_hint')).margin({ top: 12, bottom: 12 })
            } else {
              ForEach(this.users, (user: UserRecord) => {
                Row() {
                  Column() {
                    Text(user.name).fontSize(13).fontWeight(FontWeight.Medium).fontColor($r('app.color.text_primary'))
                    Text(`${user.age}岁 | ${user.email}`).fontSize(10).fontColor($r('app.color.text_secondary')).margin({ top: 2 })
                  }.layoutWeight(1).alignItems(HorizontalAlign.Start)
                  Text('随机年龄').fontSize(10).fontColor($r('app.color.primary_color')).margin({ right: 12 })
                    .onClick(() => { this.updateAge(user.id); })
                  Text('删除').fontSize(10).fontColor($r('app.color.danger_color'))
                    .onClick(() => { this.deleteUser(user.id); })
                }
                .width('100%').padding({ left: 8, right: 8, top: 8, bottom: 8 })
                .border({ width: { bottom: 1 }, color: $r('app.color.divider_color') })
              }, (user: UserRecord) => String(user.id))
            }
          }
          .width('100%').padding(16).borderRadius(12).backgroundColor($r('app.color.card_background')).margin({ bottom: 12 })

          // 日志
          Column() {
            Text('操作日志').fontSize(13).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_primary')).margin({ bottom: 8 })
            if (this.logs.length === 0) {
              Text('暂无日志').fontSize(11).fontColor($r('app.color.text_hint')).margin({ top: 8 })
            } else {
              ForEach(this.logs.slice(-8), (log: string) => {
                Text(log).fontSize(10).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 4 })
              }, (log: string) => log)
            }
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
}
