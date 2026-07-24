package soul.view.rtm.targetFrame
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweenTimeline;
   import flash.filters.GlowFilter;
   import soul.view.rtm.BarDrawer;
   import soul.view.ui.Container;
   
   public class XpBar extends BarDrawer
   {
      
      private static const GLOW:Array = [new GlowFilter(16776960,1,15,15,4)];
      
      private var initalSet:Boolean = true;
      
      public function XpBar()
      {
         super();
         barColor = 3703945;
         labelVisible = false;
         backgroundColor = 0;
         maxValue = 100;
      }
      
      override public function set value(val:int) : void
      {
         var glow:Container = null;
         super.value = val;
         if(this.initalSet)
         {
            this.initalSet = false;
            return;
         }
         glow = new Container();
         glow.backgroundColor = 16777215;
         glow.setActualSize(width,height);
         glow.alpha = 0;
         glow.filters = GLOW;
         addChild(glow);
         new GTweenTimeline(glow,2,null,{"onComplete":this.glowComplete},null,[0,new GTween(glow,0.5,{"alpha":1}),0.5,new GTween(glow,1.5,{"alpha":0})]);
      }
      
      private function glowComplete(target:GTween) : void
      {
         var glow:Container = target.target as Container;
         removeChild(glow);
      }
   }
}

