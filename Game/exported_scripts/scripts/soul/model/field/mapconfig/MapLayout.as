package soul.model.field.mapconfig
{
   import mx.utils.ObjectUtil;
   import soul.SoulNamespace;
   import soul.model.field.spriteconfig.SpritePoint;
   
   public class MapLayout
   {
      
      public static const TAG:String = "layout";
      
      public var id:String;
      
      public var deepBackground:MapBackground;
      
      public var deepBgScrollSpeed:Number = 0;
      
      public var background:MapBackground;
      
      public var borderPoints:Array;
      
      public var fillZones:Array;
      
      public var width:int;
      
      public var height:int;
      
      public var layer:MapLayer = new MapLayer();
      
      public var lights:MapLights = new MapLights();
      
      public function MapLayout()
      {
         super();
      }
      
      public static function fromXML(xml:XML) : MapLayout
      {
         var objectNode:XML = null;
         trace("MapLayout.fromXML",xml);
         default xml namespace = SoulNamespace.nameSpace;
         var cfg:MapLayout = new MapLayout();
         cfg.id = xml.@id;
         cfg.width = xml.@width;
         cfg.height = xml.@height;
         cfg.deepBgScrollSpeed = isNaN(xml.@deepBgScrollSpeed) ? 0 : Number(xml.@deepBgScrollSpeed);
         cfg.background = MapBackground.fromXML(xml.background[0]);
         cfg.deepBackground = MapBackground.fromXML(xml.deepBackground[0]);
         cfg.borderPoints = [];
         for each(objectNode in xml.borderPoint)
         {
            cfg.borderPoints.push(new SpritePoint(objectNode.@x,objectNode.@y));
         }
         cfg.fillZones = [];
         for each(objectNode in xml[MapFillZone.TAG])
         {
            cfg.fillZones.push(MapFillZone.fromXML(objectNode));
         }
         cfg.layer = MapLayer.fromXML(xml[MapLayer.TAG][0]);
         cfg.lights = MapLights.fromXML(xml[MapLights.TAG][0]);
         cfg.applyAspectRatio();
         return cfg;
      }
      
      public function toXML() : XML
      {
         var borderPoint:SpritePoint = null;
         var fillZone:MapFillZone = null;
         var lx:XML = null;
         var deep:XML = null;
         default xml namespace = SoulNamespace.nameSpace;
         this.removeAspectRatio();
         trace("Map.Layout.toString() \n" + ObjectUtil.toString(this));
         var xml:XML = new XML("<" + TAG + " id=\"" + this.id + "\" width=\"" + this.width + "\" height=\"" + this.height + "\" deepBgScrollSpeed=\"" + this.deepBgScrollSpeed + "\" />");
         if(Boolean(this.deepBackground))
         {
            deep = this.deepBackground.toXML();
            deep.setName("deepBackground");
            xml.appendChild(deep);
         }
         xml.appendChild(this.background.toXML());
         for each(borderPoint in this.borderPoints)
         {
            xml.appendChild(new XML("<borderPoint x=\"" + borderPoint.x + "\" y=\"" + borderPoint.y + "\"/>"));
         }
         for each(fillZone in this.fillZones)
         {
            xml.appendChild(fillZone.toXML());
         }
         xml.appendChild(this.layer.toXML());
         lx = this.lights.toXML();
         if(Boolean(lx))
         {
            xml.appendChild(lx);
         }
         this.applyAspectRatio();
         return xml;
      }
      
      public function applyAspectRatio() : void
      {
         var point:SpritePoint = null;
         var mfz:MapFillZone = null;
         default xml namespace = SoulNamespace.nameSpace;
         this.height /= AspectRatio.y;
         for each(point in this.borderPoints)
         {
            point.applyAspectRatio();
         }
         for each(mfz in this.fillZones)
         {
            mfz.applyAspectRatio();
         }
         this.layer.applyAspectRatio();
         if(Boolean(this.lights))
         {
            this.lights.applyAspectRatio();
         }
      }
      
      public function removeAspectRatio() : void
      {
         var point:SpritePoint = null;
         var mfz:MapFillZone = null;
         default xml namespace = SoulNamespace.nameSpace;
         this.height *= AspectRatio.y;
         for each(point in this.borderPoints)
         {
            point.removeAspectRatio();
         }
         for each(mfz in this.fillZones)
         {
            mfz.removeAspectRatio();
         }
         this.layer.removeAspectRatio();
         if(Boolean(this.lights))
         {
            this.lights.removeAspectRatio();
         }
      }
   }
}

