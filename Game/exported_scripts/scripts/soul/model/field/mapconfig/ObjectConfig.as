package soul.model.field.mapconfig
{
   import soul.SoulNamespace;
   import soul.model.field.IXMLSaving;
   
   public class ObjectConfig implements IXMLSaving
   {
      
      public static const TAG:String = "object";
      
      public var id:String;
      
      public var active:Boolean;
      
      public var mirrored:Boolean;
      
      public var objective:Boolean;
      
      public var spriteId:String;
      
      public var x:int;
      
      public var y:int;
      
      public var phase:String;
      
      public function ObjectConfig()
      {
         super();
      }
      
      public static function fromXML(xml:XML) : ObjectConfig
      {
         default xml namespace = SoulNamespace.nameSpace;
         var cfg:ObjectConfig = new ObjectConfig();
         cfg.id = xml.@id;
         cfg.spriteId = xml.@spriteId;
         cfg.x = int(xml.@x);
         cfg.y = int(xml.@y);
         cfg.phase = xml.@phase;
         cfg.active = xml.@active == "true";
         cfg.mirrored = xml.@mirrored == "true";
         cfg.applyAspectRatio();
         return cfg;
      }
      
      public function clone() : ObjectConfig
      {
         var cfg:ObjectConfig = new ObjectConfig();
         cfg.id = this.id;
         cfg.active = this.active;
         cfg.spriteId = this.spriteId;
         cfg.x = this.x;
         cfg.y = this.y;
         cfg.phase = this.phase;
         return cfg;
      }
      
      public function toXML() : XML
      {
         default xml namespace = SoulNamespace.nameSpace;
         this.removeAspectRatio();
         var xml:XML = new XML("<" + TAG + "/>");
         if(Boolean(this.id) && this.id.length > 0)
         {
            xml.@id = this.id;
         }
         xml.@spriteId = this.spriteId;
         xml.@x = this.x;
         xml.@y = this.y;
         xml.@phase = this.phase;
         if(this.active)
         {
            xml.@active = this.active;
         }
         if(this.mirrored)
         {
            xml.@mirrored = this.mirrored;
         }
         this.applyAspectRatio();
         return xml;
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
   }
}

