package soul.model.interaction.clan
{
   import soul.controller.locale.LocaleManager;
   
   public class ClanRole
   {
      
      public var priority:uint;
      
      public var role:String;
      
      public var permissions:Array;
      
      public function ClanRole()
      {
         super();
      }
      
      public function get localizedName() : String
      {
         return LocaleManager.getClanRole(this.role);
      }
      
      public function hasPermission(permission:String) : Boolean
      {
         return this.permissions.indexOf(permission) > -1;
      }
   }
}

