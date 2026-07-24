package soul.model.field
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import soul.utils.ClassUtils;
   import soul.view.ui.CachedMovieClip;
   
   public class LibraryManager extends EventDispatcher
   {
      
      public static var libLoaders:Object;
      
      private static var libsToLoad:Array;
      
      public static var libsLoaded:Array;
      
      public static var libraryErrorDescription:String;
      
      public static const instance:LibraryManager = new LibraryManager();
      
      public static const LIBRARY_LOADED:String = "LIBRARY_LOADED";
      
      public static const LOAD_COMPLETE:String = "LOAD_COMPLETE";
      
      public static const LOAD_ERROR:String = "LOAD_ERROR";
      
      public static const INTERNAL_ERROR:String = "INTERNAL_ERROR";
      
      public static const mainLibrary:String = "common.swf";
      
      public static const mapLibs:String = "map/";
      
      public static const charLibs:String = "character/";
      
      public static const LIBS:String = "libs/";
      
      public static var libPath:String = "libs/";
      
      unloadAll();
      
      public function LibraryManager()
      {
         super();
         if(Boolean(instance))
         {
            throw new IllegalOperationError("Class is singletone and can not be created manually");
         }
      }
      
      public static function init() : void
      {
         instance.loadLibraries([mainLibrary]);
      }
      
      public static function unloadAll() : void
      {
         libLoaders = {};
         libsToLoad = [];
         libsLoaded = [];
      }
      
      public static function libraryLoaded(path:String) : Boolean
      {
         return libsLoaded.indexOf(path) != -1;
      }
      
      public static function characterLoaded(path:String) : Boolean
      {
         return libraryLoaded(charLibs + path);
      }
      
      private static function getLibraryDomain(library:String) : ApplicationDomain
      {
         var info:LoaderInfo = libLoaders[library];
         if(Boolean(info))
         {
            return info.applicationDomain;
         }
         return null;
      }
      
      private static function getObjectDomain(objectId:String) : ApplicationDomain
      {
         var ad:ApplicationDomain = null;
         var info:LoaderInfo = null;
         for each(info in libLoaders)
         {
            ad = info.applicationDomain;
            if(Boolean(ad) && ad.hasDefinition(objectId))
            {
               return ad;
            }
         }
         return null;
      }
      
      public static function getObjectClass(objectId:String, library:String = null) : Class
      {
         var ad:ApplicationDomain = null;
         var msg:String = null;
         if(Boolean(library))
         {
            ad = getLibraryDomain(library);
            if(Boolean(ad) && !ad.hasDefinition(objectId))
            {
               ad = null;
            }
         }
         if(!ad)
         {
            ad = getObjectDomain(objectId);
         }
         if(Boolean(ad))
         {
            return ad.getDefinition(objectId) as Class;
         }
         msg = "\"" + objectId + "\" not found in [" + libsLoaded + "]";
         trace(msg);
         return null;
      }
      
      public static function getBitmapData(objectId:String, library:String = null) : BitmapData
      {
         var b:BitmapData = null;
         var c:Class = getObjectClass(objectId,library);
         try
         {
            b = new c(1,1);
         }
         catch(e:Error)
         {
         }
         return b;
      }
      
      public static function getObject(objectId:String, library:String = null) : DisplayObject
      {
         var d:DisplayObject = null;
         var c:Class = getObjectClass(objectId,library);
         if(!c)
         {
            return null;
         }
         var superclass:Class = ClassUtils.getSuperclass(c);
         if(superclass == MovieClip)
         {
            d = CachedMovieClip.wrap(c);
         }
         else if(superclass == BitmapData)
         {
            d = new Bitmap(new c(1,1));
         }
         else
         {
            d = new c();
         }
         return d;
      }
      
      public static function get progress() : Number
      {
         var total:int = libsToLoad.length + libsLoaded.length;
         return libsLoaded.length / total;
      }
      
      public function loadMapLibraries(names:Array) : void
      {
         var i:String = null;
         for(i in names)
         {
            names[i] = mapLibs + names[i];
         }
         this.loadLibraries(names);
      }
      
      public function loadCharacterLibraries(names:Array) : void
      {
         var i:String = null;
         for(i in names)
         {
            names[i] = charLibs + names[i];
         }
         this.loadLibraries(names);
      }
      
      public function loadLibraries(names:Array) : void
      {
         var name:String = null;
         var loader:Loader = null;
         var libsToAdd:Array = [];
         for each(name in names)
         {
            if(Boolean(name && name != "null" && libsLoaded.indexOf(name) == -1) && Boolean(libsToLoad.indexOf(name) == -1) && libsToAdd.indexOf(name) == -1)
            {
               libsToAdd.push(name);
            }
         }
         if(libsToAdd.length == 0)
         {
            this.libLoaded(null);
            return;
         }
         for each(name in libsToAdd)
         {
            libsToLoad.push(name);
            loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.libLoaded);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.loadError);
            loader.load(new URLRequest(libPath + name));
            libLoaders[name] = loader.contentLoaderInfo;
         }
      }
      
      private function libLoaded(e:Event) : void
      {
         var ll:Object = null;
         var name:String = null;
         var id:String = null;
         var lt:Array = null;
         if(Boolean(e))
         {
            ll = libLoaders;
            for(id in libLoaders)
            {
               if(LoaderInfo(e.target).url.indexOf(id) != -1)
               {
                  name = id;
                  break;
               }
            }
            if(!name)
            {
               return;
            }
            if(libsLoaded.indexOf(name) == -1)
            {
               libsLoaded.push(name);
            }
            lt = libsToLoad;
            libsToLoad.splice(libsToLoad.indexOf(name),1);
            dispatchEvent(new Event(LIBRARY_LOADED));
         }
         if(libsToLoad.length == 0)
         {
            dispatchEvent(new Event(LOAD_COMPLETE));
         }
      }
      
      private function loadError(e:IOErrorEvent) : void
      {
         var libName:String = null;
         var name:String = null;
         for(name in libLoaders)
         {
            if(libLoaders[name] == e.target)
            {
               libName = name;
               break;
            }
         }
         libraryErrorDescription = "Error loading library :\'" + libName + "\'. " + e.text;
         dispatchEvent(new Event(LOAD_ERROR));
      }
   }
}

