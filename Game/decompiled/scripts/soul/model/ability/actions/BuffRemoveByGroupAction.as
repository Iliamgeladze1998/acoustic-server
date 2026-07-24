package soul.model.ability.actions
{
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   
   public class BuffRemoveByGroupAction extends UnitAbilityAction
   {
      
      public var level:int;
      
      public var groups:Array;
      
      public function BuffRemoveByGroupAction()
      {
         super();
      }
      
      override public function getDescription() : Component
      {
         var group:String = null;
         var label:Label = new Label();
         var localizedGroups:Vector.<String> = new Vector.<String>();
         for each(group in this.groups)
         {
            localizedGroups.push(this.getBuff(group));
         }
         label.htmlText = getParam("removesEffect") + localizedGroups.join(", ");
         return label;
      }
      
      protected function getBuff(buffId:String) : String
      {
         return "<font color=\'#2ac427\'>" + LocaleManager.getString(BundleName.BUFF,buffId) + "</font>";
      }
   }
}

