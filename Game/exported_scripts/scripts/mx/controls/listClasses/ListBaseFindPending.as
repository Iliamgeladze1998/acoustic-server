package mx.controls.listClasses
{
   import mx.collections.CursorBookmark;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class ListBaseFindPending
   {
      
      mx_internal static const VERSION:String = "4.5.1.21328";
      
      public var bookmark:CursorBookmark;
      
      public var currentIndex:int;
      
      public var offset:int;
      
      public var searchString:String;
      
      public var startingBookmark:CursorBookmark;
      
      public var stopIndex:int;
      
      public function ListBaseFindPending(searchString:String, startingBookmark:CursorBookmark, bookmark:CursorBookmark, offset:int, currentIndex:int, stopIndex:int)
      {
         super();
         this.searchString = searchString;
         this.startingBookmark = startingBookmark;
         this.bookmark = bookmark;
         this.offset = offset;
         this.currentIndex = currentIndex;
         this.stopIndex = stopIndex;
      }
   }
}

