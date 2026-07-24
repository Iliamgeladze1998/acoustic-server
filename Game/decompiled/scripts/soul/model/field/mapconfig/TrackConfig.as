package soul.model.field.mapconfig
{
   import soul.SoulNamespace;
   
   public class TrackConfig
   {
      
      public static const TAG:String = "track";
      
      public var id:String = "";
      
      public var points:Array;
      
      public var patrolType:String = "bounce";
      
      public var delay:String;
      
      public var scatter:uint;
      
      public function TrackConfig(x:int = 0, y:int = 0)
      {
         super();
         this.points = [new TrackPointConfig(x,y)];
      }
      
      public static function fromXML(xml:XML) : TrackConfig
      {
         var objectNode:XML = null;
         var point:TrackPointConfig = null;
         default xml namespace = SoulNamespace.nameSpace;
         var cfg:TrackConfig = new TrackConfig();
         cfg.points = [];
         for each(objectNode in xml.trackPoint)
         {
            point = new TrackPointConfig(objectNode.@x,objectNode.@y);
            point.delay = objectNode.@delay;
            point.scatter = objectNode.@scatter;
            cfg.points.push(point);
         }
         cfg.id = xml.@id;
         cfg.delay = xml.@delay;
         cfg.scatter = uint(xml.@scatter);
         cfg.patrolType = xml.@patrolType;
         cfg.applyAspectRatio();
         return cfg;
      }
      
      public function toXML() : XML
      {
         var pointX:XML = null;
         var point:TrackPointConfig = null;
         this.removeAspectRatio();
         default xml namespace = SoulNamespace.nameSpace;
         var xml:XML = new XML("<" + TAG + "/>");
         if(Boolean(this.id) && this.id.length > 0)
         {
            xml.@id = this.id;
         }
         if(Boolean(this.delay) && this.delay.length > 0)
         {
            xml.@delay = this.delay;
         }
         if(this.scatter > 0)
         {
            xml.@scatter = this.scatter;
         }
         xml.@patrolType = this.patrolType;
         for each(point in this.points)
         {
            pointX = <trackPoint/>;
            pointX.@x = point.x;
            pointX.@y = point.y;
            if(Boolean(point.delay) && point.delay.length > 0)
            {
               pointX.@delay = point.delay;
            }
            if(!isNaN(point.scatter))
            {
               pointX.@scatter = point.scatter;
            }
            xml.appendChild(pointX);
         }
         this.applyAspectRatio();
         return xml;
      }
      
      public function applyAspectRatio() : void
      {
         var point:TrackPointConfig = null;
         default xml namespace = SoulNamespace.nameSpace;
         for each(point in this.points)
         {
            point.y /= AspectRatio.y;
         }
      }
      
      public function removeAspectRatio() : void
      {
         var point:TrackPointConfig = null;
         default xml namespace = SoulNamespace.nameSpace;
         for each(point in this.points)
         {
            point.y *= AspectRatio.y;
         }
      }
   }
}

