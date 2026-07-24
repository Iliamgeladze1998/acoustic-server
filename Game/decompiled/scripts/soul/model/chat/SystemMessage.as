package soul.model.chat
{
   import mx.utils.StringUtil;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.TypedParam;
   
   public class SystemMessage extends Message
   {
      
      public var params:Array;
      
      private var _localizedParams:Array;
      
      public function SystemMessage()
      {
         super();
      }
      
      public function get localizedText() : String
      {
         return StringUtil.substitute(this.getString(type),this.localizedParams);
      }
      
      private function get localizedParams() : Array
      {
         var str:String = null;
         var mp:TypedParam = null;
         if(!this._localizedParams)
         {
            this._localizedParams = [];
            for each(mp in this.params)
            {
               this._localizedParams.push(LocaleManager.getTypedParam(mp.type,mp.value));
            }
         }
         return this._localizedParams;
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.CHAT,key);
      }
   }
}

