package soul.view.interaction.inventory.encrust
{
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.item.ItemSubType;
   import soul.view.common.Icons;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Tile;
   
   public class AllowedJewelTypes extends Tile
   {
      
      private static const typeMap:Object = {};
      
      typeMap[ItemSubType.JEWEL01] = Icons.jewel_01;
      typeMap[ItemSubType.JEWEL02] = Icons.jewel_02;
      typeMap[ItemSubType.JEWEL03] = Icons.jewel_03;
      typeMap[ItemSubType.JEWEL04] = Icons.jewel_04;
      typeMap[ItemSubType.JEWEL05] = Icons.jewel_05;
      typeMap[ItemSubType.JEWEL06] = Icons.jewel_06;
      typeMap[ItemSubType.JEWEL07] = Icons.jewel_07;
      typeMap[ItemSubType.JEWEL08] = Icons.jewel_08;
      typeMap[ItemSubType.JEWEL09] = Icons.jewel_09;
      typeMap[ItemSubType.JEWEL10] = Icons.jewel_10;
      typeMap[ItemSubType.JEWEL11] = Icons.jewel_11;
      typeMap[ItemSubType.JEWEL12] = Icons.jewel_12;
      
      public function AllowedJewelTypes()
      {
         super();
      }
      
      public function set allowedTypes(value:Array) : void
      {
         var type:String = null;
         var child:CachedImage = null;
         removeAllChildren();
         for each(type in value)
         {
            child = new CachedImage();
            child.source = typeMap[type];
            child.toolTip = LocaleManager.getString(BundleName.TOOLTIP,type);
            addChild(child);
         }
      }
   }
}

