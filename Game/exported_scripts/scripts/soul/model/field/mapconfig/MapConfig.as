package soul.model.field.mapconfig
{
   import soul.SoulNamespace;
   
   public class MapConfig
   {
      
      public static const TAG:String = "map";
      
      public var mapLayout:MapLayout;
      
      public var layers:Array;
      
      public function MapConfig()
      {
         super();
         default xml namespace = SoulNamespace.nameSpace;
         this.mapLayout = new MapLayout();
         this.layers = [];
      }
      
      public static function fromXML(xml:XML) : MapConfig
      {
         var layerX:XML = null;
         default xml namespace = SoulNamespace.nameSpace;
         var cfg:MapConfig = new MapConfig();
         cfg.mapLayout = MapLayout.fromXML(xml[MapLayout.TAG][0]);
         cfg.layers = [];
         for each(layerX in xml[MapLayer.TAG])
         {
            cfg.layers.push(MapLayer.fromXML(layerX));
         }
         return cfg;
      }
      
      public function toXML() : XML
      {
         var layer:MapLayer = null;
         default xml namespace = SoulNamespace.nameSpace;
         var xml:XML = new XML("<" + TAG + "/>");
         xml.appendChild(this.mapLayout.toXML());
         for each(layer in this.layers)
         {
            xml.appendChild(layer.toXML());
         }
         return xml;
      }
   }
}

