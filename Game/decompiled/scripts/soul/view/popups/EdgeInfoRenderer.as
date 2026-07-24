package soul.view.popups
{
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.view.assets.Assets;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Component;
   import soul.view.ui.SimpleLabel;
   
   public class EdgeInfoRenderer extends Component
   {
      
      private var label:TextField = new SimpleLabel();
      
      private var barFrame:CachedImage = new CachedImage();
      
      private var loadLabel:TextField = new SimpleLabel();
      
      public function EdgeInfoRenderer()
      {
         super();
         mouseChildren = false;
         width = 200;
         height = 18;
         this.barFrame.source = Assets.edgeFrame;
         this.label.autoSize = "none";
         this.label.height = 18;
         this.loadLabel.autoSize = "none";
         this.loadLabel.height = 18;
         this.barFrame.x = 100;
         this.barFrame.height = 18;
         this.loadLabel.width = 100;
         this.loadLabel.x = 100;
         var tf:TextFormat = new TextFormat();
         tf.align = TextFormatAlign.CENTER;
         this.loadLabel.defaultTextFormat = tf;
         addChild(this.label);
         addChild(this.barFrame);
         addChild(this.loadLabel);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut,false,0,true);
      }
      
      public function init(id:int, load:int, enabled:Boolean) : void
      {
         this.label.textColor = load < 100 && enabled ? 16777215 : 10066329;
         this.label.text = LocaleManager.getString(BundleName.INTERFACE,"edge") + (id + 1);
         this.loadLabel.text = load + "%";
         this.barFrame.graphics.beginFill(10294551);
         this.barFrame.graphics.drawRect(1,1,load * 0.9,13);
         this.barFrame.graphics.endFill();
      }
      
      private function onMouseOver(e:MouseEvent) : void
      {
         graphics.beginFill(3355528,0.3);
         graphics.drawRect(0,0,width,height);
         graphics.endFill();
      }
      
      private function onMouseOut(e:MouseEvent) : void
      {
         graphics.clear();
      }
   }
}

