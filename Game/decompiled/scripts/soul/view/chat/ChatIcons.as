package soul.view.chat
{
   import soul.model.chat.ChatTabModel;
   
   public class ChatIcons
   {
      
      public static const group:Class = ChatIcons_group;
      
      public static const privat:Class = ChatIcons_privat;
      
      public static const publik:Class = ChatIcons_publik;
      
      public static const system:Class = ChatIcons_system;
      
      public static const trade:Class = ChatIcons_trade;
      
      public static const combat:Class = ChatIcons_combat;
      
      public static const clan:Class = ChatIcons_clan;
      
      public static const userChannel:Class = ChatIcons_userChannel;
      
      private static const icons:Object = {};
      
      icons[ChatTabModel.PLACE] = publik;
      icons[ChatTabModel.GROUP] = group;
      icons[ChatTabModel.PLACE] = publik;
      icons[ChatTabModel.PRIVATE] = privat;
      icons[ChatTabModel.TRADE] = trade;
      icons[ChatTabModel.COMBAT] = combat;
      icons[ChatTabModel.SYSTEM] = system;
      icons[ChatTabModel.CLAN] = clan;
      
      public function ChatIcons()
      {
         super();
      }
      
      public static function getTabIcon(tabKey:String) : Class
      {
         return icons[tabKey] || userChannel;
      }
   }
}

