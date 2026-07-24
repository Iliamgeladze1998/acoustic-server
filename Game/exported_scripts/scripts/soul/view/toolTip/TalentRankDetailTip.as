package soul.view.toolTip
{
   import soul.controller.locale.LocaleManager;
   import soul.model.character.ParamBonus;
   import soul.model.character.ParamType;
   import soul.model.talents.TalentRankDetail;
   import soul.sorting.Pair;
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   
   public class TalentRankDetailTip extends SoulToolTipBase
   {
      
      public function TalentRankDetailTip()
      {
         super();
         minWidth = 250;
      }
      
      public static function createDesription(value:TalentRankDetail, skipName:Boolean = false) : Component
      {
         var label:Label = null;
         var box:VBox = null;
         var sortedPairs:Vector.<Pair> = null;
         var pair:Pair = null;
         box = new VBox();
         box.percentWidth = 100;
         box.padding = 5;
         box.gap = 1;
         if(value.level > 0)
         {
            label = new Label();
            label.htmlText = "<font color=\'#FFFFFF\'>" + getString("REQUIREMENTS") + ":</font> " + getString("character.level") + " " + value.level;
            box.addChild(label);
         }
         var bonus:ParamBonus = value.bonus;
         if(Boolean(bonus))
         {
            box.addChild(createSplitter());
            sortedPairs = ParamType.sortParams(bonus.add);
            for each(pair in sortedPairs)
            {
               label = new Label();
               label.color = 16777215;
               label.text = "- " + getString(String(pair.first)) + ": " + (pair.second > 0 ? "+" : "") + pair.second;
               box.addChild(label);
            }
            sortedPairs = ParamType.sortParams(bonus.mult);
            for each(pair in sortedPairs)
            {
               label = new Label();
               label.color = 16777215;
               label.text = "- " + getString(String(pair.first)) + ": " + (pair.second > 0 ? "+" : "") + pair.second;
               box.addChild(label);
            }
         }
         box.addChild(createSplitter());
         label = new Label();
         label.color = 16777215;
         label.percentWidth = 100;
         label.wordWrap = true;
         label.multiline = true;
         label.text = LocaleManager.getTalentDescription(value.talentId);
         box.addChild(label);
         return box;
      }
      
      override public function prepare() : void
      {
         if(prepared)
         {
            return;
         }
         prepared = true;
         var value:TalentRankDetail = data as TalentRankDetail;
         if(!value)
         {
            return;
         }
         addChild(createDesription(value));
      }
   }
}

