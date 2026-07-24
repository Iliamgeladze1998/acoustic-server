package soul.model.field.spriteconfig
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   import soul.SoulNamespace;
   import soul.model.field.mapconfig.AspectRatio;
   
   public class SpriteZone implements IEventDispatcher
   {
      
      public static const TAG:String = "zone";
      
      private var _682674039penalty:Number = 0;
      
      private var _2113539591shootable:Boolean;
      
      private var _1216317675passable:Boolean;
      
      private var _982754077points:Array;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function SpriteZone()
      {
         super();
         this.points = [];
         this.points.push(new SpritePoint(0,0));
         this.points.push(new SpritePoint(10,0));
         this.points.push(new SpritePoint(10,10));
         this.points.push(new SpritePoint(0,10));
      }
      
      public static function fromXML(xml:XML) : SpriteZone
      {
         var pointX:XML = null;
         default xml namespace = SoulNamespace.nameSpace;
         var sz:SpriteZone = new SpriteZone();
         sz.passable = xml.@passable == "true";
         sz.shootable = xml.@shootable == "true";
         sz.points = [];
         for each(pointX in xml.point)
         {
            sz.points.push(new SpritePoint(pointX.@x,pointX.@y));
         }
         return sz;
      }
      
      public function toString() : String
      {
         return "Zone " + (this.points.length > 0 ? "p" + this.points.length : "") + (this.passable ? " passable" : "") + (this.shootable ? " shootable" : "");
      }
      
      public function clone() : SpriteZone
      {
         var sp:SpritePoint = null;
         var sz:SpriteZone = new SpriteZone();
         sz.penalty = this.penalty;
         sz.shootable = this.shootable;
         sz.passable = this.passable;
         sz.points = [];
         for each(sp in this.points)
         {
            sz.points.push(sp.clone());
         }
         return sz;
      }
      
      public function toXML() : XML
      {
         var point:XML = null;
         var spritePoint:SpritePoint = null;
         default xml namespace = SoulNamespace.nameSpace;
         var zone:XML = new XML("<" + TAG + " />");
         if(this.passable)
         {
            zone.@passable = true;
         }
         if(this.shootable)
         {
            zone.@shootable = true;
         }
         for each(spritePoint in this.points)
         {
            point = new XML("<point x=\"" + spritePoint.x + "\" y=\"" + spritePoint.y + "\" />");
            zone.appendChild(point);
         }
         return zone;
      }
      
      public function applyAspectRatio() : void
      {
         var point:SpritePoint = null;
         default xml namespace = SoulNamespace.nameSpace;
         for each(point in this.points)
         {
            point.y /= AspectRatio.y;
         }
      }
      
      public function removeAspectRatio() : void
      {
         var point:SpritePoint = null;
         default xml namespace = SoulNamespace.nameSpace;
         for each(point in this.points)
         {
            point.y *= AspectRatio.y;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get penalty() : Number
      {
         return this._682674039penalty;
      }
      
      public function set penalty(param1:Number) : void
      {
         var _loc2_:Object = this._682674039penalty;
         if(_loc2_ !== param1)
         {
            this._682674039penalty = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"penalty",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get shootable() : Boolean
      {
         return this._2113539591shootable;
      }
      
      public function set shootable(param1:Boolean) : void
      {
         var _loc2_:Object = this._2113539591shootable;
         if(_loc2_ !== param1)
         {
            this._2113539591shootable = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"shootable",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get passable() : Boolean
      {
         return this._1216317675passable;
      }
      
      public function set passable(param1:Boolean) : void
      {
         var _loc2_:Object = this._1216317675passable;
         if(_loc2_ !== param1)
         {
            this._1216317675passable = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"passable",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get points() : Array
      {
         return this._982754077points;
      }
      
      public function set points(param1:Array) : void
      {
         var _loc2_:Object = this._982754077points;
         if(_loc2_ !== param1)
         {
            this._982754077points = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"points",_loc2_,param1));
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

