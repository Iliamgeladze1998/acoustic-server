package soul.view.interaction.social
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.events.PropertyChangeEvent;
   import soul.model.interaction.social.SocialElement;
   import soul.view.ui.VBox;
   
   public class FriendListRenderer extends VBox
   {
      
      private var _1754784690selectedItem:SocialElement;
      
      [Bindable("lengthChanged")]
      public var length:uint;
      
      private var _dataProvider:Array;
      
      public function FriendListRenderer()
      {
         super();
      }
      
      public function set dataProvider(value:Array) : void
      {
         var item:FriendRenderer = null;
         var entry:SocialElement = null;
         removeAllChildren();
         this.length = 0;
         for each(entry in value)
         {
            item = new FriendRenderer();
            item.friend = entry;
            addChild(item);
            item.addEventListener(MouseEvent.CLICK,this.itemClick);
            ++this.length;
         }
         dispatchEvent(new Event("lengthChanged"));
      }
      
      private function itemClick(e:MouseEvent) : void
      {
         var child:FriendRenderer = null;
         var item:FriendRenderer = e.currentTarget as FriendRenderer;
         var index:int = getChildIndex(item);
         for(var i:int = 0; i < numChildren; i++)
         {
            child = getChildAt(i) as FriendRenderer;
            if(Boolean(child))
            {
               child.selected = child == item;
            }
         }
         this.selectedItem = item.friend;
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedItem() : SocialElement
      {
         return this._1754784690selectedItem;
      }
      
      public function set selectedItem(param1:SocialElement) : void
      {
         var _loc2_:Object = this._1754784690selectedItem;
         if(_loc2_ !== param1)
         {
            this._1754784690selectedItem = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedItem",_loc2_,param1));
            }
         }
      }
   }
}

