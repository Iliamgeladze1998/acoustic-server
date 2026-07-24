package soul.view.ui.layout
{
   import soul.view.ui.Box;
   import soul.view.ui.BoxDirection;
   import soul.view.ui.Component;
   import soul.view.ui.Container;
   import soul.view.ui.HorizontalAlign;
   import soul.view.ui.VerticalAlign;
   
   public class BoxLayout extends Layout
   {
      
      public function BoxLayout(target:Container)
      {
         super(target);
      }
      
      override public function layout() : void
      {
         var takenFixedWidth:int = 0;
         var takenFixedHeight:int = 0;
         var maxWidth:int = 0;
         var maxHeight:int = 0;
         var i:int = 0;
         var child:Component = null;
         var target:Box = Box(super.target);
         if(!target)
         {
            return;
         }
         var numChildren:int = target.numChildren;
         var vertical:Boolean = target.direction == BoxDirection.VERTICAL;
         var gap:int = target.gap;
         var minWidth:int = target.minWidth;
         var minHeight:int = target.minHeight;
         var verticalAlign:String = target.verticalAlign;
         var horizontalAlign:String = target.horizontalAlign;
         var padding:int = target.padding;
         var p2:int = padding * 2;
         var gaps:int = target.gap * (numChildren - 1);
         var totalPercents:Number = 0;
         for(i = 0; i < numChildren; i++)
         {
            child = target.getChildAt(i) as Component;
            if(vertical)
            {
               if(!isNaN(child.percentHeight))
               {
                  totalPercents += child.percentHeight;
               }
               else
               {
                  takenFixedHeight += child.height;
               }
            }
            else if(!isNaN(child.percentWidth))
            {
               totalPercents += child.percentWidth;
            }
            else
            {
               takenFixedWidth += child.width;
            }
            if(isNaN(child.percentWidth))
            {
               maxWidth = Math.max(maxWidth,child.width);
            }
            if(isNaN(child.percentHeight))
            {
               maxHeight = Math.max(maxHeight,child.height);
            }
         }
         if(isNaN(target.setWidth) && isNaN(target.percentWidth))
         {
            if(vertical)
            {
               target.actualWidth = Math.max(minWidth,maxWidth + p2);
            }
            else
            {
               target.actualWidth = Math.max(minWidth,takenFixedWidth + gaps + p2);
            }
         }
         if(isNaN(target.setHeight) && isNaN(target.percentHeight))
         {
            if(vertical)
            {
               target.actualHeight = Math.max(minHeight,takenFixedHeight + gaps + p2);
            }
            else
            {
               target.actualHeight = Math.max(minHeight,maxHeight + p2);
            }
         }
         if(totalPercents < 100)
         {
            totalPercents = 100;
         }
         var freeWidth:int = target.width - p2 - takenFixedWidth - (!vertical ? gaps : 0);
         var freeHeight:int = target.height - p2 - takenFixedHeight - (vertical ? gaps : 0);
         var x:Number = padding;
         var y:Number = padding;
         var xMult:Number = this.hAlignMultiplier(horizontalAlign);
         var yMult:Number = this.vAlignMultiplier(verticalAlign);
         for(i = 0; i < numChildren; i++)
         {
            child = target.getChildAt(i) as Component;
            this.setChildPercentWidth(child,freeWidth,vertical ? 100 : totalPercents);
            this.setChildPercentHeight(child,freeHeight,vertical ? totalPercents : 100);
            if(vertical)
            {
               child.y = Math.round(y);
               child.x = Math.round(x + (freeWidth - child.width) * xMult);
               y += child.height + gap;
            }
            else
            {
               child.x = Math.round(x);
               child.y = Math.round(y + (freeHeight - child.height) * yMult);
               x += child.width + gap;
            }
         }
         freeWidth = target.width - padding - x + (!vertical ? gap : 0);
         freeHeight = target.height - padding - y + (vertical ? gap : 0);
         x = freeWidth * xMult;
         y = freeHeight * yMult;
         for(i = 0; i < numChildren; i++)
         {
            child = target.getChildAt(i) as Component;
            if(vertical)
            {
               child.y += int(y);
            }
            else
            {
               child.x += int(x);
            }
         }
      }
      
      private function hAlignMultiplier(align:String) : Number
      {
         return align == HorizontalAlign.RIGHT ? 1 : (align == HorizontalAlign.CENTER ? 0.5 : 0);
      }
      
      private function vAlignMultiplier(align:String) : Number
      {
         return align == VerticalAlign.BOTTOM ? 1 : (align == VerticalAlign.MIDDLE ? 0.5 : 0);
      }
      
      private function setChildPercentWidth(child:Component, size:Number, totalPercents:Number) : void
      {
         if(!isNaN(child.percentWidth))
         {
            child.actualWidth = size / totalPercents * child.percentWidth;
         }
      }
      
      private function setChildPercentHeight(child:Component, size:Number, totalPercents:Number) : void
      {
         if(!isNaN(child.percentHeight))
         {
            child.actualHeight = size / totalPercents * child.percentHeight;
         }
      }
   }
}

