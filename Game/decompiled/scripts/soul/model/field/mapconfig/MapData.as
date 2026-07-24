package soul.model.field.mapconfig
{
   import soul.model.field.spriteconfig.ObjectLayout;
   
   public class MapData
   {
      
      public var sectorId:String;
      
      public var mapId:String;
      
      public var mapLayout:MapLayout;
      
      public var effect:String;
      
      public var sprites:Object;
      
      public var visuals:Array;
      
      public var pvpState:String;
      
      public function MapData()
      {
         super();
      }
      
      public function applyAspectRatio() : void
      {
         var config:ObjectLayout = null;
         this.mapLayout.applyAspectRatio();
         for each(config in this.sprites)
         {
            config.applyAspectRatio();
         }
      }
   }
}

