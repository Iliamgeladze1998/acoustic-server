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
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.event.ClanEvent;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.controls.PopupManager;
   import soul.view.ui.controls.Window;
   
   use namespace mx_internal;
   
   public class ClanKickPopup extends Window implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _ClanKickPopup_BorderedContainer2:BorderedContainer;
      
      public var _ClanKickPopup_Button11:Button1;
      
      public var _ClanKickPopup_Button12:Button1;
      
      public var _ClanKickPopup_Label1:Label;
      
      public var _ClanKickPopup_Label2:Label;
      
      private var _3381091nick:String;
      
      public var memberId:String;
      
      private var _3526476self:Boolean;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ClanKickPopup()
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
         bindings = this._ClanKickPopup_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_clan_ClanKickPopupWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return ClanKickPopup[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.children = [this._ClanKickPopup_BorderedContainer1_c()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ClanKickPopup._watcherSetupUtil = param1;
      }
      
      private function accept() : void
      {
         var ne:ClanEvent = new ClanEvent(ClanEvent.KICK_CONFIRM);
         ne.data = this.memberId;
         dispatchEvent(ne);
         this.exit(null);
      }
      
      override protected function exit(e:Event) : void
      {
         PopupManager.removePopup(this);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _ClanKickPopup_BorderedContainer1_c() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.padding = 10;
         _loc1_.gap = 5;
         _loc1_.direction = "vertical";
         _loc1_.horizontalAlign = "center";
         _loc1_.children = [this._ClanKickPopup_Label1_i(),this._ClanKickPopup_BorderedContainer2_i(),this._ClanKickPopup_HBox1_c()];
         return _loc1_;
      }
      
      private function _ClanKickPopup_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         this._ClanKickPopup_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_ClanKickPopup_Label1",this._ClanKickPopup_Label1);
         return _loc1_;
      }
      
      private function _ClanKickPopup_BorderedContainer2_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.percentWidth = 100;
         _loc1_.padding = 3;
         _loc1_.backgroundColor = 1;
         _loc1_.backgroundPadding = 2;
         _loc1_.children = [this._ClanKickPopup_Label2_i()];
         this._ClanKickPopup_BorderedContainer2 = _loc1_;
         BindingManager.executeBindings(this,"_ClanKickPopup_BorderedContainer2",this._ClanKickPopup_BorderedContainer2);
         return _loc1_;
      }
      
      private function _ClanKickPopup_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.align = "center";
         this._ClanKickPopup_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_ClanKickPopup_Label2",this._ClanKickPopup_Label2);
         return _loc1_;
      }
      
      private function _ClanKickPopup_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 5;
         _loc1_.children = [this._ClanKickPopup_Button11_i(),this._ClanKickPopup_Button12_i()];
         return _loc1_;
      }
      
      private function _ClanKickPopup_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.padding = 5;
         _loc1_.addEventListener("click",this.___ClanKickPopup_Button11_click);
         this._ClanKickPopup_Button11 = _loc1_;
         BindingManager.executeBindings(this,"_ClanKickPopup_Button11",this._ClanKickPopup_Button11);
         return _loc1_;
      }
      
      public function ___ClanKickPopup_Button11_click(event:MouseEvent) : void
      {
         this.accept();
      }
      
      private function _ClanKickPopup_Button12_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.padding = 5;
         _loc1_.addEventListener("click",this.___ClanKickPopup_Button12_click);
         this._ClanKickPopup_Button12 = _loc1_;
         BindingManager.executeBindings(this,"_ClanKickPopup_Button12",this._ClanKickPopup_Button12);
         return _loc1_;
      }
      
      public function ___ClanKickPopup_Button12_click(event:MouseEvent) : void
      {
         this.exit(event);
      }
      
      private function _ClanKickPopup_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = getString("clan.kick");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"this.label");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = getString(self ? "clan.leaveMessage" : "clan.kickMessage");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanKickPopup_Label1.text");
         result[2] = new Binding(this,function():Object
         {
            return Assets.serifeBorder;
         },null,"_ClanKickPopup_BorderedContainer2.borderSkin");
         result[3] = new Binding(this,function():Boolean
         {
            return !self;
         },null,"_ClanKickPopup_BorderedContainer2.visible");
         result[4] = new Binding(this,null,null,"_ClanKickPopup_Label2.text","nick");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = getString(self ? "clan.leave" : "clan.kick");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanKickPopup_Button11.label");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = getString("close");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanKickPopup_Button12.label");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get nick() : String
      {
         return this._3381091nick;
      }
      
      public function set nick(param1:String) : void
      {
         var _loc2_:Object = this._3381091nick;
         if(_loc2_ !== param1)
         {
            this._3381091nick = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"nick",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get self() : Boolean
      {
         return this._3526476self;
      }
      
      public function set self(param1:Boolean) : void
      {
         var _loc2_:Object = this._3526476self;
         if(_loc2_ !== param1)
         {
            this._3526476self = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"self",_loc2_,param1));
            }
         }
      }
   }
}

