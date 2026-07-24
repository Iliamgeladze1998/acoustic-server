package soul.sorting
{
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class EdgeOrder
   {
      
      public static const REORDER_DELAY:uint = 100;
      
      public static var applyIndexes:Boolean = true;
      
      private static const tSortRes:Vector.<int> = new Vector.<int>();
      
      private var spriteContainer:ISpriteContainer;
      
      private var spriteEdges:Dictionary = new Dictionary();
      
      private var reorder:Boolean = false;
      
      private var timer:Timer = new Timer(REORDER_DELAY);
      
      public function EdgeOrder(spriteContainer:ISpriteContainer)
      {
         super();
         this.spriteContainer = spriteContainer;
         this.reorderAll();
         this.timer.addEventListener(TimerEvent.TIMER,this.timerHandler);
         this.timer.start();
      }
      
      public static function edgeComparator(e1:Edge, e2:Edge) : int
      {
         var insidePoint:Point = null;
         var yp:int = 0;
         var tmp:Edge = null;
         var left:Edge = e1;
         var right:Edge = e2;
         var sgn:int = 1;
         if(left.from.x > right.from.x)
         {
            tmp = left;
            left = right;
            right = tmp;
            sgn = -1;
         }
         if(right.from.x >= left.from.x)
         {
            insidePoint = right.from;
            var dx:int = left.to.x - left.from.x;
            if(dx != 0)
            {
               yp = left.from.y + (left.to.y - left.from.y) * (insidePoint.x - left.from.x) / dx;
            }
            else
            {
               yp = left.from.y;
            }
            var res:int = sgn * (yp - insidePoint.y);
            if(res == 0)
            {
               return e1.id - e2.id;
            }
            return res;
         }
         return e1.id - e2.id;
      }
      
      public static function segmentComparator(s1:Segment, s2:Segment) : int
      {
         var cmp:int = s1.x - s2.x;
         return cmp == 0 ? int(s1.id - s2.id) : cmp;
      }
      
      private static function isComparable(e1:Edge, e2:Edge) : Boolean
      {
         var left:Edge = null;
         var right:Edge = null;
         if(e1.from.x > e2.from.x)
         {
            left = e2;
            right = e1;
         }
         else
         {
            left = e1;
            right = e2;
         }
         return left.to.x > right.from.x;
      }
      
      public function stop() : void
      {
         this.timer.stop();
      }
      
      private function timerHandler(e:TimerEvent) : void
      {
         if(this.reorder)
         {
            this.reorderAll();
         }
      }
      
      public function reorderAll() : void
      {
         var l:uint = 0;
         var order:Vector.<Object> = null;
         var i:int = 0;
         var indexes:Vector.<int> = this.graphSort();
         if(applyIndexes)
         {
            l = indexes.length;
            order = new Vector.<Object>(l,true);
            for(i = 0; i < l; i++)
            {
               order[i] = this.spriteContainer.getSpriteAt(indexes[i]);
            }
            for(i = 0; i < l; i++)
            {
               this.spriteContainer.setSpriteIndex(order[i],i);
            }
         }
         this.reorder = false;
      }
      
      private function graphSort() : Vector.<int>
      {
         var i:int = 0;
         var sprite1:Object = null;
         var edge1:Edge = null;
         var j:int = 0;
         var sprite2:Object = null;
         var edge2:Edge = null;
         var spriteCount:int = this.spriteContainer.spriteCount();
         var graphOut:Vector.<Vector.<int>> = new Vector.<Vector.<int>>(spriteCount,true);
         var graphIn:Vector.<Vector.<int>> = new Vector.<Vector.<int>>(spriteCount,true);
         for(i = 0; i < spriteCount; i++)
         {
            graphOut[i] = new Vector.<int>();
            graphIn[i] = new Vector.<int>();
         }
         for(i = 0; i < spriteCount - 1; i++)
         {
            sprite1 = this.spriteContainer.getSpriteAt(i);
            edge1 = this.spriteEdges[sprite1];
            for(j = i + 1; j < spriteCount; j++)
            {
               sprite2 = this.spriteContainer.getSpriteAt(j);
               edge2 = this.spriteEdges[sprite2];
               if(isComparable(edge1,edge2))
               {
                  if(edgeComparator(edge1,edge2) < 0)
                  {
                     graphOut[j].push(i);
                     graphIn[i].push(j);
                  }
                  else
                  {
                     graphOut[i].push(j);
                     graphIn[j].push(i);
                  }
               }
            }
         }
         return this.tSort(graphOut,graphIn);
      }
      
      private function toStringGraph(graph:Vector.<Vector.<int>>) : String
      {
         var i:int = 0;
         var res:String = "";
         for(i = 0; i < graph.length; i++)
         {
            res += i + ":[" + graph[i] + "], ";
         }
         return res;
      }
      
      private function tSort(graphOut:Vector.<Vector.<int>>, graphIn:Vector.<Vector.<int>>) : Vector.<int>
      {
         tSortRes.length = 0;
         var l:uint = graphIn.length;
         for(var i:int = 0; i < l; i++)
         {
            if(graphIn[i].length == 0)
            {
               this.visit(graphOut,tSortRes,i);
            }
         }
         return tSortRes;
      }
      
      private function visit(graphOut:Vector.<Vector.<int>>, res:Vector.<int>, n:int) : void
      {
         var m:int = 0;
         var siblings:Vector.<int> = graphOut[n];
         if(siblings != null)
         {
            graphOut[n] = null;
            for each(m in siblings)
            {
               this.visit(graphOut,res,m);
            }
            res.push(n);
         }
      }
      
      public function addSprite(sprite:Object, reorder:Boolean = true) : void
      {
         if(Boolean(this.spriteEdges[sprite]))
         {
            return;
         }
         this.createEdge(sprite);
         if(reorder)
         {
            this.reorder = true;
         }
      }
      
      public function removeSprite(sprite:Object) : void
      {
         this.reorder = true;
         if(!this.spriteEdges[sprite])
         {
            return;
         }
         delete this.spriteEdges[sprite];
      }
      
      public function moveSprite(sprite:Object) : void
      {
         this.reorder = true;
         this.updateEdge(sprite as ISortableSprite);
      }
      
      private function createEdge(sprite:Object) : void
      {
         this.spriteEdges[sprite] = new Edge();
         this.updateEdge(sprite as ISortableSprite);
      }
      
      private function updateEdge(sprite:ISortableSprite) : void
      {
         if(!sprite)
         {
            return;
         }
         var edge:Edge = this.spriteEdges[sprite];
         var spriteLine:Pair = sprite.getSpriteLine();
         var from:Point = spriteLine.first as Point;
         var to:Point = spriteLine.second as Point;
         if(from.x > to.x)
         {
            edge.from = to;
            edge.to = from;
         }
         else
         {
            edge.from = from;
            edge.to = to;
         }
      }
   }
}

