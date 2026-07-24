package soul.view.interaction.ability
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import soul.controller.mouse.SimpleDragManager;
   import soul.event.AbilityEvent;
   import soul.event.DragEvent;
   import soul.model.ability.Ability;
   import soul.model.item.Item;
   
   public class BeltAbilityContainer extends AbilityContainer
   {
      
      public var locked:Boolean;
      
      public function BeltAbilityContainer()
      {
         super();
         addEventListener(DragEvent.DRAG_ENTER,this.dragEnter);
         addEventListener(DragEvent.DRAG_DROP,this.dragDrop);
         addEventListener(DragEvent.DRAG_COMPLETE,this.dragComplete);
      }
      
      override protected function removed(e:Event) : void
      {
         if(e.target != this)
         {
            return;
         }
         super.removed(e);
         removeEventListener(DragEvent.DRAG_ENTER,this.dragEnter);
         removeEventListener(DragEvent.DRAG_DROP,this.dragDrop);
         removeEventListener(DragEvent.DRAG_COMPLETE,this.dragComplete);
      }
      
      override protected function mouseDown(e:MouseEvent) : void
      {
         if(this.locked && !e.ctrlKey || !ability)
         {
            return;
         }
         super.mouseDown(e);
      }
      
      protected function dragEnter(e:DragEvent) : void
      {
         var item:Item = Item(e.dragSource.dataForFormat("item")) || Item(e.dragSource.dataForFormat("runeItem"));
         if(Boolean(item) && item.usable)
         {
            SimpleDragManager.acceptDragDrop(this);
            return;
         }
         var ability:Ability = e.dragSource.hasFormat("ability") ? Ability(e.dragSource.dataForFormat("ability")) : null;
         if(Boolean(ability))
         {
            SimpleDragManager.acceptDragDrop(this);
         }
      }
      
      protected function dragDrop(e:DragEvent) : void
      {
         var ne:AbilityEvent = null;
         var ability:Ability = Ability(e.dragSource.dataForFormat("ability"));
         var item:Item = Item(e.dragSource.dataForFormat("item")) || Item(e.dragSource.dataForFormat("runeItem"));
         var sourceSlot:int = int(e.dragSource.dataForFormat("sourceSlot"));
         trace("AbilityContainer.dragDrop()");
         ne = new AbilityEvent(AbilityEvent.CREATE_ABILITY_SHORTCUT);
         ne.abilityId = ability == null ? item.templateId : ability.id;
         ne.slotIndex = slotIndex;
         dispatchEvent(ne);
      }
      
      protected function dragComplete(e:DragEvent) : void
      {
         var ne:AbilityEvent = new AbilityEvent(AbilityEvent.REMOVE_ABILITY_SHORTCUT);
         ne.slotIndex = slotIndex;
         dispatchEvent(ne);
      }
   }
}

