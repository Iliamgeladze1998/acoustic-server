package soul.model.achievement
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class AchievementSubgroup implements IEventDispatcher
   {
      
      public var id:String;
      
      public var imagePath:String;
      
      public var achievements:Array;
      
      public var pointsTotal:uint;
      
      private var _2106613158pointsCollected:uint;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function AchievementSubgroup()
      {
         super();
      }
      
      public function hasAchievement(id:String) : Boolean
      {
         var achievement:Achievement = null;
         for each(achievement in this.achievements)
         {
            if(achievement.id == id)
            {
               return true;
            }
         }
         return false;
      }
      
      [Bindable(event="propertyChange")]
      public function get pointsCollected() : uint
      {
         return this._2106613158pointsCollected;
      }
      
      public function set pointsCollected(param1:uint) : void
      {
         var _loc2_:Object = this._2106613158pointsCollected;
         if(_loc2_ !== param1)
         {
            this._2106613158pointsCollected = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pointsCollected",_loc2_,param1));
            }
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}

