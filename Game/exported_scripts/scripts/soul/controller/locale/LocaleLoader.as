package soul.controller.locale
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import soul.model.system.Configuration;
   import soul.view.console.Console;
   import vega.util.zip.ZipEntry;
   import vega.util.zip.ZipError;
   import vega.util.zip.ZipFile;
   
   public class LocaleLoader extends EventDispatcher
   {
      
      private static const LOCALE_BASE:String = "i18n/";
      
      private static const LOCALE_FILE:String = "i18n.zip";
      
      private static const HINTS_BASE:String = "preload/i18n/";
      
      private static const HINTS_FILE:String = "tips.xml";
      
      private const loader:URLLoader = new URLLoader();
      
      private var locale:String;
      
      public function LocaleLoader()
      {
         super();
      }
      
      public function loadLocale(locale:String) : void
      {
         this.locale = locale;
         this.loader.dataFormat = URLLoaderDataFormat.BINARY;
         this.loader.addEventListener(Event.COMPLETE,this.bundleLoaded);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.bundleError);
         var url:String = Configuration.staticServerURL + LOCALE_BASE + locale + "/" + LOCALE_FILE;
         Console.trace("loading",url);
         this.loader.load(new URLRequest(url));
      }
      
      private function bundleLoaded(e:Event) : void
      {
         var entry:ZipEntry = null;
         var url:String = null;
         var zip:ZipFile = null;
         Console.trace("LocaleLoader.bundleLoaded()");
         this.loader.removeEventListener(Event.COMPLETE,this.bundleLoaded);
         this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.bundleError);
         try
         {
            zip = new ZipFile(this.loader.data);
         }
         catch(er:ZipError)
         {
            mainError(null);
            return;
         }
         for each(entry in zip.entries)
         {
            LocaleManager.setBundle(entry.name,new XML(zip.getInput(entry)));
         }
         this.loader.addEventListener(Event.COMPLETE,this.tipsLoaded);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.tipsError);
         url = Configuration.staticServerURL + HINTS_BASE + this.locale + "/" + HINTS_FILE;
         Console.trace("loading",url);
         this.loader.load(new URLRequest(url));
      }
      
      private function tipsLoaded(e:Event) : void
      {
         this.loader.removeEventListener(Event.COMPLETE,this.tipsLoaded);
         this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.tipsError);
         LocaleManager.setTips(new XML(this.loader.data));
         var ne:Event = new Event(Event.COMPLETE);
         dispatchEvent(ne);
      }
      
      private function bundleError(e:IOErrorEvent) : void
      {
         Console.trace("LocaleLoader.bundleError()",e);
         this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.bundleError);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.mainError);
         var url:String = Configuration.staticServerURL + LOCALE_BASE + LOCALE_FILE;
         Console.trace("loading",url);
         this.loader.load(new URLRequest(url));
      }
      
      private function tipsError(e:IOErrorEvent) : void
      {
         Console.trace("LocaleLoader.tipsError()",e);
         var ne:Event = new Event(Event.COMPLETE);
         dispatchEvent(ne);
      }
      
      private function mainError(e:IOErrorEvent) : void
      {
         Console.trace("LocaleLoader.mainError()",e);
         var ne:Event = new IOErrorEvent(IOErrorEvent.IO_ERROR);
         dispatchEvent(ne);
      }
   }
}

