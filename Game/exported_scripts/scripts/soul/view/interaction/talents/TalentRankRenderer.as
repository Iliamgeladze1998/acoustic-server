package soul.view.interaction.talents
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import soul.model.ability.Ability;
   import soul.model.ability.AbilityModel;
   import soul.model.talents.TalentRankDetail;
   import soul.view.toolTip.AbilityTip;
   import soul.view.toolTip.TalentRankDetailTip;
   import soul.view.toolTip.ToolTipManager;
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   
   public class TalentRankRenderer extends Component
   {
      
      private static const LABELS:Array = ["I","II","III","IV","V"];
      
      private static const GLOW_FILTER:Array = [new GlowFilter(16777011,0.3,10,10,6,2,true)];
      
      public var abilityModel:AbilityModel;
      
      private var label:Label = new Label();
      
      public function TalentRankRenderer()
      {
         super();
         this.label.width = width = 22;
         height = 12;
         this.label.align = "center";
         this.label.y = -3;
         this.label.mouseEnabled = false;
         this.label.fontSize = 9;
         addChild(this.label);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      private function onMouseOver(e:MouseEvent) : void
      {
         filters = GLOW_FILTER;
      }
      
      private function onMouseOut(e:MouseEvent) : void
      {
         filters = [];
      }
      
      public function set learned(value:Boolean) : void
      {
         backgroundColor = value ? 482560 : 0;
      }
      
      public function set rank(value:int) : void
      {
         this.label.text = LABELS[value];
      }
      
      public function set detail(value:TalentRankDetail) : void
      {
         if(!this.abilityModel)
         {
            return;
         }
         var ability:Ability = this.abilityModel.getAbilityById(value.ability);
         if(Boolean(ability))
         {
            if(ability.loading)
            {
               toolTip = "Loading... " + value.ability;
               ability.addEventListener(Event.CHANGE,this.abilityLoaded);
            }
            else
            {
               this.setAbilityTooltip(ability);
            }
         }
         else
         {
            ToolTipManager.register(this,value,TalentRankDetailTip);
         }
      }
      
      protected function abilityLoaded(e:Event) : void
      {
         this.setAbilityTooltip(e.target as Ability);
      }
      
      private function setAbilityTooltip(ability:Ability) : void
      {
         toolTip = null;
         ToolTipManager.register(this,ability,AbilityTip);
      }
   }
}

