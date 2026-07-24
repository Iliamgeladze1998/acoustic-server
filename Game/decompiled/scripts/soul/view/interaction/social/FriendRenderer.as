package soul.view.interaction.social
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   import soul.controller.MenuManager;
   import soul.model.common.MenuType;
   import soul.model.interaction.social.SocialElement;
   import soul.view.common.Icons;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Component;
   import soul.view.ui.SimpleLabel;
   
   public class FriendRenderer extends Component
   {
      
      private static const ONLINE_COLOR:uint = 65280;
      
      private static const OFFLINE_COLOR:uint = 7829367;
      
      private var icon:CachedImage = new CachedImage();
      
      private var label:SimpleLabel = new SimpleLabel();
      
      private var _friend:SocialElement;
      
      public function FriendRenderer()
      {
         super();
         width = 158;
         height = 18;
         this.icon.source = Icons.infoIcon;
         this.icon.x = 3;
         this.icon.y = 3;
         this.label.x = 20;
         this.label.autoSize = TextFieldAutoSize.NONE;
         this.label.width = 135;
         this.label.height = 18;
         addChild(this.icon);
         addChild(this.label);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
         this.icon.addEventListener(MouseEvent.CLICK,this.showInfo);
      }
      
      private function removed(e:Event) : void
      {
         if(e.target != this)
         {
            return;
         }
         this.icon.removeEventListener(MouseEvent.CLICK,this.showInfo);
      }
      
      private function showInfo(e:Event) : void
      {
         e.stopPropagation();
         if(!this._friend)
         {
            return;
         }
         MenuManager.create(MenuType.CHARACTER_MENU,this._friend.id);
      }
      
      public function set friend(value:SocialElement) : void
      {
         this._friend = value;
         if(!value)
         {
            return;
         }
         this.label.textColor = value.online ? ONLINE_COLOR : OFFLINE_COLOR;
         this.label.text = "[" + value.level + "] " + value.name;
      }
      
      public function get friend() : SocialElement
      {
         return this._friend;
      }
      
      public function set selected(value:Boolean) : void
      {
         graphics.clear();
         if(!value)
         {
            return;
         }
         graphics.beginFill(3355443);
         graphics.drawRect(0,0,width,height);
         graphics.endFill();
      }
   }
}

