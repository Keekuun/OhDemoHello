import { router } from '@kit.ArkUI';

@Entry
@Component
struct CanvasPage {
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State currentDemo: number = 0;

  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24).fontColor([$r('app.color.text_primary')])
          .onClick(() => { router.back(); })
        Text('画布绘图').fontSize(18).fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary')).layoutWeight(1).margin({ left: 12 })
      }
      .width('100%').height(56 + this.statusBarHeight)
      .padding({ left: 16, right: 16, top: this.statusBarHeight })
      .backgroundColor($r('app.color.card_background')).alignItems(VerticalAlign.Center)

      Scroll() {
        Row() {
          ForEach(['基础图形', '渐变文字', '路径绘制', '合成'], (label: string, index: number) => {
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

      Stack() {
        if (this.currentDemo === 0) { this.BasicShapes() }
        if (this.currentDemo === 1) { this.GradientText() }
        if (this.currentDemo === 2) { this.PathDrawing() }
        if (this.currentDemo === 3) { this.CompositeDemo() }
      }
      .layoutWeight(1).width('100%').backgroundColor($r('app.color.page_background'))
    }
    .width('100%').height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }

  @Builder
  BasicShapes() {
    Column() {
      Text('Canvas — 基础图形绘制').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).margin({ bottom: 16 })

      Canvas(this.context)
        .width('100%').height(300)
        .onReady(() => {
          this.context.clearRect(0, 0, 400, 300);

          // 矩形
          this.context.fillStyle = '#007DFF';
          this.context.fillRect(20, 20, 80, 60);

          // 圆形
          this.context.beginPath();
          this.context.arc(180, 50, 30, 0, Math.PI * 2);
          this.context.fillStyle = '#36D372';
          this.context.fill();

          // 三角形
          this.context.beginPath();
          this.context.moveTo(260, 80);
          this.context.lineTo(220, 20);
          this.context.lineTo(300, 20);
          this.context.closePath();
          this.context.fillStyle = '#FF9F0A';
          this.context.fill();

          // 线条
          this.context.beginPath();
          this.context.moveTo(20, 120);
          this.context.lineTo(350, 120);
          this.context.strokeStyle = '#FF4D4F';
          this.context.lineWidth = 3;
          this.context.stroke();

          // 椭圆
          this.context.beginPath();
          this.context.ellipse(100, 200, 60, 30, 0, 0, Math.PI * 2);
          this.context.strokeStyle = '#9B59B6';
          this.context.lineWidth = 2;
          this.context.stroke();

          // 圆角矩形
          this.context.beginPath();
          this.context.roundRect(220, 160, 120, 80, 12);
          this.context.fillStyle = 'rgba(0, 125, 255, 0.2)';
          this.context.fill();
          this.context.strokeStyle = '#007DFF';
          this.context.stroke();

          // 文字
          this.context.font = '16px sans-serif';
          this.context.fillStyle = '#182431';
          this.context.fillText('Canvas 绘图示例', 100, 270);
        })

      Blank().layoutWeight(1)
      Text('矩形/圆/三角/椭圆/圆角矩形/线条/文字').fontSize(12).fontColor($r('app.color.text_hint')).margin({ bottom: 20 })
    }
    .width('100%').height('100%').padding(16)
  }

  @Builder
  GradientText() {
    Column() {
      Text('Canvas — 渐变填充').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).margin({ bottom: 16 })

      Canvas(this.context)
        .width('100%').height(300)
        .onReady(() => {
          this.context.clearRect(0, 0, 400, 300);

          // 线性渐变
          const linearGrad = this.context.createLinearGradient(0, 0, 350, 0);
          linearGrad.addColorStop(0, '#007DFF');
          linearGrad.addColorStop(0.5, '#36D372');
          linearGrad.addColorStop(1, '#FF9F0A');
          this.context.fillStyle = linearGrad;
          this.context.fillRect(20, 20, 350, 50);

          // 径向渐变
          const radialGrad = this.context.createRadialGradient(100, 150, 10, 100, 150, 60);
          radialGrad.addColorStop(0, '#FF4D4F');
          radialGrad.addColorStop(1, 'rgba(255, 77, 79, 0.1)');
          this.context.fillStyle = radialGrad;
          this.context.beginPath();
          this.context.arc(100, 150, 60, 0, Math.PI * 2);
          this.context.fill();

          // 渐变文字
          const textGrad = this.context.createLinearGradient(0, 220, 350, 280);
          textGrad.addColorStop(0, '#9B59B6');
          textGrad.addColorStop(1, '#007DFF');
          this.context.fillStyle = textGrad;
          this.context.font = 'bold 28px sans-serif';
          this.context.fillText('Gradient Text', 60, 260);
        })

      Blank().layoutWeight(1)
      Text('线性渐变 / 径向渐变 / 渐变文字').fontSize(12).fontColor($r('app.color.text_hint')).margin({ bottom: 20 })
    }
    .width('100%').height('100%').padding(16)
  }

  @Builder
  PathDrawing() {
    Column() {
      Text('Canvas — 路径绘制').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).margin({ bottom: 16 })

      Canvas(this.context)
        .width('100%').height(300)
        .onReady(() => {
          this.context.clearRect(0, 0, 400, 300);

          // 贝塞尔曲线
          this.context.beginPath();
          this.context.moveTo(20, 150);
          this.context.bezierCurveTo(100, 20, 200, 280, 350, 150);
          this.context.strokeStyle = '#007DFF';
          this.context.lineWidth = 3;
          this.context.stroke();

          // 二次贝塞尔
          this.context.beginPath();
          this.context.moveTo(20, 250);
          this.context.quadraticCurveTo(180, 50, 350, 250);
          this.context.strokeStyle = '#36D372';
          this.context.lineWidth = 2;
          this.context.stroke();

          // 星形路径
          this.context.beginPath();
          const cx = 100, cy = 80, spikes = 5, outerR = 40, innerR = 20;
          let rot = Math.PI / 2 * 3;
          for (let i = 0; i < spikes; i++) {
            this.context.lineTo(cx + Math.cos(rot) * outerR, cy + Math.sin(rot) * outerR);
            rot += Math.PI / spikes;
            this.context.lineTo(cx + Math.cos(rot) * innerR, cy + Math.sin(rot) * innerR);
            rot += Math.PI / spikes;
          }
          this.context.closePath();
          this.context.fillStyle = '#FF9F0A';
          this.context.fill();
        })

      Blank().layoutWeight(1)
      Text('贝塞尔曲线 / 二次曲线 / 星形路径').fontSize(12).fontColor($r('app.color.text_hint')).margin({ bottom: 20 })
    }
    .width('100%').height('100%').padding(16)
  }

  @Builder
  CompositeDemo() {
    Column() {
      Text('Canvas — 透明度与叠加').fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary')).margin({ bottom: 16 })

      Canvas(this.context)
        .width('100%').height(300)
        .onReady(() => {
          this.context.clearRect(0, 0, 400, 300);

          // 三个半透明圆叠加
          this.context.globalAlpha = 0.6;
          this.context.fillStyle = '#007DFF';
          this.context.beginPath();
          this.context.arc(120, 100, 50, 0, Math.PI * 2);
          this.context.fill();

          this.context.fillStyle = '#36D372';
          this.context.beginPath();
          this.context.arc(180, 100, 50, 0, Math.PI * 2);
          this.context.fill();

          this.context.fillStyle = '#FF9F0A';
          this.context.beginPath();
          this.context.arc(150, 160, 50, 0, Math.PI * 2);
          this.context.fill();

          this.context.globalAlpha = 1.0;

          // 阴影
          this.context.shadowBlur = 15;
          this.context.shadowColor = 'rgba(0, 0, 0, 0.3)';
          this.context.fillStyle = '#FF4D4F';
          this.context.beginPath();
          this.context.roundRect(250, 180, 100, 80, 12);
          this.context.fill();
          this.context.shadowBlur = 0;
        })

      Blank().layoutWeight(1)
      Text('透明度叠加 / 阴影效果').fontSize(12).fontColor($r('app.color.text_hint')).margin({ bottom: 20 })
    }
    .width('100%').height('100%').padding(16)
  }
}
