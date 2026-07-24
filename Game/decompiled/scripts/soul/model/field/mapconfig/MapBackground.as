package soul.model.field.mapconfig
{
   import soul.SoulNamespace;
   
   public class MapBackground
   {
      
      public static const TAG:String = "background";
      
      public var id:String;
      
      public var library:String;
      
      public function MapBackground(id:String = "", library:String = "")
      {
         super();
         this.id = id;
         this.library = library;
      }
      
      public static function fromXML(xml:XML) : MapBackground
      {
         trace("MapBackground.fromXML()",xml);
         default xml namespace = SoulNamespace.nameSpace;
         return Boolean(xml) ? new MapBackground(xml.@id,xml.@library) : null;
      }
      
      public function toXML() : XML
      {
         default xml namespace = SoulNamespace.nameSpace;
         var xml:XML = new XML("<" + TAG + " />");
         xml.@id = this.id;
         xml.@library = this.library;
         return xml;
      }
   }
}

