package soul.view.toolTip
{
   import soul.controller.locale.LocaleManager;
   import soul.model.ability.Ability;
   import soul.model.ability.actions.AbilityAction;
   import soul.model.rtm.TargetType;
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   
   public class AbilityTip extends SoulToolTipBase
   {
      
      public function AbilityTip()
      {
         super();
         minWidth = 250;
      }
      
      public static function createDesription(value:Ability, skipName:Boolean = false) : Component
      {
         var label:Label = null;
         var box:VBox = null;
         var statType:String = null;
         var itemTemplate:String = null;
         var aa:AbilityAction = null;
         var a:Object = null;
         var description:Component = null;
         var cost:Number = NaN;
         var count:int = 0;
         box = new VBox();
         box.percentWidth = 100;
         box.padding = 5;
         box.gap = 1;
         if(!skipName)
         {
            label = new Label();
            label.color = 2802727;
            label.text = LocaleManager.getAbilityName(Boolean(value.locId) ? value.locId : value.id) + " (" + LocaleManager.getAbilitySchool(value.school) + ")";
            box.addChild(label);
         }
         if(value.level > 0)
         {
            label = new Label();
            label.htmlText = "<font color=\'#FFFFFF\'>" + getString("REQUIREMENTS") + ":</font> " + getString("character.level") + " " + value.level;
            box.addChild(label);
         }
         box.addChild(createSplitter());
         label = new Label();
         label.multiline = true;
         label.wordWrap = true;
         label.percentWidth = 100;
         var txt:String = "";
         txt += "<font color=\'#FFFFFF\'>" + getString("target") + reqBonSuffix + "</font> " + getString(value.distance == 0 ? TargetType.SELF : value.target);
         if(value.radius > 0)
         {
            txt += "<br><font color=\'#FFFFFF\'>" + getString("radius") + reqBonSuffix + "</font> " + value.radius;
         }
         txt += "<br><font color=\'#FFFFFF\'>" + getString("castingTime") + reqBonSuffix + "</font> " + getTime(value.castTime) + " / " + getTime(value.coolDown);
         var costs:Vector.<String> = new Vector.<String>();
         for(statType in value.costs)
         {
            cost = Number(value.costs[statType]);
            if(cost > 0)
            {
               costs.push(getString(statType) + " " + cost);
            }
         }
         for(itemTemplate in value.itemCosts)
         {
            count = int(value.itemCosts[itemTemplate]);
            if(count > 0)
            {
               costs.push(LocaleManager.getItemName(itemTemplate) + " " + count);
            }
         }
         if(costs.length > 0)
         {
            txt += "<br><font color=\'#FFFFFF\'>" + getString("cost") + reqBonSuffix + "</font> " + costs.join(", ");
         }
         label.htmlText = txt;
         box.addChild(label);
         box.addChild(createSplitter());
         label = new Label();
         label.color = 16777215;
         label.percentWidth = 100;
         label.wordWrap = true;
         label.multiline = true;
         label.text = LocaleManager.getAbilityDescription(Boolean(value.locId) ? value.locId : value.id);
         box.addChild(label);
         for each(a in value.actions)
         {
            aa = a as AbilityAction;
            if(Boolean(aa))
            {
               description = aa.getDescriptionWithCondition();
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
               label.text = "[Unmapped AbilityAction]";
               box.addChild(label);
            }
         }
         for each(a in value.casterActions)
         {
            aa = a as AbilityAction;
            if(Boolean(aa))
            {
               description = aa.getDescriptionWithCondition();
               if(Boolean(description))
               {
                  description.backgroundColor = 3355392;
                  box.addChild(createSplitter());
                  box.addChild(description);
               }
            }
            else
            {
               box.addChild(createSplitter());
               label = new Label();
               label.text = "[Unmapped AbilityAction]";
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
         var value:Ability = data as Ability;
         if(!value)
         {
            return;
         }
         addChild(createDesription(value));
      }
   }
}

