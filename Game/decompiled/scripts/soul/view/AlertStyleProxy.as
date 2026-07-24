package soul.view
{
   import flash.display.Graphics;
   import flash.display.Sprite;
   import mx.controls.Alert;
   import soul.view.assets.Assets;
   
   public class AlertStyleProxy
   {
      
      public function AlertStyleProxy()
      {
         super();
      }
      
      public static function show(text:String = "", title:String = "", flags:uint = 4, parent:Sprite = null, closeHandler:Function = null, iconClass:Class = null, defaultButtonFlag:uint = 4) : void
      {
         var alert:Alert = Alert.show(text,title,flags,parent,closeHandler,iconClass,defaultButtonFlag);
         alert.width = 300;
         alert.height = 150;
         var g:Graphics = alert.graphics;
         g.beginBitmapFill(new Assets.pattern_06().bitmapData);
         g.drawRect(0,0,alert.width,alert.height);
         g.endFill();
      }
   }
}

