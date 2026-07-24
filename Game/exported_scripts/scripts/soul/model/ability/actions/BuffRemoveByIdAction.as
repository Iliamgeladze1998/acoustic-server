package soul.model.ability.actions
{
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   
   public class BuffRemoveByIdAction extends UnitAbilityAction
   {
      
      public var id:String;
      
      public var level:int;
      
      public function BuffRemoveByIdAction()
      {
         super();
      }
      
      override public function getDescription() : Component
      {
         var label:Label = new Label();
         label.htmlText = getParam("removesEffect") + this.getBuff(this.id);
         return label;
      }
      
      protected function getBuff(buffId:String) : String
      {
         return "<font color=\'#2ac427\'>" + LocaleManager.getString(BundleName.BUFF,buffId) + "</font>";
      }
      
      protected function getBuffDescription(buffId:String) : String
      {
         return LocaleManager.getString(BundleName.BUFF,buffId + ".description");
      }
   }
}

