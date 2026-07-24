package soul.view.cooldown
{
   import flash.events.Event;
   import flash.geom.Rectangle;
   import soul.model.cooldown.Cooldown;
   import soul.view.ui.Component;
   
   public class CooldownRenderer extends Component
   {
      
      private static const PI2:Number = Math.PI * 2;
      
      private static const halfPI:Number = Math.PI / 2;
      
      private static const updateFrequency:int = 40;
      
      private static const anglePoints:Array = [[1,-1],[1,0],[1,1],[0,1],[-1,1],[-1,0],[-1,-1],[0,-1]];
      
      private var maskRect:Rectangle = new Rectangle(0,0,width,height);
      
      private var cooldowns:Object = {};
      
      private var _cooldownLeft:int = 0;
      
      public function CooldownRenderer()
      {
         super();
         scrollRect = this.maskRect;
         width = 20;
         height = 20;
      }
      
      private function clear() : void
      {
         graphics.clear();
      }
      
      private function drawCD() : void
      {
         var found:Boolean = false;
         var cd:Cooldown = null;
         var p:Array = null;
         var percDoneOne:Number = NaN;
         var percDone:Number = 1;
         for each(cd in this.cooldowns)
         {
            found = true;
            this._cooldownLeft = cd.total - cd.progress;
            percDoneOne = cd.progress / cd.total;
            percDone = Math.min(percDoneOne,percDone);
         }
         if(!found)
         {
            this._cooldownLeft = 0;
            this.clear();
            return;
         }
         var partAngle:Number = percDone * PI2 - halfPI;
         var part:int = Math.floor(percDone * 8);
         var rad:Number = Math.max(width,height) / 2;
         var cx:Number = width / 2;
         var cy:Number = height / 2;
         graphics.clear();
         graphics.beginFill(0,0.7);
         graphics.moveTo(cx,cy);
         var xx:Number = rad * 2 * Math.cos(partAngle);
         var yy:Number = rad * 2 * Math.sin(partAngle);
         graphics.lineTo(cx + xx,cy + yy);
         while(part < anglePoints.length)
         {
            p = anglePoints[part];
            graphics.lineTo(cx + rad * p[0],cy + rad * p[1]);
            part++;
         }
         graphics.lineTo(cx,cy);
         graphics.endFill();
      }
      
      public function set cooldown(value:Cooldown) : void
      {
         if(!value)
         {
            return;
         }
         var oldCd:Cooldown = this.cooldowns[value.id];
         if(Boolean(oldCd))
         {
            this.removeListener(oldCd);
         }
         this.addListener(value);
      }
      
      public function get cooldownLeft() : uint
      {
         return this._cooldownLeft < 0 ? 0 : uint(this._cooldownLeft);
      }
      
      private function progressChanged(e:Event) : void
      {
         var cd:Cooldown = e.target as Cooldown;
         if(cd.progress >= cd.total)
         {
            this.removeListener(cd);
         }
         this.drawCD();
      }
      
      private function addListener(cd:Cooldown) : void
      {
         this.cooldowns[cd.id] = cd;
         cd.addEventListener(Cooldown.PROGRESS_CHANGED,this.progressChanged);
      }
      
      private function removeListener(cd:Cooldown) : void
      {
         delete this.cooldowns[cd.id];
         cd.removeEventListener(Cooldown.PROGRESS_CHANGED,this.progressChanged);
      }
      
      override protected function applySize() : void
      {
         this.maskRect.width = _width;
         this.maskRect.height = _height;
         scrollRect = this.maskRect;
      }
   }
}

