package soulex
{
   public class CharacterInfo
   {
      
      private static const TAG:String = "CharacterInfo";
      
      public var id:String;
      
      public var name:String;
      
      public var serverId:String;
      
      public var disposition:String;
      
      public var level:uint;
      
      public var sex:String;
      
      public var side:String;
      
      public var location:String;
      
      public var avatar:String;
      
      public function CharacterInfo()
      {
         super();
      }
      
      public static function load(data:String) : Array
      {
         var x:XML = null;
         var сi:CharacterInfo = null;
         var arr:Array = [];
         var xml:XML = new XML(data);
         for each(x in xml[TAG])
         {
            сi = new CharacterInfo();
            сi.id = x.@id;
            сi.name = x.@name;
            сi.serverId = x.@serverId;
            сi.disposition = x.@disposition;
            сi.sex = x.@sex;
            сi.level = x.@level;
            сi.side = x.@side;
            сi.location = x.@location;
            сi.avatar = x.@avatar;
            arr.push(сi);
         }
         return arr;
      }
   }
}

