package soul.view.interaction.map
{
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import soul.view.ui.SimpleLabel;
   
   public class MapCharacter extends Sprite
   {
      
      private static const charFilters:Array = [new GlowFilter(0,1,7,7,3)];
      
      private static const myColor:uint = 65280;
      
      private static const otherColor:uint = 16711680;
      
      private var label:TextField = new SimpleLabel();
      
      private var icon:Sprite = new Sprite();
      
      public function MapCharacter(myPlayer:Boolean = false)
      {
         super();
         addChild(this.icon);
         addChild(this.label);
         this.icon.graphics.beginFill(myPlayer ? myColor : otherColor);
         this.icon.graphics.drawCircle(0,0,3);
         this.icon.graphics.endFill();
         this.label.selectable = false;
         this.label.autoSize = TextFieldAutoSize.LEFT;
         this.label.textColor = 16777215;
         this.label.y = -20;
         filters = charFilters;
      }
      
      public function set characterName(value:String) : void
      {
         this.label.text = value;
         this.label.x = int(-this.label.width / 2);
      }
   }
}

