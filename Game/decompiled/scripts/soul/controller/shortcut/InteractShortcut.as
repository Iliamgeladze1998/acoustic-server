package soul.controller.shortcut
{
   import flash.ui.Keyboard;
   
   public class InteractShortcut extends Shortcut
   {
      
      public static const GATHER_ALL:int = 3;
      
      public static const TARGET_FRAME:int = 2;
      
      public static const USE_INTERACTIVE:int = 1;
      
      public static const instance:InteractShortcut = new InteractShortcut();
      
      public function InteractShortcut()
      {
         super(Keyboard.SPACE);
      }
   }
}

