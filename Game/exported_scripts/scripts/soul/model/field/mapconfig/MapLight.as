package soul.model.field.mapconfig
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   import soul.SoulNamespace;
   import soul.model.field.IXMLSaving;
   
   public class MapLight implements IXMLSaving, IEventDispatcher
   {
      
      public static const TAG:String = "light";
      
      private var _120x:int;
      
      private var _121y:int;
      
      private var _108114min:uint = 20;
      
      private var _107876max:uint = 100;
      
      private var _94842723color:uint = 16777215;
      
      private var _92909918alpha:Number = 1;
      
      private var _895597972blendMode:String = "multiply";
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function MapLight()
      {
         super();
      }
      
      public static function fromXML(xml:XML) : MapLight
      {
         default xml namespace = SoulNamespace.nameSpace;
         if(xml == null)
         {
            return null;
         }
         var ml:MapLight = new MapLight();
         ml.x = uint(xml.@x);
         ml.y = uint(xml.@y);
         ml.min = uint(xml.@min);
         ml.max = uint(xml.@max);
         ml.color = uint(xml.@color);
         ml.alpha = Number(xml.@alpha);
         ml.blendMode = String(xml.@blendMode);
         return ml;
      }
      
      public function clone() : MapLight
      {
         var ml:MapLight = new MapLight();
         ml.x = this.x;
         ml.y = this.y;
         ml.min = this.min;
         ml.max = this.max;
         ml.color = this.color;
         ml.alpha = this.alpha;
         ml.blendMode = this.blendMode;
         return ml;
      }
      
      public function toXML() : XML
      {
         default xml namespace = SoulNamespace.nameSpace;
         return new XML("<" + TAG + " x=\"" + this.x + "\" y=\"" + this.y + "\" min=\"" + this.min + "\" max=\"" + this.max + "\" color=\"" + this.color + "\" alpha=\"" + this.alpha + "\" blendMode=\"" + this.blendMode + "\" />");
      }
      
      public function applyAspectRatio() : void
      {
         default xml namespace = SoulNamespace.nameSpace;
         this.y /= AspectRatio.y;
      }
      
      public function removeAspectRatio() : void
      {
         default xml namespace = SoulNamespace.nameSpace;
         this.y *= AspectRatio.y;
      }
      
      public function toString() : String
      {
         default xml namespace = SoulNamespace.nameSpace;
         return "MapLight(" + this.blendMode + "):" + this.x + "," + this.y;
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
      
      [Bindable(event="propertyChange")]
      public function get min() : uint
      {
         return this._108114min;
      }
      
      public function set min(param1:uint) : void
      {
         var _loc2_:Object = this._108114min;
         if(_loc2_ !== param1)
         {
            this._108114min = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"min",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get max() : uint
      {
         return this._107876max;
      }
      
      public function set max(param1:uint) : void
      {
         var _loc2_:Object = this._107876max;
         if(_loc2_ !== param1)
         {
            this._107876max = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"max",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get color() : uint
      {
         return this._94842723color;
      }
      
      public function set color(param1:uint) : void
      {
         var _loc2_:Object = this._94842723color;
         if(_loc2_ !== param1)
         {
            this._94842723color = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"color",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get alpha() : Number
      {
         return this._92909918alpha;
      }
      
      public function set alpha(param1:Number) : void
      {
         var _loc2_:Object = this._92909918alpha;
         if(_loc2_ !== param1)
         {
            this._92909918alpha = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"alpha",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get blendMode() : String
      {
         return this._895597972blendMode;
      }
      
      public function set blendMode(param1:String) : void
      {
         var _loc2_:Object = this._895597972blendMode;
         if(_loc2_ !== param1)
         {
            this._895597972blendMode = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"blendMode",_loc2_,param1));
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

