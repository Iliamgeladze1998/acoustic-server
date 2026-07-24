package soul.view.field.visual.players.models
{
   import soul.view.field.visual.AnimationType;
   
   public class Settler2 extends Settler1
   {
      
      public function Settler2(hsl:String = "")
      {
         super();
         library = "settler2.swf";
         linkages = ["settler2"];
         frameList[AnimationType.IDLE] = [0,[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,10,11,11,11,11,12,13,14,15,15,15,15,16,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,18,19,20,19,20,19,20,19,20,21,22]];
      }
   }
}

