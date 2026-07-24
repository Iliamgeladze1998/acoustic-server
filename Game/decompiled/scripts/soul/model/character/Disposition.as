package soul.model.character
{
   public class Disposition
   {
      
      public static const KNIGHT:String = "KNIGHT";
      
      public static const ROGUE:String = "ROGUE";
      
      public static const ACOLYTE:String = "ACOLYTE";
      
      public static const WIZARD:String = "WIZARD";
      
      public static const BERSERK:String = "BERSERK";
      
      public static const STING:String = "STING";
      
      public static const BELIEVER:String = "BELIEVER";
      
      public static const SHAMAN:String = "SHAMAN";
      
      private static const classMap:Object = {};
      
      private static const groupMap:Object = {};
      
      classMap[Side.GREAT_EMPIRE + "." + DispositionGroup.WARRIOR] = KNIGHT;
      classMap[Side.GREAT_EMPIRE + "." + DispositionGroup.THIEF] = ROGUE;
      classMap[Side.GREAT_EMPIRE + "." + DispositionGroup.PRIEST] = ACOLYTE;
      classMap[Side.GREAT_EMPIRE + "." + DispositionGroup.MAGICIAN] = WIZARD;
      classMap[Side.WASTELAND + "." + DispositionGroup.WARRIOR] = BERSERK;
      classMap[Side.WASTELAND + "." + DispositionGroup.THIEF] = STING;
      classMap[Side.WASTELAND + "." + DispositionGroup.PRIEST] = BELIEVER;
      classMap[Side.WASTELAND + "." + DispositionGroup.MAGICIAN] = SHAMAN;
      groupMap[BERSERK] = DispositionGroup.WARRIOR;
      groupMap[KNIGHT] = DispositionGroup.WARRIOR;
      groupMap[ROGUE] = DispositionGroup.THIEF;
      groupMap[STING] = DispositionGroup.THIEF;
      groupMap[ACOLYTE] = DispositionGroup.PRIEST;
      groupMap[BELIEVER] = DispositionGroup.PRIEST;
      groupMap[SHAMAN] = DispositionGroup.MAGICIAN;
      groupMap[WIZARD] = DispositionGroup.MAGICIAN;
      
      public function Disposition()
      {
         super();
      }
      
      public static function getBySideAndClass(side:String, klass:String) : String
      {
         return classMap[side + "." + klass];
      }
      
      public static function getDispositionGroup(klass:String) : String
      {
         return groupMap[klass];
      }
   }
}

