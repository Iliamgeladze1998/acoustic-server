package soul.view.interaction.inventory
{
   import flash.events.IEventDispatcher;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.DropShadowFilter;
   import mx.events.PropertyChangeEvent;
   import soul.model.item.Item;
   import soul.model.item.ItemClass;
   import soul.model.system.Configuration;
   import soul.view.assets.Assets;
   import soul.view.common.IconRenderer;
   import soul.view.toolTip.ItemTipComparable;
   import soul.view.toolTip.ToolTipManager;
   
   public class ItemRenderer extends IconRenderer
   {
      
      private static const SHADOW_FILTER:DropShadowFilter = new DropShadowFilter(5,45,0,1,12,12);
      
      private static const BROKEN_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0.6,0.6,0.6,0.4,0,0.2,0.2,0.2,0,0,0.2,0.2,0.2,0,0,0,0,0,1,0]);
      
      public var backgroundTransparent:Boolean = false;
      
      private var _item:Item;
      
      private var _dropsShadow:Boolean = false;
      
      private var _broken:Boolean = false;
      
      public function ItemRenderer()
      {
         super();
         width = 66;
         height = 66;
         backgroundPadding = 1;
         padding = 3;
         image.showIcon = true;
         this.dropsShadow = true;
         borderSkin = Assets.simpleBorderRound;
         this.showItemClass();
      }
      
      public function set item(value:Item) : void
      {
         if(this._item == value)
         {
            return;
         }
         if(Boolean(this._item))
         {
            IEventDispatcher(this.item).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.itemChanged);
         }
         this._item = value;
         if(Boolean(value))
         {
            ToolTipManager.register(this,value,ItemTipComparable);
            image.source = Configuration.getItemImageUrl(value.imagePath);
            count = value.count;
            enabled = !value.locked;
            this.broken = value.durabilityMaximum > 0 && value.durability <= 0;
            IEventDispatcher(value).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.itemChanged,false,0,true);
         }
         else
         {
            ToolTipManager.unregister(this);
            image.source = null;
            count = null;
            this.broken = false;
         }
         this.showItemClass();
         applySize();
      }
      
      public function get item() : Item
      {
         return this._item;
      }
      
      public function set dropsShadow(value:Boolean) : void
      {
         if(this._dropsShadow == value)
         {
            return;
         }
         this._dropsShadow = value;
         callLater(this.applyFilters);
      }
      
      public function set broken(value:Boolean) : void
      {
         if(this._broken == value)
         {
            return;
         }
         this._broken = value;
         callLater(this.applyFilters);
      }
      
      private function applyFilters() : void
      {
         var filters:Array = [];
         if(this._dropsShadow)
         {
            filters.push(SHADOW_FILTER);
         }
         if(this._broken)
         {
            filters.push(BROKEN_FILTER);
         }
         image.filters = filters;
      }
      
      private function itemChanged(e:PropertyChangeEvent) : void
      {
         if(e.property == "count")
         {
            count = e.newValue as int;
         }
         if(e.property == "locked")
         {
            enabled = !e.newValue;
         }
         if(e.property == "durability")
         {
            this.broken = Boolean(this.item) && this.item.durabilityMaximum > 0 && int(e.newValue) <= 0;
         }
      }
      
      private function showItemClass() : void
      {
         var defaultClassImage:Object = this.backgroundTransparent ? null : ItemClass.IMG_CLASS1;
         backgroundImage = Boolean(this._item) ? ItemClass.getItemImage(this._item.itemClass) : defaultClassImage;
      }
   }
}

