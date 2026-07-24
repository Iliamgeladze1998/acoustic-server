package soul.sorting
{
   public class Segment
   {
      
      public var id:int;
      
      public var x:int;
      
      public function Segment(id:int, x:int)
      {
         super();
         this.id = id;
         this.x = x;
      }
      
      public function toString() : String
      {
         return "Segment x:" + this.x + ", id: " + this.id;
      }
   }
}

