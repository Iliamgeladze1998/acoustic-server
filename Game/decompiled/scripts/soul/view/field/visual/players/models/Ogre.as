package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class Ogre extends UnitBitmap
   {
      
      public static const visualId:String = "ogre";
      
      public function Ogre(hsl:String = "")
      {
         super();
         frameWidth = 148;
         frameHeight = 125;
         library = "ogre.swf";
         linkages = ["ogre1","ogre2","ogre3"];
         defaultFps = 12;
         spriteCenter = new Point(-73,-99);
         hitArea = new Rectangle(39,11,72,106);
         nameHeight = 110;
         frameList = {};
         frameList[AnimationType.IDLE] = [0,[0,0,0,0,0,0,0,1,2,3]];
         frameList[AnimationType.DEAD] = [2,[13]];
         frameList[AnimationType.WALK] = [0,[4,5,6,7,8,9,10]];
         frameList[AnimationType.SWORD] = [0,[11,12,13,14,15,16,17]];
         frameList[AnimationType.START_BOW] = [1,[0,1,2]];
         frameList[AnimationType.BOW] = [1,[3]];
         frameList[AnimationType.END_BOW] = [1,[2,3,3,3,3,4,5,6]];
         frameList[AnimationType.START_CAST] = [1,[7,8]];
         frameList[AnimationType.CAST] = [1,[9,10,11]];
         frameList[AnimationType.END_CAST] = [1,[10,10,11,12,13]];
         frameList[AnimationType.DAMAGE] = [2,[0,1,2,3,4,5,6]];
         frameList[AnimationType.DIE] = [2,[7,8,9,10,11,12,13]];
         frameList[AnimationType.RESURREST] = [2,[13,12,11,10,9,8,7]];
         fpsList[AnimationType.WALK] = 9;
         fpsList[AnimationType.SWORD] = 9;
         fpsList[AnimationType.DAMAGE] = 9;
      }
   }
}

