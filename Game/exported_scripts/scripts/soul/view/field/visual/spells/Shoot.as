package soul.view.field.visual.spells
{
   import com.gskinner.motion.GTween;
   import flash.display.Sprite;
   import flash.events.Event;
   import soul.model.field.LibraryManager;
   
   public class Shoot extends Sprite
   {
      
      public static const VERICAL_GAP:uint = 50;
      
      protected static const LIBRARY:String = LibraryManager.mainLibrary;
      
      public function Shoot()
      {
         super();
         mouseEnabled = false;
      }
      
      public static function createFromType(type:String) : Shoot
      {
         switch(type)
         {
            case "lightning_01":
               return new Lightning();
            case "lightning_02":
               return new Lightning2();
            case "lightning_03":
               return new Lightning3();
            case "rock_01":
               return new Rock();
            case "poison_01":
               return new Arrow("poison_01",37,37);
            case "icebolt_02":
               return new Arrow("icebolt_02",45,45);
            case "icebolt_01":
               return new Arrow("icebolt_01",32,32);
            case "firebolt_02":
               return new Arrow("firebolt_02",41,41);
            case "firebolt_01":
               return new Arrow("firebolt_01",35,35);
            case "arrow_pierce_01":
               return new Arrow("arrow_pierce_01");
            case "arrow_poison_01":
               return new Arrow("arrow_poison_01",35,25);
            case "arrow_ogre_01":
               return new Arrow("arrow_ogre_01",20,16);
            case "arrow_ice_01":
               return new Arrow("arrow_ice_01");
            case "arrow_fire_01":
               return new Arrow("arrow_fire_01");
            case "arrow_dark_01":
               return new Arrow("arrow_dark_01");
            case "arrow_02":
               return new Arrow("arrow_02",37);
            case "arrow_02":
               return new Arrow("arrow_02");
            case "arcane_missile_01":
               return new Arrow("arcane_missile_01",32,32);
            case "dark_clot_01":
               return new Arrow("dark_clot_01",37,37);
            case "firebolt_03":
               return new Arrow("firebolt_03",35,35);
            case "arrow_01":
         }
         return new Arrow();
      }
      
      public function shoot(x:int, y:int, duration:int = 0) : void
      {
         new GTween(this,duration / 1000,{
            "x":this.x + x,
            "y":this.y + y
         }).onComplete = this.complete;
      }
      
      private function complete(tween:GTween) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}

