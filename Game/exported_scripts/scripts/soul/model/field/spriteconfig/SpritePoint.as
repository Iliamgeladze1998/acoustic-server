package soul.model.field.spriteconfig
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   import soul.model.field.mapconfig.AspectRatio;
   
   public class SpritePoint implements IEventDispatcher
   {
      
      private var _120x:int;
      
      private var _121y:int;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function SpritePoint(x:int = 0, y:int = 0)
      {
         super();
         this.x = x;
         this.y = y;
      }
      
      public function clone() : SpritePoint
      {
         return new SpritePoint(this.x,this.y);
      }
      
      public function toString() : String
      {
         return "Point: " + this.x + "," + this.y;
      }
      
      public function applyAspectRatio() : void
      {
         this.x /= AspectRatio.x;
         this.y /= AspectRatio.y;
      }
      
      public function removeAspectRatio() : void
      {
         this.x *= AspectRatio.x;
         this.y *= AspectRatio.y;
      }
      
      [Bindable(event="propertyChange")]
      public function get x() : int
      {
         return this._120x;
      }
      
      public function set x(param1:int) : void
      {
         var _loc2_:Object = this._120x;
         if(_loc2_ !== param1)
         {
            this._120x = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"x",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get y() : int
      {
         return this._121y;
      }
      
      public function set y(param1:int) : void
      {
         var _loc2_:Object = this._121y;
         if(_loc2_ !== param1)
         {
            this._121y = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"y",_loc2_,param1));
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

