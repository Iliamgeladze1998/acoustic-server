package soul.view.common
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import soul.model.cooldown.Cooldown;
   import soul.view.cooldown.CooldownRenderer;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Canvas;
   import soul.view.ui.Label;
   
   public class IconRenderer extends Canvas
   {
      
      private static const DISABLED_ALPHA:Number = 0.3;
      
      private static const LABEL_FILTERS:Array = [new DropShadowFilter(0,0,0,1,3,3,8,2)];
      
      private var bg:DisplayObject;
      
      protected var border:Sprite;
      
      protected var image:CachedImage = new CachedImage();
      
      private var cd:CooldownRenderer = new CooldownRenderer();
      
      protected var tCount:Label = new Label(Label.ITEM_COUNT);
      
      protected var tShortcut:Label = new Label(Label.ITEM_SHORTCUT);
      
      protected var glow:CachedImage = new CachedImage();
      
      private var _count:int = -1;
      
      public function IconRenderer()
      {
         super();
         this.image.horizontalCenter = this.image.verticalCenter = 0;
         this.image.percentWidth = this.image.percentHeight = 100;
         this.cd.left = this.cd.top = 0;
         this.cd.percentWidth = this.cd.percentHeight = 100;
         this.tCount.top = this.tCount.right = 2;
         this.tShortcut.bottom = this.tShortcut.right = 2;
         this.tCount.filters = this.tShortcut.filters = LABEL_FILTERS;
         this.glow.percentWidth = 100;
         this.glow.percentHeight = 100;
         this.glow.left = this.glow.top = 0;
         mouseChildren = false;
         addChild(this.image);
         addChild(this.cd);
         addChild(this.tCount);
         addChild(this.tShortcut);
         addChild(this.glow);
      }
      
      public function set glowSource(value:Object) : void
      {
         this.glow.source = value;
      }
      
      public function set source(value:Object) : void
      {
         this.image.source = value;
      }
      
      public function get source() : Object
      {
         return this.image.source;
      }
      
      public function set count(value:int) : void
      {
         if(this._count == value)
         {
            return;
         }
         this._count = value;
         var ks:int = int(value / 1000);
         var kn:Number = int(value / 100) / 10;
         this.tCount.text = "" + (ks > 0 ? kn + "k" : (value > 1 ? value : ""));
      }
      
      public function set shortcut(value:String) : void
      {
         if(!value)
         {
            value = "";
         }
         this.tShortcut.text = value.toUpperCase();
      }
      
      public function set cooldown(value:Cooldown) : void
      {
         this.cd.cooldown = value;
      }
      
      public function get cooldownLeft() : uint
      {
         return Boolean(this.cd.cooldownLeft) ? this.cd.cooldownLeft : 0;
      }
      
      public function set backgroundImage(value:Object) : void
      {
         if(Boolean(this.bg))
         {
            background.removeChild(this.bg);
         }
         this.bg = null;
         if(value is Class)
         {
            this.bg = new value();
            background.addChildAt(this.bg,0);
         }
      }
      
      public function set borderSkin(value:Object) : void
      {
         if(Boolean(this.border))
         {
            background.removeChild(this.border);
         }
         if(value is Class)
         {
            this.border = new value();
            background.addChildAt(this.border,background.numChildren);
         }
      }
      
      override protected function redraw() : void
      {
         super.redraw();
         this.image.maxWidth = width - padding * 2;
         this.image.maxHeight = height - padding * 2;
         if(Boolean(this.bg))
         {
            this.bg.x = backgroundPadding;
            this.bg.y = backgroundPadding;
            this.bg.width = width - backgroundPadding * 2;
            this.bg.height = height - backgroundPadding * 2;
         }
         if(Boolean(this.border))
         {
            this.border.width = width;
            this.border.height = height;
         }
      }
   }
}

