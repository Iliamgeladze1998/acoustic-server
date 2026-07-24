package soul.view.ui
{
   public class ComboBoxDropItem extends Label
   {
      
      public var labelField:String = "label";
      
      public var fillColor:uint = 11379081;
      
      public function ComboBoxDropItem()
      {
         super();
         backgroundColor = 255;
         backgroundAlpha = 0;
         color = 0;
         width = 100;
         height = 15;
      }
      
      public function set value(value:Object) : void
      {
         text = value.hasOwnProperty(this.labelField) ? value[this.labelField] : value.toString();
      }
      
      public function get value() : Object
      {
         return textField.text;
      }
      
      public function set selected(value:Boolean) : void
      {
         graphics.clear();
         if(value)
         {
            graphics.beginFill(this.fillColor);
            graphics.drawRect(0,0,width,height);
            graphics.endFill();
         }
      }
   }
}

