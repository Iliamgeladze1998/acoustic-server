package soul.view.interaction.character.parts
{
   import soul.view.assets.Assets;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Component;
   
   public class CharacterRoundIcon extends Component
   {
      
      private const bg:CachedImage = new CachedImage();
      
      private const icon:CachedImage = new CachedImage();
      
      public function CharacterRoundIcon()
      {
         super();
         width = 50;
         height = 46;
         this.icon.x = 4;
         this.icon.y = 2;
         this.bg.source = Assets.iconBg;
         addChild(this.bg);
         addChild(this.icon);
      }
      
      public function set source(value:Object) : void
      {
         this.icon.source = value;
      }
   }
}

