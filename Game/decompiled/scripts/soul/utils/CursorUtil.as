package soul.utils
{
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.ui.Mouse;
   import flash.ui.MouseCursor;
   import flash.ui.MouseCursorData;
   import flash.utils.getQualifiedClassName;
   
   public class CursorUtil
   {
      
      private static const registeredCursors:Object = {};
      
      public function CursorUtil()
      {
         super();
      }
      
      public static function setCursor(cursorClass:Class) : void
      {
         var instance:Sprite = null;
         var mc:MovieClip = null;
         var frames:Vector.<BitmapData> = null;
         var frame:BitmapData = null;
         var i:int = 0;
         var mcData:MouseCursorData = null;
         var className:String = getQualifiedClassName(cursorClass);
         if(!registeredCursors[className])
         {
            instance = new cursorClass();
            if(Boolean(instance))
            {
               mc = instance as MovieClip;
               frames = new Vector.<BitmapData>(Boolean(mc) ? mc.totalFrames : 1);
               if(Boolean(mc) && mc.totalFrames > 0)
               {
                  for(i = 1; i <= mc.totalFrames; i++)
                  {
                     mc.gotoAndStop(i);
                     frame = new BitmapData(32,32,true,0);
                     frame.draw(mc);
                     frames[i - 1] = frame;
                  }
               }
               else
               {
                  frame = new BitmapData(32,32,true,0);
                  frame.draw(instance);
                  frames[0] = frame;
               }
               try
               {
                  mcData = new MouseCursorData();
                  mcData.data = frames;
                  mcData.frameRate = 24;
                  Mouse.registerCursor(className,mcData);
                  registeredCursors[className] = true;
               }
               catch(e:Error)
               {
               }
            }
         }
         try
         {
            Mouse.cursor = className;
         }
         catch(e:Error)
         {
         }
      }
      
      public static function removeAllCursors() : void
      {
         Mouse.cursor = MouseCursor.AUTO;
      }
   }
}

