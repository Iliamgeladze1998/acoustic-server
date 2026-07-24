package soul.model.field.mapconfig
{
   import mx.events.PropertyChangeEvent;
   import soul.model.field.spriteconfig.SpritePoint;
   
   public class TrackPointConfig extends SpritePoint
   {
      
      private var _95467907delay:String;
      
      private var _1911146174scatter:Number;
      
      public function TrackPointConfig(x:int = 0, y:int = 0)
      {
         super(x,y);
      }
      
      override public function clone() : SpritePoint
      {
         return new TrackPointConfig(x,y);
      }
      
      override public function toString() : String
      {
         return "Point: " + x + "," + y + (Boolean(this.delay) && this.delay.length > 0 ? " (" + this.delay + ")" : "");
      }
      
      [Bindable(event="propertyChange")]
      public function get delay() : String
      {
         return this._95467907delay;
      }
      
      public function set delay(param1:String) : void
      {
         var _loc2_:Object = this._95467907delay;
         if(_loc2_ !== param1)
         {
            this._95467907delay = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"delay",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get scatter() : Number
      {
         return this._1911146174scatter;
      }
      
      public function set scatter(param1:Number) : void
      {
         var _loc2_:Object = this._1911146174scatter;
         if(_loc2_ !== param1)
         {
            this._1911146174scatter = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"scatter",_loc2_,param1));
            }
         }
      }
   }
}

