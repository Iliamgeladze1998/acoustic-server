package soul.view.ui.layout
{
   import flash.display.DisplayObject;
   import soul.view.ui.Component;
   import soul.view.ui.Container;
   
   public class Layout implements ILayout
   {
      
      protected var target:Container;
      
      private var availWidth:int;
      
      private var availHeight:int;
      
      private var inProgress:Boolean;
      
      public function Layout(target:Container)
      {
         super();
         this.target = target;
      }
      
      public function layout() : void
      {
         var i:int = 0;
         var child:DisplayObject = null;
         var p2:int = this.target.padding * 2;
         this.availWidth = this.target.width - p2;
         this.availHeight = this.target.height - p2;
         for(i = 0; i < this.target.numChildren; i++)
         {
            child = this.target.getChildAt(i);
            this.layoutOne(child);
         }
      }
      
      public function layoutOne(child:DisplayObject) : void
      {
         var component:Component = null;
         var pw:Number = NaN;
         var ph:Number = NaN;
         var aw:Number = NaN;
         var ah:Number = NaN;
         var _width:Number = NaN;
         var _height:Number = NaN;
         if(!(child is Component) || this.inProgress)
         {
            return;
         }
         this.inProgress = true;
         component = child as Component;
         if(!isNaN(component.percentWidth))
         {
            aw = this.availWidth - (isNaN(component.left) ? 0 : component.left) - (isNaN(component.right) ? 0 : component.right);
            pw = Math.min(100,component.percentWidth);
            pw = Math.max(0,component.percentWidth);
            _width = Math.round(aw / 100 * pw);
            _width = Math.max(_width,component.minWidth);
            if(!isNaN(component.maxWidth))
            {
               _width = Math.min(_width,component.maxWidth);
            }
            component.actualWidth = _width;
         }
         if(!isNaN(component.percentHeight))
         {
            ah = this.availHeight - (isNaN(component.top) ? 0 : component.top) - (isNaN(component.bottom) ? 0 : component.bottom);
            ph = Math.min(100,component.percentHeight);
            ph = Math.max(0,component.percentHeight);
            _height = Math.round(ah / 100 * ph);
            _height = Math.max(_height,component.minHeight);
            if(!isNaN(component.maxHeight))
            {
               _height = Math.min(_height,component.maxHeight);
            }
            component.actualHeight = _height;
         }
         if(!isNaN(component.horizontalCenter))
         {
            component.x = int((this.target.width - component.width) / 2) + component.horizontalCenter;
         }
         else if(!isNaN(component.left))
         {
            component.x = this.target.padding + component.left;
         }
         else if(!isNaN(component.right))
         {
            component.x = this.target.padding + this.availWidth - component.width - component.right;
         }
         if(!isNaN(component.verticalCenter))
         {
            component.y = int((this.target.height - component.height) / 2) + component.verticalCenter;
         }
         else if(!isNaN(component.top))
         {
            component.y = this.target.padding + component.top;
         }
         else if(!isNaN(component.bottom))
         {
            component.y = this.target.padding + this.availHeight - component.height - component.bottom;
         }
         this.inProgress = false;
      }
   }
}

