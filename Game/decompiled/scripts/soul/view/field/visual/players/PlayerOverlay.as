package soul.view.field.visual.players
{
   import com.gskinner.motion.GTween;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.PixelSnapping;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import soul.model.field.FieldUnit;
   import soul.model.field.NpcDifficulty;
   import soul.model.field.StatType;
   import soul.view.field.visual.players.speech.PlayerBubble;
   import soul.view.ui.Label;
   import soul.view.ui.SimpleLabel;
   
   public class PlayerOverlay extends PlayerUnderlay
   {
      
      private static const NAMEPLATE_FILTERS:Array = [new GlowFilter(0,1,2,2,2,1),new DropShadowFilter(4,45,0,0.5)];
      
      private static const FLYING_TEXT_FILTER:Array = [new GlowFilter(0,1,2,2,5)];
      
      private static const BAR_HEIGHT:int = 2;
      
      private static const BAR_WIDTH:int = 50;
      
      private static const PADDING:int = 25;
      
      private static const GAP:int = 3;
      
      private static const FLYING_TEXT_GAP:int = 12;
      
      private var textLayer:Sprite = new Sprite();
      
      private var namePlate:Sprite = new Sprite();
      
      private var bubble:PlayerBubble = new PlayerBubble();
      
      private var nameLabel:TextField = new SimpleLabel(Label.FIELD_LABEL);
      
      private var barHolder:Shape = new Shape();
      
      private var lastFlyingText:Sprite;
      
      private var _unit:FieldUnit;
      
      private var _bottom:int = 0;
      
      public function PlayerOverlay()
      {
         super();
         this.textLayer.mouseEnabled = false;
         this.namePlate.filters = NAMEPLATE_FILTERS;
         this.namePlate.addChild(this.nameLabel);
         this.namePlate.addChild(this.barHolder);
         addChild(this.textLayer);
         addChild(this.namePlate);
         addChild(this.bubble);
         this.nameLabel.multiline = true;
         this.nameLabel.autoSize = TextFieldAutoSize.LEFT;
         this.nameLabel.visible = false;
         this.barHolder.x = -BAR_WIDTH / 2;
      }
      
      public function set unit(value:FieldUnit) : void
      {
         var txt:String = null;
         this._unit = value;
         var level:int = Boolean(value.stats) && Boolean(value.types) && value.types.length > 0 ? int(value.stats[StatType.LEVEL]) : 0;
         if(Boolean(value.name))
         {
            this.nameLabel.textColor = NpcDifficulty.getColor(value.difficulty);
            txt = (level > 0 ? "[" + level + "] " : "") + value.name.substr(0,24);
            if(Boolean(value.clan))
            {
               txt += "<br><center><font size=\'10\'>&lt;" + value.clan + "&gt;</font></center>";
            }
            this.nameLabel.htmlText = txt;
         }
         this.nameLabel.x = -this.nameLabel.width / 2;
         this.updatePositions();
         this.checkVisibility();
      }
      
      public function set bottom(value:int) : void
      {
         this._bottom = value;
         this.updatePositions();
      }
      
      public function get bottom() : int
      {
         return this._bottom;
      }
      
      private function updatePositions() : void
      {
         this.barHolder.y = this._bottom - BAR_HEIGHT - GAP + PADDING;
         this.nameLabel.y = this.barHolder.y - GAP - this.nameLabel.height;
         this.textLayer.y = this.nameLabel.y - 15;
         this.bubble.y = this.textLayer.y - 10;
      }
      
      public function showFlyingText(text:String, color:int, icon:DisplayObject, critical:Boolean = false, bold:Boolean = false) : void
      {
         var s:Sprite = null;
         var t:TextField = null;
         var gt:GTween = null;
         s = new Sprite();
         t = new TextField();
         var tf:TextFormat = new TextFormat("Verdana",16);
         tf.bold = bold;
         t.autoSize = "left";
         t.defaultTextFormat = tf;
         t.selectable = false;
         t.textColor = color;
         t.htmlText = text;
         t.filters = FLYING_TEXT_FILTER;
         s.mouseEnabled = false;
         s.mouseChildren = false;
         s.cacheAsBitmap = true;
         this.textLayer.addChild(s);
         var bd:BitmapData = new BitmapData(t.width,t.height,true,0);
         bd.draw(t);
         var bmp:Bitmap = new Bitmap(bd,PixelSnapping.NEVER,true);
         bmp.x = -bmp.width / 2;
         bmp.name = "bitmap";
         s.addChild(bmp);
         if(Boolean(icon))
         {
            s.addChild(icon);
            icon.x = bmp.x - icon.width;
         }
         var y:int = Boolean(this.lastFlyingText) ? int(this.lastFlyingText.y + FLYING_TEXT_GAP) : 0;
         if(y < -FLYING_TEXT_GAP)
         {
            y = 0;
         }
         s.y = y;
         this.lastFlyingText = s;
         if(critical)
         {
            gt = new GTween(s,2,{
               "y":y - 100,
               "scaleX":3,
               "scaleY":3,
               "alpha":0
            });
         }
         else
         {
            gt = new GTween(s,2,{
               "y":y - 100,
               "alpha":0
            });
         }
         gt.onComplete = this.tweenComplete;
      }
      
      private function tweenComplete(gt:GTween) : void
      {
         var s:Sprite = gt.target as Sprite;
         if(this.textLayer.contains(s))
         {
            this.textLayer.removeChild(s);
         }
         var bmp:Bitmap = s.getChildByName("bitmap") as Bitmap;
         if(Boolean(bmp))
         {
            bmp.bitmapData.dispose();
         }
         if(this.lastFlyingText == s)
         {
            this.lastFlyingText = null;
         }
      }
      
      public function speak(text:String, type:String) : void
      {
         this.bubble.speak(text,type);
      }
      
      public function checkVisibility() : void
      {
         if(!this._unit || !this._unit.stats)
         {
            this.barHolder.visible = false;
            this.nameLabel.visible = false;
            return;
         }
         var maxHp:int = int(this._unit.stats[StatType.MAX_HP]);
         var hp:int = int(this._unit.stats[StatType.HP]);
         this.barHolder.graphics.clear();
         this.nameLabel.visible = hp < maxHp || this._unit.character || !this._unit.acceptsNegative;
         if(hp >= maxHp)
         {
            return;
         }
         this.barHolder.graphics.beginFill(16742263);
         this.barHolder.graphics.drawRect(0,0,BAR_WIDTH,BAR_HEIGHT);
         if(maxHp != 0)
         {
            this.barHolder.graphics.beginFill(16711680);
            this.barHolder.graphics.drawRect(0,0,BAR_WIDTH * hp / maxHp,BAR_HEIGHT);
         }
         this.barHolder.graphics.endFill();
      }
   }
}

