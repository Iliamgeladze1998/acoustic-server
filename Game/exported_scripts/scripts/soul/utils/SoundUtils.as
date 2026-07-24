package soul.utils
{
   import flash.media.Sound;
   import flash.media.SoundTransform;
   
   public class SoundUtils
   {
      
      public static var enabled:Boolean = false;
      
      private static const Shoot:Class = SoundUtils_Shoot;
      
      private static const Shoot2:Class = SoundUtils_Shoot2;
      
      private static const Ouch:Class = SoundUtils_Ouch;
      
      private static const Ouch2:Class = SoundUtils_Ouch2;
      
      private static const Miss:Class = SoundUtils_Miss;
      
      public static const SHOOT:String = "SHOOT";
      
      public static const OUCH:String = "OUCH";
      
      public static const MISS:String = "MISS";
      
      public static const IMMUNE:String = "IMMUNE";
      
      private static const sounds:Object = {};
      
      private static const transform:SoundTransform = new SoundTransform(0.3);
      
      sounds[SHOOT] = [Shoot,Shoot2];
      sounds[OUCH] = [Ouch,Ouch2];
      sounds[MISS] = Miss;
      
      public function SoundUtils()
      {
         super();
      }
      
      public static function play(linkage:String) : void
      {
         var sndClass:Class = null;
         var sndIndex:int = 0;
         if(!enabled)
         {
            return;
         }
         var soundObject:Object = sounds[linkage];
         if(!soundObject)
         {
            return;
         }
         if(soundObject is Array)
         {
            sndIndex = Math.random() * soundObject.length;
            sndClass = soundObject[sndIndex];
         }
         else
         {
            sndClass = soundObject as Class;
         }
         if(!sndClass)
         {
            return;
         }
         var snd:Sound = new sndClass();
         snd.play(0,0,transform);
      }
   }
}

