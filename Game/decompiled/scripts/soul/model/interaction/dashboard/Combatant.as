package soul.model.interaction.dashboard
{
   import soul.model.item.Item;
   
   public class Combatant
   {
      
      public var name:String;
      
      public var id:String;
      
      public var level:uint;
      
      public var disposition:String;
      
      public var kills:uint;
      
      public var deaths:uint;
      
      public var assists:uint;
      
      public var minions:uint;
      
      public var structures:uint;
      
      public var score:int;
      
      public var reward:Item;
      
      public function Combatant()
      {
         super();
      }
   }
}

