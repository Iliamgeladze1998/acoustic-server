package soul.model.item
{
   public class InvKey
   {
      
      public var sack:int;
      
      public var slot:int;
      
      public function InvKey(sack:int = 0, slot:int = 0)
      {
         super();
         this.sack = sack;
         this.slot = slot;
      }
      
      public function toString() : String
      {
         return "InvKey [" + this.sack + "," + this.slot + "]";
      }
   }
}

