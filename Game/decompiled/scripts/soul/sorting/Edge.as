package soul.sorting
{
   import flash.geom.Point;
   
   public class Edge
   {
      
      private static var nextId:int = 0;
      
      public const id:int = nextId++;
      
      public var from:Point;
      
      public var to:Point;
      
      public function Edge()
      {
         super();
      }
      
      public function toString() : String
      {
         return "Edge id: " + this.id + ", from:" + this.from + ", to: " + this.to;
      }
      
      public function equals(edge:Edge) : Boolean
      {
         return this.pointsEqual(this.from,edge.from) && this.pointsEqual(this.to,edge.to);
      }
      
      private function pointsEqual(p1:Point, p2:Point) : Boolean
      {
         var x1:int = int(p1.x);
         var x2:int = int(p2.x);
         var y1:int = int(p1.y);
         var y2:int = int(p2.y);
         return x1 == x2 && y1 == y2;
      }
   }
}

