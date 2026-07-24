package soul.view.ui
{
   import flash.events.MouseEvent;
   
   public class RadioButton extends Checkbox
   {
      
      public var value:Object;
      
      private var _group:RadioButtonGroup;
      
      public function RadioButton()
      {
         super();
      }
      
      override protected function applyDefaultStyle() : void
      {
         downSkin = downSkin || UIAssets.radioButton;
         selectedSkin = selectedSkin || UIAssets.radioButtonSelected;
      }
      
      override protected function onClick(e:MouseEvent) : void
      {
         if(!this._group)
         {
            return;
         }
         this._group.selectedValue = this.value;
      }
      
      public function set group(value:RadioButtonGroup) : void
      {
         if(this._group == value)
         {
            return;
         }
         this._group = value;
         value.addChild(this);
      }
   }
}

