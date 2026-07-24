package soul.utils
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   
   public class BundleLoader extends EventDispatcher
   {
      
      private var loaderMap:Object;
      
      private var filesToLoad:uint;
      
      private var filesLoaded:uint;
      
      public var files:Object;
      
      public function BundleLoader()
      {
         super();
      }
      
      public function loadBundle(bundle:Object, basePath:String = "") : void
      {
         var loader:StackLoader = null;
         var item:String = null;
         var urlRequest:URLRequest = null;
         this.filesToLoad = 0;
         this.filesLoaded = 0;
         this.files = null;
         for each(loader in this.loaderMap)
         {
            loader.close();
         }
         this.loaderMap = {};
         for each(item in bundle)
         {
            loader = new StackLoader();
            loader.dataFormat = URLLoaderDataFormat.BINARY;
            loader.addEventListener(Event.COMPLETE,this.fileLoaded);
            loader.addEventListener(IOErrorEvent.IO_ERROR,this.fileLoaded);
            this.loaderMap[item] = loader;
            ++this.filesToLoad;
            urlRequest = new URLRequest(basePath + item);
            loader.load(urlRequest);
         }
      }
      
      private function fileLoaded(e:Event) : void
      {
         var item:String = null;
         var loader:StackLoader = e.target as StackLoader;
         if(e is IOErrorEvent)
         {
            loader.data = null;
         }
         ++this.filesLoaded;
         if(this.filesLoaded < this.filesToLoad)
         {
            return;
         }
         this.files = {};
         for(item in this.loaderMap)
         {
            loader = this.loaderMap[item];
            this.files[item] = loader.data;
         }
         this.loaderMap = null;
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}

