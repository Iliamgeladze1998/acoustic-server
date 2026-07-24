package soul.view.interaction.talents
{
   import flash.events.Event;
   import soul.event.TalentEvent;
   import soul.model.ability.AbilityModel;
   import soul.model.talents.Talent;
   import soul.view.ui.Component;
   
   public class TalentTree extends Component
   {
      
      private static const GAP:int = 5;
      
      private static const ICON_WIDTH:uint = 124;
      
      private static const ICON_HEIGHT:uint = 95;
      
      public var level:uint;
      
      public var pointsAvailable:uint;
      
      public var abilityModel:AbilityModel;
      
      private var children:Vector.<TalentRenderer> = new Vector.<TalentRenderer>();
      
      public function TalentTree()
      {
         super();
         backgroundColor = 1;
         backgroundAlpha = 0;
      }
      
      public function set talents(value:Array) : void
      {
         var tier:Array = null;
         var i:uint = 0;
         var talent:Talent = null;
         var icon:TalentRenderer = null;
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
         this.children.length = 0;
         if(!value)
         {
            return;
         }
         for(var j:uint = 0; j < value.length; j++)
         {
            tier = value[j];
            if(tier)
            {
               for(i = 0; i < tier.length; i++)
               {
                  talent = tier[i];
                  if(talent)
                  {
                     icon = new TalentRenderer();
                     icon.abilityModel = this.abilityModel;
                     icon.characterLevel = this.level;
                     icon.pointsAvailable = this.pointsAvailable;
                     icon.talent = talent;
                     icon.x = i * (ICON_WIDTH + GAP);
                     icon.y = j * (ICON_HEIGHT + GAP);
                     addChild(icon);
                     this.children.push(icon);
                     icon.addEventListener(Event.CHANGE,this.childChanged);
                  }
               }
            }
         }
      }
      
      private function childChanged(e:Event) : void
      {
         var child:TalentRenderer = e.target as TalentRenderer;
         var ne:TalentEvent = new TalentEvent(TalentEvent.PURCHASE);
         ne.id = child.talent.id;
         dispatchEvent(ne);
      }
   }
}

