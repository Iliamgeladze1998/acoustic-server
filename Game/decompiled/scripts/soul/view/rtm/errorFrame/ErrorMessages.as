package soul.view.rtm.errorFrame
{
   import flash.filters.GlowFilter;
   import soul.view.ui.VBox;
   
   public class ErrorMessages extends VBox
   {
      
      public function ErrorMessages()
      {
         super();
         mouseChildren = false;
         mouseEnabled = false;
         gap = -2;
         verticalAlign = "bottom";
         horizontalAlign = "right";
         filters = [new GlowFilter(0,1,2,2,10)];
      }
      
      public function addMessage(txt:String) : void
      {
         if(numChildren > 5)
         {
            removeChildAt(0);
         }
         var msg:ErrorMessage = new ErrorMessage();
         msg.width = width;
         msg.htmlText = txt;
         addChild(msg);
      }
   }
}

