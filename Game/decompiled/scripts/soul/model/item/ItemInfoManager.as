package soul.model.item
{
   import flash.events.EventDispatcher;
   import soul.net.ServerLayer;
   import soul.view.toolTip.SoulToolTipBase;
   
   public class ItemInfoManager extends EventDispatcher
   {
      
      private static var cache:Array = [];
      
      public function ItemInfoManager()
      {
         super();
      }
      
      public static function hasInfo(itemId:String) : Boolean
      {
         return cache[itemId] != null;
      }
      
      public static function removeInfo(itemId:String) : void
      {
         cache[itemId] = null;
      }
      
      public static function getItemInfo(itemId:String) : ItemInfoData
      {
         return cache[itemId];
      }
      
      public static function requestInfo(itemId:String, callBack:Function) : void
      {
         var arr:Array;
         var realType:String;
         var realId:String = null;
         var result:Function = null;
         var fault:Function = null;
         result = function(ii:ItemInfoData = null):void
         {
            try
            {
               if(realId.substr(0,1) != "-")
               {
                  cache[itemId] = ii;
               }
               callBack(ii);
            }
            catch(e:Error)
            {
            }
         };
         fault = function(f:Object = null):void
         {
            callBack(null);
         };
         if(itemId.indexOf(SoulToolTipBase.DELIMITER) == -1)
         {
            return;
         }
         arr = itemId.split(SoulToolTipBase.DELIMITER);
         realType = arr[0];
         realId = arr[1];
         switch(realType)
         {
            case SoulToolTipBase.PREFIX_TEMPLATE:
               ServerLayer.call("itemInfoService","getTemplateInfo",result,fault,realId);
               break;
            case SoulToolTipBase.PREFIX_ITEM:
            default:
               ServerLayer.call("itemInfoService","getItemInfo",result,fault,realId);
         }
      }
      
      public static function removeCacheEntry(itemId:String) : void
      {
         var id:String = SoulToolTipBase.PREFIX_ITEM + SoulToolTipBase.DELIMITER + itemId;
         delete cache[id];
      }
   }
}

