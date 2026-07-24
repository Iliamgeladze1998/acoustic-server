package mx.controls.listClasses
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class ListRowInfo
   {
      
      mx_internal static const VERSION:String = "4.5.1.21328";
      
      public var data:Object;
      
      public var height:Number;
      
      public var itemOldY:Number;
      
      public var oldY:Number;
      
      public var uid:String;
      
      public var y:Number;
      
      public function ListRowInfo(y:Number, height:Number, uid:String, data:Object = null)
      {
         super();
         this.y = y;
         this.height = height;
         this.uid = uid;
         this.data = data;
      }
   }
}

