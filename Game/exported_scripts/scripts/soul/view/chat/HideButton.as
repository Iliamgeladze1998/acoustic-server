package soul.view.chat
{
   import soul.view.assets.Assets;
   import soul.view.assets.SelectButton;
   
   public class HideButton extends SelectButton
   {
      
      public function HideButton()
      {
         super();
      }
      
      override protected function applyDefaultStyle() : void
      {
         skin = Assets.chatCheckBox;
         selectedSkin = Assets.chatCheckBoxSelected;
      }
   }
}

