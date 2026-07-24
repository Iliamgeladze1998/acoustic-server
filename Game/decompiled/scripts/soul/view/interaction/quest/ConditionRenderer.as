package soul.view.interaction.quest
{
   import mx.binding.utils.BindingUtils;
   import mx.binding.utils.ChangeWatcher;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.condition.Condition;
   import soul.view.ui.Label;
   
   public class ConditionRenderer extends Label
   {
      
      private var cw:ChangeWatcher;
      
      private var questLog:Boolean;
      
      private var _condition:Condition;
      
      public function ConditionRenderer(questLog:Boolean = false)
      {
         super();
         percentWidth = 100;
         multiline = wordWrap = true;
         this.questLog = questLog;
         color = 0;
         fontSize = 11;
         bold = true;
      }
      
      public function set condition(value:Condition) : void
      {
         if(this._condition == value)
         {
            return;
         }
         if(Boolean(this.cw))
         {
            this.cw.unwatch();
            this.cw = null;
         }
         if(!value)
         {
            text = "";
            return;
         }
         this._condition = value;
         if(this.questLog)
         {
            this.cw = BindingUtils.bindSetter(this.currentChanged,value,"current",false,true);
         }
         else
         {
            this.currentChanged(0);
         }
      }
      
      private function currentChanged(value:int) : void
      {
         text = "- " + LocaleManager.getString(BundleName.CONDITIONS,this._condition.type) + ": " + LocaleManager.getCondition(this._condition.type,this._condition.id) + (this.questLog ? " (" + value + "/" + this._condition.count + ")" : (this._condition.count > 1 ? " (" + this._condition.count + ")" : ""));
      }
   }
}

