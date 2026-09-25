import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { http } from '@kit.NetworkKit';

class LogItem {
  time: string;
  text: string;
  isError: boolean;
  constructor(text: string, isError: boolean = false) {
    this.time = `${String(new Date().getHours()).padStart(2, '0')}:${String(new Date().getMinutes()).padStart(2, '0')}:${String(new Date().getSeconds()).padStart(2, '0')}`;
    this.text = text;
    this.isError = isError;
  }
}

@Entry
@Component
struct NetworkPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State logs: LogItem[] = [];
  @State loading: boolean = false;
  @State requestUrl: string = 'https://httpbin.org/get';
  @State requestMethod: string = 'GET';
  @State postBody: string = '{"key":"value"}';
  @State responseData: string = '';

  private addLog(text: string, isError: boolean = false): void {
    this.logs = [...this.logs, new LogItem(text, isError)];
  }

  private async sendRequest(): Promise<void> {
    this.loading = true;
    this.responseData = '';
    this.addLog(`${this.requestMethod} ${this.requestUrl}`);

    try {
      const httpRequest = http.createHttp();
      const headers: Record<string, string> = { 'Content-Type': 'application/json' };

      let response: http.HttpResponse;
      if (this.requestMethod === 'GET') {
        response = await httpRequest.request(this.requestUrl, {
          method: http.RequestMethod.GET,
          header: headers,
          expectDataType: http.HttpDataType.STRING,
          connectTimeout: 10000,
          readTimeout: 10000,
        });
      } else {
        response = await httpRequest.request(this.requestUrl, {
          method: http.RequestMethod.POST,
          header: headers,
          extraData: this.postBody,
          expectDataType: http.HttpDataType.STRING,
          connectTimeout: 10000,
          readTimeout: 10000,
        });
      }

      const code = response.responseCode;
      this.addLog(`响应码: ${code}`);

      if (code >= 200 && code < 300) {
        const data = response.result as string;
        this.responseData = data.length > 500 ? data.substring(0, 500) + '...' : data;
        this.addLog(`响应长度: ${data.length} 字节`);
        this.addLog('请求成功 ✓');
      } else {
        this.addLog(`请求失败，状态码: ${code}`, true);
      }

      httpRequest.destroy();
    } catch (e) {
      this.addLog(`请求异常: ${(e as Error).message}`, true);
    }

    this.loading = false;
  }

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24).fontColor([$r('app.color.text_primary')])
          .onClick(() => { router.back(); })
        Text('网络请求').fontSize(18).fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary')).layoutWeight(1).margin({ left: 12 })
      }
      .width('100%').height(56 + this.statusBarHeight)
      .padding({ left: 16, right: 16, top: this.statusBarHeight })
      .backgroundColor($r('app.color.card_background')).alignItems(VerticalAlign.Center)

      Scroll() {
        Column() {
          Text('HTTP 网络请求 (@kit.NetworkKit)').fontSize(14).fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary')).width('100%').margin({ bottom: 12 })

          // 请求方法选择
          Row() {
            ForEach(['GET', 'POST'], (method: string) => {
              Text(method).fontSize(13).padding({ left: 14, right: 14, top: 6, bottom: 6 })
                .borderRadius(16)
                .backgroundColor(this.requestMethod === method ? $r('app.color.primary_color') : $r('app.color.page_background'))
                .fontColor(this.requestMethod === method ? Color.White : $r('app.color.text_secondary'))
                .margin({ right: 8 })
                .onClick(() => { this.requestMethod = method; })
            }, (method: string) => method)
          }.margin({ bottom: 12 })

          // URL 输入
          Text('请求 URL').fontSize(12).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 4 })
          TextInput({ text: this.requestUrl, placeholder: 'https://' })
            .width('100%').height(40).borderRadius(8)
            .border({ width: 1, color: $r('app.color.divider_color') })
            .onChange((v: string) => { this.requestUrl = v; })
            .margin({ bottom: 12 })

          // POST Body
          if (this.requestMethod === 'POST') {
            Text('请求 Body (JSON)').fontSize(12).fontColor($r('app.color.text_secondary')).width('100%').margin({ bottom: 4 })
            TextArea({ text: this.postBody, placeholder: '{"key":"value"}' })
              .width('100%').height(80).borderRadius(8)
              .border({ width: 1, color: $r('app.color.divider_color') })
              .onChange((v: string) => { this.postBody = v; })
              .margin({ bottom: 12 })
          }

          // 快捷 URL
          Row() {
            Text('快捷:').fontSize(11).fontColor($r('app.color.text_hint')).margin({ right: 8 })
            ForEach(['httpbin.org/get', 'httpbin.org/post'], (url: string) => {
              Text(url).fontSize(10).fontColor($r('app.color.primary_color')).margin({ right: 12 })
                .onClick(() => { this.requestUrl = `https://${url}`; this.requestMethod = url.includes('post') ? 'POST' : 'GET'; })
            }, (url: string) => url)
          }.width('100%').margin({ bottom: 12 })

          // 发送按钮
          Button(this.loading ? '请求中...' : '发送请求').width('100%').fontSize(14).type(ButtonType.Capsule)
            .backgroundColor($r('app.color.primary_color')).fontColor(Color.White).height(42)
            .enabled(!this.loading)
            .onClick(() => { this.sendRequest(); })
            .margin({ bottom: 16 })

          // 响应数据
          if (this.responseData.length > 0) {
            Column() {
              Text('响应数据').fontSize(13).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_primary')).margin({ bottom: 8 })
              Text(this.responseData).fontSize(11).fontColor($r('app.color.text_secondary')).width('100%')
            }
            .width('100%').padding(16).borderRadius(12).backgroundColor($r('app.color.card_background')).margin({ bottom: 12 })
          }

          // 请求日志
          Column() {
            Text('请求日志').fontSize(13).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_primary')).margin({ bottom: 8 })
            if (this.logs.length === 0) {
              Text('暂无日志').fontSize(11).fontColor($r('app.color.text_hint')).margin({ top: 8 })
            } else {
              ForEach(this.logs, (log: LogItem) => {
                Row() {
                  Text(log.time).fontSize(10).fontColor($r('app.color.text_hint')).width(60)
                  Text(log.text).fontSize(11)
                    .fontColor(log.isError ? $r('app.color.danger_color') : $r('app.color.text_secondary'))
                    .layoutWeight(1).maxLines(2).textOverflow({ overflow: TextOverflow.Ellipsis })
                }.width('100%').margin({ bottom: 4 })
              }, (log: LogItem) => `${log.time}_${log.text}`)
            }
          }
          .width('100%').padding(16).borderRadius(12).backgroundColor($r('app.color.card_background')).margin({ bottom: 12 })

          // 清除日志
          if (this.logs.length > 0) {
            Button('清除日志').width('100%').fontSize(13).type(ButtonType.Capsule)
              .backgroundColor($r('app.color.page_background')).fontColor($r('app.color.text_secondary')).height(38)
              .onClick(() => { this.logs = []; })
              .margin({ bottom: 20 })
          }
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
