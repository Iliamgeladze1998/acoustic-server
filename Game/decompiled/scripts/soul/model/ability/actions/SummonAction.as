package soul.model.ability.actions
{
   import soul.utils.DateUtils;
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   
   public class SummonAction extends UnitAbilityAction
   {
      
      public var templateId:String;
      
      public var lifeTime:Number;
      
      public var level:int;
      
      public function SummonAction()
      {
         super();
      }
      
      override public function getDescription() : Component
      {
         var label:Label = null;
         label = new Label();
         label.multiline = label.wordWrap = true;
         label.percentWidth = 100;
         label.htmlText = getParam("summon") + getNpc(this.templateId) + " " + DateUtils.getTimeLeft(this.lifeTime);
         return label;
      }
   }
}

