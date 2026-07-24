package spark.events
{
   import flash.events.Event;
   import mx.core.IVisualElement;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class RendererExistenceEvent extends Event
   {
      
      mx_internal static const VERSION:String = "4.5.1.21328";
      
      public static const RENDERER_ADD:String = "rendererAdd";
      
      public static const RENDERER_REMOVE:String = "rendererRemove";
      
      public var data:Object;
      
      public var index:int;
      
      public var renderer:IVisualElement;
      
      public function RendererExistenceEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, renderer:IVisualElement = null, index:int = -1, data:Object = null)
      {
         super(type,bubbles,cancelable);
         this.renderer = renderer;
         this.index = index;
         this.data = data;
      }
      
      override public function clone() : Event
      {
         return new RendererExistenceEvent(type,bubbles,cancelable,this.renderer,this.index,this.data);
      }
   }
}

