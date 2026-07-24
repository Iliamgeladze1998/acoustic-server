package soul.view.avatar
{
   import flash.filters.GlowFilter;
   import soul.model.avatar.Avatar;
   import soul.model.system.Configuration;
   import soul.view.assets.Assets;
   import soul.view.common.IconRenderer;
   import soul.view.ui.BorderedContainer;
   
   public class AvatarRenderer extends BorderedContainer
   {
      
      private static const FILTERS:Array = [new GlowFilter(7864098)];
      
      private const icon:IconRenderer = new IconRenderer();
      
      private var _avatar:Avatar;
      
      public function AvatarRenderer()
      {
         super();
         borderSkin = Assets.simpleBorderRound;
         padding = 3;
         this.icon.width = 60;
         this.icon.height = 60;
         this.icon.glowSource = Assets.iconGlow;
         addChild(this.icon);
      }
      
      public function get avatar() : Avatar
      {
         return this._avatar;
      }
      
      public function set avatar(value:Avatar) : void
      {
         this._avatar = value;
         this.icon.source = Configuration.getSmallAvatarUrl(value.path);
      }
      
      public function set selected(value:Boolean) : void
      {
         filters = value ? FILTERS : [];
      }
   }
}

