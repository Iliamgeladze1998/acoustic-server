package spark.events
{
   import flash.events.Event;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class SkinPartEvent extends Event
   {
      
      mx_internal static const VERSION:String = "4.5.1.21328";
      
      public static const PART_ADDED:String = "partAdded";
      
      public static const PART_REMOVED:String = "partRemoved";
      
      public var instance:Object;
      
      public var partName:String;
      
      public function SkinPartEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, partName:String = null, instance:Object = null)
      {
         super(type,bubbles,cancelable);
         this.partName = partName;
         this.instance = instance;
      }
      
      override public function clone() : Event
      {
         return new SkinPartEvent(type,bubbles,cancelable,this.partName,this.instance);
      }
   }
}

