package soul.view.field.visual.players
{
   import flash.display.Sprite;
   import flash.events.Event;
   import soul.view.field.visual.players.effect.EffectPlayer;
   
   public class PlayerUnderlay extends Sprite
   {
      
      public var effectLocations:Object;
      
      protected var effects:Sprite = new Sprite();
      
      public function PlayerUnderlay()
      {
         super();
         mouseEnabled = mouseChildren = false;
         this.effects.mouseEnabled = false;
         addChild(this.effects);
      }
      
      public function playEffect(effectId:String, location:String) : void
      {
         var effect:EffectPlayer = new EffectPlayer();
         if(Boolean(this.effectLocations))
         {
            effect.y = this.effectLocations[location];
         }
         effect.addEventListener(Event.COMPLETE,this.effectPlayed);
         effect.play(effectId);
         this.effects.addChild(effect);
      }
      
      private function effectPlayed(e:Event) : void
      {
         var effect:EffectPlayer = e.currentTarget as EffectPlayer;
         this.effects.removeChild(effect);
      }
   }
}

