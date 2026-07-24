package soul.view.rtm.errorFrame
{
   import flash.text.TextFormat;
   import flash.utils.setTimeout;
   import soul.view.ui.Label;
   
   public class ErrorMessage extends Label
   {
      
      private static const FORMAT:TextFormat = new TextFormat("Verdana, Tahoma, _sans",12,15450201);
      
      private static const delay:int = 10000;
      
      private var timer:int;
      
      public function ErrorMessage()
      {
         super(FORMAT);
         align = "right";
         wordWrap = true;
         multiline = true;
         this.timer = setTimeout(this.expired,delay);
      }
      
      private function expired() : void
      {
         if(Boolean(parent) && parent.contains(this))
         {
            parent.removeChild(this);
         }
      }
   }
}

