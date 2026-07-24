package soul.view.chat
{
   import flash.utils.Dictionary;
   import soul.model.chat.ChatUser;
   import soul.view.ui.Box;
   import soul.view.ui.BoxDirection;
   
   public class ChatUsers extends Box
   {
      
      private var sortField:String = "name";
      
      private var sortReverse:Boolean;
      
      private var childMap:Dictionary = new Dictionary();
      
      private var userMap:Vector.<ChatUser> = new Vector.<ChatUser>(0);
      
      private var _dataProvider:Array;
      
      public function ChatUsers()
      {
         super();
         direction = BoxDirection.VERTICAL;
      }
      
      public function sortBy(field:String) : void
      {
         if(field.charAt(0) == "-")
         {
            this.sortField = field.substr(1);
            this.sortReverse = true;
         }
         else
         {
            this.sortField = field;
            this.sortReverse = false;
         }
         this.sort();
      }
      
      public function set dataProvider(value:Array) : void
      {
         var user:ChatUser = null;
         var user2:ChatUser = null;
         var child:ChatUserRenderer = null;
         var index:int = 0;
         var i:int = 0;
         var toRemove:Vector.<ChatUser> = new Vector.<ChatUser>();
         for each(user in this.userMap)
         {
            index = -1;
            if(value != null)
            {
               for(i = 0; i < value.length; i++)
               {
                  user2 = value[i];
                  if(user2.id == user.id)
                  {
                     index = i;
                     break;
                  }
               }
            }
            if(index == -1)
            {
               toRemove.push(user);
            }
         }
         for each(user in toRemove)
         {
            child = this.childMap[user];
            removeChild(child);
            delete this.childMap[user];
            this.userMap.splice(this.userMap.indexOf(user),1);
         }
         for each(user in value)
         {
            index = -1;
            for(i = 0; i < this.userMap.length; i++)
            {
               user2 = this.userMap[i];
               if(user2.id == user.id)
               {
                  index = i;
                  break;
               }
            }
            if(index == -1)
            {
               this.userMap.push(user);
               child = new ChatUserRenderer();
               child.user = user;
               addChild(child);
               this.childMap[user] = child;
            }
         }
         this._dataProvider = value;
         this.sort();
      }
      
      private function sort() : void
      {
         var user:ChatUser = null;
         var child:ChatUserRenderer = null;
         this.userMap.sort(this.sortFunction);
         for each(user in this.userMap)
         {
            child = this.childMap[user];
            setChildIndex(child,this.userMap.indexOf(user));
         }
         updateLater();
      }
      
      private function sortFunction(a:ChatUser, b:ChatUser) : int
      {
         var av:Object = this.sortReverse ? b[this.sortField] : a[this.sortField];
         var bv:Object = this.sortReverse ? a[this.sortField] : b[this.sortField];
         return av < bv ? -1 : (av > bv ? 1 : 0);
      }
   }
}

