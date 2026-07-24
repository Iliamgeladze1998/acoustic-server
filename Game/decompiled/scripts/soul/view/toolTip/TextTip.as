package soul.view.toolTip
{
   import flash.events.Event;
   import soul.view.ui.Container;
   import soul.view.ui.Label;
   
   public class TextTip extends ToolTipBase
   {
      
      private static const PADDING:uint = 3;
      
      private var container:Container = new Container();
      
      private var tf:Label = new Label(Label.TEXT_TOOLTIP);
      
      public function TextTip()
      {
         super();
         this.tf.multiline = true;
         this.tf.wordWrap = true;
         this.tf.x = PADDING;
         this.tf.y = PADDING;
         addChild(this.container);
         this.container.addChild(this.tf);
      }
      
      override protected function onAdded(e:Event) : void
      {
         this.tf.htmlText = String(data);
         this.container.width = this.tf.width + PADDING * 2;
         this.container.height = this.tf.height + PADDING * 2;
         updateNow();
      }
   }
}

