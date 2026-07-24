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
   import soul.model.interaction.clan.ClanRole;
   import soul.view.assets.Button1;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientLabel;
   import soul.view.common.Icons;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.ComboBox;
   import soul.view.ui.HBox;
   import soul.view.ui.TextArea;
   import soul.view.ui.controls.PopupManager;
   import soul.view.ui.controls.Window;
   
   use namespace mx_internal;
   
   public class ClanStatusPopup extends Window implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _ClanStatusPopup_Button11:Button1;
      
      public var _ClanStatusPopup_Button12:Button1;
      
      public var _ClanStatusPopup_GradientLabel1:GradientLabel;
      
      public var _ClanStatusPopup_GradientLabel2:GradientLabel;
      
      public var _ClanStatusPopup_TextArea1:TextArea;
      
      private var _1754521167selectedRole:ComboBox;
      
      private var _3381091nick:String;
      
      private var _601181583currentRole:String;
      
      public var memberId:String;
      
      private var _1967634944sortedRoles:Array;
      
      private var _1454378115currentRoleIndex:int;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ClanStatusPopup()
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
         bindings = this._ClanStatusPopup_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_clan_ClanStatusPopupWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return ClanStatusPopup[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.children = [this._ClanStatusPopup_BorderedContainer1_c()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ClanStatusPopup._watcherSetupUtil = param1;
      }
      
      public function setRole(currentRole:String, allowedRoles:Array) : void
      {
         var role:ClanRole = null;
         if(!allowedRoles)
         {
            return;
         }
         this.sortedRoles = allowedRoles;
         var currentRoleIndex:int = -1;
         for(var i:int = 0; i < allowedRoles.length; i++)
         {
            role = allowedRoles[i];
            if(role.role == currentRole)
            {
               currentRoleIndex = i;
               break;
            }
         }
         this.currentRoleIndex = currentRoleIndex;
         this.currentRole = currentRole;
      }
      
      private function accept() : void
      {
         var ne:ClanEvent = new ClanEvent(ClanEvent.STATUS_CONFIRM);
         ne.data = [this.memberId,ClanRole(this.selectedRole.selectedItem).role];
         dispatchEvent(ne);
         this.exit(null);
      }
      
      override protected function exit(e:Event) : void
      {
         PopupManager.removePopup(this);
      }
      
      private function getRoleDescription(role:String) : String
      {
         return LocaleManager.getClanRoleDescription(role);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _ClanStatusPopup_BorderedContainer1_c() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.width = 320;
         _loc1_.padding = 9;
         _loc1_.gap = 10;
         _loc1_.direction = "vertical";
         _loc1_.horizontalAlign = "center";
         _loc1_.children = [this._ClanStatusPopup_GradientLabel1_i(),this._ClanStatusPopup_ComboBox1_i(),this._ClanStatusPopup_GradientLabel2_i(),this._ClanStatusPopup_TextArea1_i(),this._ClanStatusPopup_HBox1_c()];
         return _loc1_;
      }
      
      private function _ClanStatusPopup_GradientLabel1_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.percentWidth = 100;
         _loc1_.height = 20;
         _loc1_.bold = true;
         _loc1_.bgPaddingLeft = -9;
         this._ClanStatusPopup_GradientLabel1 = _loc1_;
         BindingManager.executeBindings(this,"_ClanStatusPopup_GradientLabel1",this._ClanStatusPopup_GradientLabel1);
         return _loc1_;
      }
      
      private function _ClanStatusPopup_ComboBox1_i() : ComboBox
      {
         var _loc1_:ComboBox = new ComboBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 21;
         _loc1_.labelField = "localizedName";
         this.selectedRole = _loc1_;
         BindingManager.executeBindings(this,"selectedRole",this.selectedRole);
         return _loc1_;
      }
      
      private function _ClanStatusPopup_GradientLabel2_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.percentWidth = 100;
         _loc1_.height = 20;
         _loc1_.bold = true;
         _loc1_.bgPaddingLeft = -9;
         this._ClanStatusPopup_GradientLabel2 = _loc1_;
         BindingManager.executeBindings(this,"_ClanStatusPopup_GradientLabel2",this._ClanStatusPopup_GradientLabel2);
         return _loc1_;
      }
      
      private function _ClanStatusPopup_TextArea1_i() : TextArea
      {
         var _loc1_:TextArea = new TextArea();
         _loc1_.percentWidth = 100;
         _loc1_.height = 60;
         _loc1_.multiline = true;
         _loc1_.wordWrap = true;
         this._ClanStatusPopup_TextArea1 = _loc1_;
         BindingManager.executeBindings(this,"_ClanStatusPopup_TextArea1",this._ClanStatusPopup_TextArea1);
         return _loc1_;
      }
      
      private function _ClanStatusPopup_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 10;
         _loc1_.children = [this._ClanStatusPopup_Button11_i(),this._ClanStatusPopup_Button12_i()];
         return _loc1_;
      }
      
      private function _ClanStatusPopup_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 28;
         _loc1_.addEventListener("click",this.___ClanStatusPopup_Button11_click);
         this._ClanStatusPopup_Button11 = _loc1_;
         BindingManager.executeBindings(this,"_ClanStatusPopup_Button11",this._ClanStatusPopup_Button11);
         return _loc1_;
      }
      
      public function ___ClanStatusPopup_Button11_click(event:MouseEvent) : void
      {
         this.accept();
      }
      
      private function _ClanStatusPopup_Button12_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 28;
         _loc1_.addEventListener("click",this.___ClanStatusPopup_Button12_click);
         this._ClanStatusPopup_Button12 = _loc1_;
         BindingManager.executeBindings(this,"_ClanStatusPopup_Button12",this._ClanStatusPopup_Button12);
         return _loc1_;
      }
      
      public function ___ClanStatusPopup_Button12_click(event:MouseEvent) : void
      {
         this.exit(null);
      }
      
      private function _ClanStatusPopup_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = getString("clan.status");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"this.label");
         result[1] = new Binding(this,null,null,"_ClanStatusPopup_GradientLabel1.text","nick");
         result[2] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_ClanStatusPopup_GradientLabel1.color");
         result[3] = new Binding(this,function():Array
         {
            var _loc1_:* = sortedRoles;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"selectedRole.dataProvider","sortedRoles");
         result[4] = new Binding(this,null,null,"selectedRole.selectedIndex","currentRoleIndex");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = getString("clan.role.bonuses") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanStatusPopup_GradientLabel2.text");
         result[6] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_ClanStatusPopup_GradientLabel2.color");
         result[7] = new Binding(this,function():String
         {
            var _loc1_:* = getRoleDescription(ClanRole(selectedRole.selectedItem).role);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanStatusPopup_TextArea1.text");
         result[8] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_ClanStatusPopup_TextArea1.color");
         result[9] = new Binding(this,function():Object
         {
            return Icons.accept;
         },null,"_ClanStatusPopup_Button11.icon");
         result[10] = new Binding(this,function():Boolean
         {
            return selectedRole.selectedItem.value != currentRole;
         },null,"_ClanStatusPopup_Button11.enabled");
         result[11] = new Binding(this,function():Object
         {
            return Icons.cancel;
         },null,"_ClanStatusPopup_Button12.icon");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedRole() : ComboBox
      {
         return this._1754521167selectedRole;
      }
      
      public function set selectedRole(param1:ComboBox) : void
      {
         var _loc2_:Object = this._1754521167selectedRole;
         if(_loc2_ !== param1)
         {
            this._1754521167selectedRole = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedRole",_loc2_,param1));
            }
         }
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
      public function get currentRole() : String
      {
         return this._601181583currentRole;
      }
      
      public function set currentRole(param1:String) : void
      {
         var _loc2_:Object = this._601181583currentRole;
         if(_loc2_ !== param1)
         {
            this._601181583currentRole = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentRole",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get sortedRoles() : Array
      {
         return this._1967634944sortedRoles;
      }
      
      public function set sortedRoles(param1:Array) : void
      {
         var _loc2_:Object = this._1967634944sortedRoles;
         if(_loc2_ !== param1)
         {
            this._1967634944sortedRoles = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sortedRoles",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get currentRoleIndex() : int
      {
         return this._1454378115currentRoleIndex;
      }
      
      public function set currentRoleIndex(param1:int) : void
      {
         var _loc2_:Object = this._1454378115currentRoleIndex;
         if(_loc2_ !== param1)
         {
            this._1454378115currentRoleIndex = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentRoleIndex",_loc2_,param1));
            }
         }
      }
   }
}

