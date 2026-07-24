package soul.view.interaction.ability
{
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import mx.core.DragSource;
   import soul.controller.mouse.SimpleDragManager;
   import soul.event.AbilityEvent;
   import soul.model.ability.Ability;
   import soul.net.ServerLayer;
   import soul.view.ui.CachedImage;
   
   public class AbilityContainer extends AbilityRenderer
   {
      
      private var dragInt:int;
      
      private const dragTimeout:int = 100;
      
      public var slotIndex:int = -1;
      
      public function AbilityContainer()
      {
         super();
         mouseChildren = false;
         addEventListener(Event.REMOVED,this.removed);
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         addEventListener(MouseEvent.CLICK,this.click);
      }
      
      protected function removed(e:Event) : void
      {
         if(e.target != this)
         {
            return;
         }
         removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         removeEventListener(MouseEvent.CLICK,this.click);
      }
      
      protected function mouseDown(e:MouseEvent) : void
      {
         if(!ability)
         {
            return;
         }
         stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
         if(this.dragInt != -1)
         {
            clearInterval(this.dragInt);
         }
         this.dragInt = setInterval(this.dragStart,this.dragTimeout,e);
      }
      
      private function mouseUp(e:Event) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
         clearInterval(this.dragInt);
         this.dragInt = -1;
      }
      
      protected function dragStart(e:MouseEvent) : void
      {
         var ds:DragSource = null;
         var dsi2:CachedImage = null;
         this.mouseUp(null);
         var target:AbilityContainer = e.target as AbilityContainer;
         var ability:Ability = target.ability;
         if(ability != null)
         {
            ds = new DragSource();
            ds.addData(ability,"ability");
            ds.addData(this.slotIndex,"sourceSlot");
            dsi2 = new CachedImage();
            dsi2.source = image.source;
            SimpleDragManager.doDrag(this,ds,e,dsi2);
         }
      }
      
      public function click(e:Event) : void
      {
         var ne:AbilityEvent = null;
         trace("AbilityContainer.click()");
         var cooldownLeft:int = this.cooldownLeft - ServerLayer.latency * 0.75;
         if(cooldownLeft > 0)
         {
            return;
         }
         if(Boolean(ability) && Boolean(abilityModel))
         {
            ne = new AbilityEvent(AbilityEvent.ABILITY_CLICK);
            ne.abilityId = ability.id;
            ne.self = e is MouseEvent && MouseEvent(e).shiftKey || e is KeyboardEvent && KeyboardEvent(e).shiftKey;
            abilityModel.dispatchEvent(ne);
         }
      }
   }
}

