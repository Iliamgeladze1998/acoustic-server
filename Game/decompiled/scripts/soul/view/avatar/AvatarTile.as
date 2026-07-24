package soul.view.avatar
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import soul.model.avatar.Avatar;
   import soul.view.ui.Tile;
   
   [Event(name="change",type="flash.events.Event")]
   public class AvatarTile extends Tile
   {
      
      public var selectedAvatar:Avatar;
      
      private var selectedChild:AvatarRenderer;
      
      public function AvatarTile()
      {
         super();
         gap = 5;
      }
      
      public function unselect() : void
      {
         if(Boolean(this.selectedChild))
         {
            this.selectedChild.selected = false;
            this.selectedChild = null;
            this.selectedAvatar = null;
         }
      }
      
      public function set dataProvider(value:Vector.<Avatar>) : void
      {
         var avatar:Avatar = null;
         var child:AvatarRenderer = null;
         removeAllChildren();
         for each(avatar in value)
         {
            child = new AvatarRenderer();
            child.avatar = avatar;
            child.addEventListener(MouseEvent.CLICK,this.childClick);
            addChild(child);
         }
      }
      
      private function childClick(e:MouseEvent) : void
      {
         var child:AvatarRenderer = e.currentTarget as AvatarRenderer;
         if(Boolean(this.selectedChild))
         {
            this.selectedChild.selected = false;
         }
         this.selectedChild = child;
         this.selectedChild.selected = true;
         this.selectedAvatar = this.selectedChild.avatar;
         this.notify();
      }
      
      private function notify() : void
      {
         dispatchEvent(new Event(Event.CHANGE));
      }
   }
}

