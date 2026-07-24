package soul.model.field.mapconfig
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   import soul.SoulNamespace;
   import soul.model.field.spriteconfig.SpritePoint;
   
   public class MapFillZone implements IEventDispatcher
   {
      
      public static const TAG:String = "fillZone";
      
      private var _1332194002background:MapBackground;
      
      private var _982754077points:Array;
      
      private var _1216317675passable:Boolean = true;
      
      private var _466743410visible:Boolean = true;
      
      private var _3027047blur:int;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function MapFillZone(linkage:String = null, library:String = null, x:int = 0, y:int = 0)
      {
         super();
         this.background = new MapBackground(linkage,library);
         this.points = [new ContourPoint(x,y),new ContourPoint(x + 100,y),new ContourPoint(x + 100,y + 100),new ContourPoint(x,y + 100)];
      }
      
      public static function fromXML(xml:XML) : MapFillZone
      {
         var objectNode:XML = null;
         default xml namespace = SoulNamespace.nameSpace;
         var zone:MapFillZone = new MapFillZone();
         zone.points = [];
         for each(objectNode in xml.point)
         {
            zone.points.push(new ContourPoint(objectNode.@x,objectNode.@y,int(objectNode.@controlX),int(objectNode.@controlY)));
         }
         zone.background = MapBackground.fromXML(xml[MapBackground.TAG][0]);
         zone.passable = xml.@passable == "true";
         zone.blur = xml.@blur;
         return zone;
      }
      
      public function toXML() : XML
      {
         var point:ContourPoint = null;
         var child:XML = null;
         default xml namespace = SoulNamespace.nameSpace;
         var xml:XML = new XML("<" + TAG + " passable=\"" + this.passable + "\" blur=\"" + this.blur + "\"/>");
         xml.appendChild(this.background.toXML());
         for each(point in this.points)
         {
            child = new XML("<point x=\"" + point.x + "\" y=\"" + point.y + "\"/>");
            if(point.controlX != 0)
            {
               child.@controlX = point.controlX;
            }
            if(point.controlY != 0)
            {
               child.@controlY = point.controlY;
            }
            xml.appendChild(child);
         }
         return xml;
      }
      
      public function applyAspectRatio() : void
      {
         var point:SpritePoint = null;
         default xml namespace = SoulNamespace.nameSpace;
         for each(point in this.points)
         {
            point.applyAspectRatio();
         }
      }
      
      public function removeAspectRatio() : void
      {
         var point:SpritePoint = null;
         default xml namespace = SoulNamespace.nameSpace;
         for each(point in this.points)
         {
            point.removeAspectRatio();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get background() : MapBackground
      {
         return this._1332194002background;
      }
      
      public function set background(param1:MapBackground) : void
      {
         var _loc2_:Object = this._1332194002background;
         if(_loc2_ !== param1)
         {
            this._1332194002background = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"background",_loc2_,param1));
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
      public function get visible() : Boolean
      {
         return this._466743410visible;
      }
      
      public function set visible(param1:Boolean) : void
      {
         var _loc2_:Object = this._466743410visible;
         if(_loc2_ !== param1)
         {
            this._466743410visible = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"visible",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get blur() : int
      {
         return this._3027047blur;
      }
      
      public function set blur(param1:int) : void
      {
         var _loc2_:Object = this._3027047blur;
         if(_loc2_ !== param1)
         {
            this._3027047blur = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"blur",_loc2_,param1));
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

