package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class Slime extends UnitBitmap
   {
      
      public static const visualId:String = "slime";
      
      public function Slime(hsl:String = "")
      {
         super();
         frameWidth = 128;
         frameHeight = 73;
         library = "slime.swf";
         linkages = ["slime1","slime2"];
         defaultFps = 12;
         spriteCenter = new Point(-63,-35);
         hasShadow = false;
         hitArea = new Rectangle(46,17,40,40);
         nameHeight = 50;
         frameList = {};
         frameList[AnimationType.IDLE] = [0,[0]];
         frameList[AnimationType.DEAD] = [1,[13]];
         frameList[AnimationType.WALK] = [0,[0,1,2,3,4,5,6]];
         frameList[AnimationType.SWORD] = [0,[7,8,9,10,11,12,13]];
         frameList[AnimationType.START_BOW] = [0,[14,15,16]];
         frameList[AnimationType.BOW] = [0,[16]];
         frameList[AnimationType.END_BOW] = [0,[17,18,19,20]];
         frameList[AnimationType.DAMAGE] = [1,[0,1,2,3,4,5,6]];
         frameList[AnimationType.DIE] = [1,[7,8,9,10,11,12,13]];
         frameList[AnimationType.RESURREST] = [1,[13,12,11,10,9,8,7]];
      }
   }
}

