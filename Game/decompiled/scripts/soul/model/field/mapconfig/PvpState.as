package soul.model.field.mapconfig
{
   public class PvpState
   {
      
      public static const PVE:String = "PVE";
      
      public static const SVS:String = "SVS";
      
      public static const PVP:String = "PVP";
      
      public static const TVT:String = "TVT";
      
      private static const mapColors:Object = {};
      
      private static const textColors:Object = {};
      
      public static const squarePve:Class = PvpState_squarePve;
      
      public static const squarePvp:Class = PvpState_squarePvp;
      
      public static const squareSvs:Class = PvpState_squareSvs;
      
      private static const squareIcons:Object = {};
      
      public static const roundPve:Class = PvpState_roundPve;
      
      public static const roundPvp:Class = PvpState_roundPvp;
      
      public static const roundSvs:Class = PvpState_roundSvs;
      
      private static const roundIcons:Object = {};
      
      mapColors[PVE] = 3632900;
      mapColors[SVS] = 8553021;
      mapColors[PVP] = 10160907;
      mapColors[TVT] = 8553021;
      textColors[PVE] = 52224;
      textColors[SVS] = 10658413;
      textColors[PVP] = 12270395;
      textColors[TVT] = 10658413;
      squareIcons[PVE] = squarePve;
      squareIcons[PVP] = squarePvp;
      squareIcons[SVS] = squareSvs;
      roundIcons[PVE] = roundPve;
      roundIcons[PVP] = roundPvp;
      roundIcons[SVS] = roundSvs;
      
      public function PvpState()
      {
         super();
      }
      
      public static function getMapColor(status:String) : uint
      {
         return Boolean(mapColors[status]) ? uint(mapColors[status]) : uint(mapColors[SVS]);
      }
      
      public static function getTextColor(status:String) : uint
      {
         return Boolean(textColors[status]) ? uint(textColors[status]) : uint(textColors[SVS]);
      }
      
      public static function getSquareIcon(type:String) : Class
      {
         return squareIcons[type] || squarePve;
      }
      
      public static function getRoundIcon(type:String) : Class
      {
         return roundIcons[type];
      }
   }
}

