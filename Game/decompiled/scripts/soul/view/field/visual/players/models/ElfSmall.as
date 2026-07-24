package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class ElfSmall extends UnitBitmap
   {
      
      public static const visualId:String = "elf_small";
      
      public function ElfSmall(hsl:String = "")
      {
         super();
         frameWidth = 99;
         frameHeight = 92;
         nameHeight = 120;
         library = "elf_small.swf";
         linkages = ["elf1","elf2","elf3"];
         spriteCenter = new Point(-49,-77);
         hitArea = new Rectangle(32,15,35,65);
         defaultFps = 12;
      }
   }
}

