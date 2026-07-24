package mx.containers
{
   import mx.containers.utilityClasses.CanvasLayout;
   import mx.containers.utilityClasses.ConstraintColumn;
   import mx.containers.utilityClasses.ConstraintRow;
   import mx.containers.utilityClasses.IConstraintLayout;
   import mx.core.Container;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [Alternative(replacement="spark.components.BorderContainer",since="4.0")]
   [Alternative(replacement="spark.components.Group",since="4.0")]
   [IconFile("Canvas.png")]
   [Exclude(name="focusOutEffect",kind="effect")]
   [Exclude(name="focusInEffect",kind="effect")]
   [Exclude(name="paddingTop",kind="style")]
   [Exclude(name="paddingRight",kind="style")]
   [Exclude(name="paddingLeft",kind="style")]
   [Exclude(name="paddingBottom",kind="style")]
   [Exclude(name="focusThickness",kind="style")]
   [Exclude(name="focusSkin",kind="style")]
   [Exclude(name="focusBlendMode",kind="style")]
   [Exclude(name="focusOut",kind="event")]
   [Exclude(name="focusIn",kind="event")]
   public class Canvas extends Container implements IConstraintLayout
   {
      
      mx_internal static const VERSION:String = "4.5.1.21328";
      
      private var layoutObject:CanvasLayout = new CanvasLayout();
      
      private var _constraintColumns:Array = [];
      
      private var _constraintRows:Array = [];
      
      public function Canvas()
      {
         super();
         this.layoutObject.target = this;
      }
      
      override mx_internal function get usePadding() : Boolean
      {
         return false;
      }
      
      [Inspectable(arrayType="mx.containers.utilityClasses.ConstraintColumn")]
      [ArrayElementType("mx.containers.utilityClasses.ConstraintColumn")]
      public function get constraintColumns() : Array
      {
         return this._constraintColumns;
      }
      
      public function set constraintColumns(value:Array) : void
      {
         var n:int = 0;
         var i:int = 0;
         if(value != this._constraintColumns)
         {
            n = int(value.length);
            for(i = 0; i < n; i++)
            {
               ConstraintColumn(value[i]).container = this;
            }
            this._constraintColumns = value;
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      [Inspectable(arrayType="mx.containers.utilityClasses.ConstraintRow")]
      [ArrayElementType("mx.containers.utilityClasses.ConstraintRow")]
      public function get constraintRows() : Array
      {
         return this._constraintRows;
      }
      
      public function set constraintRows(value:Array) : void
      {
         var n:int = 0;
         var i:int = 0;
         if(value != this._constraintRows)
         {
            n = int(value.length);
            for(i = 0; i < n; i++)
            {
               ConstraintRow(value[i]).container = this;
            }
            this._constraintRows = value;
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         this.layoutObject.measure();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         this.layoutObject.updateDisplayList(unscaledWidth,unscaledHeight);
      }
   }
}

