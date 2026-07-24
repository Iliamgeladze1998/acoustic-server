package soul.view.interaction.clan
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
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import mx.utils.StringUtil;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.event.ClanEvent;
   import soul.model.character.CharacterModel;
   import soul.model.interaction.clan.ClanCreationData;
   import soul.model.interaction.clan.ClanModel;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientBox;
   import soul.view.chat.ClanIcon;
   import soul.view.common.CurrencyType;
   import soul.view.common.Icons;
   import soul.view.common.MoneyRenderer;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.Box;
   import soul.view.ui.Container;
   import soul.view.ui.Input;
   import soul.view.ui.Label;
   import soul.view.ui.ScrollBase;
   import soul.view.ui.controls.Alert;
   
   use namespace mx_internal;
   
   public class ClanManage extends Container implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const iconWidth:uint = 15;
      
      private static const maxFileSize:uint = 5000;
      
      public var _ClanManage_BorderedContainer1:BorderedContainer;
      
      public var _ClanManage_BorderedContainer2:BorderedContainer;
      
      public var _ClanManage_Button11:Button1;
      
      public var _ClanManage_Button12:Button1;
      
      public var _ClanManage_Button13:Button1;
      
      public var _ClanManage_Label1:Label;
      
      public var _ClanManage_Label2:Label;
      
      public var _ClanManage_Label3:Label;
      
      public var _ClanManage_Label4:Label;
      
      public var _ClanManage_MoneyRenderer1:MoneyRenderer;
      
      private var _686569455clanIcon:ClanIcon;
      
      private var _686716417clanName:Input;
      
      private var _104069929model:ClanModel;
      
      private var _340320640characterModel:CharacterModel;
      
      private var _878580099imageFits:Boolean;
      
      private var imageBytes:ByteArray;
      
      private var fr:FileReference;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ClanManage()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this.fr = new FileReference();
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         bindings = this._ClanManage_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_clan_ClanManageWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return ClanManage[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.children = [this._ClanManage_BorderedContainer1_i(),this._ClanManage_Container2_c(),this._ClanManage_Container3_c(),this._ClanManage_Container4_c()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ClanManage._watcherSetupUtil = param1;
      }
      
      private function browse() : void
      {
         this.fr.addEventListener(Event.SELECT,this.selected);
         this.fr.addEventListener(IOErrorEvent.IO_ERROR,this.loaderError);
         this.fr.browse();
      }
      
      private function selected(e:Event) : void
      {
         this.fr.removeEventListener(Event.SELECT,this.selected);
         this.fr.removeEventListener(IOErrorEvent.IO_ERROR,this.loaderError);
         trace("selected",e.target,this.fr.name);
         this.fr.addEventListener(Event.COMPLETE,this.fileLoaded);
         this.fr.load();
      }
      
      private function fileLoaded(e:Event) : void
      {
         this.fr.removeEventListener(Event.COMPLETE,this.fileLoaded);
         trace("file loaded",e.target);
         var loader:Loader = new Loader();
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loaderComplete);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.loaderError);
         if(this.fr.data.length > maxFileSize)
         {
            Alert.show(StringUtil.substitute(this.getString("clan.create.fileSizeExceedsInfo"),maxFileSize));
         }
         else if(this.fr.data.length < 1)
         {
            this.loaderError(null);
         }
         else
         {
            loader.loadBytes(this.fr.data);
         }
      }
      
      private function loaderComplete(e:Event) : void
      {
         trace("loader loaded",e.target);
         var loaderInfo:LoaderInfo = e.target as LoaderInfo;
         var bd:BitmapData = Bitmap(loaderInfo.content).bitmapData;
         this.imageBytes = bd.getPixels(bd.rect);
         if(!bd)
         {
            this.loaderError(null);
            return;
         }
         if(bd.width == iconWidth && bd.height == iconWidth)
         {
            this.clanIcon.bitmapData = bd;
            this.imageFits = true;
         }
         else
         {
            Alert.show(StringUtil.substitute(this.getString("clan.create.imageSizeInfo"),iconWidth,iconWidth));
         }
      }
      
      private function loaderError(e:IOErrorEvent) : void
      {
         Alert.show(this.getString("clan.create.errorLoadingImage"));
      }
      
      private function create() : void
      {
         var data:ClanCreationData = new ClanCreationData();
         data.name = this.clanName.text;
         data.image = this.imageBytes;
         var ne:ClanEvent = new ClanEvent(ClanEvent.CREATE_CLAN);
         ne.data = data;
         this.model.dispatchEvent(ne);
      }
      
      private function change() : void
      {
         var data:ClanCreationData = new ClanCreationData();
         data.name = this.clanName.text;
         data.image = this.imageFits ? this.imageBytes : null;
         var ne:ClanEvent = new ClanEvent(ClanEvent.CHANGE_CLAN);
         ne.data = data;
         this.model.dispatchEvent(ne);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _ClanManage_BorderedContainer1_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.backgroundPadding = 1;
         _loc1_.width = 437;
         _loc1_.height = 188;
         _loc1_.padding = 3;
         _loc1_.children = [this._ClanManage_ScrollBase1_c()];
         this._ClanManage_BorderedContainer1 = _loc1_;
         BindingManager.executeBindings(this,"_ClanManage_BorderedContainer1",this._ClanManage_BorderedContainer1);
         return _loc1_;
      }
      
      private function _ClanManage_ScrollBase1_c() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.horizontalScrollPolicy = "off";
         _loc1_.verticalScrollPolicy = "on";
         _loc1_.children = [this._ClanManage_Label1_i()];
         return _loc1_;
      }
      
      private function _ClanManage_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.multiline = true;
         _loc1_.wordWrap = true;
         _loc1_.width = 405;
         this._ClanManage_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_ClanManage_Label1",this._ClanManage_Label1);
         return _loc1_;
      }
      
      private function _ClanManage_Container2_c() : Container
      {
         var _loc1_:Container = new Container();
         _loc1_.y = 200;
         _loc1_.children = [this._ClanManage_GradientBox1_c(),this._ClanManage_Box1_c()];
         return _loc1_;
      }
      
      private function _ClanManage_GradientBox1_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.width = 436;
         _loc1_.height = 24;
         return _loc1_;
      }
      
      private function _ClanManage_Box1_c() : Box
      {
         var _loc1_:Box = new Box();
         _loc1_.verticalAlign = "middle";
         _loc1_.y = 1;
         _loc1_.children = [this._ClanManage_Label2_i(),this._ClanManage_Input1_i()];
         return _loc1_;
      }
      
      private function _ClanManage_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.fontSize = 12;
         _loc1_.width = 180;
         _loc1_.height = 20;
         this._ClanManage_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_ClanManage_Label2",this._ClanManage_Label2);
         return _loc1_;
      }
      
      private function _ClanManage_Input1_i() : Input
      {
         var _loc1_:Input = new Input();
         _loc1_.width = 172;
         _loc1_.height = 22;
         _loc1_.color = 0;
         _loc1_.fontSize = 12;
         _loc1_.maxChars = 18;
         this.clanName = _loc1_;
         BindingManager.executeBindings(this,"clanName",this.clanName);
         return _loc1_;
      }
      
      private function _ClanManage_Container3_c() : Container
      {
         var _loc1_:Container = new Container();
         _loc1_.y = 231;
         _loc1_.children = [this._ClanManage_GradientBox2_c(),this._ClanManage_Label3_i(),this._ClanManage_BorderedContainer2_i(),this._ClanManage_Button11_i()];
         return _loc1_;
      }
      
      private function _ClanManage_GradientBox2_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.width = 436;
         _loc1_.height = 24;
         return _loc1_;
      }
      
      private function _ClanManage_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.fontSize = 12;
         _loc1_.width = 180;
         _loc1_.height = 20;
         _loc1_.y = 1;
         this._ClanManage_Label3 = _loc1_;
         BindingManager.executeBindings(this,"_ClanManage_Label3",this._ClanManage_Label3);
         return _loc1_;
      }
      
      private function _ClanManage_BorderedContainer2_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.backgroundColor = 1;
         _loc1_.x = 180;
         _loc1_.padding = 3;
         _loc1_.y = 1;
         _loc1_.children = [this._ClanManage_ClanIcon1_i()];
         this._ClanManage_BorderedContainer2 = _loc1_;
         BindingManager.executeBindings(this,"_ClanManage_BorderedContainer2",this._ClanManage_BorderedContainer2);
         return _loc1_;
      }
      
      private function _ClanManage_ClanIcon1_i() : ClanIcon
      {
         var _loc1_:ClanIcon = new ClanIcon();
         this.clanIcon = _loc1_;
         BindingManager.executeBindings(this,"clanIcon",this.clanIcon);
         return _loc1_;
      }
      
      private function _ClanManage_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.fontSize = 12;
         _loc1_.x = 245;
         _loc1_.y = 1;
         _loc1_.width = 108;
         _loc1_.height = 22;
         _loc1_.addEventListener("click",this.___ClanManage_Button11_click);
         this._ClanManage_Button11 = _loc1_;
         BindingManager.executeBindings(this,"_ClanManage_Button11",this._ClanManage_Button11);
         return _loc1_;
      }
      
      public function ___ClanManage_Button11_click(event:MouseEvent) : void
      {
         this.browse();
      }
      
      private function _ClanManage_Container4_c() : Container
      {
         var _loc1_:Container = new Container();
         _loc1_.y = 278;
         _loc1_.children = [this._ClanManage_Label4_i(),this._ClanManage_MoneyRenderer1_i(),this._ClanManage_Button12_i(),this._ClanManage_Button13_i()];
         return _loc1_;
      }
      
      private function _ClanManage_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.x = 13;
         _loc1_.y = 3;
         _loc1_.fontSize = 12;
         this._ClanManage_Label4 = _loc1_;
         BindingManager.executeBindings(this,"_ClanManage_Label4",this._ClanManage_Label4);
         return _loc1_;
      }
      
      private function _ClanManage_MoneyRenderer1_i() : MoneyRenderer
      {
         var _loc1_:MoneyRenderer = new MoneyRenderer();
         _loc1_.fontSize = 12;
         _loc1_.color = 16777215;
         _loc1_.x = 180;
         _loc1_.y = 3;
         this._ClanManage_MoneyRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_ClanManage_MoneyRenderer1",this._ClanManage_MoneyRenderer1);
         return _loc1_;
      }
      
      private function _ClanManage_Button12_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.x = 380;
         _loc1_.width = 50;
         _loc1_.height = 26;
         _loc1_.addEventListener("click",this.___ClanManage_Button12_click);
         this._ClanManage_Button12 = _loc1_;
         BindingManager.executeBindings(this,"_ClanManage_Button12",this._ClanManage_Button12);
         return _loc1_;
      }
      
      public function ___ClanManage_Button12_click(event:MouseEvent) : void
      {
         this.create();
      }
      
      private function _ClanManage_Button13_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.x = 380;
         _loc1_.width = 50;
         _loc1_.height = 26;
         _loc1_.addEventListener("click",this.___ClanManage_Button13_click);
         this._ClanManage_Button13 = _loc1_;
         BindingManager.executeBindings(this,"_ClanManage_Button13",this._ClanManage_Button13);
         return _loc1_;
      }
      
      public function ___ClanManage_Button13_click(event:MouseEvent) : void
      {
         this.change();
      }
      
      private function _ClanManage_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return Assets.shadedBorderRound;
         },null,"_ClanManage_BorderedContainer1.borderSkin");
         result[1] = new Binding(this,function():Object
         {
            return Assets.pattern_06;
         },null,"_ClanManage_BorderedContainer1.backgroundImage");
         result[2] = new Binding(this,function():uint
         {
            return Colors.LABEL;
         },null,"_ClanManage_Label1.color");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = getString(model.id > 0 ? "clan.change.description" : "clan.description");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanManage_Label1.text");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = getString("clan.name");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanManage_Label2.text");
         result[5] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_ClanManage_Label2.color");
         result[6] = new Binding(this,function():Object
         {
            return Assets.chatInput;
         },null,"clanName.borderSkin");
         result[7] = new Binding(this,function():String
         {
            var _loc1_:* = model.name;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"clanName.text");
         result[8] = new Binding(this,function():String
         {
            var _loc1_:* = getString("clan.logo");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanManage_Label3.text");
         result[9] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_ClanManage_Label3.color");
         result[10] = new Binding(this,function():Object
         {
            return Assets.simpleBorderRound;
         },null,"_ClanManage_BorderedContainer2.borderSkin");
         result[11] = new Binding(this,function():Number
         {
            return iconWidth + 6;
         },null,"_ClanManage_BorderedContainer2.width");
         result[12] = new Binding(this,function():Number
         {
            return iconWidth + 6;
         },null,"_ClanManage_BorderedContainer2.height");
         result[13] = new Binding(this,function():Number
         {
            return model.id;
         },null,"clanIcon.clanId");
         result[14] = new Binding(this,function():String
         {
            var _loc1_:* = getString("browse");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanManage_Button11.label");
         result[15] = new Binding(this,function():String
         {
            var _loc1_:* = getString(model.id > 0 ? "clan.changeCost" : "clan.creationCost") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanManage_Label4.text");
         result[16] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_ClanManage_Label4.color");
         result[17] = new Binding(this,function():String
         {
            var _loc1_:* = CurrencyType.RUBIES;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanManage_MoneyRenderer1.type");
         result[18] = new Binding(this,function():uint
         {
            return model.id == 0 ? model.creationCost : model.changeCost;
         },null,"_ClanManage_MoneyRenderer1.value");
         result[19] = new Binding(this,function():Object
         {
            return Icons.accept;
         },null,"_ClanManage_Button12.icon");
         result[20] = new Binding(this,function():Boolean
         {
            return model.id == 0;
         },null,"_ClanManage_Button12.visible");
         result[21] = new Binding(this,function():Boolean
         {
            return imageFits && clanName.text.length > 0;
         },null,"_ClanManage_Button12.enabled");
         result[22] = new Binding(this,function():Object
         {
            return Icons.accept;
         },null,"_ClanManage_Button13.icon");
         result[23] = new Binding(this,function():Boolean
         {
            return model.id > 0;
         },null,"_ClanManage_Button13.visible");
         result[24] = new Binding(this,function():Boolean
         {
            return (imageFits || clanName.text != model.name) && model.changeCost <= model.rubies;
         },null,"_ClanManage_Button13.enabled");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get clanIcon() : ClanIcon
      {
         return this._686569455clanIcon;
      }
      
      public function set clanIcon(param1:ClanIcon) : void
      {
         var _loc2_:Object = this._686569455clanIcon;
         if(_loc2_ !== param1)
         {
            this._686569455clanIcon = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clanIcon",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get clanName() : Input
      {
         return this._686716417clanName;
      }
      
      public function set clanName(param1:Input) : void
      {
         var _loc2_:Object = this._686716417clanName;
         if(_loc2_ !== param1)
         {
            this._686716417clanName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clanName",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get model() : ClanModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:ClanModel) : void
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
      
      [Bindable(event="propertyChange")]
      public function get characterModel() : CharacterModel
      {
         return this._340320640characterModel;
      }
      
      public function set characterModel(param1:CharacterModel) : void
      {
         var _loc2_:Object = this._340320640characterModel;
         if(_loc2_ !== param1)
         {
            this._340320640characterModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"characterModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get imageFits() : Boolean
      {
         return this._878580099imageFits;
      }
      
      private function set imageFits(param1:Boolean) : void
      {
         var _loc2_:Object = this._878580099imageFits;
         if(_loc2_ !== param1)
         {
            this._878580099imageFits = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"imageFits",_loc2_,param1));
            }
         }
      }
   }
}

