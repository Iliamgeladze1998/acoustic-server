package soul.model.field.spriteconfig
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   import soul.SoulNamespace;
   
   public class SpritePhase implements IEventDispatcher
   {
      
      public static const TAG:String = "spritePhase";
      
      private var _3355id:String;
      
      private var _1996270002sprites:Array = [];
      
      private var _116085319zones:Array;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function SpritePhase(id:String = "")
      {
         super();
         this.id = id;
         this.zones = [new SpriteZone()];
      }
      
      public static function fromXML(xml:XML) : SpritePhase
      {
         var spriteX:XML = null;
         var zoneX:XML = null;
         default xml namespace = SoulNamespace.nameSpace;
         var phase:SpritePhase = new SpritePhase();
         phase.id = xml.@id;
         phase.sprites = [];
         for each(spriteX in xml[SpriteConfig.TAG])
         {
            phase.sprites.push(SpriteConfig.fromXML(spriteX));
         }
         phase.zones = [];
         for each(zoneX in xml[SpriteZone.TAG])
         {
            phase.zones.push(SpriteZone.fromXML(zoneX));
         }
         return phase;
      }
      
      public function toXML() : XML
      {
         var cfg:SpriteConfig = null;
         var zone:SpriteZone = null;
         default xml namespace = SoulNamespace.nameSpace;
         var xml:XML = new XML("<" + TAG + "/>");
         xml.@id = this.id;
         for each(cfg in this.sprites)
         {
            xml.appendChild(cfg.toXML());
         }
         for each(zone in this.zones)
         {
            xml.appendChild(zone.toXML());
         }
         return xml;
      }
      
      public function applyAspectRatio() : void
      {
         var cfg:SpriteConfig = null;
         var zone:SpriteZone = null;
         default xml namespace = SoulNamespace.nameSpace;
         for each(cfg in this.sprites)
         {
            cfg.applyAspectRatio();
         }
         for each(zone in this.zones)
         {
            zone.applyAspectRatio();
         }
      }
      
      public function removeAspectRatio() : void
      {
         var cfg:SpriteConfig = null;
         var zone:SpriteZone = null;
         default xml namespace = SoulNamespace.nameSpace;
         for each(cfg in this.sprites)
         {
            cfg.removeAspectRatio();
         }
         for each(zone in this.zones)
         {
            zone.removeAspectRatio();
         }
      }
      
      public function toString() : String
      {
         default xml namespace = SoulNamespace.nameSpace;
         return "SpritePhase \'" + this.id + "\'";
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
      public function get sprites() : Array
      {
         return this._1996270002sprites;
      }
      
      public function set sprites(param1:Array) : void
      {
         var _loc2_:Object = this._1996270002sprites;
         if(_loc2_ !== param1)
         {
            this._1996270002sprites = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sprites",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get zones() : Array
      {
         return this._116085319zones;
      }
      
      public function set zones(param1:Array) : void
      {
         var _loc2_:Object = this._116085319zones;
         if(_loc2_ !== param1)
         {
            this._116085319zones = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"zones",_loc2_,param1));
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

