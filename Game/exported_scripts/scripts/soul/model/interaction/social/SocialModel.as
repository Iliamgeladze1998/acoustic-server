package soul.model.interaction.social
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class SocialModel extends EventDispatcher
   {
      
      private var _2008090584socialLists:Object;
      
      public function SocialModel()
      {
         super();
      }
      
      public function isFriend(characterId:String) : Boolean
      {
         return this.isCharacterInList(characterId,SocialListType.FRIEND);
      }
      
      public function isEnemy(characterId:String) : Boolean
      {
         return this.isCharacterInList(characterId,SocialListType.ENEMY);
      }
      
      public function isIgnored(characterId:String) : Boolean
      {
         return this.isCharacterInList(characterId,SocialListType.IGNORE);
      }
      
      private function isCharacterInList(characterId:String, type:String) : Boolean
      {
         var element:SocialElement = null;
         for each(element in this.socialLists[type])
         {
            if(element.id == characterId)
            {
               return true;
            }
         }
         return false;
      }
      
      [Bindable(event="propertyChange")]
      public function get socialLists() : Object
      {
         return this._2008090584socialLists;
      }
      
      public function set socialLists(param1:Object) : void
      {
         var _loc2_:Object = this._2008090584socialLists;
         if(_loc2_ !== param1)
         {
            this._2008090584socialLists = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"socialLists",_loc2_,param1));
            }
         }
      }
   }
}

