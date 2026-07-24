package soul.model.field
{
   public class QuestGiverStatus
   {
      
      public static const READY:String = "READY";
      
      public static const AVAILABLE:String = "AVAILABLE";
      
      public static const REPEATABLE:String = "REPEATABLE";
      
      public static const TAKEN:String = "TAKEN";
      
      public static const COMING_SOON:String = "COMING_SOON";
      
      public static const exclamation:Class = QuestGiverStatus_exclamation;
      
      public static const question:Class = QuestGiverStatus_question;
      
      public static const questionDisabled:Class = QuestGiverStatus_questionDisabled;
      
      public static const dialog:Class = QuestGiverStatus_dialog;
      
      private static const smallIcons:Object = {};
      
      public static const roundComing:Class = QuestGiverStatus_roundComing;
      
      public static const roundAvailable:Class = QuestGiverStatus_roundAvailable;
      
      public static const roundTaken:Class = QuestGiverStatus_roundTaken;
      
      public static const roundReady:Class = QuestGiverStatus_roundReady;
      
      private static const roundIcons:Object = {};
      
      public static const questAvailable:Class = QuestGiverStatus_questAvailable;
      
      public static const questComingSoon:Class = QuestGiverStatus_questComingSoon;
      
      public static const questReady:Class = QuestGiverStatus_questReady;
      
      public static const questTaken:Class = QuestGiverStatus_questTaken;
      
      public static const questRepeatable:Class = QuestGiverStatus_questRepeatable;
      
      private static const icons:Object = {};
      
      smallIcons[AVAILABLE] = exclamation;
      smallIcons[TAKEN] = questionDisabled;
      smallIcons[READY] = question;
      roundIcons[COMING_SOON] = roundComing;
      roundIcons[AVAILABLE] = roundAvailable;
      roundIcons[TAKEN] = roundTaken;
      roundIcons[READY] = roundReady;
      icons[AVAILABLE] = questAvailable;
      icons[COMING_SOON] = questComingSoon;
      icons[READY] = questReady;
      icons[TAKEN] = questTaken;
      icons[REPEATABLE] = questRepeatable;
      
      public function QuestGiverStatus()
      {
         super();
      }
      
      public static function getSmallIcon(status:String) : Class
      {
         return smallIcons[status] || dialog;
      }
      
      public static function getRoundIcon(status:String) : Class
      {
         return roundIcons[status] || dialog;
      }
      
      public static function getIcon(status:String) : Class
      {
         return icons[status];
      }
   }
}

