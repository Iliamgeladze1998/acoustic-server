package soul.model.interaction.ruby
{
   import soul.model.character.ParamBonus;
   
   public class Subscription
   {
      
      public var autoRenew:Boolean;
      
      public var type:String;
      
      public var minLevel:int;
      
      public var maxLevel:int;
      
      public var prices:Array;
      
      public var bonus:ParamBonus;
      
      public var otherBonuses:Object;
      
      public function Subscription()
      {
         super();
      }
   }
}

