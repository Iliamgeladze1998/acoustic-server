package soul.controller.interaction
{
   import flash.events.Event;
   import soul.controller.IManager;
   import soul.event.CraftEvent;
   import soul.model.interaction.craft.CraftData;
   import soul.model.interaction.craft.CraftModel;
   import soul.net.ComponentLocator;
   import soul.net.ServerLayer;
   import soul.view.interaction.craft.CraftScreen;
   
   public class CraftManager implements IManager
   {
      
      private var model:CraftModel;
      
      private var view:CraftScreen;
      
      public function CraftManager(view:CraftScreen, model:CraftModel)
      {
         super();
         this.view = view;
         this.model = model;
         view.model = model;
         ComponentLocator.setComponent(ComponentLocator.CRAFT,this);
         model.addEventListener(CraftEvent.CRAFT,this.makeCraft);
         model.addEventListener(CraftEvent.CANCEL,this.cancelCraft);
         ServerLayer.call("craftService",ComponentLocator.READY);
      }
      
      public function reset() : void
      {
         this.view.model = null;
         this.model.reset();
         ComponentLocator.setComponent(ComponentLocator.CRAFT,null);
         this.model.removeEventListener(CraftEvent.CRAFT,this.makeCraft);
      }
      
      public function init(data:CraftData) : void
      {
         trace("CraftManager.init()",data);
         this.model.recipes = data.recipes;
         this.model.craftType = data.craftType;
         this.model.level = data.level;
         this.model.dispatchEvent(new Event("recipesChanged"));
      }
      
      public function startCraft(time:int) : void
      {
         this.model.craftInProgress = true;
         var e:CraftEvent = new CraftEvent(CraftEvent.CRAFT_STARTED);
         e.time = time;
         this.model.dispatchEvent(e);
      }
      
      public function stopCraft(reason:String) : void
      {
         var e:CraftEvent = new CraftEvent(CraftEvent.CRAFT_CANCELED);
         this.model.dispatchEvent(e);
         this.model.craftInProgress = false;
      }
      
      public function craftComplete(level:int) : void
      {
         this.model.level = level;
         --this.model.iterationsLeft;
         if(this.model.iterationsLeft > 0)
         {
            this.makeCraft(null);
         }
         else
         {
            this.model.craftInProgress = false;
            this.model.dispatchEvent(new CraftEvent(CraftEvent.CRAFT_FINISHED));
         }
      }
      
      private function makeCraft(e:CraftEvent) : void
      {
         ServerLayer.call("craftService","craft",null,null,this.model.recipeCrafting.id);
      }
      
      private function cancelCraft(e:CraftEvent) : void
      {
         ServerLayer.call("craftService","stopCraft");
      }
   }
}

