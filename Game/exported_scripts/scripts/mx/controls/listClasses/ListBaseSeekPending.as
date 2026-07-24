package mx.controls.listClasses
{
   import mx.collections.CursorBookmark;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class ListBaseSeekPending
   {
      
      mx_internal static const VERSION:String = "4.5.1.21328";
      
      public var bookmark:CursorBookmark;
      
      public var offset:int;
      
      public function ListBaseSeekPending(bookmark:CursorBookmark, offset:int)
      {
         super();
         this.bookmark = bookmark;
         this.offset = offset;
      }
   }
}

