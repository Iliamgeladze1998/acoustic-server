package soul.view.interaction.arena
{
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.geom.*;
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
   import mx.binding.utils.ChangeWatcher;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import mx.utils.StringUtil;
   import soul.controller.locale.LocaleManager;
   import soul.event.ArenaEvent;
   import soul.event.SimpleUIEvent;
   import soul.model.interaction.arena.ArenaInfo;
   import soul.model.interaction.arena.ArenaModel;
   import soul.model.interaction.arena.ArenaState;
   import soul.model.interaction.arena.ArenaStateData;
   import soul.model.interaction.arena.FightTypeModel;
   import soul.model.system.Configuration;
   import soul.utils.DateUtils;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.CachedImage;
   import soul.view.ui.ComboBox;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.ScrollBase;
   import soul.view.ui.TextArea;
   import soul.view.ui.VBox;
   import soul.view.ui.controls.PopupManager;
   
   use namespace mx_internal;
   
   public class Arena extends HBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _Arena_BorderedContainer1:BorderedContainer;
      
      public var _Arena_BorderedContainer2:BorderedContainer;
      
      public var _Arena_BorderedContainer3:BorderedContainer;
      
      public var _Arena_BorderedContainer4:BorderedContainer;
      
      public var _Arena_Label1:Label;
      
      public var _Arena_VBox1:VBox;
      
      private var _2137162227aArenas:ComboBox;
      
      private var _1436648296aTypes:ComboBox;
      
      private var _360327771btnMagnify:BorderedContainer;
      
      private var _1842381704btnOperate:Button1;
      
      private var _1453208249cooldownInfo:TextArea;
      
      private var _1724546052description:Label;
      
      private var _158535007mapImage:CachedImage;
      
      private var _65745726scrollBase:ScrollBase;
      
      private var _104069929model:ArenaModel;
      
      private var cw:ChangeWatcher;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function Arena()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         bindings = this._Arena_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_arena_ArenaWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return Arena[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 509;
         this.height = 220;
         this.padding = 10;
         this.gap = 6;
         this.children = [this._Arena_BorderedContainer1_i(),this._Arena_BorderedContainer4_i()];
         this.addEventListener("removedFromStage",this.___Arena_HBox1_removedFromStage);
         this.addEventListener("creationComplete",this.___Arena_HBox1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         Arena._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         InteractionWindow.findInteractionParent(this).label = this.getString("arena.title");
         this.model.addEventListener(ArenaEvent.STATE_CHANGED,this.processStateChange);
         this.model.addEventListener(ArenaEvent.TICK,this.cooldownTick);
         this.btnMagnify.addEventListener(MouseEvent.CLICK,this.showMapInfo);
         this.btnOperate.addEventListener(MouseEvent.CLICK,this.processOperationClick);
         this.processStateChange(null);
         this.cooldownTick(null);
         this.showDescription();
      }
      
      private function remove() : void
      {
         this.model.removeEventListener(ArenaEvent.STATE_CHANGED,this.processStateChange);
         this.model.removeEventListener(ArenaEvent.TICK,this.cooldownTick);
         this.btnMagnify.removeEventListener(MouseEvent.CLICK,this.showMapInfo);
         this.btnOperate.removeEventListener(MouseEvent.CLICK,this.processOperationClick);
      }
      
      private function processOperationClick(e:Event) : void
      {
         var ae:ArenaEvent = null;
         if(this.model.state == null)
         {
            if(this.aArenas.selectedIndex < 1)
            {
               if(this.aTypes.selectedIndex < 0)
               {
                  return;
               }
               ae = new ArenaEvent(ArenaEvent.CREATE_FIGHT_TYPE_CLAIM);
               ae.data = this.aTypes.selectedItem.fightType;
            }
            else
            {
               ae = new ArenaEvent(ArenaEvent.CREATE_ARENA_CLAIM);
               ae.data = this.aArenas.selectedItem.id;
            }
         }
         else
         {
            ae = new ArenaEvent(ArenaEvent.CANCEL);
         }
         this.model.dispatchEvent(ae);
      }
      
      private function processStateChange(e:Event) : void
      {
         var ft:FightTypeModel = null;
         var ai:ArenaInfo = null;
         var value:ArenaStateData = this.model.state;
         if(!value)
         {
            this.init();
            return;
         }
         var index:int = -1;
         var i:int = -1;
         for each(ft in this.model.fightTypes)
         {
            i++;
            if(ft.fightType == value.fightType)
            {
               index = i;
               break;
            }
         }
         this.aTypes.selectedIndex = index;
         this.aTypes.enabled = false;
         index = -1;
         i = -1;
         for each(ai in this.model.arenas[value.fightType])
         {
            i++;
            if(ai.id == value.arenaId)
            {
               index = i;
               break;
            }
         }
         this.aArenas.selectedIndex = index;
         this.aArenas.enabled = false;
         switch(value.arenaState)
         {
            case ArenaState.ACCEPTED:
            case ArenaState.INVITED:
               this.btnOperate.label = this.getString("cancelClaim.label");
               break;
            case ArenaState.CLEANUP:
               this.btnOperate.label = this.getString("exitFight.label");
               break;
            case ArenaState.COOLDOWN:
            case ArenaState.NONE:
               this.btnOperate.label = this.getString("createClaim.label");
               break;
            default:
               this.btnOperate.label = this.getString("cancelFight.label");
         }
         this.showCooldownInfo();
      }
      
      private function cooldownTick(e:Event) : void
      {
         if(this.model.cooldown > 0)
         {
            this.cooldownInfo.htmlText = StringUtil.substitute(this.getString("arena.cooldownLeft"),DateUtils.getTimeLeft(this.model.cooldown));
            this.btnOperate.enabled = false;
         }
         else
         {
            this.showCooldownInfo();
            this.btnOperate.enabled = this.model.state == null || this.model.state.arenaState != ArenaState.COOLDOWN;
         }
      }
      
      private function showCooldownInfo() : void
      {
         this.cooldownInfo.htmlText = StringUtil.substitute(this.getString("arena.cooldownInfo"),DateUtils.getTimeLeft(this.model.losingCooldown));
      }
      
      private function init() : void
      {
         if(this.aTypes.dataProvider.length > 0)
         {
            this.aTypes.selectedIndex = 0;
         }
         this.aTypes.enabled = true;
         this.aArenas.selectedIndex = -1;
         this.aArenas.enabled = true;
         this.btnOperate.label = this.getString("createClaim.label");
         this.btnOperate.enabled = true;
         this.showCooldownInfo();
      }
      
      private function getDescription(typeIndex:int, arenaIndex:int) : String
      {
         var info:ArenaInfo = null;
         var ft:FightTypeModel = this.model.fightTypes[typeIndex];
         if(!ft)
         {
            return "";
         }
         if(arenaIndex > 0)
         {
            info = this.model.arenas[ft.fightType][arenaIndex];
            return info.description;
         }
         return ft.description;
      }
      
      private function showDescription() : void
      {
         var str:String = this.getDescription(this.aTypes.selectedIndex,this.aArenas.selectedIndex);
         this.description.htmlText = str;
      }
      
      private function showMapInfo(e:Event) : void
      {
         var mapInfo:MapInfoPopup = new MapInfoPopup();
         mapInfo.arenaInfo = ArenaInfo(this.aArenas.selectedItem);
         PopupManager.addPopup(mapInfo,null,true);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString("interface",key);
      }
      
      private function _Arena_BorderedContainer1_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.width = 245;
         _loc1_.percentHeight = 100;
         _loc1_.padding = 10;
         _loc1_.horizontalAlign = "center";
         _loc1_.gap = 10;
         _loc1_.direction = "vertical";
         _loc1_.children = [this._Arena_BorderedContainer2_i(),this._Arena_ComboBox1_i(),this._Arena_ComboBox2_i(),this._Arena_BorderedContainer3_i(),this._Arena_Button11_i()];
         this._Arena_BorderedContainer1 = _loc1_;
         BindingManager.executeBindings(this,"_Arena_BorderedContainer1",this._Arena_BorderedContainer1);
         return _loc1_;
      }
      
      private function _Arena_BorderedContainer2_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.percentWidth = 100;
         _loc1_.height = 27;
         _loc1_.backgroundColor = 1;
         _loc1_.backgroundPadding = 2;
         _loc1_.horizontalAlign = "center";
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._Arena_Label1_i()];
         this._Arena_BorderedContainer2 = _loc1_;
         BindingManager.executeBindings(this,"_Arena_BorderedContainer2",this._Arena_BorderedContainer2);
         return _loc1_;
      }
      
      private function _Arena_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         this._Arena_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_Arena_Label1",this._Arena_Label1);
         return _loc1_;
      }
      
      private function _Arena_ComboBox1_i() : ComboBox
      {
         var _loc1_:ComboBox = new ComboBox();
         _loc1_.width = 187;
         _loc1_.height = 21;
         _loc1_.selectedIndex = -1;
         _loc1_.labelField = "label";
         _loc1_.addEventListener("change",this.__aTypes_change);
         this.aTypes = _loc1_;
         BindingManager.executeBindings(this,"aTypes",this.aTypes);
         return _loc1_;
      }
      
      public function __aTypes_change(event:Event) : void
      {
         this.showDescription();
      }
      
      private function _Arena_ComboBox2_i() : ComboBox
      {
         var _loc1_:ComboBox = new ComboBox();
         _loc1_.width = 187;
         _loc1_.height = 21;
         _loc1_.selectedIndex = -1;
         _loc1_.labelField = "mapName";
         _loc1_.addEventListener("change",this.__aArenas_change);
         this.aArenas = _loc1_;
         BindingManager.executeBindings(this,"aArenas",this.aArenas);
         return _loc1_;
      }
      
      public function __aArenas_change(event:Event) : void
      {
         this.showDescription();
      }
      
      private function _Arena_BorderedContainer3_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.percentWidth = 100;
         _loc1_.height = 45;
         _loc1_.backgroundColor = 1;
         _loc1_.backgroundPadding = 2;
         _loc1_.horizontalAlign = "center";
         _loc1_.padding = 4;
         _loc1_.children = [this._Arena_TextArea1_i()];
         this._Arena_BorderedContainer3 = _loc1_;
         BindingManager.executeBindings(this,"_Arena_BorderedContainer3",this._Arena_BorderedContainer3);
         return _loc1_;
      }
      
      private function _Arena_TextArea1_i() : TextArea
      {
         var _loc1_:TextArea = new TextArea();
         _loc1_.editable = false;
         _loc1_.selectable = false;
         _loc1_.align = "center";
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.wordWrap = true;
         _loc1_.multiline = true;
         this.cooldownInfo = _loc1_;
         BindingManager.executeBindings(this,"cooldownInfo",this.cooldownInfo);
         return _loc1_;
      }
      
      private function _Arena_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.padding = 5;
         _loc1_.enabled = false;
         this.btnOperate = _loc1_;
         BindingManager.executeBindings(this,"btnOperate",this.btnOperate);
         return _loc1_;
      }
      
      private function _Arena_BorderedContainer4_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.horizontalAlign = "left";
         _loc1_.backgroundColor = 1;
         _loc1_.backgroundPadding = 2;
         _loc1_.padding = 6;
         _loc1_.children = [this._Arena_ScrollBase1_i()];
         this._Arena_BorderedContainer4 = _loc1_;
         BindingManager.executeBindings(this,"_Arena_BorderedContainer4",this._Arena_BorderedContainer4);
         return _loc1_;
      }
      
      private function _Arena_ScrollBase1_i() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.verticalScrollPolicy = "auto";
         _loc1_.children = [this._Arena_VBox1_i()];
         this.scrollBase = _loc1_;
         BindingManager.executeBindings(this,"scrollBase",this.scrollBase);
         return _loc1_;
      }
      
      private function _Arena_VBox1_i() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.gap = 0;
         _loc1_.horizontalAlign = "center";
         _loc1_.children = [this._Arena_BorderedContainer5_i(),this._Arena_Label2_i()];
         this._Arena_VBox1 = _loc1_;
         BindingManager.executeBindings(this,"_Arena_VBox1",this._Arena_VBox1);
         return _loc1_;
      }
      
      private function _Arena_BorderedContainer5_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.padding = 4;
         _loc1_.children = [this._Arena_CachedImage1_i()];
         this.btnMagnify = _loc1_;
         BindingManager.executeBindings(this,"btnMagnify",this.btnMagnify);
         return _loc1_;
      }
      
      private function _Arena_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this.mapImage = _loc1_;
         BindingManager.executeBindings(this,"mapImage",this.mapImage);
         return _loc1_;
      }
      
      private function _Arena_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.multiline = true;
         _loc1_.wordWrap = true;
         this.description = _loc1_;
         BindingManager.executeBindings(this,"description",this.description);
         return _loc1_;
      }
      
      public function ___Arena_HBox1_removedFromStage(event:Event) : void
      {
         this.remove();
      }
      
      public function ___Arena_HBox1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _Arena_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return Assets.dialogPattern2;
         },null,"_Arena_BorderedContainer1.backgroundImage");
         result[1] = new Binding(this,function():Object
         {
            return Assets.simpleBorder;
         },null,"_Arena_BorderedContainer1.borderSkin");
         result[2] = new Binding(this,function():Object
         {
            return Assets.serifeBorder;
         },null,"_Arena_BorderedContainer2.borderSkin");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = getString("arena.chooseFightOptions");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_Arena_Label1.text");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = getString("arena.fightTypes");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"aTypes.prompt");
         result[5] = new Binding(this,function():Array
         {
            var _loc1_:* = model.fightTypes;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"aTypes.dataProvider");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = getString("arena.arenas");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"aArenas.prompt");
         result[7] = new Binding(this,function():Array
         {
            var _loc1_:* = model.arenas[aTypes.selectedItem.fightType];
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"aArenas.dataProvider");
         result[8] = new Binding(this,function():Object
         {
            return Assets.serifeBorder;
         },null,"_Arena_BorderedContainer3.borderSkin");
         result[9] = new Binding(this,function():Object
         {
            return Assets.serifeBorder;
         },null,"_Arena_BorderedContainer4.borderSkin");
         result[10] = new Binding(this,function():Number
         {
            return scrollBase.width;
         },null,"_Arena_VBox1.width");
         result[11] = new Binding(this,function():Number
         {
            return aArenas.selectedIndex > 0 ? 1 : 0;
         },null,"btnMagnify.scaleY");
         result[12] = new Binding(this,function():Object
         {
            return Assets.tooltipBorder;
         },null,"btnMagnify.borderSkin");
         result[13] = new Binding(this,function():Object
         {
            return Configuration.getArenaMapUrl(ArenaInfo(aArenas.selectedItem));
         },null,"mapImage.source");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get aArenas() : ComboBox
      {
         return this._2137162227aArenas;
      }
      
      public function set aArenas(param1:ComboBox) : void
      {
         var _loc2_:Object = this._2137162227aArenas;
         if(_loc2_ !== param1)
         {
            this._2137162227aArenas = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"aArenas",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get aTypes() : ComboBox
      {
         return this._1436648296aTypes;
      }
      
      public function set aTypes(param1:ComboBox) : void
      {
         var _loc2_:Object = this._1436648296aTypes;
         if(_loc2_ !== param1)
         {
            this._1436648296aTypes = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"aTypes",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get btnMagnify() : BorderedContainer
      {
         return this._360327771btnMagnify;
      }
      
      public function set btnMagnify(param1:BorderedContainer) : void
      {
         var _loc2_:Object = this._360327771btnMagnify;
         if(_loc2_ !== param1)
         {
            this._360327771btnMagnify = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"btnMagnify",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get btnOperate() : Button1
      {
         return this._1842381704btnOperate;
      }
      
      public function set btnOperate(param1:Button1) : void
      {
         var _loc2_:Object = this._1842381704btnOperate;
         if(_loc2_ !== param1)
         {
            this._1842381704btnOperate = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"btnOperate",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get cooldownInfo() : TextArea
      {
         return this._1453208249cooldownInfo;
      }
      
      public function set cooldownInfo(param1:TextArea) : void
      {
         var _loc2_:Object = this._1453208249cooldownInfo;
         if(_loc2_ !== param1)
         {
            this._1453208249cooldownInfo = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cooldownInfo",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get description() : Label
      {
         return this._1724546052description;
      }
      
      public function set description(param1:Label) : void
      {
         var _loc2_:Object = this._1724546052description;
         if(_loc2_ !== param1)
         {
            this._1724546052description = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"description",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mapImage() : CachedImage
      {
         return this._158535007mapImage;
      }
      
      public function set mapImage(param1:CachedImage) : void
      {
         var _loc2_:Object = this._158535007mapImage;
         if(_loc2_ !== param1)
         {
            this._158535007mapImage = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapImage",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get scrollBase() : ScrollBase
      {
         return this._65745726scrollBase;
      }
      
      public function set scrollBase(param1:ScrollBase) : void
      {
         var _loc2_:Object = this._65745726scrollBase;
         if(_loc2_ !== param1)
         {
            this._65745726scrollBase = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"scrollBase",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get model() : ArenaModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:ArenaModel) : void
      {
         var _loc2_:Object = this._104069929model;
         if(_loc2_ !== param1)
         {
            this._104069929model = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"model",_loc2_,param1));
            }
         }
      }
   }
}

