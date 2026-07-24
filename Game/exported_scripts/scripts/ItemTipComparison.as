package
{
   import soul.view.toolTip.ItemTip;
   import soul.view.ui.Label;
   
   public class ItemTipComparison extends ItemTip
   {
      
      public function ItemTipComparison()
      {
         super();
      }
      
      override protected function draw() : void
      {
         super.draw();
         var label:Label = new Label();
         label.text = getString("CURRENTLY_EQUIPPED");
         label.color = 11141120;
         mainInfo.addChildAt(label,0);
      }
   }
}

