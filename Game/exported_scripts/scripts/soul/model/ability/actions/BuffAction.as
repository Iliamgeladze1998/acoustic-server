package soul.model.ability.actions
{
   import soul.model.buff.effects.BuffEffect;
   import soul.utils.DateUtils;
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   
   public class BuffAction extends BuffRemoveByIdAction
   {
      
      public var lifetime:Number;
      
      public var chance:Number;
      
      public var effects:Array;
      
      public var hp:uint;
      
      public function BuffAction()
      {
         super();
      }
      
      override public function getDescription() : Component
      {
         var be:BuffEffect = null;
         var box:VBox = new VBox();
         box.percentWidth = 100;
         var label:Label = new Label();
         label.percentWidth = 100;
         label.multiline = true;
         label.wordWrap = true;
         var txt:String = getParam("effect") + getBuff(id) + " " + DateUtils.getTimeLeft(this.lifetime);
         if(this.chance > 0)
         {
            txt += " " + Math.round(this.chance * 10000) / 100 + "%";
         }
         if(this.hp > 0)
         {
            txt += " (" + this.hp + " hp)";
         }
         label.htmlText = txt;
         box.addChild(label);
         for each(be in this.effects)
         {
            box.addChild(be.getDescription());
         }
         return box;
      }
   }
}

