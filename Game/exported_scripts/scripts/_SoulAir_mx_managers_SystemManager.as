package
{
   import flash.display.LoaderInfo;
   import flash.system.ApplicationDomain;
   import flash.system.Security;
   import flash.utils.Dictionary;
   import flashx.textLayout.compose.ISWFContext;
   import mx.core.EmbeddedFontRegistry;
   import mx.core.IFlexModule;
   import mx.core.IFlexModuleFactory;
   import mx.core.Singleton;
   import mx.events.RSLEvent;
   import mx.managers.SystemManager;
   import mx.preloaders.SparkDownloadProgressBar;
   
   public class _SoulAir_mx_managers_SystemManager extends SystemManager implements IFlexModuleFactory, ISWFContext
   {
      
      private var _info:Object;
      
      private var _preloadedRSLs:Dictionary;
      
      private var _allowDomainParameters:Vector.<Array>;
      
      private var _allowInsecureDomainParameters:Vector.<Array>;
      
      public function _SoulAir_mx_managers_SystemManager()
      {
         super();
      }
      
      override public function callInContext(fn:Function, thisArg:Object, argArray:Array, returns:Boolean = true) : *
      {
         if(returns)
         {
            return fn.apply(thisArg,argArray);
         }
         fn.apply(thisArg,argArray);
      }
      
      override public function create(... params) : Object
      {
         if(params.length > 0 && !(params[0] is String))
         {
            return super.create.apply(this,params);
         }
         var mainClassName:String = params.length == 0 ? "SoulAir" : String(params[0]);
         var mainClass:Class = Class(getDefinitionByName(mainClassName));
         if(!mainClass)
         {
            return null;
         }
         var instance:Object = new mainClass();
         if(instance is IFlexModule)
         {
            IFlexModule(instance).moduleFactory = this;
         }
         if(params.length == 0)
         {
            Singleton.registerClass("mx.core::IEmbeddedFontRegistry",Class(getDefinitionByName("mx.core::EmbeddedFontRegistry")));
            EmbeddedFontRegistry.registerFonts(this.info()["fonts"],this);
         }
         return instance;
      }
      
      override public function info() : Object
      {
         if(!this._info)
         {
            this._info = {
               "applicationComplete":"creationComplete()",
               "backgroundFrameRate":"24",
               "compiledLocales":["en_US"],
               "compiledResourceBundleNames":["collections","components","containers","controls","core","effects","layout","skins","styles"],
               "currentDomain":ApplicationDomain.currentDomain,
               "fonts":{"MyVerdana":{
                  "regular":true,
                  "bold":true,
                  "italic":true,
                  "boldItalic":true
               }},
               "frameRate":"60",
               "height":"600",
               "mainClassName":"SoulAir",
               "minHeight":"600",
               "minWidth":"1000",
               "mixins":["_SoulAir_FlexInit","_SoulAir_Styles","mx.managers.systemClasses.ActiveWindowManager","mx.messaging.config.LoaderConfig"],
               "preloader":SparkDownloadProgressBar,
               "showStatusBar":"false",
               "width":"1000"
            };
         }
         return this._info;
      }
      
      override public function get preloadedRSLs() : Dictionary
      {
         if(this._preloadedRSLs == null)
         {
            this._preloadedRSLs = new Dictionary(true);
         }
         return this._preloadedRSLs;
      }
      
      override public function allowDomain(... domains) : void
      {
         var loaderInfo:Object = null;
         Security.allowDomain.apply(null,domains);
         for(loaderInfo in this._preloadedRSLs)
         {
            if(Boolean(loaderInfo.content) && "allowDomainInRSL" in loaderInfo.content)
            {
               loaderInfo.content["allowDomainInRSL"].apply(null,domains);
            }
         }
         if(!this._allowDomainParameters)
         {
            this._allowDomainParameters = new Vector.<Array>();
         }
         this._allowDomainParameters.push(domains);
         addEventListener(RSLEvent.RSL_ADD_PRELOADED,this.addPreloadedRSLHandler,false,50);
      }
      
      override public function allowInsecureDomain(... domains) : void
      {
         var loaderInfo:Object = null;
         Security.allowInsecureDomain.apply(null,domains);
         for(loaderInfo in this._preloadedRSLs)
         {
            if(Boolean(loaderInfo.content) && "allowInsecureDomainInRSL" in loaderInfo.content)
            {
               loaderInfo.content["allowInsecureDomainInRSL"].apply(null,domains);
            }
         }
         if(!this._allowInsecureDomainParameters)
         {
            this._allowInsecureDomainParameters = new Vector.<Array>();
         }
         this._allowInsecureDomainParameters.push(domains);
         addEventListener(RSLEvent.RSL_ADD_PRELOADED,this.addPreloadedRSLHandler,false,50);
      }
      
      private function addPreloadedRSLHandler(event:RSLEvent) : void
      {
         var domains:Array = null;
         var loaderInfo:LoaderInfo = event.loaderInfo;
         if(!loaderInfo || !loaderInfo.content)
         {
            return;
         }
         if(allowDomainsInNewRSLs && Boolean(this._allowDomainParameters))
         {
            for each(domains in this._allowDomainParameters)
            {
               if("allowDomainInRSL" in loaderInfo.content)
               {
                  loaderInfo.content["allowDomainInRSL"].apply(null,domains);
               }
            }
         }
         if(allowInsecureDomainsInNewRSLs && Boolean(this._allowInsecureDomainParameters))
         {
            for each(domains in this._allowInsecureDomainParameters)
            {
               if("allowInsecureDomainInRSL" in loaderInfo.content)
               {
                  loaderInfo.content["allowInsecureDomainInRSL"].apply(null,domains);
               }
            }
         }
      }
   }
}

