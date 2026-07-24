package soul.view.astral
{
   import com.gskinner.motion.GTween;
   import flash.display.Sprite;
   import soul.view.toolTip.ToolTipManager;
   
   public class AstralPlayer extends Sprite
   {
      
      private static const myColors:Array = [16776960,16711680,16763904];
      
      private static const memeberColors:Array = [0,35955,3801087];
      
      private var tween:GTween;
      
      public function AstralPlayer(me:Boolean = true)
      {
         super();
         var colors:Array = me ? myColors : memeberColors;
         graphics.lineStyle(2,colors[0]);
         graphics.beginFill(colors[1]);
         graphics.drawCircle(0,0,5);
         graphics.endFill();
         graphics.lineStyle();
         graphics.beginFill(colors[2],0.5);
         graphics.drawCircle(-2,-2,3);
         graphics.endFill();
      }
      
      public function set label(value:String) : void
      {
         ToolTipManager.register(this,value);
      }
      
      public function moveTo(x:int, y:int, duration:int) : void
      {
         this.stop();
         this.tween = new GTween(this,duration / 1000,{
            "x":x,
            "y":y
         });
      }
      
      public function stopAt(x:int, y:int) : void
      {
         this.stop();
         this.x = x;
         this.y = y;
      }
      
      public function stop() : void
      {
         if(Boolean(this.tween))
         {
            this.tween.paused = true;
            this.tween = null;
         }
      }
   }
}

