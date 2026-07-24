package mx.controls.listClasses
{
   import mx.collections.CursorBookmark;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class ListBaseSelectionPending
   {
      
      mx_internal static const VERSION:String = "4.5.1.21328";
      
      public var bookmark:CursorBookmark;
      
      public var incrementing:Boolean;
      
      public var index:int;
      
      public var offset:int;
      
      public var placeHolder:CursorBookmark;
      
      public var stopData:Object;
      
      public var transition:Boolean;
      
      public function ListBaseSelectionPending(incrementing:Boolean, index:int, stopData:Object, transition:Boolean, placeHolder:CursorBookmark, bookmark:CursorBookmark, offset:int)
      {
         super();
         this.incrementing = incrementing;
         this.index = index;
         this.stopData = stopData;
         this.transition = transition;
         this.placeHolder = placeHolder;
         this.bookmark = bookmark;
         this.offset = offset;
      }
   }
}

