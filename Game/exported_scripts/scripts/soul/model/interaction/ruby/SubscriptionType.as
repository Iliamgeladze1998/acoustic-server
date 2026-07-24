package soul.model.interaction.ruby
{
   public class SubscriptionType
   {
      
      public static const STARTER:String = "STARTER";
      
      public static const SILVER:String = "SILVER";
      
      public static const GOLD:String = "GOLD";
      
      public static const PLATINUM:String = "PLATINUM";
      
      public static const starter:Class = SubscriptionType_starter;
      
      public static const silver:Class = SubscriptionType_silver;
      
      public static const gold:Class = SubscriptionType_gold;
      
      public static const platinum:Class = SubscriptionType_platinum;
      
      private static const icons:Object = {};
      
      public static const starterSmall:Class = SubscriptionType_starterSmall;
      
      public static const silverSmall:Class = SubscriptionType_silverSmall;
      
      public static const goldSmall:Class = SubscriptionType_goldSmall;
      
      public static const platinumSmall:Class = SubscriptionType_platinumSmall;
      
      public static const noneSmall:Class = SubscriptionType_noneSmall;
      
      private static const smallIcons:Object = {};
      
      public static const starterMed:Class = SubscriptionType_starterMed;
      
      public static const silverMed:Class = SubscriptionType_silverMed;
      
      public static const goldMed:Class = SubscriptionType_goldMed;
      
      public static const platinumMed:Class = SubscriptionType_platinumMed;
      
      public static const noneMed:Class = SubscriptionType_noneMed;
      
      private static const medIcons:Object = {};
      
      public static const months12:Class = SubscriptionType_months12;
      
      public static const month1:Class = SubscriptionType_month1;
      
      public static const months3:Class = SubscriptionType_months3;
      
      public static const months6:Class = SubscriptionType_months6;
      
      public static const week1:Class = SubscriptionType_week1;
      
      public static const renew:Class = SubscriptionType_renew;
      
      private static const termIcons:Array = [week1,month1,months3,months6,months12];
      
      icons[STARTER] = starter;
      icons[SILVER] = silver;
      icons[GOLD] = gold;
      icons[PLATINUM] = platinum;
      smallIcons[STARTER] = starterSmall;
      smallIcons[SILVER] = silverSmall;
      smallIcons[GOLD] = goldSmall;
      smallIcons[PLATINUM] = platinumSmall;
      medIcons[STARTER] = starterMed;
      medIcons[SILVER] = silverMed;
      medIcons[GOLD] = goldMed;
      medIcons[PLATINUM] = platinumMed;
      
      public function SubscriptionType()
      {
         super();
      }
      
      public static function getIcon(type:String) : Class
      {
         return icons[type];
      }
      
      public static function getSmallIcon(type:String) : Class
      {
         return smallIcons[type] || noneSmall;
      }
      
      public static function getMedIcon(type:String) : Class
      {
         return medIcons[type] || noneMed;
      }
      
      public static function getTermIcon(index:int) : Class
      {
         return termIcons[index];
      }
   }
}

