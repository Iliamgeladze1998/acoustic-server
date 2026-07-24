package spark.primitives.supportClasses
{
   import flash.display.Graphics;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.graphics.IFill;
   
   use namespace mx_internal;
   
   public class FilledElement extends StrokedElement
   {
      
      mx_internal static const VERSION:String = "4.5.1.21328";
      
      protected var _fill:IFill;
      
      public function FilledElement()
      {
         super();
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get fill() : IFill
      {
         return this._fill;
      }
      
      public function set fill(value:IFill) : void
      {
         var fillEventDispatcher:EventDispatcher = null;
         var oldValue:IFill = this._fill;
         fillEventDispatcher = this._fill as EventDispatcher;
         if(Boolean(fillEventDispatcher))
         {
            fillEventDispatcher.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.fill_propertyChangeHandler);
         }
         this._fill = value;
         fillEventDispatcher = this._fill as EventDispatcher;
         if(Boolean(fillEventDispatcher))
         {
            fillEventDispatcher.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.fill_propertyChangeHandler);
         }
         dispatchPropertyChangeEvent("fill",oldValue,this._fill);
         invalidateDisplayList();
      }
      
      override protected function beginDraw(g:Graphics) : void
      {
         var strokeBounds:Rectangle = null;
         var fillBounds:Rectangle = null;
         var origin:Point = new Point(drawX,drawY);
         if(Boolean(stroke))
         {
            strokeBounds = getStrokeBounds();
            strokeBounds.offset(drawX,drawY);
            stroke.apply(g,strokeBounds,origin);
         }
         else
         {
            g.lineStyle();
         }
         if(Boolean(this.fill))
         {
            fillBounds = new Rectangle(drawX,drawY,width,height);
            this.fill.begin(g,fillBounds,origin);
         }
      }
      
      override protected function endDraw(g:Graphics) : void
      {
         if(Boolean(this.fill))
         {
            this.fill.end(g);
         }
      }
      
      private function fill_propertyChangeHandler(event:Event) : void
      {
         invalidateDisplayList();
      }
   }
}

