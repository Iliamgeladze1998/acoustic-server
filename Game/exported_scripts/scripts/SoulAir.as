package
{
   import air.update.ApplicationUpdaterUI;
   import air.update.events.DownloadErrorEvent;
   import air.update.events.StatusFileUpdateEvent;
   import air.update.events.StatusUpdateErrorEvent;
   import air.update.events.StatusUpdateEvent;
   import air.update.events.UpdateEvent;
   import flash.accessibility.*;
   import flash.data.*;
   import flash.debugger.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filesystem.*;
   import flash.geom.*;
   import flash.html.*;
   import flash.html.script.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import mx.binding.*;
   import mx.controls.Alert;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.CloseEvent;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.managers.ToolTipManager;
   import mx.styles.*;
   import soul.controller.GameManager;
   import soul.controller.LogManager;
   import soul.controller.loading.LoadingManager;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleLoader;
   import soul.controller.locale.LocaleManager;
   import soul.controller.shortcut.ShortcutManager;
   import soul.event.GameEvent;
   import soul.model.system.Configuration;
   import soul.model.system.GameCfg;
   import soul.net.ServerLayer;
   import soul.styles.StyleManager;
   import soul.utils.RemoteClassRegister;
   import soul.view.AlertStyleProxy;
   import soul.view.assets.Assets;
   import soul.view.assets.Styles;
   import soul.view.common.BigMessage;
   import soul.view.console.Console;
   import soul.view.toolTip.TextToolTip;
   import soul.view.toolTip.ToolTipManager;
   import soul.view.ui.Canvas;
   import soul.view.ui.UIAssets;
   import soul.view.ui.controls.PopupManager;
   import soulex.GameConfig;
   import soulex.controller.AirLocale;
   import soulex.controller.GameContent;
   import soulex.controller.LoginManager;
   import soulex.event.ContentEvent;
   import soulex.event.LoginEvent;
   import soulex.view.LoginBackground;
   import soulex.view.UpdateScreen;
   import soulex.view.skin.InputSkin;
   import spark.components.WindowedApplication;
   
   use namespace mx_internal;
   
   [Frame(factoryClass="_SoulAir_mx_managers_SystemManager")]
   [Frame(extraClass="_SoulAir_FlexInit")]
   [SWF(frameRate="60",height="600",width="1000")]
   public class SoulAir extends WindowedApplication implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static var _skinParts:Object = {
         "gripper":false,
         "contentGroup":false,
         "statusBar":false,
         "statusText":false,
         "controlBarGroup":false,
         "titleBar":false
      };
      
      Assets.customFont;
      
      private var _410956671container:Canvas;
      
      private var _3732ui:UIComponent;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var updater:ApplicationUpdaterUI;
      
      private var gameContent:GameContent;
      
      private var localeLoader:LocaleLoader;
      
      private var loginManager:LoginManager;
      
      private var gameManager:GameManager;
      
      private var loginBackground:LoginBackground;
      
      private var updateScreen:UpdateScreen;
      
      private var localeNotLoaded:Boolean;
      
      private var debugServer:String;
      
      private var debugUser:String;
      
      mx_internal var _SoulAir_StylesInit_done:Boolean = false;
      
      private var _embed_css____images_airSkin_swf_selButtonOver_1732830652_selButtonOver_403991183:Class;
      
      private var _embed_css____images_btn_disabled_png_1111104921_1855881536:Class;
      
      private var _embed_css____images_btn_over_png_1424061681_2081701816:Class;
      
      private var _embed_css____images_combobox_wide_png_1925567505_1532825542:Class;
      
      private var _embed_css____images_airSkin_swf_selButton_1732830652_selButton_1819611531:Class;
      
      private var _embed_css____images_combobox_png_738712215_1572603454:Class;
      
      private var _embed_css____images_btn_active_png__109175389_1864786074:Class;
      
      private var _embed_css____images_airSkin_swf_selButtonDisabled_1732830652_selButtonDisabled_1722522841:Class;
      
      private var _embed_css____images_airSkin_swf_selButtonSelected_1732830652_selButtonSelected_1647622998:Class;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function SoulAir()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this.updater = new ApplicationUpdaterUI();
         this.localeLoader = new LocaleLoader();
         this._embed_css____images_airSkin_swf_selButtonOver_1732830652_selButtonOver_403991183 = _class_embed_css____images_airSkin_swf_selButtonOver_1732830652_selButtonOver_403991183;
         this._embed_css____images_btn_disabled_png_1111104921_1855881536 = _class_embed_css____images_btn_disabled_png_1111104921_1855881536;
         this._embed_css____images_btn_over_png_1424061681_2081701816 = _class_embed_css____images_btn_over_png_1424061681_2081701816;
         this._embed_css____images_combobox_wide_png_1925567505_1532825542 = _class_embed_css____images_combobox_wide_png_1925567505_1532825542;
         this._embed_css____images_airSkin_swf_selButton_1732830652_selButton_1819611531 = _class_embed_css____images_airSkin_swf_selButton_1732830652_selButton_1819611531;
         this._embed_css____images_combobox_png_738712215_1572603454 = _class_embed_css____images_combobox_png_738712215_1572603454;
         this._embed_css____images_btn_active_png__109175389_1864786074 = _class_embed_css____images_btn_active_png__109175389_1864786074;
         this._embed_css____images_airSkin_swf_selButtonDisabled_1732830652_selButtonDisabled_1722522841 = _class_embed_css____images_airSkin_swf_selButtonDisabled_1732830652_selButtonDisabled_1722522841;
         this._embed_css____images_airSkin_swf_selButtonSelected_1732830652_selButtonSelected_1647622998 = _class_embed_css____images_airSkin_swf_selButtonSelected_1732830652_selButtonSelected_1647622998;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         bindings = this._SoulAir_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_SoulAirWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return SoulAir[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 1000;
         this.height = 600;
         this.showStatusBar = false;
         this.backgroundFrameRate = 24;
         this.minWidth = 1000;
         this.minHeight = 600;
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._SoulAir_Array1_c);
         this._SoulAir_Canvas1_i();
         this.addEventListener("applicationComplete",this.___SoulAir_WindowedApplication1_applicationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         SoulAir._watcherSetupUtil = param1;
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         super.moduleFactory = param1;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
         mx_internal::_SoulAir_StylesInit();
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      private function creationComplete() : void
      {
         stage.quality = StageQuality.MEDIUM;
         this.ui.addChild(this.container);
         RemoteClassRegister.register();
         ShortcutManager.init(systemManager.stage);
         LoadingManager.init(systemManager.stage);
         BigMessage.init(systemManager.stage);
         PopupManager.init(systemManager.stage);
         ToolTipManager.hideDelay = Infinity;
         ToolTipManager.toolTipClass = TextToolTip;
         StyleManager.defaultManager.load(Styles.soulStyle);
         addEventListener(Event.CLOSING,this.onClose);
         var descr:XML = nativeApplication.applicationDescriptor;
         var ns:Namespace = descr.namespace();
         GameConfig.version = descr.ns::versionNumber;
         Console.trace("Starting SoulAir, version:" + GameConfig.version);
         if(Boolean(GameConfig.lastWidth))
         {
            width = GameConfig.lastWidth;
            height = GameConfig.lastHeight;
         }
         if(GameConfig.maximized)
         {
            maximize();
         }
         var css:CSSStyleDeclaration = styleManager.getStyleDeclaration("mx.controls.scrollClasses.ScrollBar");
         css.setStyle("upArrowUpSkin",UIAssets.scrollButtonUp);
         css.setStyle("upArrowOverSkin",UIAssets.scrollButtonUp);
         css.setStyle("upArrowDownSkin",UIAssets.scrollButtonUp);
         css.setStyle("upArrowDisabledSkin",UIAssets.scrollButtonUp);
         css.setStyle("downArrowUpSkin",UIAssets.scrollButtonDown);
         css.setStyle("downArrowOverSkin",UIAssets.scrollButtonDown);
         css.setStyle("downArrowDownSkin",UIAssets.scrollButtonDown);
         css.setStyle("downArrowDisabledSkin",UIAssets.scrollButtonDown);
         css.setStyle("trackSkin",UIAssets.scrollTrack);
         css.setStyle("thumbSkin",UIAssets.scrollSlider);
         css = styleManager.getStyleDeclaration("mx.containers.Panel");
         css.setStyle("borderSkin",UIAssets.windowFrame);
         Console.trace("loading soul_config.xml");
         GameConfig.load("soul_config.xml");
         GameConfig.locale = Boolean(GameConfig.lastLocale) ? GameConfig.lastLocale : GameConfig.defaultLocale;
         AirLocale.loadLocale();
         Configuration.portalServerURL = GameConfig.portalServer;
         this.checkForShellUpdate();
      }
      
      private function checkForShellUpdate() : void
      {
         Console.trace("checking shell update: " + GameConfig.updateFile);
         this.updater.updateURL = GameConfig.updateFile;
         this.updater.isDownloadProgressVisible = false;
         this.updater.isDownloadUpdateVisible = false;
         this.updater.isInstallUpdateVisible = false;
         this.updater.isCheckForUpdateVisible = false;
         this.updater.addEventListener(DownloadErrorEvent.DOWNLOAD_ERROR,this.onShellUpdateError);
         this.updater.addEventListener(ErrorEvent.ERROR,this.onShellUpdateError);
         this.updater.addEventListener(StatusUpdateErrorEvent.UPDATE_ERROR,this.onShellUpdateError);
         this.updater.addEventListener(StatusFileUpdateEvent.FILE_UPDATE_STATUS,this.onShellUpdateError);
         this.updater.addEventListener(StatusUpdateEvent.UPDATE_STATUS,this.onShellUpdateStatus);
         this.updater.addEventListener(ProgressEvent.PROGRESS,this.onShellUpdateProgress);
         this.updater.addEventListener(UpdateEvent.INITIALIZED,this.onShellUpdate);
         this.updater.initialize();
      }
      
      private function onShellUpdateError(e:Event) : void
      {
         var text:String = null;
         Console.trace("onShellUpdateError() - update URL: " + GameConfig.updateFile);
         var title:String = "Error";
         if(e is StatusUpdateErrorEvent && StatusUpdateErrorEvent(e).subErrorID == 404)
         {
            text = "Error connecting update site. Please contant game provider.";
         }
         else
         {
            text = "Error update checking.\n\n" + (e.hasOwnProperty("text") ? e["text"] : "");
         }
         text += "\n\nPress OK to exit";
         AlertStyleProxy.show(text,title,4,null,this.applicationExit);
      }
      
      private function onShellUpdateProgress(e:ProgressEvent) : void
      {
         Console.trace("onShellUpdateProgress",e.bytesLoaded / e.bytesTotal);
      }
      
      private function onShellUpdate(e:Event) : void
      {
         Console.trace("onUpdate");
         this.updater.checkNow();
      }
      
      private function onShellUpdateStatus(e:StatusUpdateEvent) : void
      {
         Console.trace("onStatus",e.available);
         if(e.available)
         {
            return;
         }
         this.loginBackground = new LoginBackground();
         this.createInitialScreen();
      }
      
      private function createInitialScreen() : void
      {
         if(Boolean(this.gameManager))
         {
            this.gameManager.reset();
         }
         addElement(this.loginBackground);
         this.gameContent = new GameContent(GameConfig.version);
         this.updateScreen = new UpdateScreen();
         this.loginBackground.addElement(this.updateScreen);
         this.gameContent.addEventListener(ContentEvent.DATA_OK,this.updateComplete);
         this.gameContent.addEventListener(ContentEvent.UPDATE_ERROR,this.updateError);
         this.gameContent.update(this.updateScreen);
      }
      
      private function updateComplete(e:Event) : void
      {
         Configuration.staticServerURL = this.gameContent.getStaticPath();
         this.gameContent = null;
         if(Boolean(this.updateScreen) && this.loginBackground.contains(this.updateScreen))
         {
            this.loginBackground.removeChild(this.updateScreen);
         }
         this.loadLocale();
      }
      
      private function updateError(e:Event) : void
      {
         AlertStyleProxy.show("Error updating game content");
      }
      
      public function loadLocale() : void
      {
         LoadingManager.show();
         LoadingManager.action = "Loading locale";
         this.localeLoader = new LocaleLoader();
         this.localeLoader.addEventListener(Event.COMPLETE,this.localeLoaded);
         this.localeLoader.addEventListener(IOErrorEvent.IO_ERROR,this.localeError);
         this.localeLoader.loadLocale(GameConfig.locale);
      }
      
      private function localeError(e:Event) : void
      {
         trace("SoulClient.localeError()",e);
         this.localeNotLoaded = true;
         this.localeLoaded(null);
      }
      
      private function localeLoaded(e:Event) : void
      {
         trace("SoulClient.localeLoaded()",e);
         this.localeLoader = null;
         LoadingManager.action = "Locale loaded";
         LoadingManager.hide();
         this.createLoginScreen();
      }
      
      private function createLoginScreen() : void
      {
         this.loginManager = new LoginManager(this.loginBackground);
         this.loginManager.addEventListener(LoginEvent.COMPLETE,this.loginComplete);
         this.loginManager.addEventListener(LoginEvent.LOCALE_CHANGED,this.localeChanged);
         this.loginManager.addEventListener(LoginEvent.EXIT,this.exitRequested);
         this.loginManager.createLoginScreen();
      }
      
      private function localeChanged(e:LoginEvent) : void
      {
         this.loginManager.remove();
         GameConfig.lastLocale = GameConfig.locale;
         AirLocale.loadLocale();
         this.loadLocale();
      }
      
      private function exitRequested(e:LoginEvent) : void
      {
         AlertStyleProxy.show(AirLocale.getString("exit.text"),AirLocale.getString("exit.title"),Alert.YES | Alert.NO,null,this.exitAnswer);
      }
      
      private function exitAnswer(e:CloseEvent) : void
      {
         if(Boolean(e.detail & Alert.YES))
         {
            this.applicationExit(null);
         }
      }
      
      private function debugLogin(args:Array) : void
      {
         if(args.length < 2)
         {
            Console.trace("login usage: login {server_ip} {user_id}");
            return;
         }
         Configuration.host = args[0];
         Configuration.token = args[1];
         ServerLayer.reset();
         this.loginComplete(null);
      }
      
      private function loginComplete(e:LoginEvent) : void
      {
         Configuration.locale = GameConfig.locale;
         ServerLayer.init(Configuration.host,this.serverLayerInitialized,this.serverDisconnected);
      }
      
      private function serverLayerInitialized() : void
      {
         LoadingManager.action = LocaleManager.getString(BundleName.SYSTEM,"loadingCharacter");
         LoadingManager.tip = LocaleManager.getRandomTip();
         if(this.localeNotLoaded)
         {
            LogManager.report("Locale could not be loaded");
         }
         ServerLayer.registerCharacter(Configuration.token,this.loginOk,this.loginFailed);
      }
      
      private function loginOk(r:* = null) : void
      {
         LoadingManager.action = LocaleManager.getString(BundleName.SYSTEM,"gettingConfiguration");
         LoadingManager.tip = LocaleManager.getRandomTip();
         ServerLayer.call("configurationService","getGameCfg",this.setGameCfg);
      }
      
      private function loginFailed(r:* = null) : void
      {
         this.gameUserExit(null);
      }
      
      private function setGameCfg(cfg:GameCfg) : void
      {
         Configuration.load(cfg);
         this.createGameScreen();
         LogManager.report("System Information",true);
      }
      
      private function createGameScreen() : void
      {
         if(Boolean(this.loginBackground) && contains(this.loginBackground))
         {
            removeElement(this.loginBackground);
         }
         this.gameManager = new GameManager(this.container);
         this.gameManager.addEventListener(GameEvent.USER_LOGOUT,this.gameUserExit);
      }
      
      private function onClose(e:Event) : void
      {
         if(stage.nativeWindow.displayState == NativeWindowDisplayState.MAXIMIZED)
         {
            GameConfig.maximized = true;
         }
         else
         {
            GameConfig.maximized = false;
            GameConfig.lastWidth = width;
            GameConfig.lastHeight = height;
         }
      }
      
      private function serverDisconnected(e:Event = null) : void
      {
         LoadingManager.hide();
         AlertStyleProxy.show(LocaleManager.getString(BundleName.SYSTEM,"serverFault"),"",4,null,this.gameUserExit);
      }
      
      private function gameUserExit(e:Event) : void
      {
         ServerLayer.reset();
         ShortcutManager.reset();
         this.createInitialScreen();
      }
      
      private function applicationExit(e:Event) : void
      {
         nativeApplication.exit();
      }
      
      private function _SoulAir_Canvas1_i() : Canvas
      {
         var _loc1_:Canvas = new Canvas();
         this.container = _loc1_;
         BindingManager.executeBindings(this,"container",this.container);
         return _loc1_;
      }
      
      private function _SoulAir_Array1_c() : Array
      {
         return [this._SoulAir_UIComponent1_i()];
      }
      
      private function _SoulAir_UIComponent1_i() : UIComponent
      {
         var _loc1_:UIComponent = new UIComponent();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.id = "ui";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.ui = _loc1_;
         BindingManager.executeBindings(this,"ui",this.ui);
         return _loc1_;
      }
      
      public function ___SoulAir_WindowedApplication1_applicationComplete(event:FlexEvent) : void
      {
         this.creationComplete();
      }
      
      private function _SoulAir_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Number
         {
            return ui.width;
         },null,"container.width");
         result[1] = new Binding(this,function():Number
         {
            return ui.height;
         },null,"container.height");
         return result;
      }
      
      mx_internal function _SoulAir_StylesInit() : void
      {
         var style:CSSStyleDeclaration = null;
         var effects:Array = null;
         var conditions:Array = null;
         var condition:CSSCondition = null;
         var selector:CSSSelector = null;
         if(mx_internal::_SoulAir_StylesInit_done)
         {
            return;
         }
         mx_internal::_SoulAir_StylesInit_done = true;
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("mx.controls.ToolTip",conditions,selector);
         style = styleManager.getStyleDeclaration("mx.controls.ToolTip");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingTop = 2;
               this.color = 16777215;
               this.fontFamily = "Tahoma";
               this.fontSize = 12;
               this.paddingBottom = 2;
               this.paddingLeft = 4;
               this.paddingRight = 4;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("soul.view.toolTip.ItemToolTip",conditions,selector);
         style = styleManager.getStyleDeclaration("soul.view.toolTip.ItemToolTip");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingTop = 7;
               this.paddingBottom = 7;
               this.paddingLeft = 5;
               this.paddingRight = 5;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("soul.view.toolTip.AbilityToolTip",conditions,selector);
         style = styleManager.getStyleDeclaration("soul.view.toolTip.AbilityToolTip");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingTop = 5;
               this.verticalGap = -2;
               this.paddingBottom = 7;
               this.paddingLeft = 5;
               this.paddingRight = 5;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("soul.view.toolTip.PartyToolTip",conditions,selector);
         style = styleManager.getStyleDeclaration("soul.view.toolTip.PartyToolTip");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingTop = 5;
               this.verticalGap = -2;
               this.paddingBottom = 7;
               this.paddingLeft = 5;
               this.paddingRight = 5;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","toolTipMainInfo");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".toolTipMainInfo");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalGap = -4;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","toolTipSetInfo");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".toolTipSetInfo");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalGap = -4;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("global",conditions,selector);
         style = styleManager.getStyleDeclaration("global");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.modalTransparency = 0.3;
               this.modalTransparencyBlur = 0;
               this.fontGridFitType = "pixel";
               this.fontAntiAliasType = "advanced";
               this.fontSharpness = 400;
               this.modalTransparencyDuration = 100;
               this.modalTransparencyColor = 0;
               this.fontThickness = 0;
               this.fontFamily = "Verdana";
               this.focusThickness = 0;
               this.fontSize = 11;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","iconButton");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".iconButton");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css____images_airSkin_swf_selButton_1732830652_selButton_1819611531;
               this.fontWeight = false;
               this.selectedDownSkin = _embed_css____images_airSkin_swf_selButtonSelected_1732830652_selButtonSelected_1647622998;
               this.downSkin = _embed_css____images_airSkin_swf_selButtonSelected_1732830652_selButtonSelected_1647622998;
               this.overSkin = _embed_css____images_airSkin_swf_selButtonOver_1732830652_selButtonOver_403991183;
               this.selectedDisabledSkin = _embed_css____images_airSkin_swf_selButtonDisabled_1732830652_selButtonDisabled_1722522841;
               this.color = 12690311;
               this.selectedUpSkin = _embed_css____images_airSkin_swf_selButtonSelected_1732830652_selButtonSelected_1647622998;
               this.fontSize = 11;
               this.disabledSkin = _embed_css____images_airSkin_swf_selButtonDisabled_1732830652_selButtonDisabled_1722522841;
               this.selectedOverSkin = _embed_css____images_airSkin_swf_selButtonOver_1732830652_selButtonOver_403991183;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","formDropdown");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".formDropdown");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderColor = 3611908;
               this.dropShadowVisible = true;
               this.borderThickness = 5;
               this.contentBackgroundColor = 15585444;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.WindowedApplication",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.WindowedApplication");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 0;
               this.padding = 0;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("mx.core.Application",conditions,selector);
         style = styleManager.getStyleDeclaration("mx.core.Application");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 0;
               this.padding = 0;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("mx.controls.Button",conditions,selector);
         style = styleManager.getStyleDeclaration("mx.controls.Button");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css____images_airSkin_swf_selButton_1732830652_selButton_1819611531;
               this.fontWeight = false;
               this.selectedDownSkin = _embed_css____images_airSkin_swf_selButtonSelected_1732830652_selButtonSelected_1647622998;
               this.downSkin = _embed_css____images_airSkin_swf_selButtonSelected_1732830652_selButtonSelected_1647622998;
               this.overSkin = _embed_css____images_airSkin_swf_selButtonOver_1732830652_selButtonOver_403991183;
               this.selectedDisabledSkin = _embed_css____images_airSkin_swf_selButtonDisabled_1732830652_selButtonDisabled_1722522841;
               this.color = 12690311;
               this.selectedUpSkin = _embed_css____images_airSkin_swf_selButtonSelected_1732830652_selButtonSelected_1647622998;
               this.fontSize = 11;
               this.disabledSkin = _embed_css____images_airSkin_swf_selButtonDisabled_1732830652_selButtonDisabled_1722522841;
               this.selectedOverSkin = _embed_css____images_airSkin_swf_selButtonOver_1732830652_selButtonOver_403991183;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","form");
         conditions.push(condition);
         selector = new CSSSelector("mx.controls.Button",conditions,selector);
         style = styleManager.getStyleDeclaration("mx.controls.Button.form");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css____images_btn_active_png__109175389_1864786074;
               this.downSkin = _embed_css____images_btn_active_png__109175389_1864786074;
               this.overSkin = _embed_css____images_btn_over_png_1424061681_2081701816;
               this.color = 12690311;
               this.textRollOverColor = 12690311;
               this.fontSize = 13;
               this.disabledSkin = _embed_css____images_btn_disabled_png_1111104921_1855881536;
               this.textSelectedColor = 12690311;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("mx.containers.Panel",conditions,selector);
         style = styleManager.getStyleDeclaration("mx.containers.Panel");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 5124118;
               this.color = 10253648;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","form");
         conditions.push(condition);
         selector = new CSSSelector("mx.controls.Label",conditions,selector);
         style = styleManager.getStyleDeclaration("mx.controls.Label.form");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "bold";
               this.color = 3611908;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","splitter");
         conditions.push(condition);
         selector = new CSSSelector("mx.containers.Canvas",conditions,selector);
         style = styleManager.getStyleDeclaration("mx.containers.Canvas.splitter");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 3611908;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","form");
         conditions.push(condition);
         selector = new CSSSelector("mx.controls.TextInput",conditions,selector);
         style = styleManager.getStyleDeclaration("mx.controls.TextInput.form");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 0;
               this.borderSkin = InputSkin;
               this.textAlign = "center";
               this.fontSize = 11;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","form");
         conditions.push(condition);
         selector = new CSSSelector("mx.controls.ComboBox",conditions,selector);
         style = styleManager.getStyleDeclaration("mx.controls.ComboBox.form");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css____images_combobox_png_738712215_1572603454;
               this.fontWeight = "bold";
               this.downSkin = _embed_css____images_combobox_png_738712215_1572603454;
               this.overSkin = _embed_css____images_combobox_png_738712215_1572603454;
               this.focusColor = 255;
               this.color = 3611908;
               this.rollOverColor = 13941395;
               this.textAlign = "center";
               this.dropDownStyleName = "formDropdown";
               this.fontSize = 11;
               this.disabledSkin = _embed_css____images_combobox_png_738712215_1572603454;
               this.selectionColor = 15585444;
               this.paddingLeft = 30;
               this.paddingRight = 40;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","form");
         conditions.push(condition);
         condition = new CSSCondition("id","serverList");
         conditions.push(condition);
         selector = new CSSSelector("mx.controls.ComboBox",conditions,selector);
         style = styleManager.getStyleDeclaration("mx.controls.ComboBox.form#serverList");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css____images_combobox_wide_png_1925567505_1532825542;
               this.downSkin = _embed_css____images_combobox_wide_png_1925567505_1532825542;
               this.overSkin = _embed_css____images_combobox_wide_png_1925567505_1532825542;
               this.disabledSkin = _embed_css____images_combobox_wide_png_1925567505_1532825542;
            };
         }
         styleManager.initProtoChainRoots();
      }
      
      [Bindable(event="propertyChange")]
      public function get container() : Canvas
      {
         return this._410956671container;
      }
      
      public function set container(param1:Canvas) : void
      {
         var _loc2_:Object = this._410956671container;
         if(_loc2_ !== param1)
         {
            this._410956671container = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"container",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ui() : UIComponent
      {
         return this._3732ui;
      }
      
      public function set ui(param1:UIComponent) : void
      {
         var _loc2_:Object = this._3732ui;
         if(_loc2_ !== param1)
         {
            this._3732ui = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ui",_loc2_,param1));
            }
         }
      }
   }
}

