package soul.view.interaction.character.parts
{
   import flash.filters.GlowFilter;
   import soul.view.assets.Colors;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   
   public class ResistRenderer extends VBox
   {
      
      private static const GLOW:Array = [new GlowFilter(0,1,6,6,4)];
      
      private const icon:CharacterRoundIcon = new CharacterRoundIcon();
      
      private const _label:Label = new Label();
      
      public function ResistRenderer()
      {
         super();
         horizontalAlign = "center";
         this._label.color = Colors.GOLD_LIGHT;
         this._label.filters = GLOW;
         addChild(this.icon);
         addChild(this._label);
      }
      
      public function set source(value:Object) : void
      {
         this.icon.source = value;
      }
      
      public function set label(value:String) : void
      {
         this._label.text = value;
      }
   }
}

