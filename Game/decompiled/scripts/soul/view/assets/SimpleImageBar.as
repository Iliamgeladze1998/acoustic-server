package soul.view.assets
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.events.ItemClickEvent;
   import soul.view.ui.Box;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Component;
   
   [Event(name="itemClick",type="mx.events.ItemClickEvent")]
   public class SimpleImageBar extends Box
   {
      
      private var childs:Vector.<CachedImage> = new Vector.<CachedImage>();
      
      private var _dataPovider:Array;
      
      private var _toolTips:Array;
      
      private var preferedIndex:int = -1;
      
      private var _selectedIndex:int = -1;
      
      public function SimpleImageBar()
      {
         super();
      }
      
      public function set dataProvider(value:Array) : void
      {
         var child:CachedImage = null;
         var src:Object = null;
         var i:String = null;
         var spacing:Component = null;
         if(this._dataPovider == value)
         {
            return;
         }
         removeAllChildren();
         this.childs.length = 0;
         this._dataPovider = value;
         for(i in value)
         {
            src = value[i];
            if(src is int)
            {
               spacing = new Component();
               spacing.width = int(src);
               addChild(spacing);
            }
            else
            {
               child = new CachedImage();
               child.source = src[0];
               child.addEventListener(MouseEvent.CLICK,this.onClick);
               addChild(child);
               this.childs.push(child);
            }
         }
         this.applyToolTips();
         this.selectedIndex = this.preferedIndex;
      }
      
      public function set toolTips(value:Array) : void
      {
         this._toolTips = value;
         this.applyToolTips();
      }
      
      private function applyToolTips() : void
      {
         var child:CachedImage = null;
         if(!this._toolTips)
         {
            return;
         }
         for(var i:int = 0; i < this.childs.length; i++)
         {
            child = this.childs[i];
            child.toolTip = this._toolTips[i];
         }
      }
      
      [Bindable("selectedIndexChanged")]
      public function set selectedIndex(value:int) : void
      {
         var child:CachedImage = null;
         var src:Array = null;
         var dataIndex:int = 0;
         if(value >= this.childs.length || value < 0)
         {
            this.preferedIndex = value;
            value = -1;
         }
         else
         {
            this.preferedIndex = -1;
         }
         if(value == this._selectedIndex)
         {
            return;
         }
         if(this._selectedIndex != -1)
         {
            child = this.childs[this._selectedIndex];
            dataIndex = getChildIndex(this.childs[this._selectedIndex]);
            src = this._dataPovider[dataIndex];
            if(Boolean(child) && Boolean(src))
            {
               child.source = src[0];
            }
         }
         this._selectedIndex = value;
         if(value != -1)
         {
            child = this.childs[this._selectedIndex];
            dataIndex = getChildIndex(this.childs[this._selectedIndex]);
            src = this._dataPovider[dataIndex];
            if(Boolean(child) && Boolean(src))
            {
               child.source = src[1];
            }
         }
         dispatchEvent(new Event("selectedIndexChanged"));
      }
      
      public function get selectedIndex() : int
      {
         return this.preferedIndex > -1 ? this.preferedIndex : this._selectedIndex;
      }
      
      private function onClick(e:MouseEvent) : void
      {
         var child:CachedImage = e.currentTarget as CachedImage;
         if(!child)
         {
            return;
         }
         this.selectedIndex = this.childs.indexOf(child);
         dispatchEvent(new Event("selectedIndexChanged"));
         var ne:ItemClickEvent = new ItemClickEvent(ItemClickEvent.ITEM_CLICK);
         ne.index = this.selectedIndex;
         dispatchEvent(ne);
      }
   }
}

