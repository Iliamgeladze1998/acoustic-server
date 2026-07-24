package soul.view.assets
{
   import soul.view.ui.Button;
   
   public class Button1 extends Button
   {
      
      public function Button1()
      {
         super();
         textColor = Colors.BUTTON_LABEL;
         downSkin = Assets.btn1;
         overSkin = Assets.btn1Over;
         disabledSkin = Assets.btn1Disabled;
         padding = 5;
      }
   }
}

