package soul.view.ui
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   
   [Event(name="change",type="flash.events.Event")]
   public class CachedImage extends Component
   {
      
      private static const loaders:Dictionary = new Dictionary();
      
      private static const bitmapDataCache:Object = {};
      
      public var showIcon:Boolean = false;
      
      private var icon:DisplayObject;
      
      private var bitmapDisposable:Boolean;
      
      private var child:DisplayObject;
      
      private var _source:Object;
      
      private var oldWidth:int;
      
      private var oldHeight:int;
      
      public function CachedImage()
      {
         super();
         mouseChildren = false;
         cacheAsBitmap = true;
      }
      
      private static function isLoaded(url:String) : Boolean
      {
         return bitmapDataCache[url] != null;
      }
      
      private static function getCachedBitmapData(url:Object) : BitmapData
      {
         return bitmapDataCache[url];
      }
      
      private function load(url:String) : void
      {
         var existingLoader:Loader = null;
         var o:Object = null;
         var loader:Loader = null;
         for(o in loaders)
         {
            if(loaders[o] == url)
            {
               existingLoader = o as Loader;
               break;
            }
         }
         loader = existingLoader || new Loader();
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.libLoaded);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.loadError);
         if(this.showIcon)
         {
            if(Boolean(this.icon))
            {
               removeChild(this.icon);
            }
            this.icon = new UIAssets.loading();
            addChild(this.icon);
            this.centerIcon();
         }
         if(!existingLoader)
         {
            loaders[loader.contentLoaderInfo] = url;
            loader.load(new URLRequest(url));
         }
      }
      
      private function hideIcon() : void
      {
         if(Boolean(this.icon))
         {
            removeChild(this.icon);
            this.icon = null;
         }
      }
      
      private function libLoaded(e:Event) : void
      {
         var bmpd:BitmapData = null;
         var loaderInfo:LoaderInfo = e.target as LoaderInfo;
         var url:String = loaders[loaderInfo];
         if(loaderInfo.content is Bitmap)
         {
            bmpd = Bitmap(loaderInfo.content).bitmapData;
         }
         else
         {
            bmpd = new BitmapData(loaderInfo.content.width,loaderInfo.content.height,true,0);
            bmpd.draw(loaderInfo.content);
         }
         this.hideIcon();
         bitmapDataCache[url] = bmpd;
         delete loaders[loaderInfo];
         this.createChildFromCache();
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function loadError(e:IOErrorEvent) : void
      {
         var loaderInfo:LoaderInfo = e.target as LoaderInfo;
         var l:Dictionary = loaders;
         if(this.showIcon)
         {
            if(Boolean(this.icon))
            {
               removeChild(this.icon);
            }
            this.icon = new UIAssets.loadFailed();
            addChild(this.icon);
            this.centerIcon();
         }
         delete loaders[loaderInfo];
      }
      
      public function set source(value:Object) : void
      {
         var url:String = null;
         if(value == this._source)
         {
            return;
         }
         this._source = value;
         this.bitmapDisposable = false;
         this.hideIcon();
         if(Boolean(this.child))
         {
            this.dispose();
            removeChild(this.child);
            this.child = null;
            this.applySize();
         }
         if(value is Class)
         {
            this.createChildFromClass();
         }
         else if(value is String)
         {
            url = value as String;
            if(isLoaded(url))
            {
               this.createChildFromCache();
            }
            else
            {
               this.load(url);
            }
         }
         else if(value is BitmapData)
         {
            this.createFromBitmap();
         }
         else
         {
            this.applySize();
         }
      }
      
      public function get source() : Object
      {
         return this._source;
      }
      
      override public function destroy() : void
      {
         this.dispose();
         super.destroy();
      }
      
      private function dispose() : void
      {
         var bitmapChild:Bitmap = this.child as Bitmap;
         if(Boolean(bitmapChild) && this.bitmapDisposable)
         {
            bitmapChild.bitmapData.dispose();
         }
      }
      
      private function createChildFromCache() : void
      {
         var bmp:BitmapData = getCachedBitmapData(this._source);
         this.child = new Bitmap(bmp,"auto",true);
         addChildAt(this.child,0);
         this.hideIcon();
         this.applySize();
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function createFromBitmap() : void
      {
         this.child = new Bitmap(this._source as BitmapData);
         addChild(this.child);
         this.applySize();
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function createChildFromClass() : void
      {
         var bmpd:BitmapData = null;
         this.bitmapDisposable = true;
         var cls:Class = this._source as Class;
         if(describeType(cls).factory.extendsClass.@type[0] == getQualifiedClassName(BitmapData))
         {
            bmpd = new cls(0,0);
            this.child = new Bitmap(bmpd);
         }
         else
         {
            this.child = new cls();
         }
         cacheAsBitmap = !(this.child is MovieClip) || MovieClip(this.child).totalFrames <= 1;
         this.hideIcon();
         addChild(this.child);
         this.applySize();
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      override protected function applySize() : void
      {
         if(Boolean(this.child))
         {
            if(!isNaN(setWidth))
            {
               this.child.width = setWidth;
            }
            else if(!isNaN(percentWidth))
            {
               this.child.scaleX = 1;
               if(this.child is Bitmap && this.child.width < _width)
               {
                  this.child.x = _width - this.child.width >> 1;
               }
               else
               {
                  this.child.width = _width;
               }
            }
            else
            {
               actualWidth = this.child.width;
            }
            if(!isNaN(setHeight))
            {
               this.child.height = setHeight;
            }
            else if(!isNaN(percentHeight))
            {
               this.child.scaleY = 1;
               if(this.child is Bitmap && this.child.height < _height)
               {
                  this.child.y = _height - this.child.height >> 1;
               }
               else
               {
                  this.child.height = _height;
               }
            }
            else
            {
               actualHeight = this.child.height;
            }
         }
         if(this.showIcon)
         {
            this.centerIcon();
         }
      }
      
      private function centerIcon() : void
      {
         if(!this.icon)
         {
            return;
         }
         this.icon.x = _width / 2;
         this.icon.y = _height / 2;
      }
   }
}

