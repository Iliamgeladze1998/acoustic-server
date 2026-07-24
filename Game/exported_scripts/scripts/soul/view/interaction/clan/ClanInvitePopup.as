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
   import soul.event.SimpleUIEvent;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.common.CurrencyType;
   import soul.view.common.MoneyRenderer;
   import soul.view.interaction.auction.MoneyEnter;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.HBox;
   import soul.view.ui.Input;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   import soul.view.ui.controls.PopupManager;
   import soul.view.ui.controls.Window;
   
   use namespace mx_internal;
   
   public class ClanInvitePopup extends Window implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _ClanInvitePopup_BorderedContainer1:BorderedContainer;
      
      public var _ClanInvitePopup_Button11:Button1;
      
      public var _ClanInvitePopup_Button12:Button1;
      
      public var _ClanInvitePopup_Label1:Label;
      
      public var _ClanInvitePopup_Label2:Label;
      
      public var _ClanInvitePopup_Label3:Label;
      
      public var _ClanInvitePopup_MoneyRenderer1:MoneyRenderer;
      
      private var _3381091nick:Input;
      
      private var _920168456rubies:MoneyEnter;
      
      private var _1053125763enterFeeValue:uint;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ClanInvitePopup()
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
         bindings = this._ClanInvitePopup_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_clan_ClanInvitePopupWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return ClanInvitePopup[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.children = [this._ClanInvitePopup_VBox1_c()];
         this.addEventListener("creationComplete",this.___ClanInvitePopup_Window1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ClanInvitePopup._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         this.nick.setFocus();
      }
      
      private function accept() : void
      {
         var ne:ClanEvent = new ClanEvent(ClanEvent.INVITE_CONFIRM);
         ne.data = [this.nick.text,this.rubies.value];
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
      
      private function _ClanInvitePopup_VBox1_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.padding = 10;
         _loc1_.horizontalAlign = "center";
         _loc1_.gap = 4;
         _loc1_.children = [this._ClanInvitePopup_Label1_i(),this._ClanInvitePopup_Input1_i(),this._ClanInvitePopup_Label2_i(),this._ClanInvitePopup_MoneyEnter1_i(),this._ClanInvitePopup_BorderedContainer1_i(),this._ClanInvitePopup_HBox1_c()];
         return _loc1_;
      }
      
      private function _ClanInvitePopup_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         this._ClanInvitePopup_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_ClanInvitePopup_Label1",this._ClanInvitePopup_Label1);
         return _loc1_;
      }
      
      private function _ClanInvitePopup_Input1_i() : Input
      {
         var _loc1_:Input = null;
         _loc1_ = new Input();
         _loc1_.width = 157;
         _loc1_.height = 20;
         _loc1_.align = "center";
         _loc1_.fontSize = 12;
         this.nick = _loc1_;
         BindingManager.executeBindings(this,"nick",this.nick);
         return _loc1_;
      }
      
      private function _ClanInvitePopup_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         this._ClanInvitePopup_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_ClanInvitePopup_Label2",this._ClanInvitePopup_Label2);
         return _loc1_;
      }
      
      private function _ClanInvitePopup_MoneyEnter1_i() : MoneyEnter
      {
         var _loc1_:MoneyEnter = new MoneyEnter();
         _loc1_.value = 0;
         this.rubies = _loc1_;
         BindingManager.executeBindings(this,"rubies",this.rubies);
         return _loc1_;
      }
      
      private function _ClanInvitePopup_BorderedContainer1_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.percentWidth = 100;
         _loc1_.backgroundColor = 1;
         _loc1_.backgroundPadding = 2;
         _loc1_.direction = "horizontal";
         _loc1_.padding = 5;
         _loc1_.children = [this._ClanInvitePopup_Label3_i(),this._ClanInvitePopup_MoneyRenderer1_i()];
         this._ClanInvitePopup_BorderedContainer1 = _loc1_;
         BindingManager.executeBindings(this,"_ClanInvitePopup_BorderedContainer1",this._ClanInvitePopup_BorderedContainer1);
         return _loc1_;
      }
      
      private function _ClanInvitePopup_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         this._ClanInvitePopup_Label3 = _loc1_;
         BindingManager.executeBindings(this,"_ClanInvitePopup_Label3",this._ClanInvitePopup_Label3);
         return _loc1_;
      }
      
      private function _ClanInvitePopup_MoneyRenderer1_i() : MoneyRenderer
      {
         var _loc1_:MoneyRenderer = new MoneyRenderer();
         this._ClanInvitePopup_MoneyRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_ClanInvitePopup_MoneyRenderer1",this._ClanInvitePopup_MoneyRenderer1);
         return _loc1_;
      }
      
      private function _ClanInvitePopup_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 5;
         _loc1_.children = [this._ClanInvitePopup_Button11_i(),this._ClanInvitePopup_Button12_i()];
         return _loc1_;
      }
      
      private function _ClanInvitePopup_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.padding = 5;
         _loc1_.addEventListener("click",this.___ClanInvitePopup_Button11_click);
         this._ClanInvitePopup_Button11 = _loc1_;
         BindingManager.executeBindings(this,"_ClanInvitePopup_Button11",this._ClanInvitePopup_Button11);
         return _loc1_;
      }
      
      public function ___ClanInvitePopup_Button11_click(event:MouseEvent) : void
      {
         this.accept();
      }
      
      private function _ClanInvitePopup_Button12_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.padding = 5;
         _loc1_.addEventListener("click",this.___ClanInvitePopup_Button12_click);
         this._ClanInvitePopup_Button12 = _loc1_;
         BindingManager.executeBindings(this,"_ClanInvitePopup_Button12",this._ClanInvitePopup_Button12);
         return _loc1_;
      }
      
      public function ___ClanInvitePopup_Button12_click(event:MouseEvent) : void
      {
         this.exit(event);
      }
      
      public function ___ClanInvitePopup_Window1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _ClanInvitePopup_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = getString("clan.invitation");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"this.label");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = getString("clan.nick") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanInvitePopup_Label1.text");
         result[2] = new Binding(this,function():Object
         {
            return Assets.chatInput;
         },null,"nick.borderSkin");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = getString("clan.entryCost");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanInvitePopup_Label2.text");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = CurrencyType.RUBIES;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"rubies.type");
         result[5] = new Binding(this,function():Object
         {
            return Assets.serifeBorder;
         },null,"_ClanInvitePopup_BorderedContainer1.borderSkin");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = getString("clan.fee") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanInvitePopup_Label3.text");
         result[7] = new Binding(this,function():String
         {
            var _loc1_:* = CurrencyType.RUBIES;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanInvitePopup_MoneyRenderer1.type");
         result[8] = new Binding(this,null,null,"_ClanInvitePopup_MoneyRenderer1.value","enterFeeValue");
         result[9] = new Binding(this,function():String
         {
            var _loc1_:* = getString("clan.invite");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanInvitePopup_Button11.label");
         result[10] = new Binding(this,function():Boolean
         {
            return nick.text.length > 0;
         },null,"_ClanInvitePopup_Button11.enabled");
         result[11] = new Binding(this,function():String
         {
            var _loc1_:* = getString("close");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanInvitePopup_Button12.label");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get nick() : Input
      {
         return this._3381091nick;
      }
      
      public function set nick(param1:Input) : void
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
      public function get rubies() : MoneyEnter
      {
         return this._920168456rubies;
      }
      
      public function set rubies(param1:MoneyEnter) : void
      {
         var _loc2_:Object = this._920168456rubies;
         if(_loc2_ !== param1)
         {
            this._920168456rubies = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rubies",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get enterFeeValue() : uint
      {
         return this._1053125763enterFeeValue;
      }
      
      public function set enterFeeValue(param1:uint) : void
      {
         var _loc2_:Object = this._1053125763enterFeeValue;
         if(_loc2_ !== param1)
         {
            this._1053125763enterFeeValue = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enterFeeValue",_loc2_,param1));
            }
         }
      }
   }
}

