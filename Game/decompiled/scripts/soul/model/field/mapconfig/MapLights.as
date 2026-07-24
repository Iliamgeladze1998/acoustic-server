package soul.model.field.mapconfig
{
   import soul.SoulNamespace;
   import soul.model.field.IXMLSaving;
   
   public class MapLights implements IXMLSaving
   {
      
      public static const TAG:String = "lights";
      
      public var enabled:Boolean = false;
      
      public var color:uint = 16777215;
      
      public var lights:Array = [];
      
      public function MapLights()
      {
         super();
      }
      
      public static function fromXML(xml:XML) : MapLights
      {
         var node:XML = null;
         trace("MapLights.fromXML",xml);
         default xml namespace = SoulNamespace.nameSpace;
         var ml:MapLights = new MapLights();
         if(Boolean(xml))
         {
            ml.enabled = xml.@enabled;
            ml.color = uint(xml.@color);
            ml.lights = [];
            for each(node in xml[MapLight.TAG])
            {
               ml.lights.push(MapLight.fromXML(node));
            }
         }
         return ml;
      }
      
      public function toXML() : XML
      {
         var light:MapLight = null;
         default xml namespace = SoulNamespace.nameSpace;
         if(!this.enabled)
         {
            return null;
         }
         var xml:XML = new XML("<" + TAG + " color=\"" + this.color + "\" />");
         for each(light in this.lights)
         {
            xml.appendChild(light.toXML());
         }
         return xml;
      }
      
      public function applyAspectRatio() : void
      {
         var light:MapLight = null;
         default xml namespace = SoulNamespace.nameSpace;
         for each(light in this.lights)
         {
            light.applyAspectRatio();
         }
      }
      
      public function removeAspectRatio() : void
      {
         var light:MapLight = null;
         default xml namespace = SoulNamespace.nameSpace;
         for each(light in this.lights)
         {
            light.removeAspectRatio();
         }
      }
   }
}

