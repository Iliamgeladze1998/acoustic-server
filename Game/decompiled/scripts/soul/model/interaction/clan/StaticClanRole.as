package soul.model.interaction.clan
{
   import flash.display.BitmapData;
   
   public class StaticClanRole
   {
      
      public static const HEAD:String = "HEAD";
      
      public static const VICE_HEAD:String = "VICE_HEAD";
      
      public static const OFFICER:String = "OFFICER";
      
      public static const SOLDIER:String = "SOLDIER";
      
      public static const RECRUIT:String = "RECRUIT";
      
      private static const head:Class = StaticClanRole_head;
      
      private static const vice:Class = StaticClanRole_vice;
      
      private static const officer:Class = StaticClanRole_officer;
      
      private static const soldier:Class = StaticClanRole_soldier;
      
      private static const recruit:Class = StaticClanRole_recruit;
      
      private static const icons:Object = {};
      
      icons[HEAD] = new head().bitmapData;
      icons[VICE_HEAD] = new vice().bitmapData;
      icons[OFFICER] = new officer().bitmapData;
      icons[SOLDIER] = new soldier().bitmapData;
      icons[RECRUIT] = new recruit().bitmapData;
      
      public function StaticClanRole()
      {
         super();
      }
      
      public static function getSackIcon(value:String) : BitmapData
      {
         return icons[value];
      }
   }
}

