package soul.model.character
{
   import soul.model.interaction.resurrection.ResurrectionData;
   
   public class CharacterData extends CharacterPublicData
   {
      
      public var portalId:int;
      
      public var currencies:Object;
      
      public var abilityCache:Array;
      
      public var abilityBook:Array;
      
      public var abilitySlots:Array;
      
      public var additionalPoints:Object;
      
      public var alternativeIndex:int;
      
      public var quiver:Array;
      
      public var selectedAmmoIndex:int;
      
      public var belt:Array;
      
      public var runMode:Boolean;
      
      public var attackMode:Boolean;
      
      public var fightMode:Boolean;
      
      public var messages:Array;
      
      public var instanceRecords:Array;
      
      public var resurrection:ResurrectionData;
      
      public var interaction:String;
      
      public function CharacterData()
      {
         super();
      }
   }
}

