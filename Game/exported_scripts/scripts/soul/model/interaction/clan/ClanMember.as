package soul.model.interaction.clan
{
   import flash.events.EventDispatcher;
   
   public class ClanMember extends EventDispatcher
   {
      
      public var id:String;
      
      public var name:String;
      
      public var level:String;
      
      public var disposition:String;
      
      public var role:String;
      
      public var online:Boolean;
      
      public var lastLogin:String;
      
      [Bindable("clanRoleChanged")]
      public var clanRole:ClanRole;
      
      public function ClanMember()
      {
         super();
      }
   }
}

