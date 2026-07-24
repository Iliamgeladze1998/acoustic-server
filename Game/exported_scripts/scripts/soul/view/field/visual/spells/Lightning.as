package soul.view.field.visual.spells
{
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class Lightning extends Shoot
   {
      
      private static const fadeTime:int = 150;
      
      protected var segmentLength:int = 20;
      
      protected var bolts:int = 3;
      
      protected var randomSpread:int = 20;
      
      protected var glowColor:int = 30719;
      
      protected var boltColor:int = 16777215;
      
      protected var segments:int = -1;
      
      private var interval:int;
      
      private var segment:int;
      
      private var segmentPoints:Array = [];
      
      private var endPoint:Point;
      
      public function Lightning()
      {
         super();
         filters = [new GlowFilter(this.glowColor,1,7,7,2)];
      }
      
      override public function shoot(x:int, y:int, duration:int = 0) : void
      {
         var gip:int = 0;
         this.endPoint = new Point(x,y);
         if(this.segments < 1)
         {
            gip = Math.sqrt(this.endPoint.x * this.endPoint.x + this.endPoint.y * this.endPoint.y);
            this.segments = Math.max(1,Math.floor(gip / this.segmentLength));
         }
         graphics.lineStyle(1,this.boltColor);
         if(duration <= 100)
         {
            for(this.segment = 1; this.segment <= this.segments; ++this.segment)
            {
               this.drawSegment();
            }
            this.interval = setInterval(this.fadeComplete,fadeTime);
         }
         else
         {
            this.interval = setInterval(this.tick,duration / this.segments);
            this.tick();
         }
      }
      
      private function tick() : void
      {
         ++this.segment;
         if(this.segment > this.segments)
         {
            clearInterval(this.interval);
            this.interval = setInterval(this.fadeComplete,fadeTime);
            return;
         }
         this.drawSegment();
      }
      
      private function drawSegment() : void
      {
         var startPoint:Point = null;
         var endPoint:Point = null;
         if(this.bolts < 1)
         {
            return;
         }
         for(var i:int = 0; i < this.bolts; i++)
         {
            startPoint = this.segmentPoints[i];
            if(Boolean(startPoint))
            {
               graphics.moveTo(startPoint.x,startPoint.y);
            }
            else
            {
               graphics.moveTo(0,0);
            }
            endPoint = new Point();
            if(this.segment < this.segments)
            {
               endPoint.x = this.endPoint.x / this.segments * this.segment - this.randomSpread / 2 + Math.random() * this.randomSpread;
               endPoint.y = this.endPoint.y / this.segments * this.segment - this.randomSpread / 2 + Math.random() * this.randomSpread;
            }
            else
            {
               endPoint.x = this.endPoint.x;
               endPoint.y = this.endPoint.y;
            }
            graphics.lineTo(endPoint.x,endPoint.y);
            this.segmentPoints[i] = endPoint;
         }
      }
      
      private function fadeComplete() : void
      {
         clearInterval(this.interval);
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}

