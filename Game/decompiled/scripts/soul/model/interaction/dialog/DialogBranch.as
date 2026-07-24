package soul.model.interaction.dialog
{
   public class DialogBranch
   {
      
      public var id:String;
      
      public var locId:String;
      
      public var image:String;
      
      public var requirements:Array;
      
      public var minReputations:Object;
      
      public var maxReputations:Object;
      
      public var rewards:Array;
      
      public var metaRewards:Array;
      
      public var answers:Array;
      
      public var minLevel:int;
      
      public var maxLevel:int;
      
      public var difficulty:String;
      
      public var questGiver:String;
      
      public var questGiverLocation:String;
      
      public var questTargetLocation:Array;
      
      public function DialogBranch()
      {
         super();
      }
   }
}

