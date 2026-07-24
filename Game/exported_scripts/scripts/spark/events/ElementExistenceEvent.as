package spark.events
{
   import flash.events.Event;
   import mx.core.IVisualElement;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class ElementExistenceEvent extends Event
   {
      
      mx_internal static const VERSION:String = "4.5.1.21328";
      
      public static const ELEMENT_ADD:String = "elementAdd";
      
      public static const ELEMENT_REMOVE:String = "elementRemove";
      
      public var index:int;
      
      public var element:IVisualElement;
      
      public function ElementExistenceEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, element:IVisualElement = null, index:int = -1)
      {
         super(type,bubbles,cancelable);
         this.element = element;
         this.index = index;
      }
      
      override public function clone() : Event
      {
         return new ElementExistenceEvent(type,bubbles,cancelable,this.element,this.index);
      }
   }
}

