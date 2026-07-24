package soul.view.interaction.auction
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   
   [Event(name="pageChanged",type="flash.events.Event")]
   public class PageList extends HBox
   {
      
      private var leftLabel:Label = this.makeLink("<","left");
      
      private var rightLabel:Label = this.makeLink(">","right");
      
      private var _pages:int = -1;
      
      private var _page:int = -1;
      
      public function PageList()
      {
         super();
         gap = 2;
         horizontalAlign = "center";
      }
      
      public function set pages(value:int) : void
      {
         if(this._pages == value)
         {
            return;
         }
         this._pages = value;
         if(this._page >= value)
         {
            this.page = value - 1;
         }
         this.draw();
      }
      
      [Bindable("pageChanged")]
      public function set page(value:int) : void
      {
         if(value >= this._pages)
         {
            value = this._pages - 1;
         }
         if(this._page == value)
         {
            return;
         }
         this._page = value;
         this.draw();
      }
      
      public function get page() : int
      {
         return this._page;
      }
      
      private function draw() : void
      {
         removeAllChildren();
         addChild(this.leftLabel);
         addChild(this.makeLink(this._page + 1 + "/" + this._pages));
         addChild(this.rightLabel);
      }
      
      private function makeLink(text:String, url:String = null) : Label
      {
         var label:Label = new Label();
         label.text = text;
         if(Boolean(url))
         {
            label.name = url;
            label.addEventListener(MouseEvent.CLICK,this.labelClick);
         }
         return label;
      }
      
      private function labelClick(e:MouseEvent) : void
      {
         var linkName:String = e.currentTarget.name;
         if(linkName == "left")
         {
            if(this._page > 0)
            {
               --this.page;
            }
         }
         else if(linkName == "right")
         {
            if(this._page < this._pages - 1)
            {
               ++this.page;
            }
         }
         else
         {
            this.page = int(linkName);
         }
         dispatchEvent(new Event("pageChanged"));
      }
   }
}

