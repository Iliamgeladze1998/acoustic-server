package soul.model.field.mapconfig
{
   import soul.SoulNamespace;
   import soul.model.field.spriteconfig.SpritePoint;
   
   public class TriggerZoneConfig
   {
      
      public static const TAG:String = "triggerZone";
      
      public var id:String = "";
      
      public var x:int;
      
      public var y:int;
      
      public var points:Array;
      
      public function TriggerZoneConfig()
      {
         super();
         this.points = [];
         this.points.push(new SpritePoint(0,0));
         this.points.push(new SpritePoint(50,0));
         this.points.push(new SpritePoint(50,50));
         this.points.push(new SpritePoint(0,50));
      }
      
      public static function fromXML(xml:XML) : TriggerZoneConfig
      {
         var objectNode:XML = null;
         var point:SpritePoint = null;
         default xml namespace = SoulNamespace.nameSpace;
         var cfg:TriggerZoneConfig = new TriggerZoneConfig();
         cfg.points = [];
         for each(objectNode in xml.point)
         {
            point = new SpritePoint(objectNode.@x,objectNode.@y);
            cfg.points.push(point);
         }
         cfg.id = xml.@id;
         cfg.x = xml.@x;
         cfg.y = xml.@y;
         cfg.applyAspectRatio();
         return cfg;
      }
      
      public function clone() : TriggerZoneConfig
      {
         var sp:SpritePoint = null;
         var tzc:TriggerZoneConfig = new TriggerZoneConfig();
         tzc.id = this.id;
         tzc.x = this.x;
         tzc.y = this.y;
         tzc.points = [];
         for each(sp in this.points)
         {
            tzc.points.push(sp.clone());
         }
         return tzc;
      }
      
      public function setId(value:String) : void
      {
         this.id = value;
      }
      
      public function getId() : String
      {
         return Boolean(this.id) ? this.id : "";
      }
      
      public function toXML() : XML
      {
         var pointX:XML = null;
         var point:SpritePoint = null;
         this.removeAspectRatio();
         default xml namespace = SoulNamespace.nameSpace;
         var xml:XML = new XML("<" + TAG + "/>");
         if(Boolean(this.id) && this.id.length > 0)
         {
            xml.@id = this.id;
         }
         xml.@x = this.x;
         xml.@y = this.y;
         for each(point in this.points)
         {
            pointX = <point/>;
            pointX.@x = point.x;
            pointX.@y = point.y;
            xml.appendChild(pointX);
         }
         this.applyAspectRatio();
         return xml;
      }
      
      public function applyAspectRatio() : void
      {
         var point:SpritePoint = null;
         default xml namespace = SoulNamespace.nameSpace;
         this.y /= AspectRatio.y;
         for each(point in this.points)
         {
            point.y /= AspectRatio.y;
         }
      }
      
      public function removeAspectRatio() : void
      {
         var point:SpritePoint = null;
         default xml namespace = SoulNamespace.nameSpace;
         this.y *= AspectRatio.y;
         for each(point in this.points)
         {
            point.y *= AspectRatio.y;
         }
      }
   }
}

