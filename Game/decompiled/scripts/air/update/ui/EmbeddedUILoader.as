package air.update.ui
{
   import air.update.logging.Logger;
   import flash.desktop.NativeApplication;
   import flash.display.Loader;
   import flash.display.NativeWindow;
   import flash.display.NativeWindowInitOptions;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.system.ApplicationDomain;
   import flash.system.Capabilities;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   
   [ExcludeClass]
   [Event(name="ioError",type="flash.events.IOErrorEvent")]
   [Event(name="complete",type="flash.events.Event")]
   public class EmbeddedUILoader extends EventDispatcher
   {
      
      private static var logger:Logger = Logger.getLogger("air.update.ui.EmbeddedUILoader");
      
      private var loader:Loader;
      
      private var _initialized:Boolean;
      
      private var uiPath:String;
      
      [Embed(source="/assets/ApplicationUpdaterDialogs.swf",mimeType="application/octet-stream")]
      private var DialogBytes:Class = EmbeddedUILoader_DialogBytes;
      
      private var uiWindow:NativeWindow;
      
      private var appUpdater:UpdaterUI;
      
      private var isExiting:Boolean;
      
      private var applicationDialogs:Object;
      
      public function EmbeddedUILoader()
      {
         super();
         this.watchOpenedWindows();
         NativeApplication.nativeApplication.addEventListener(Event.EXITING,this.onExiting,false,int.MAX_VALUE);
      }
      
      private function setupResourceManager() : void
      {
         var resMgr:ResourceManagerReflection = null;
         var RESOURCE_BUNDLE_NAME:String = null;
         var addApplicationResourceBundles:Function = function():void
         {
            var content:Object = null;
            var locales:Array = resMgr.getLocales();
            for(var i:int = 0; i < locales.length; i++)
            {
               content = resMgr.getResourceBundleContent(locales[i],RESOURCE_BUNDLE_NAME);
               if(Boolean(content))
               {
                  addResources(locales[i],content);
               }
            }
         };
         resMgr = ResourceManagerReflection.getInstance();
         if(!resMgr.hasResourceManager())
         {
            return;
         }
         resMgr.addEventListener(Event.CHANGE,function(ev:Event):void
         {
            addApplicationResourceBundles();
            setLocaleChain(resMgr.localeChain);
         });
         RESOURCE_BUNDLE_NAME = "ApplicationUpdaterDialogs";
         addApplicationResourceBundles();
         this.setLocaleChain(resMgr.localeChain);
      }
      
      public function addResources(lang:String, res:Object) : void
      {
         if(this.applicationDialogs != null)
         {
            this.applicationDialogs.addResources(lang,res);
         }
      }
      
      public function setLocaleChain(locale:Array) : void
      {
         if(this.applicationDialogs != null)
         {
            this.applicationDialogs.setLocaleChain(locale);
         }
      }
      
      private function onWindowClose(e:Event) : void
      {
         if(this.uiWindow != null && !this.uiWindow.closed && NativeApplication.nativeApplication.openedWindows.length == 1)
         {
            logger.fine("UpdateUI is last window standing. Action: Close & Exit");
            this.onExiting(e);
         }
         else
         {
            this.watchOpenedWindows();
         }
      }
      
      private function watchOpenedWindows() : void
      {
         var win:NativeWindow = null;
         logger.fine("Check opened windows");
         for(var i:uint = 0; i < NativeApplication.nativeApplication.openedWindows.length; i++)
         {
            win = NativeApplication.nativeApplication.openedWindows[i];
            logger.fine("Opened window [" + i + "] " + (Boolean(win.title) ? win.title : "-- no title --"));
            if(win != this.uiWindow)
            {
               win.removeEventListener(Event.CLOSE,this.onWindowClose);
               if(!win.closed)
               {
                  win.addEventListener(Event.CLOSE,this.onWindowClose);
               }
            }
         }
      }
      
      public function showWindow() : void
      {
         var screenX:Number;
         var screenY:Number;
         var options:NativeWindowInitOptions;
         if(this.uiWindow != null)
         {
            logger.fine("window already created");
            return;
         }
         this.isExiting = false;
         logger.fine("Creating UI window");
         screenX = Capabilities.screenResolutionX;
         screenY = Capabilities.screenResolutionY;
         options = new NativeWindowInitOptions();
         options.resizable = false;
         options.maximizable = false;
         this.uiWindow = new NativeWindow(options);
         this.uiWindow.addEventListener(Event.CLOSING,function(evt:Event):void
         {
            logger.fine("Closing UI window." + (isExiting ? " Exiting" : " Not exiting, just hide"));
            if(!isExiting)
            {
               evt.preventDefault();
            }
            else
            {
               uiWindow = null;
            }
            if(appUpdater.currentState != "PENDING_INSTALLING")
            {
               appUpdater.cancelUpdate();
            }
         });
         this.uiWindow.visible = false;
         this.uiWindow.width = 1024;
         this.uiWindow.height = 800;
         this.uiWindow.x = (screenX - 530) / 2;
         this.uiWindow.y = (screenY - 230) / 2;
         this.uiWindow.stage.align = StageAlign.TOP_LEFT;
         this.uiWindow.stage.scaleMode = StageScaleMode.NO_SCALE;
         this.uiWindow.stage.addChild(this.loader);
      }
      
      private function onUILoadError(event:Event) : void
      {
         logger.severe("SWF Loading complete");
         dispatchEvent(event);
      }
      
      public function getLocaleChain() : Array
      {
         if(this.applicationDialogs == null)
         {
            return [];
         }
         return this.applicationDialogs.getLocaleChain();
      }
      
      private function removeCloseListeners() : void
      {
         var win:NativeWindow = null;
         for(var i:uint = 0; i < NativeApplication.nativeApplication.openedWindows.length; i++)
         {
            win = NativeApplication.nativeApplication.openedWindows[i];
            win.removeEventListener(Event.CLOSE,this.onWindowClose);
         }
      }
      
      public function get initialized() : Boolean
      {
         return this._initialized;
      }
      
      public function hideWindow() : void
      {
         logger.fine("Hide window");
         if(this.uiWindow != null)
         {
            this.uiWindow.visible = false;
         }
      }
      
      private function onExiting(event:Event) : void
      {
         logger.fine("Exiting: " + this.uiWindow);
         this.isExiting = true;
         this.unload();
      }
      
      private function onUILoadInit(event:Event) : void
      {
         logger.fine("SWF Loading complete. Waiting for ApplicationComplete");
         this.loader.content.addEventListener("windowComplete",this.onUIApplicationComplete,true);
      }
      
      public function load() : void
      {
         if(this.loader != null)
         {
            return;
         }
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.INIT,this.onUILoadInit);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onUILoadError);
         var dlgBytes:ByteArray = new this.DialogBytes() as ByteArray;
         if(dlgBytes.length == 0)
         {
            dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
            return;
         }
         var ctx:LoaderContext = new LoaderContext(false,new ApplicationDomain());
         ctx.allowLoadBytesCodeExecution = true;
         this.showWindow();
         this.loader.loadBytes(dlgBytes,ctx);
      }
      
      public function set applicationUpdater(value:UpdaterUI) : void
      {
         this.appUpdater = value;
      }
      
      private function onUIApplicationComplete(event:Event) : void
      {
         logger.fine("Application loading complete.");
         this.applicationDialogs = (event.currentTarget as Object).application;
         this.applicationDialogs.setApplicationUpdater(this.appUpdater);
         this.setupResourceManager();
         this._initialized = true;
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function unload() : void
      {
         logger.fine("unload " + this.uiWindow);
         if(this.uiWindow != null && !this.uiWindow.closed)
         {
            if(this.appUpdater.currentState != "PENDING_INSTALLING")
            {
               this.appUpdater.cancelUpdate();
            }
            this.applicationDialogs.setApplicationUpdater(null);
            this.uiWindow.close();
            this.uiWindow = null;
         }
      }
   }
}

