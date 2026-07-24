package soul.view.ui.layout
{
   import flash.display.DisplayObject;
   import soul.view.ui.Container;
   import soul.view.ui.Tile;
   
   public class TileLayout extends Layout
   {
      
      private var maxWidth:int;
      
      private var maxHeight:int;
      
      private var columns:int;
      
      public function TileLayout(target:Container)
      {
         super(target);
      }
      
      override public function layout() : void
      {
         var i:int = 0;
         var child:DisplayObject = null;
         var target:Tile = Tile(super.target);
         if(!target)
         {
            return;
         }
         var gap:int = target.gap;
         for(i = 0; i < target.numChildren; i++)
         {
            child = target.getChildAt(0);
            this.maxWidth = Math.max(this.maxWidth,child.width);
            this.maxHeight = Math.max(this.maxHeight,child.height);
         }
         this.columns = this.countColumns();
         this.layoutFull();
      }
      
      private function countColumns() : int
      {
         var target:Tile = Tile(super.target);
         var availWidth:int = target.width - target.padding * 2;
         var gap:int = target.gap;
         return (availWidth + gap) / (this.maxWidth + gap);
      }
      
      private function layoutFull() : void
      {
         var child:DisplayObject = null;
         var row:uint = 0;
         var column:uint = 0;
         var p2:int = 0;
         var target:Tile = Tile(super.target);
         var padding:int = target.padding;
         var gap:int = target.gap;
         for(var i:int = 0; i < target.numChildren; i++)
         {
            child = target.getChildAt(i);
            row = i / this.columns;
            column = i % this.columns;
            child.x = padding + column * (this.maxWidth + gap);
            child.y = padding + row * (this.maxHeight + gap);
         }
         if(Boolean(child))
         {
            target.setActualSize(target.width,child.y + this.maxHeight + padding);
         }
         else
         {
            p2 = padding * 2;
            target.setActualSize(target.width,p2);
         }
      }
      
      override public function layoutOne(child:DisplayObject) : void
      {
         var columns:int = 0;
         if(child.width > this.maxWidth || child.height > this.maxHeight)
         {
            this.maxWidth = Math.max(this.maxWidth,child.width);
            this.maxHeight = Math.max(this.maxHeight,child.height);
            columns = this.countColumns();
            if(columns != this.columns)
            {
               this.columns = columns;
               this.layoutFull();
               return;
            }
         }
         var target:Tile = Tile(super.target);
         var padding:int = target.padding;
         var gap:int = target.gap;
         var i:int = target.getChildIndex(child);
         var row:uint = i / this.columns;
         var column:uint = i % this.columns;
         child.x = padding + column * (this.maxWidth + gap);
         child.y = padding + row * (this.maxHeight + gap);
         target.setActualSize(target.width,child.y + this.maxHeight + padding);
      }
   }
}

