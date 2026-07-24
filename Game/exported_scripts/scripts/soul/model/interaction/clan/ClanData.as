package soul.model.interaction.clan
{
   public class ClanData extends ClanInfo
   {
      
      public var maxMembers:uint;
      
      public var creationCost:uint;
      
      public var changeCost:uint;
      
      public var inviteCost:uint;
      
      public var rubies:uint;
      
      public var roles:Object;
      
      public var clanBonuses:Array;
      
      public var memberBonuses:Array;
      
      public var points:uint;
      
      public var log:Array;
      
      public var storage:Array;
      
      public function ClanData()
      {
         super();
      }
   }
}

