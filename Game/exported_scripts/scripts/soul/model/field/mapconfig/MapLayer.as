package soul.model.field.mapconfig
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   import soul.SoulNamespace;
   
   public class MapLayer implements IEventDispatcher
   {
      
      public static const TAG:String = "layer";
      
      private var _3355id:String;
      
      public var objects:Array;
      
      public var triggerZones:Array;
      
      public var tracks:Array;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function MapLayer()
      {
         super();
      }
      
      public static function fromXML(xml:XML) : MapLayer
      {
         var objx:XML = null;
         var zonex:XML = null;
         var trackX:XML = null;
         trace("MapLayer.fromXML()",xml);
         default xml namespace = SoulNamespace.nameSpace;
         var layer:MapLayer = new MapLayer();
         layer.id = xml.@id;
         layer.objects = [];
         for each(objx in xml[ObjectConfig.TAG])
         {
            layer.objects.push(ObjectConfig.fromXML(objx));
         }
         layer.triggerZones = [];
         for each(zonex in xml[TriggerZoneConfig.TAG])
         {
            layer.triggerZones.push(TriggerZoneConfig.fromXML(zonex));
         }
         layer.tracks = [];
         for each(trackX in xml[TrackConfig.TAG])
         {
            layer.tracks.push(TrackConfig.fromXML(trackX));
         }
         return layer;
      }
      
      public function toXML() : XML
      {
         var object:ObjectConfig = null;
         var zone:TriggerZoneConfig = null;
         var track:TrackConfig = null;
         default xml namespace = SoulNamespace.nameSpace;
         var xml:XML = new XML("<" + TAG + "/>");
         xml.@id = this.id;
         for each(object in this.objects)
         {
            xml.appendChild(object.toXML());
         }
         for each(zone in this.triggerZones)
         {
            xml.appendChild(zone.toXML());
         }
         for each(track in this.tracks)
         {
            xml.appendChild(track.toXML());
         }
         return xml;
      }
      
      public function applyAspectRatio() : void
      {
         default xml namespace = SoulNamespace.nameSpace;
      }
      
      public function removeAspectRatio() : void
      {
         default xml namespace = SoulNamespace.nameSpace;
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

