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
   import soul.controller.Interaction;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.event.SimpleUIEvent;
   import soul.model.common.InteractionType;
   import soul.model.interaction.clan.ClanInfo;
   import soul.net.ServerLayer;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientBox;
   import soul.view.common.Icons;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.Box;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Component;
   import soul.view.ui.Container;
   import soul.view.ui.Label;
   
   use namespace mx_internal;
   
   public class ExternalClanScreen extends Container implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _ExternalClanScreen_Button11:Button1;
      
      public var _ExternalClanScreen_CachedImage1:CachedImage;
      
      public var _ExternalClanScreen_Label1:Label;
      
      public var _ExternalClanScreen_Label2:Label;
      
      private var _1034135705memberSelector:ClanMembers;
      
      public var clanId:String;
      
      private var _686579748clanInfo:ClanInfo;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ExternalClanScreen()
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
         bindings = this._ExternalClanScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_clan_ExternalClanScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return ExternalClanScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 480;
         this.height = 350;
         this.children = [this._ExternalClanScreen_CachedImage1_i(),this._ExternalClanScreen_Container2_c()];
         this.addEventListener("creationComplete",this.___ExternalClanScreen_Container1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ExternalClanScreen._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         ServerLayer.call("clanService","getClanInfo",this.setClanInfo,null,this.clanId);
      }
      
      private function setClanInfo(r:ClanInfo = null) : void
      {
         if(r == null)
         {
            Interaction.hide(InteractionType.CLAN_EXTERNAL);
            return;
         }
         this.clanInfo = r;
         InteractionWindow.findInteractionParent(this).label = r.name;
      }
      
      private function close() : void
      {
         Interaction.hide(InteractionType.CLAN_EXTERNAL);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _ExternalClanScreen_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.x = 12;
         _loc1_.y = 12;
         this._ExternalClanScreen_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_ExternalClanScreen_CachedImage1",this._ExternalClanScreen_CachedImage1);
         return _loc1_;
      }
      
      private function _ExternalClanScreen_Container2_c() : Container
      {
         var _loc1_:Container = new Container();
         _loc1_.x = 21;
         _loc1_.y = 21;
         _loc1_.children = [this._ExternalClanScreen_GradientBox1_c(),this._ExternalClanScreen_Box1_c()];
         return _loc1_;
      }
      
      private function _ExternalClanScreen_GradientBox1_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.width = 436;
         _loc1_.height = 20;
         return _loc1_;
      }
      
      private function _ExternalClanScreen_Box1_c() : Box
      {
         var _loc1_:Box = new Box();
         _loc1_.width = 436;
         _loc1_.height = 310;
         _loc1_.direction = "vertical";
         _loc1_.gap = 1;
         _loc1_.children = [this._ExternalClanScreen_Box2_c(),this._ExternalClanScreen_ClanMembers1_i(),this._ExternalClanScreen_Component2_c(),this._ExternalClanScreen_Box3_c()];
         return _loc1_;
      }
      
      private function _ExternalClanScreen_Box2_c() : Box
      {
         var _loc1_:Box = new Box();
         _loc1_.percentWidth = 100;
         _loc1_.height = 20;
         _loc1_.verticalAlign = "middle";
         _loc1_.direction = "horizontal";
         _loc1_.children = [this._ExternalClanScreen_Component1_c(),this._ExternalClanScreen_Label1_i(),this._ExternalClanScreen_Label2_i()];
         return _loc1_;
      }
      
      private function _ExternalClanScreen_Component1_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.width = 25;
         return _loc1_;
      }
      
      private function _ExternalClanScreen_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.width = 196;
         _loc1_.height = 20;
         _loc1_.fontSize = 12;
         this._ExternalClanScreen_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_ExternalClanScreen_Label1",this._ExternalClanScreen_Label1);
         return _loc1_;
      }
      
      private function _ExternalClanScreen_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.fontSize = 12;
         this._ExternalClanScreen_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_ExternalClanScreen_Label2",this._ExternalClanScreen_Label2);
         return _loc1_;
      }
      
      private function _ExternalClanScreen_ClanMembers1_i() : ClanMembers
      {
         var _loc1_:ClanMembers = new ClanMembers();
         _loc1_.percentWidth = 100;
         _loc1_.height = 241;
         _loc1_.horizontalScrollPolicy = "off";
         _loc1_.verticalScrollPolicy = "on";
         this.memberSelector = _loc1_;
         BindingManager.executeBindings(this,"memberSelector",this.memberSelector);
         return _loc1_;
      }
      
      private function _ExternalClanScreen_Component2_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.height = 14;
         return _loc1_;
      }
      
      private function _ExternalClanScreen_Box3_c() : Box
      {
         var _loc1_:Box = new Box();
         _loc1_.direction = "horizontal";
         _loc1_.horizontalAlign = "center";
         _loc1_.width = 430;
         _loc1_.height = 26;
         _loc1_.children = [this._ExternalClanScreen_Button11_i()];
         return _loc1_;
      }
      
      private function _ExternalClanScreen_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 60;
         _loc1_.height = 26;
         _loc1_.fontSize = 12;
         _loc1_.addEventListener("click",this.___ExternalClanScreen_Button11_click);
         this._ExternalClanScreen_Button11 = _loc1_;
         BindingManager.executeBindings(this,"_ExternalClanScreen_Button11",this._ExternalClanScreen_Button11);
         return _loc1_;
      }
      
      public function ___ExternalClanScreen_Button11_click(event:MouseEvent) : void
      {
         this.close();
      }
      
      public function ___ExternalClanScreen_Container1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _ExternalClanScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return Assets.panelSet;
         },null,"_ExternalClanScreen_CachedImage1.source");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = getString("clan.nick");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ExternalClanScreen_Label1.text");
         result[2] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_ExternalClanScreen_Label1.color");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = getString("clan.status");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ExternalClanScreen_Label2.text");
         result[4] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_ExternalClanScreen_Label2.color");
         result[5] = new Binding(this,function():Array
         {
            var _loc1_:* = clanInfo.members;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"memberSelector.dataProvider");
         result[6] = new Binding(this,function():Object
         {
            return Icons.cancel;
         },null,"_ExternalClanScreen_Button11.icon");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get memberSelector() : ClanMembers
      {
         return this._1034135705memberSelector;
      }
      
      public function set memberSelector(param1:ClanMembers) : void
      {
         var _loc2_:Object = this._1034135705memberSelector;
         if(_loc2_ !== param1)
         {
            this._1034135705memberSelector = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"memberSelector",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get clanInfo() : ClanInfo
      {
         return this._686579748clanInfo;
      }
      
      private function set clanInfo(param1:ClanInfo) : void
      {
         var _loc2_:Object = this._686579748clanInfo;
         if(_loc2_ !== param1)
         {
            this._686579748clanInfo = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clanInfo",_loc2_,param1));
            }
         }
      }
   }
}

