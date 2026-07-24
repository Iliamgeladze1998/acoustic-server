package soul.view.common
{
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import soul.view.assets.Colors;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   
   public class OptionRenderer extends Component
   {
      
      private static const LABEL:Array = [new GlowFilter(0,1,4,4)];
      
      private static const SELECTED:Array = [new GlowFilter(16755200,0.75,20,20)];
      
      private static const NORMAL:Array = [new DropShadowFilter(7,45,0,0.5)];
      
      private var image:CachedImage = new CachedImage();
      
      private var _label:Label = new Label(new TextFormat("Verdana, Tahoma, _sans",11,Colors.GOLD_LIGHT));
      
      public var value:Object;
      
      private var _selected:Boolean;
      
      public function OptionRenderer()
      {
         super();
         width = 80;
         height = 95;
         this._label.align = TextFormatAlign.CENTER;
         this._label.width = 80;
         this._label.filters = LABEL;
         this._label.y = 83;
         this.showGlow();
         addChild(this.image);
         addChild(this._label);
      }
      
      private function showGlow() : void
      {
         this.image.filters = !enabled ? Colors.DISABLED_ALPHA_FILTER : (this._selected ? SELECTED : NORMAL);
      }
      
      public function set source(value:Object) : void
      {
         this.image.source = value;
      }
      
      public function set label(value:String) : void
      {
         this._label.text = value;
      }
      
      public function set selected(value:Boolean) : void
      {
         this._selected = value;
         this.showGlow();
      }
      
      override public function set enabled(value:Boolean) : void
      {
         if(enabled == value)
         {
            return;
         }
         super.enabled = value;
         this.showGlow();
      }
   }
}

