package soul.model.field.spriteconfig
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   import soul.SoulNamespace;
   import soul.model.field.mapconfig.AspectRatio;
   
   public class SpriteConfig implements IEventDispatcher
   {
      
      public static const TAG:String = "sprite";
      
      private var _3355id:String;
      
      private var _166208699library:String;
      
      private var _120x:int;
      
      private var _121y:int;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function SpriteConfig()
      {
         super();
      }
      
      public static function fromXML(xml:XML) : SpriteConfig
      {
         default xml namespace = SoulNamespace.nameSpace;
         var sz:SpriteConfig = new SpriteConfig();
         sz.id = xml.@id;
         sz.library = xml.@library;
         sz.x = xml.@x;
         sz.y = xml.@y;
         return sz;
      }
      
      public function toString() : String
      {
         return "Sprite " + this.x + "," + this.y;
      }
      
      public function toXML() : XML
      {
         default xml namespace = SoulNamespace.nameSpace;
         var sprite:XML = <sprite />;
         sprite.@id = this.id;
         sprite.@library = this.library;
         sprite.@x = this.x;
         sprite.@y = this.y;
         return sprite;
      }
      
      public function applyAspectRatio() : void
      {
         default xml namespace = SoulNamespace.nameSpace;
         this.x /= AspectRatio.x;
         this.y /= AspectRatio.y;
      }
      
      public function removeAspectRatio() : void
      {
         default xml namespace = SoulNamespace.nameSpace;
         this.x *= AspectRatio.x;
         this.y *= AspectRatio.y;
      }
      
      [Bindable(event="propertyChange")]
      public function get id() : String
      {
         return this._3355id;
      }
      
      public function set id(param1:String) : void
      {
         var _loc2_:Object = this._3355id;
         if(_loc2_ !== param1)
         {
            this._3355id = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"id",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get library() : String
      {
         return this._166208699library;
      }
      
      public function set library(param1:String) : void
      {
         var _loc2_:Object = this._166208699library;
         if(_loc2_ !== param1)
         {
            this._166208699library = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"library",_loc2_,param1));
            }
         }
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

