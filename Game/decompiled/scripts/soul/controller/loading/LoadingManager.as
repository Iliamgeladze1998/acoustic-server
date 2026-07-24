package soul.controller.loading
{
   import flash.display.Stage;
   import soul.view.loading.LoadingScreen;
   
   public class LoadingManager
   {
      
      public static var stage:Stage;
      
      private static var screen:LoadingScreen = new LoadingScreen();
      
      public function LoadingManager()
      {
         super();
      }
      
      public static function init(stage:Stage) : void
      {
         LoadingManager.stage = stage;
      }
      
      public static function show() : void
      {
         if(Boolean(screen.parent))
         {
            return;
         }
         stage.addChild(screen);
      }
      
      public static function hide() : void
      {
         screen.tip = "";
         if(stage.contains(screen))
         {
            stage.removeChild(screen);
         }
      }
      
      public static function set progress(value:Number) : void
      {
         screen.progress = value;
      }
      
      public static function set action(value:String) : void
      {
         screen.action = value;
      }
      
      public static function set tip(value:String) : void
      {
         screen.tip = value;
      }
   }
}

