package soul.view.chat
{
   import flash.display.Sprite;
   import soul.view.assets.Assets;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.BoxDirection;
   
   public class ChatBorder extends BorderedContainer
   {
      
      private var _transparent:Boolean = false;
      
      public function ChatBorder()
      {
         super();
         direction = BoxDirection.VERTICAL;
         borderSkin = Assets.chatBorder;
      }
      
      public function set transparent(value:Boolean) : void
      {
         if(this._transparent == value)
         {
            return;
         }
         this._transparent = value;
         mouseEnabled = !this._transparent;
         if(border is Sprite)
         {
            Sprite(border).mouseEnabled = Sprite(border).mouseChildren = !this._transparent;
         }
      }
      
      public function set borderAlpha(value:Number) : void
      {
         border.alpha = value;
      }
   }
}

