package soul.view.toolTip
{
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.view.assets.Assets;
   
   public class SoulToolTipBase extends ToolTipBase
   {
      
      public static const DELIMITER:String = ":";
      
      public static const PREFIX_LOOT:String = "loot";
      
      public static const PREFIX_ITEM:String = "item";
      
      public static const PREFIX_TEMPLATE:String = "template";
      
      protected static const reqBonPrefix:String = "- ";
      
      protected static const reqBonSuffix:String = ": ";
      
      private static const bundles:Array = [BundleName.TOOLTIP,BundleName.INTERFACE];
      
      public function SoulToolTipBase()
      {
         super();
         borderSkin = Assets.tooltipBorder;
      }
      
      protected static function createSplitter() : TipSplitter
      {
         var splitter:TipSplitter = null;
         splitter = new TipSplitter();
         splitter.percentWidth = 100;
         splitter.height = 1;
         return splitter;
      }
      
      protected static function getString(key:String) : String
      {
         var bundle:String = null;
         var str:String = null;
         for each(bundle in bundles)
         {
            str = LocaleManager.getString(bundle,key);
            if(str != key)
            {
               return str;
            }
         }
         return key;
      }
   }
}

