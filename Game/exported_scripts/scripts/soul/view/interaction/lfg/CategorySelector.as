package soul.view.interaction.lfg
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.interaction.lfg.ApplicationType;
   import soul.view.common.Icons;
   import soul.view.ui.CachedImage;
   import soul.view.ui.HBox;
   
   [Event(name="change",type="flash.events.Event")]
   public class CategorySelector extends HBox
   {
      
      private static const SELECTED:Array = [new GlowFilter(3407650)];
      
      [Bindable("selectedTypeChanged")]
      public var selectedType:String;
      
      private const quests:CachedImage = new CachedImage();
      
      private const instances:CachedImage = new CachedImage();
      
      private const locations:CachedImage = new CachedImage();
      
      private var selectedChild:CachedImage;
      
      public function CategorySelector()
      {
         super();
         gap = 10;
         this.quests.source = Icons.quest;
         this.instances.source = Icons.instance;
         this.locations.source = Icons.location;
         addChild(this.quests);
         addChild(this.instances);
         addChild(this.locations);
         this.quests.addEventListener(MouseEvent.CLICK,this.onClick);
         this.instances.addEventListener(MouseEvent.CLICK,this.onClick);
         this.locations.addEventListener(MouseEvent.CLICK,this.onClick);
         this.quests.name = ApplicationType.QUEST;
         this.instances.name = ApplicationType.INSTANCE;
         this.locations.name = ApplicationType.LOCATION;
         this.quests.toolTip = getString("lfg.quests");
         this.instances.toolTip = getString("lfg.instances");
         this.locations.toolTip = getString("lfg.locations");
      }
      
      private static function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function onClick(e:MouseEvent) : void
      {
         if(Boolean(this.selectedChild))
         {
            this.selectedChild.filters = [];
            this.selectedChild = null;
         }
         this.selectedType = null;
         var child:CachedImage = e.currentTarget as CachedImage;
         if(!child)
         {
            return;
         }
         this.selectedChild = child;
         this.selectedChild.filters = SELECTED;
         this.selectedType = child.name;
         dispatchEvent(new Event("selectedTypeChanged"));
         dispatchEvent(new Event(Event.CHANGE));
      }
   }
}

