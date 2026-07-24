package soul.view.toolTip
{
   import soul.controller.locale.LocaleManager;
   import soul.model.buff.Effect;
   import soul.model.buff.effects.BuffEffect;
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   
   public class EffectTip extends SoulToolTipBase
   {
      
      public function EffectTip()
      {
         super();
         minWidth = 250;
      }
      
      public static function createDesription(value:Effect) : Component
      {
         var box:VBox = null;
         var be:BuffEffect = null;
         var description:Component = null;
         box = new VBox();
         box.percentWidth = 100;
         box.padding = 5;
         box.gap = 1;
         var label:Label = new Label();
         label.color = 2802727;
         label.text = LocaleManager.getBuffEffectName(value.localeId);
         box.addChild(label);
         box.addChild(createSplitter());
         label = new Label();
         label.color = 16777215;
         label.percentWidth = 100;
         label.wordWrap = true;
         label.multiline = true;
         label.text = LocaleManager.getBuffEffectDescription(value.localeId);
         box.addChild(label);
         if(value.maxHp > 0)
         {
            label = new Label();
            label.color = 16777215;
            label.percentWidth = 100;
            label.wordWrap = true;
            label.multiline = true;
            label.text = "(" + value.maxHp + " hp)";
            box.addChild(label);
         }
         for each(be in value.effects)
         {
            if(Boolean(be))
            {
               description = be.getDescription();
               if(Boolean(description))
               {
                  box.addChild(createSplitter());
                  box.addChild(description);
               }
            }
            else
            {
               box.addChild(createSplitter());
               label = new Label();
               label.text = "[Unmapped BuffEffect]";
               box.addChild(label);
            }
         }
         return box;
      }
      
      private static function getTime(ms:Number) : String
      {
         return int(ms / 100) / 10 + " " + getString("time.sec");
      }
      
      override public function prepare() : void
      {
         if(prepared)
         {
            return;
         }
         prepared = true;
         var value:Effect = data as Effect;
         if(!value)
         {
            return;
         }
         addChild(createDesription(value));
      }
   }
}

