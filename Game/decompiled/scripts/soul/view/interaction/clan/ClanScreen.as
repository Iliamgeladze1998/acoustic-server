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
   import soul.event.ClanEvent;
   import soul.event.SimpleUIEvent;
   import soul.model.character.CharacterModel;
   import soul.model.common.InteractionType;
   import soul.model.interaction.clan.ClanBonus;
   import soul.model.interaction.clan.ClanMember;
   import soul.model.interaction.clan.ClanModel;
   import soul.model.interaction.clan.ClanPermission;
   import soul.model.interaction.clan.ClanRecordType;
   import soul.model.interaction.clan.ClanRole;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientBox;
   import soul.view.assets.GradientLabel;
   import soul.view.assets.SimpleImageBar;
   import soul.view.common.Currency;
   import soul.view.common.CurrencyType;
   import soul.view.common.Icons;
   import soul.view.common.MoneyRenderer;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.Box;
   import soul.view.ui.CachedImage;
   import soul.view.ui.ComboBox;
   import soul.view.ui.Component;
   import soul.view.ui.Container;
   import soul.view.ui.HBox;
   import soul.view.ui.Input;
   import soul.view.ui.Label;
   import soul.view.ui.ScrollBase;
   import soul.view.ui.VBox;
   import soul.view.ui.ViewStack;
   import soul.view.ui.controls.PopupManager;
   
   use namespace mx_internal;
   
   public class ClanScreen extends Container implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const TABS:Array = [[Assets.membersOff,Assets.membersOn],[Assets.bonusesOff,Assets.bonusesOn],[Assets.storageOff,Assets.storageOn],[Assets.treasuryOff,Assets.treasuryOn]];
      
      private static const ADMIN_TABS:Array = [Assets.createOff,Assets.createOn];
      
      public var _ClanScreen_Button15:Button1;
      
      public var _ClanScreen_Button16:Button1;
      
      public var _ClanScreen_Button17:Button1;
      
      public var _ClanScreen_Button18:Button1;
      
      public var _ClanScreen_CachedImage1:CachedImage;
      
      public var _ClanScreen_CachedImage2:CachedImage;
      
      public var _ClanScreen_ClanRecords1:ClanRecords;
      
      public var _ClanScreen_GradientLabel1:GradientLabel;
      
      public var _ClanScreen_GradientLabel2:GradientLabel;
      
      public var _ClanScreen_HBox3:HBox;
      
      public var _ClanScreen_Label1:Label;
      
      public var _ClanScreen_Label2:Label;
      
      public var _ClanScreen_Label3:Label;
      
      public var _ClanScreen_Label4:Label;
      
      public var _ClanScreen_Label5:Label;
      
      public var _ClanScreen_Label6:Label;
      
      public var _ClanScreen_Label7:Label;
      
      public var _ClanScreen_Label8:Label;
      
      public var _ClanScreen_MoneyRenderer1:MoneyRenderer;
      
      public var _ClanScreen_MoneyRenderer2:MoneyRenderer;
      
      public var _ClanScreen_MoneyRenderer3:MoneyRenderer;
      
      public var _ClanScreen_ViewStack1:ViewStack;
      
      private var _97299bar:SimpleImageBar;
      
      private var _618239529clanBonuses:ClanBonuses;
      
      private var _407477098depositAmount:Input;
      
      private var _881400013filterBox:ComboBox;
      
      private var _1901031789inviteBtn:Button1;
      
      private var _720609738kickBtn:Button1;
      
      private var _1577592869leaveBtn:Button1;
      
      private var _1081434779manage:ClanManage;
      
      private var _1465029357memberBonuses:ClanBonuses;
      
      private var _724370576memberControls:HBox;
      
      private var _1034135705memberSelector:ClanMembers;
      
      private var _2070226678statusBtn:Button1;
      
      private var _1884274053storage:ClanStorage;
      
      private var _104069929model:ClanModel;
      
      private var _340320640characterModel:CharacterModel;
      
      private var _1429644868selectedBonus:ClanBonus;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ClanScreen()
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
         bindings = this._ClanScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_clan_ClanScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return ClanScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 480;
         this.height = 380;
         this.children = [this._ClanScreen_SimpleImageBar1_i(),this._ClanScreen_CachedImage1_i(),this._ClanScreen_ViewStack1_i()];
         this._ClanScreen_Button11_i();
         this._ClanScreen_Button12_i();
         this._ClanScreen_Button14_i();
         this._ClanScreen_Button13_i();
         this.addEventListener("creationComplete",this.___ClanScreen_Container1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ClanScreen._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         this.clanName = this.model.name;
      }
      
      private function set clanName(value:String) : void
      {
         InteractionWindow.findInteractionParent(this).label = value;
      }
      
      private function getButtons(role:ClanRole) : Array
      {
         if(!role)
         {
            return null;
         }
         var arr:Array = [];
         if(role.hasPermission(ClanPermission.INVITE))
         {
            arr.push(this.inviteBtn);
         }
         arr.push(role.hasPermission(ClanPermission.KICK) ? this.kickBtn : this.leaveBtn);
         if(role.hasPermission(ClanPermission.PROMOTE) || role.hasPermission(ClanPermission.DEMOTE))
         {
            arr.push(this.statusBtn);
         }
         return arr;
      }
      
      private function getTabs(me:ClanMember) : Array
      {
         var arr:Array = TABS.slice();
         if(me.clanRole.hasPermission(ClanPermission.MANAGE_CLAN))
         {
            arr.push(ADMIN_TABS);
         }
         return arr;
      }
      
      private function invite() : void
      {
         var popup:ClanInvitePopup = new ClanInvitePopup();
         popup.enterFeeValue = this.model.inviteCost;
         PopupManager.addPopup(popup,null,true);
         PopupManager.centerPopup(popup);
         popup.addEventListener(ClanEvent.INVITE_CONFIRM,this.inviteConfirm);
      }
      
      private function inviteConfirm(e:ClanEvent) : void
      {
         var ne:ClanEvent = new ClanEvent(e.type);
         ne.data = e.data;
         this.model.dispatchEvent(ne);
      }
      
      private function leave() : void
      {
         var popup:ClanKickPopup = new ClanKickPopup();
         popup.nick = this.characterModel.name;
         popup.memberId = this.characterModel.id;
         popup.self = true;
         PopupManager.addPopup(popup,null,true);
         PopupManager.centerPopup(popup);
         popup.addEventListener(ClanEvent.KICK_CONFIRM,this.kickConfirm);
      }
      
      private function kick() : void
      {
         var popup:ClanKickPopup = new ClanKickPopup();
         popup.nick = this.memberSelector.selectedMember.name;
         popup.memberId = this.memberSelector.selectedMember.id;
         PopupManager.addPopup(popup,null,true);
         PopupManager.centerPopup(popup);
         popup.addEventListener(ClanEvent.KICK_CONFIRM,this.kickConfirm);
      }
      
      private function kickConfirm(e:ClanEvent) : void
      {
         var ne:ClanEvent = new ClanEvent(e.type);
         ne.data = e.data;
         this.model.dispatchEvent(ne);
      }
      
      private function status() : void
      {
         var role:ClanRole = null;
         var popup:ClanStatusPopup = new ClanStatusPopup();
         popup.nick = this.memberSelector.selectedMember.name;
         popup.memberId = this.memberSelector.selectedMember.id;
         var allowedRoles:Array = [];
         var allowsSelfRank:Boolean = this.model.myMember.clanRole.hasPermission(ClanPermission.DELEGATION);
         for each(role in this.model.sortedRoles)
         {
            if(allowsSelfRank)
            {
               if(role.priority >= this.model.myMember.clanRole.priority)
               {
                  allowedRoles.push(role);
               }
            }
            else if(role.priority > this.model.myMember.clanRole.priority)
            {
               allowedRoles.push(role);
            }
         }
         popup.setRole(this.memberSelector.selectedMember.role,allowedRoles);
         PopupManager.addPopup(popup,null,true);
         PopupManager.centerPopup(popup);
         popup.addEventListener(ClanEvent.STATUS_CONFIRM,this.statusConfirm);
      }
      
      private function statusConfirm(e:ClanEvent) : void
      {
         var ne:ClanEvent = new ClanEvent(e.type);
         ne.data = e.data;
         this.model.dispatchEvent(ne);
      }
      
      private function deposit() : void
      {
         var ne:ClanEvent = new ClanEvent(ClanEvent.DEPOSIT_CONFIRM);
         ne.data = uint(this.depositAmount.text);
         this.clearDeposit();
         this.model.dispatchEvent(ne);
      }
      
      private function clearDeposit() : void
      {
         this.depositAmount.text = "";
      }
      
      private function clanBonusSelected() : void
      {
         this.memberBonuses.unselect();
         this.selectedBonus = this.clanBonuses.selectedBonus;
      }
      
      private function memberBonusSelected() : void
      {
         this.clanBonuses.unselect();
         this.selectedBonus = this.memberBonuses.selectedBonus;
      }
      
      private function apply() : void
      {
         var ne:ClanEvent = new ClanEvent(ClanEvent.BUY_BONUS);
         ne.data = this.selectedBonus.id;
         this.model.dispatchEvent(ne);
         this.cancel();
      }
      
      private function cancel() : void
      {
         this.memberBonuses.unselect();
         this.clanBonuses.unselect();
         this.selectedBonus = null;
      }
      
      private function close() : void
      {
         Interaction.hide(InteractionType.CLAN);
      }
      
      private function hasPermissionToChange(me:ClanMember, target:ClanMember) : Boolean
      {
         if(target.clanRole.priority > me.clanRole.priority)
         {
            return true;
         }
         if(target.clanRole.priority == me.clanRole.priority && me.clanRole.hasPermission(ClanPermission.DELEGATION))
         {
            return true;
         }
         return false;
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _ClanScreen_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 110;
         _loc1_.height = 26;
         _loc1_.fontSize = 12;
         _loc1_.addEventListener("click",this.__inviteBtn_click);
         this.inviteBtn = _loc1_;
         BindingManager.executeBindings(this,"inviteBtn",this.inviteBtn);
         return _loc1_;
      }
      
      public function __inviteBtn_click(event:MouseEvent) : void
      {
         this.invite();
      }
      
      private function _ClanScreen_Button12_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 110;
         _loc1_.height = 26;
         _loc1_.fontSize = 12;
         _loc1_.addEventListener("click",this.__kickBtn_click);
         this.kickBtn = _loc1_;
         BindingManager.executeBindings(this,"kickBtn",this.kickBtn);
         return _loc1_;
      }
      
      public function __kickBtn_click(event:MouseEvent) : void
      {
         this.kick();
      }
      
      private function _ClanScreen_Button14_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 110;
         _loc1_.height = 26;
         _loc1_.fontSize = 12;
         _loc1_.addEventListener("click",this.__leaveBtn_click);
         this.leaveBtn = _loc1_;
         BindingManager.executeBindings(this,"leaveBtn",this.leaveBtn);
         return _loc1_;
      }
      
      public function __leaveBtn_click(event:MouseEvent) : void
      {
         this.leave();
      }
      
      private function _ClanScreen_Button13_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 110;
         _loc1_.height = 26;
         _loc1_.fontSize = 12;
         _loc1_.addEventListener("click",this.__statusBtn_click);
         this.statusBtn = _loc1_;
         BindingManager.executeBindings(this,"statusBtn",this.statusBtn);
         return _loc1_;
      }
      
      public function __statusBtn_click(event:MouseEvent) : void
      {
         this.status();
      }
      
      private function _ClanScreen_SimpleImageBar1_i() : SimpleImageBar
      {
         var _loc1_:SimpleImageBar = new SimpleImageBar();
         _loc1_.x = 13;
         _loc1_.y = 8;
         _loc1_.selectedIndex = 0;
         _loc1_.gap = 1;
         this.bar = _loc1_;
         BindingManager.executeBindings(this,"bar",this.bar);
         return _loc1_;
      }
      
      private function _ClanScreen_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.x = 12;
         _loc1_.y = 42;
         this._ClanScreen_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_ClanScreen_CachedImage1",this._ClanScreen_CachedImage1);
         return _loc1_;
      }
      
      private function _ClanScreen_ViewStack1_i() : ViewStack
      {
         var _loc1_:ViewStack = new ViewStack();
         _loc1_.x = 21;
         _loc1_.y = 51;
         _loc1_.children = [this._ClanScreen_VBox1_c(),this._ClanScreen_VBox2_c(),this._ClanScreen_VBox4_c(),this._ClanScreen_ClanStorage1_i(),this._ClanScreen_ClanManage1_i()];
         this._ClanScreen_ViewStack1 = _loc1_;
         BindingManager.executeBindings(this,"_ClanScreen_ViewStack1",this._ClanScreen_ViewStack1);
         return _loc1_;
      }
      
      private function _ClanScreen_VBox1_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.width = 436;
         _loc1_.height = 306;
         _loc1_.gap = 1;
         _loc1_.children = [this._ClanScreen_GradientBox1_c(),this._ClanScreen_ClanMembers1_i(),this._ClanScreen_Component2_c(),this._ClanScreen_HBox2_i()];
         return _loc1_;
      }
      
      private function _ClanScreen_GradientBox1_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 20;
         _loc1_.children = [this._ClanScreen_HBox1_c()];
         return _loc1_;
      }
      
      private function _ClanScreen_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 20;
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._ClanScreen_Component1_c(),this._ClanScreen_Label1_i(),this._ClanScreen_Label2_i()];
         return _loc1_;
      }
      
      private function _ClanScreen_Component1_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.width = 25;
         return _loc1_;
      }
      
      private function _ClanScreen_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.width = 196;
         _loc1_.height = 20;
         _loc1_.fontSize = 12;
         this._ClanScreen_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_ClanScreen_Label1",this._ClanScreen_Label1);
         return _loc1_;
      }
      
      private function _ClanScreen_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.fontSize = 12;
         this._ClanScreen_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_ClanScreen_Label2",this._ClanScreen_Label2);
         return _loc1_;
      }
      
      private function _ClanScreen_ClanMembers1_i() : ClanMembers
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
      
      private function _ClanScreen_Component2_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.percentHeight = 100;
         return _loc1_;
      }
      
      private function _ClanScreen_HBox2_i() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.verticalAlign = "middle";
         _loc1_.gap = 10;
         _loc1_.width = 430;
         _loc1_.height = 26;
         _loc1_.children = [this._ClanScreen_Component3_c(),this._ClanScreen_Label3_i(),this._ClanScreen_Component4_c(),this._ClanScreen_HBox3_i()];
         this.memberControls = _loc1_;
         BindingManager.executeBindings(this,"memberControls",this.memberControls);
         return _loc1_;
      }
      
      private function _ClanScreen_Component3_c() : Component
      {
         return new Component();
      }
      
      private function _ClanScreen_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.x = 30;
         _loc1_.y = 335;
         _loc1_.fontSize = 12;
         this._ClanScreen_Label3 = _loc1_;
         BindingManager.executeBindings(this,"_ClanScreen_Label3",this._ClanScreen_Label3);
         return _loc1_;
      }
      
      private function _ClanScreen_Component4_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.percentWidth = 100;
         return _loc1_;
      }
      
      private function _ClanScreen_HBox3_i() : HBox
      {
         var _loc1_:HBox = new HBox();
         this._ClanScreen_HBox3 = _loc1_;
         BindingManager.executeBindings(this,"_ClanScreen_HBox3",this._ClanScreen_HBox3);
         return _loc1_;
      }
      
      private function _ClanScreen_VBox2_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.width = 436;
         _loc1_.height = 306;
         _loc1_.gap = 1;
         _loc1_.children = [this._ClanScreen_ScrollBase1_c(),this._ClanScreen_Container2_c(),this._ClanScreen_Component5_c(),this._ClanScreen_HBox4_c()];
         return _loc1_;
      }
      
      private function _ClanScreen_ScrollBase1_c() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.percentWidth = 100;
         _loc1_.height = 243;
         _loc1_.verticalScrollPolicy = "on";
         _loc1_.horizontalScrollPolicy = "off";
         _loc1_.backgroundColor = 1;
         _loc1_.backgroundAlpha = 0;
         _loc1_.wheelMultiplier = 3;
         _loc1_.children = [this._ClanScreen_VBox3_c()];
         return _loc1_;
      }
      
      private function _ClanScreen_VBox3_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.gap = 1;
         _loc1_.children = [this._ClanScreen_GradientLabel1_i(),this._ClanScreen_ClanBonuses1_i(),this._ClanScreen_GradientLabel2_i(),this._ClanScreen_ClanBonuses2_i()];
         return _loc1_;
      }
      
      private function _ClanScreen_GradientLabel1_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.width = 436;
         _loc1_.height = 20;
         _loc1_.fontSize = 12;
         this._ClanScreen_GradientLabel1 = _loc1_;
         BindingManager.executeBindings(this,"_ClanScreen_GradientLabel1",this._ClanScreen_GradientLabel1);
         return _loc1_;
      }
      
      private function _ClanScreen_ClanBonuses1_i() : ClanBonuses
      {
         var _loc1_:ClanBonuses = new ClanBonuses();
         _loc1_.percentWidth = 100;
         _loc1_.addEventListener("change",this.__clanBonuses_change);
         this.clanBonuses = _loc1_;
         BindingManager.executeBindings(this,"clanBonuses",this.clanBonuses);
         return _loc1_;
      }
      
      public function __clanBonuses_change(event:Event) : void
      {
         this.clanBonusSelected();
      }
      
      private function _ClanScreen_GradientLabel2_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.width = 436;
         _loc1_.height = 20;
         _loc1_.fontSize = 12;
         this._ClanScreen_GradientLabel2 = _loc1_;
         BindingManager.executeBindings(this,"_ClanScreen_GradientLabel2",this._ClanScreen_GradientLabel2);
         return _loc1_;
      }
      
      private function _ClanScreen_ClanBonuses2_i() : ClanBonuses
      {
         var _loc1_:ClanBonuses = new ClanBonuses();
         _loc1_.percentWidth = 100;
         _loc1_.addEventListener("change",this.__memberBonuses_change);
         this.memberBonuses = _loc1_;
         BindingManager.executeBindings(this,"memberBonuses",this.memberBonuses);
         return _loc1_;
      }
      
      public function __memberBonuses_change(event:Event) : void
      {
         this.memberBonusSelected();
      }
      
      private function _ClanScreen_Container2_c() : Container
      {
         var _loc1_:Container = new Container();
         _loc1_.height = 20;
         _loc1_.children = [this._ClanScreen_GradientBox2_c(),this._ClanScreen_Box1_c()];
         return _loc1_;
      }
      
      private function _ClanScreen_GradientBox2_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.width = 436;
         _loc1_.height = 20;
         return _loc1_;
      }
      
      private function _ClanScreen_Box1_c() : Box
      {
         var _loc1_:Box = new Box();
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._ClanScreen_Label4_i(),this._ClanScreen_MoneyRenderer1_i()];
         return _loc1_;
      }
      
      private function _ClanScreen_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.fontSize = 12;
         _loc1_.width = 180;
         _loc1_.height = 20;
         this._ClanScreen_Label4 = _loc1_;
         BindingManager.executeBindings(this,"_ClanScreen_Label4",this._ClanScreen_Label4);
         return _loc1_;
      }
      
      private function _ClanScreen_MoneyRenderer1_i() : MoneyRenderer
      {
         var _loc1_:MoneyRenderer = new MoneyRenderer();
         _loc1_.color = 16777215;
         _loc1_.fontSize = 12;
         this._ClanScreen_MoneyRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_ClanScreen_MoneyRenderer1",this._ClanScreen_MoneyRenderer1);
         return _loc1_;
      }
      
      private function _ClanScreen_Component5_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.percentHeight = 100;
         return _loc1_;
      }
      
      private function _ClanScreen_HBox4_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.verticalAlign = "middle";
         _loc1_.gap = 10;
         _loc1_.width = 430;
         _loc1_.height = 26;
         _loc1_.children = [this._ClanScreen_Component6_c(),this._ClanScreen_Label5_i(),this._ClanScreen_MoneyRenderer2_i(),this._ClanScreen_Component7_c(),this._ClanScreen_Button15_i(),this._ClanScreen_Button16_i()];
         return _loc1_;
      }
      
      private function _ClanScreen_Component6_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.width = 5;
         return _loc1_;
      }
      
      private function _ClanScreen_Label5_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.fontSize = 12;
         this._ClanScreen_Label5 = _loc1_;
         BindingManager.executeBindings(this,"_ClanScreen_Label5",this._ClanScreen_Label5);
         return _loc1_;
      }
      
      private function _ClanScreen_MoneyRenderer2_i() : MoneyRenderer
      {
         var _loc1_:MoneyRenderer = new MoneyRenderer();
         _loc1_.fontSize = 12;
         _loc1_.color = 16777215;
         this._ClanScreen_MoneyRenderer2 = _loc1_;
         BindingManager.executeBindings(this,"_ClanScreen_MoneyRenderer2",this._ClanScreen_MoneyRenderer2);
         return _loc1_;
      }
      
      private function _ClanScreen_Component7_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.percentWidth = 100;
         return _loc1_;
      }
      
      private function _ClanScreen_Button15_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 26;
         _loc1_.addEventListener("click",this.___ClanScreen_Button15_click);
         this._ClanScreen_Button15 = _loc1_;
         BindingManager.executeBindings(this,"_ClanScreen_Button15",this._ClanScreen_Button15);
         return _loc1_;
      }
      
      public function ___ClanScreen_Button15_click(event:MouseEvent) : void
      {
         this.apply();
      }
      
      private function _ClanScreen_Button16_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 26;
         _loc1_.addEventListener("click",this.___ClanScreen_Button16_click);
         this._ClanScreen_Button16 = _loc1_;
         BindingManager.executeBindings(this,"_ClanScreen_Button16",this._ClanScreen_Button16);
         return _loc1_;
      }
      
      public function ___ClanScreen_Button16_click(event:MouseEvent) : void
      {
         this.cancel();
      }
      
      private function _ClanScreen_VBox4_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.width = 436;
         _loc1_.height = 306;
         _loc1_.gap = 1;
         _loc1_.children = [this._ClanScreen_GradientBox3_c(),this._ClanScreen_ClanRecords1_i(),this._ClanScreen_Container3_c(),this._ClanScreen_Component8_c(),this._ClanScreen_HBox6_c()];
         return _loc1_;
      }
      
      private function _ClanScreen_GradientBox3_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.width = 436;
         _loc1_.height = 20;
         _loc1_.children = [this._ClanScreen_Label6_i(),this._ClanScreen_ComboBox1_i()];
         return _loc1_;
      }
      
      private function _ClanScreen_Label6_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         this._ClanScreen_Label6 = _loc1_;
         BindingManager.executeBindings(this,"_ClanScreen_Label6",this._ClanScreen_Label6);
         return _loc1_;
      }
      
      private function _ClanScreen_ComboBox1_i() : ComboBox
      {
         var _loc1_:ComboBox = new ComboBox();
         _loc1_.right = 0;
         _loc1_.selectedIndex = 0;
         this.filterBox = _loc1_;
         BindingManager.executeBindings(this,"filterBox",this.filterBox);
         return _loc1_;
      }
      
      private function _ClanScreen_ClanRecords1_i() : ClanRecords
      {
         var _loc1_:ClanRecords = new ClanRecords();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         this._ClanScreen_ClanRecords1 = _loc1_;
         BindingManager.executeBindings(this,"_ClanScreen_ClanRecords1",this._ClanScreen_ClanRecords1);
         return _loc1_;
      }
      
      private function _ClanScreen_Container3_c() : Container
      {
         var _loc1_:Container = new Container();
         _loc1_.height = 20;
         _loc1_.children = [this._ClanScreen_GradientBox4_c(),this._ClanScreen_HBox5_c()];
         return _loc1_;
      }
      
      private function _ClanScreen_GradientBox4_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.width = 436;
         _loc1_.height = 20;
         return _loc1_;
      }
      
      private function _ClanScreen_HBox5_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._ClanScreen_Label7_i(),this._ClanScreen_MoneyRenderer3_i()];
         return _loc1_;
      }
      
      private function _ClanScreen_Label7_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.fontSize = 12;
         _loc1_.width = 180;
         _loc1_.height = 20;
         this._ClanScreen_Label7 = _loc1_;
         BindingManager.executeBindings(this,"_ClanScreen_Label7",this._ClanScreen_Label7);
         return _loc1_;
      }
      
      private function _ClanScreen_MoneyRenderer3_i() : MoneyRenderer
      {
         var _loc1_:MoneyRenderer = new MoneyRenderer();
         _loc1_.color = 16777215;
         _loc1_.fontSize = 12;
         this._ClanScreen_MoneyRenderer3 = _loc1_;
         BindingManager.executeBindings(this,"_ClanScreen_MoneyRenderer3",this._ClanScreen_MoneyRenderer3);
         return _loc1_;
      }
      
      private function _ClanScreen_Component8_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.height = 12;
         return _loc1_;
      }
      
      private function _ClanScreen_HBox6_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.verticalAlign = "middle";
         _loc1_.gap = 10;
         _loc1_.width = 430;
         _loc1_.height = 26;
         _loc1_.children = [this._ClanScreen_Component9_c(),this._ClanScreen_Label8_i(),this._ClanScreen_CachedImage2_i(),this._ClanScreen_Input1_i(),this._ClanScreen_Component10_c(),this._ClanScreen_Button17_i(),this._ClanScreen_Button18_i()];
         return _loc1_;
      }
      
      private function _ClanScreen_Component9_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.width = 5;
         return _loc1_;
      }
      
      private function _ClanScreen_Label8_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.fontSize = 12;
         this._ClanScreen_Label8 = _loc1_;
         BindingManager.executeBindings(this,"_ClanScreen_Label8",this._ClanScreen_Label8);
         return _loc1_;
      }
      
      private function _ClanScreen_CachedImage2_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.width = 10;
         this._ClanScreen_CachedImage2 = _loc1_;
         BindingManager.executeBindings(this,"_ClanScreen_CachedImage2",this._ClanScreen_CachedImage2);
         return _loc1_;
      }
      
      private function _ClanScreen_Input1_i() : Input
      {
         var _loc1_:Input = new Input();
         _loc1_.width = 70;
         _loc1_.height = 20;
         _loc1_.maxChars = 7;
         _loc1_.restrict = "0-9";
         _loc1_.padding = 5;
         this.depositAmount = _loc1_;
         BindingManager.executeBindings(this,"depositAmount",this.depositAmount);
         return _loc1_;
      }
      
      private function _ClanScreen_Component10_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.percentWidth = 100;
         return _loc1_;
      }
      
      private function _ClanScreen_Button17_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 26;
         _loc1_.addEventListener("click",this.___ClanScreen_Button17_click);
         this._ClanScreen_Button17 = _loc1_;
         BindingManager.executeBindings(this,"_ClanScreen_Button17",this._ClanScreen_Button17);
         return _loc1_;
      }
      
      public function ___ClanScreen_Button17_click(event:MouseEvent) : void
      {
         this.deposit();
      }
      
      private function _ClanScreen_Button18_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 26;
         _loc1_.addEventListener("click",this.___ClanScreen_Button18_click);
         this._ClanScreen_Button18 = _loc1_;
         BindingManager.executeBindings(this,"_ClanScreen_Button18",this._ClanScreen_Button18);
         return _loc1_;
      }
      
      public function ___ClanScreen_Button18_click(event:MouseEvent) : void
      {
         this.clearDeposit();
      }
      
      private function _ClanScreen_ClanStorage1_i() : ClanStorage
      {
         var _loc1_:ClanStorage = new ClanStorage();
         _loc1_.width = 445;
         _loc1_.height = 270;
         this.storage = _loc1_;
         BindingManager.executeBindings(this,"storage",this.storage);
         return _loc1_;
      }
      
      private function _ClanScreen_ClanManage1_i() : ClanManage
      {
         var _loc1_:ClanManage = new ClanManage();
         this.manage = _loc1_;
         BindingManager.executeBindings(this,"manage",this.manage);
         return _loc1_;
      }
      
      public function ___ClanScreen_Container1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _ClanScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = getString("clan.invite");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"inviteBtn.label");
         result[1] = new Binding(this,function():Boolean
         {
            return model.members.length < model.maxMembers;
         },null,"inviteBtn.enabled");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = getString("accept");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"inviteBtn.toolTip");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = getString("clan.kick");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"kickBtn.label");
         result[4] = new Binding(this,function():Boolean
         {
            return memberSelector.selectedMember != null && (model.myMember == memberSelector.selectedMember || hasPermissionToChange(model.myMember,memberSelector.selectedMember));
         },null,"kickBtn.enabled");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = getString("clan.status");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"statusBtn.label");
         result[6] = new Binding(this,function():Boolean
         {
            return memberSelector.selectedMember != null && hasPermissionToChange(model.myMember,memberSelector.selectedMember);
         },null,"statusBtn.enabled");
         result[7] = new Binding(this,function():String
         {
            var _loc1_:* = getString("clan.leave");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"leaveBtn.label");
         result[8] = new Binding(this,function():*
         {
            return model.name;
         },function(param1:*):void
         {
            clanName = param1;
         },"clanName");
         result[9] = new Binding(this,function():Array
         {
            var _loc1_:* = getTabs(model.myMember);
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"bar.dataProvider");
         result[10] = new Binding(this,function():Array
         {
            var _loc1_:* = [getString("clan.members"),getString("clan.bonuses"),getString("clan.treasury"),getString("clan.storage"),getString("clan.manage")];
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"bar.toolTips");
         result[11] = new Binding(this,function():Object
         {
            return Assets.panelSet;
         },null,"_ClanScreen_CachedImage1.source");
         result[12] = new Binding(this,function():int
         {
            return bar.selectedIndex;
         },null,"_ClanScreen_ViewStack1.selectedIndex");
         result[13] = new Binding(this,function():String
         {
            var _loc1_:* = getString("clan.nick");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanScreen_Label1.text");
         result[14] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_ClanScreen_Label1.color");
         result[15] = new Binding(this,function():String
         {
            var _loc1_:* = getString("clan.status");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanScreen_Label2.text");
         result[16] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_ClanScreen_Label2.color");
         result[17] = new Binding(this,function():Array
         {
            var _loc1_:* = model.members;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"memberSelector.dataProvider");
         result[18] = new Binding(this,function():String
         {
            var _loc1_:* = model.members.length + "/" + model.maxMembers;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanScreen_Label3.text");
         result[19] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_ClanScreen_Label3.color");
         result[20] = new Binding(this,function():Array
         {
            var _loc1_:* = getButtons(model.myMember.clanRole);
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_ClanScreen_HBox3.children");
         result[21] = new Binding(this,function():String
         {
            var _loc1_:* = getString("clan.bonusesForClan");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanScreen_GradientLabel1.text");
         result[22] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_ClanScreen_GradientLabel1.color");
         result[23] = new Binding(this,function():Array
         {
            var _loc1_:* = model.clanBonuses;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"clanBonuses.dataPovider");
         result[24] = new Binding(this,function():String
         {
            var _loc1_:* = getString("clan.bonusesForMembers");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanScreen_GradientLabel2.text");
         result[25] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_ClanScreen_GradientLabel2.color");
         result[26] = new Binding(this,function():Array
         {
            var _loc1_:* = model.memberBonuses;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"memberBonuses.dataPovider");
         result[27] = new Binding(this,function():String
         {
            var _loc1_:* = getString("clan.balance") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanScreen_Label4.text");
         result[28] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_ClanScreen_Label4.color");
         result[29] = new Binding(this,function():String
         {
            var _loc1_:* = CurrencyType.RUBIES;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanScreen_MoneyRenderer1.type");
         result[30] = new Binding(this,function():uint
         {
            return model.rubies;
         },null,"_ClanScreen_MoneyRenderer1.value");
         result[31] = new Binding(this,function():String
         {
            var _loc1_:* = getString("clan.upgradeCost") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanScreen_Label5.text");
         result[32] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_ClanScreen_Label5.color");
         result[33] = new Binding(this,function():String
         {
            var _loc1_:* = CurrencyType.RUBIES;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanScreen_MoneyRenderer2.type");
         result[34] = new Binding(this,function():uint
         {
            return selectedBonus.cost;
         },null,"_ClanScreen_MoneyRenderer2.value");
         result[35] = new Binding(this,function():Object
         {
            return Icons.accept;
         },null,"_ClanScreen_Button15.icon");
         result[36] = new Binding(this,function():String
         {
            var _loc1_:* = getString("accept");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanScreen_Button15.toolTip");
         result[37] = new Binding(this,function():Boolean
         {
            return model.myMember.clanRole.hasPermission(ClanPermission.MANAGE_BONUSES) && selectedBonus != null && selectedBonus.cost <= model.rubies;
         },null,"_ClanScreen_Button15.enabled");
         result[38] = new Binding(this,function():Object
         {
            return Icons.cancel;
         },null,"_ClanScreen_Button16.icon");
         result[39] = new Binding(this,function():String
         {
            var _loc1_:* = getString("cancel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanScreen_Button16.toolTip");
         result[40] = new Binding(this,function():Boolean
         {
            return selectedBonus != null;
         },null,"_ClanScreen_Button16.enabled");
         result[41] = new Binding(this,function():String
         {
            var _loc1_:* = getString("clan.records.filter");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanScreen_Label6.text");
         result[42] = new Binding(this,function():Array
         {
            var _loc1_:* = ClanRecordType.getFilters();
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"filterBox.dataProvider");
         result[43] = new Binding(this,function():Array
         {
            var _loc1_:* = model.log;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_ClanScreen_ClanRecords1.dataProvider");
         result[44] = new Binding(this,function():String
         {
            var _loc1_:* = filterBox.selectedItem.data;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanScreen_ClanRecords1.filter");
         result[45] = new Binding(this,function():String
         {
            var _loc1_:* = getString("clan.balance") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanScreen_Label7.text");
         result[46] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_ClanScreen_Label7.color");
         result[47] = new Binding(this,function():String
         {
            var _loc1_:* = CurrencyType.RUBIES;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanScreen_MoneyRenderer3.type");
         result[48] = new Binding(this,function():uint
         {
            return model.rubies;
         },null,"_ClanScreen_MoneyRenderer3.value");
         result[49] = new Binding(this,function():String
         {
            var _loc1_:* = getString("clan.deposit") + ": ";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanScreen_Label8.text");
         result[50] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_ClanScreen_Label8.color");
         result[51] = new Binding(this,function():Object
         {
            return Currency.RUBIES;
         },null,"_ClanScreen_CachedImage2.source");
         result[52] = new Binding(this,function():Object
         {
            return Assets.chatInput;
         },null,"depositAmount.borderSkin");
         result[53] = new Binding(this,function():Object
         {
            return Icons.accept;
         },null,"_ClanScreen_Button17.icon");
         result[54] = new Binding(this,function():String
         {
            var _loc1_:* = getString("accept");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanScreen_Button17.toolTip");
         result[55] = new Binding(this,function():Boolean
         {
            return uint(depositAmount.text) > 0 && uint(depositAmount.text) <= characterModel.currencies[CurrencyType.RUBIES];
         },null,"_ClanScreen_Button17.enabled");
         result[56] = new Binding(this,function():Object
         {
            return Icons.cancel;
         },null,"_ClanScreen_Button18.icon");
         result[57] = new Binding(this,function():String
         {
            var _loc1_:* = getString("cancel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClanScreen_Button18.toolTip");
         result[58] = new Binding(this,function():Boolean
         {
            return uint(depositAmount.text) > 0;
         },null,"_ClanScreen_Button18.enabled");
         result[59] = new Binding(this,null,null,"storage.model","model");
         result[60] = new Binding(this,null,null,"manage.model","model");
         result[61] = new Binding(this,null,null,"manage.characterModel","characterModel");
         return result;
      }
      
      private function _ClanScreen_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         this.clanName = this.model.name;
      }
      
      [Bindable(event="propertyChange")]
      public function get bar() : SimpleImageBar
      {
         return this._97299bar;
      }
      
      public function set bar(param1:SimpleImageBar) : void
      {
         var _loc2_:Object = this._97299bar;
         if(_loc2_ !== param1)
         {
            this._97299bar = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bar",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get clanBonuses() : ClanBonuses
      {
         return this._618239529clanBonuses;
      }
      
      public function set clanBonuses(param1:ClanBonuses) : void
      {
         var _loc2_:Object = this._618239529clanBonuses;
         if(_loc2_ !== param1)
         {
            this._618239529clanBonuses = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clanBonuses",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get depositAmount() : Input
      {
         return this._407477098depositAmount;
      }
      
      public function set depositAmount(param1:Input) : void
      {
         var _loc2_:Object = this._407477098depositAmount;
         if(_loc2_ !== param1)
         {
            this._407477098depositAmount = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"depositAmount",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get filterBox() : ComboBox
      {
         return this._881400013filterBox;
      }
      
      public function set filterBox(param1:ComboBox) : void
      {
         var _loc2_:Object = this._881400013filterBox;
         if(_loc2_ !== param1)
         {
            this._881400013filterBox = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"filterBox",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get inviteBtn() : Button1
      {
         return this._1901031789inviteBtn;
      }
      
      public function set inviteBtn(param1:Button1) : void
      {
         var _loc2_:Object = this._1901031789inviteBtn;
         if(_loc2_ !== param1)
         {
            this._1901031789inviteBtn = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inviteBtn",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get kickBtn() : Button1
      {
         return this._720609738kickBtn;
      }
      
      public function set kickBtn(param1:Button1) : void
      {
         var _loc2_:Object = this._720609738kickBtn;
         if(_loc2_ !== param1)
         {
            this._720609738kickBtn = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"kickBtn",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get leaveBtn() : Button1
      {
         return this._1577592869leaveBtn;
      }
      
      public function set leaveBtn(param1:Button1) : void
      {
         var _loc2_:Object = this._1577592869leaveBtn;
         if(_loc2_ !== param1)
         {
            this._1577592869leaveBtn = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leaveBtn",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get manage() : ClanManage
      {
         return this._1081434779manage;
      }
      
      public function set manage(param1:ClanManage) : void
      {
         var _loc2_:Object = this._1081434779manage;
         if(_loc2_ !== param1)
         {
            this._1081434779manage = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"manage",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get memberBonuses() : ClanBonuses
      {
         return this._1465029357memberBonuses;
      }
      
      public function set memberBonuses(param1:ClanBonuses) : void
      {
         var _loc2_:Object = this._1465029357memberBonuses;
         if(_loc2_ !== param1)
         {
            this._1465029357memberBonuses = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"memberBonuses",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get memberControls() : HBox
      {
         return this._724370576memberControls;
      }
      
      public function set memberControls(param1:HBox) : void
      {
         var _loc2_:Object = this._724370576memberControls;
         if(_loc2_ !== param1)
         {
            this._724370576memberControls = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"memberControls",_loc2_,param1));
            }
         }
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
      public function get statusBtn() : Button1
      {
         return this._2070226678statusBtn;
      }
      
      public function set statusBtn(param1:Button1) : void
      {
         var _loc2_:Object = this._2070226678statusBtn;
         if(_loc2_ !== param1)
         {
            this._2070226678statusBtn = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statusBtn",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get storage() : ClanStorage
      {
         return this._1884274053storage;
      }
      
      public function set storage(param1:ClanStorage) : void
      {
         var _loc2_:Object = this._1884274053storage;
         if(_loc2_ !== param1)
         {
            this._1884274053storage = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"storage",_loc2_,param1));
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
      private function get selectedBonus() : ClanBonus
      {
         return this._1429644868selectedBonus;
      }
      
      private function set selectedBonus(param1:ClanBonus) : void
      {
         var _loc2_:Object = this._1429644868selectedBonus;
         if(_loc2_ !== param1)
         {
            this._1429644868selectedBonus = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedBonus",_loc2_,param1));
            }
         }
      }
   }
}

