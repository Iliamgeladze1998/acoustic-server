package soul.view.sprite
{
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.UncaughtErrorEvent;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import soul.model.field.LibraryManager;
   import soul.model.system.Configuration;
   import soul.utils.BundleLoader;
   import soul.view.field.visual.RotatingBitmap;
   
   public class SpriteSheetLoder extends EventDispatcher
   {
      
      private static var ssToLoad:uint;
      
      private static var ssLoaded:uint;
      
      private static const characterLoaderCache:Object = {};
      
      private static const spriteLoaderCache:Object = {};
      
      public static const dispatcher:EventDispatcher = new EventDispatcher();
      
      public var spriteSheets:Vector.<SpriteSheet>;
      
      private var linkages:Array;
      
      private var library:String;
      
      private var frameWidth:int;
      
      private var frameHeight:int;
      
      private var billBoard:Boolean;
      
      private var parseAsync:Boolean = true;
      
      private var libraryLoader:Loader;
      
      private var bundleLoader:BundleLoader;
      
      private var files:Array;
      
      private var visualId:String;
      
      private var _loaded:Boolean;
      
      public function SpriteSheetLoder(linkages:Array = null, library:String = null, frameWidth:uint = 0, frameHeight:uint = 0, billBoard:Boolean = false)
      {
         super();
         this.linkages = linkages.slice();
         this.library = library;
         this.frameWidth = frameWidth;
         this.frameHeight = frameHeight;
         this.billBoard = billBoard;
      }
      
      public static function loadSpriteSheets(visuals:Array) : void
      {
         var visualId:String = null;
         var loader:SpriteSheetLoder = null;
         var addedToLoad:uint = 0;
         for each(visualId in visuals)
         {
            loader = getCharacterLoader(visualId);
            if(!loader.loaded)
            {
               addedToLoad++;
               loader.parseAsync = false;
               loader.loadCharacter();
            }
         }
         if(addedToLoad < 1)
         {
            allLoaded();
         }
      }
      
      public static function getSpriteLoader(key:String, linkages:Array) : SpriteSheetLoder
      {
         var loader:SpriteSheetLoder = spriteLoaderCache[key];
         if(!loader)
         {
            loader = new SpriteSheetLoder(linkages);
            spriteLoaderCache[key] = loader;
         }
         return loader;
      }
      
      public static function getCharacterLoader(visualId:String) : SpriteSheetLoder
      {
         var unitBitmap:RotatingBitmap = null;
         var loader:SpriteSheetLoder = characterLoaderCache[visualId];
         if(!loader)
         {
            unitBitmap = RotatingBitmap.getUnitInstanceByVisualId(visualId);
            if(Boolean(unitBitmap))
            {
               loader = new SpriteSheetLoder(unitBitmap.linkages,unitBitmap.library,unitBitmap.frameWidth,unitBitmap.frameHeight);
               loader.visualId = visualId;
               characterLoaderCache[visualId] = loader;
            }
         }
         return loader;
      }
      
      private static function allLoaded() : void
      {
         ssLoaded = 0;
         ssToLoad = 0;
         dispatcher.dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public static function get progress() : Number
      {
         return ssToLoad == 0 ? 1 : ssLoaded / ssToLoad;
      }
      
      public function loadSprite(frameWidth:uint, frameHeight:uint) : void
      {
         var linkage:String = null;
         var bd:BitmapData = null;
         var ss:SpriteSheet = null;
         this.spriteSheets = new Vector.<SpriteSheet>();
         for each(linkage in this.linkages)
         {
            bd = LibraryManager.getBitmapData(linkage);
            ss = new SpriteSheet();
            ss.load(bd,frameWidth,frameHeight,this.billBoard);
            this.spriteSheets.push(ss);
         }
         this._loaded = true;
      }
      
      public function loadCharacter() : void
      {
         if(Configuration.loadSS)
         {
            this.loadCachedCharacter();
         }
         else
         {
            this.loadLibraryCharacter();
         }
      }
      
      private function loadCachedCharacter() : void
      {
         var linkage:String = null;
         if(this._loaded)
         {
            return;
         }
         if(Boolean(this.bundleLoader))
         {
            return;
         }
         ++ssToLoad;
         this.files = [];
         for each(linkage in this.linkages)
         {
            this.files.push(this.visualId + "_" + linkage + ".ss");
         }
         this.bundleLoader = new BundleLoader();
         this.bundleLoader.addEventListener(Event.COMPLETE,this.bundleLoaded);
         this.bundleLoader.loadBundle(this.files,LibraryManager.libPath + LibraryManager.charLibs);
      }
      
      private function loadLibraryCharacter() : void
      {
         if(this._loaded)
         {
            return;
         }
         if(Boolean(this.libraryLoader))
         {
            return;
         }
         ++ssToLoad;
         this.libraryLoader = new Loader();
         this.libraryLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.libraryLoaded);
         this.libraryLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.libraryLoadError);
         this.libraryLoader.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.libraryLoadError);
         this.libraryLoader.load(new URLRequest(LibraryManager.libPath + LibraryManager.charLibs + this.library));
      }
      
      private function bundleLoaded(e:Event) : void
      {
         var file:String = null;
         var ba:ByteArray = null;
         var ss:SpriteSheet = null;
         this.bundleLoader.removeEventListener(Event.COMPLETE,this.bundleLoaded);
         ++ssLoaded;
         this._loaded = true;
         this.spriteSheets = new Vector.<SpriteSheet>();
         for each(file in this.files)
         {
            ba = this.bundleLoader.files[file];
            ss = new SpriteSheet();
            ba.uncompress();
            ss.setBytes(ba);
            this.spriteSheets.push(ss);
         }
         this.bundleLoader = null;
         this.thisLoaded();
      }
      
      private function libraryLoaded(e:Event) : void
      {
         var linkage:String = null;
         var bdc:Class = null;
         var bd:BitmapData = null;
         var ss:SpriteSheet = null;
         this.libraryLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.libraryLoaded);
         this.libraryLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.libraryLoadError);
         this.libraryLoader.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.libraryLoadError);
         this.spriteSheets = new Vector.<SpriteSheet>();
         for each(linkage in this.linkages)
         {
            bdc = this.libraryLoader.contentLoaderInfo.applicationDomain.getDefinition(linkage) as Class;
            bd = new bdc(1,1);
            ss = new SpriteSheet();
            if(this.parseAsync)
            {
               ss.addEventListener(Event.COMPLETE,this.checkAllSSLoaded);
               ss.loadAsync(bd,this.frameWidth,this.frameHeight,this.billBoard);
            }
            else
            {
               ss.load(bd,this.frameWidth,this.frameHeight,this.billBoard);
            }
            this.spriteSheets.push(ss);
         }
         if(!this.parseAsync)
         {
            this.checkAllSSLoaded(null);
         }
      }
      
      private function checkAllSSLoaded(e:Event) : void
      {
         var ss:SpriteSheet = null;
         for each(ss in this.spriteSheets)
         {
            if(!ss.loaded)
            {
               return;
            }
         }
         this._loaded = true;
         this.libraryLoader = null;
         ++ssLoaded;
         this.thisLoaded();
      }
      
      private function libraryLoadError(e:Event) : void
      {
         this.libraryLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.libraryLoaded);
         this.libraryLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.libraryLoadError);
         this.libraryLoader.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.libraryLoadError);
         var txt:String = "ERROR loading library: " + this.library;
         if(dispatcher.hasEventListener(ErrorEvent.ERROR))
         {
            dispatcher.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,txt));
         }
         this.libraryLoader = null;
         ++ssLoaded;
         this.thisLoaded();
      }
      
      private function thisLoaded() : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
         dispatcher.dispatchEvent(new Event(Event.CHANGE));
         if(ssLoaded == ssToLoad)
         {
            allLoaded();
         }
      }
      
      public function get loaded() : Boolean
      {
         return this._loaded;
      }
   }
}

