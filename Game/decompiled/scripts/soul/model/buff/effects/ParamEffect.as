package soul.model.buff.effects
{
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   
   public class ParamEffect extends BuffEffect
   {
      
      public var param:String;
      
      public var mult:Number;
      
      public var add:int;
      
      public function ParamEffect()
      {
         super();
      }
      
      override public function getDescription() : Component
      {
         var txt:String = null;
         var label:Label = null;
         var values:Array = [];
         if(this.mult != 0)
         {
            values.push((this.mult > 0 ? "+" : "") + Math.round(this.mult * 100) + "%");
         }
         if(this.add != 0)
         {
            values.push((this.add > 0 ? "+" : "") + String(this.add));
         }
         txt = getString(this.param) + ": " + values.join(", ");
         label = new Label();
         label.percentWidth = 100;
         label.multiline = true;
         label.wordWrap = true;
         label.text = txt;
         return label;
      }
   }
}

