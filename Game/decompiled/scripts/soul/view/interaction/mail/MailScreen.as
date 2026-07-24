package soul.view.interaction.mail
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
   import mx.events.ItemClickEvent;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.event.MailEvent;
   import soul.event.SimpleUIEvent;
   import soul.model.character.CharacterModel;
   import soul.model.interaction.mail.Mail;
   import soul.model.interaction.mail.MailModel;
   import soul.view.assets.SimpleImageBar;
   import soul.view.common.TabIcons;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.VBox;
   import soul.view.ui.ViewStack;
   
   use namespace mx_internal;
   
   public class MailScreen extends VBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const TABS:Array = [[TabIcons.inbox0,TabIcons.inbox1],[TabIcons.compose0,TabIcons.compose1]];
      
      public var _MailScreen_ViewStack1:ViewStack;
      
      private var _97299bar:SimpleImageBar;
      
      private var _950497682compose:ComposeScreen;
      
      private var _100344454inbox:InboxScreen;
      
      private var _104069929model:MailModel;
      
      private var _340320640characterModel:CharacterModel;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function MailScreen()
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
         bindings = this._MailScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_mail_MailScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return MailScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.padding = 10;
         this.children = [this._MailScreen_SimpleImageBar1_i(),this._MailScreen_ViewStack1_i()];
         this.addEventListener("creationComplete",this.___MailScreen_VBox1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         MailScreen._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         InteractionWindow.findInteractionParent(this).label = this.getString("mail.title");
         this.bar.toolTips = [this.getString("mail.inbox"),this.getString("mail.compose")];
         addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
         this.inbox.mailList.addEventListener(MailList.MAIL_SELECTED,this.mailSelected,false,0,true);
         this.inbox.body.addEventListener(ItemClickEvent.ITEM_CLICK,this.onTake,false,0,true);
         this.inbox.reply.addEventListener(MouseEvent.CLICK,this.onReply,false,0,true);
         this.inbox.deleteBtn.addEventListener(MouseEvent.CLICK,this.onDelete,false,0,true);
         this.compose.addEventListener(Event.CLOSE,this.composeClose,false,0,true);
      }
      
      private function removed(e:Event) : void
      {
         if(e.target != this)
         {
            return;
         }
         this.inbox.mailList.removeEventListener(MailList.MAIL_SELECTED,this.mailSelected);
         this.inbox.body.removeEventListener(ItemClickEvent.ITEM_CLICK,this.onTake);
         this.inbox.reply.removeEventListener(MouseEvent.CLICK,this.onReply);
         this.inbox.deleteBtn.removeEventListener(MouseEvent.CLICK,this.onDelete);
         this.compose.removeEventListener(Event.CLOSE,this.composeClose);
         this.compose.clean();
      }
      
      private function mailSelected(e:Event) : void
      {
         var ne:MailEvent = new MailEvent(MailEvent.READ);
         if(!this.inbox.mailList.selectedMail)
         {
            return;
         }
         this.inbox.mailList.selectedMail.read = true;
         ne.mailId = this.inbox.mailList.selectedMail.id;
         this.model.dispatchEvent(ne);
      }
      
      private function onTake(e:ItemClickEvent) : void
      {
         var ne:MailEvent = new MailEvent(MailEvent.TAKE);
         ne.mailId = this.inbox.mailList.selectedMail.id;
         ne.itemIndex = e.index;
         this.model.dispatchEvent(ne);
      }
      
      private function onReply(e:Event) : void
      {
         var m:Mail = this.inbox.mailList.selectedMail;
         this.compose.recipient.text = m.from;
         this.compose.subject.text = "Re: " + m.subject;
         this.bar.selectedIndex = 1;
      }
      
      private function onDelete(e:Event) : void
      {
         var ne:MailEvent = new MailEvent(MailEvent.DELETE);
         ne.mailId = this.inbox.mailList.selectedMail.id;
         this.model.dispatchEvent(ne);
      }
      
      private function composeClose(e:Event) : void
      {
         this.bar.selectedIndex = 0;
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _MailScreen_SimpleImageBar1_i() : SimpleImageBar
      {
         var _loc1_:SimpleImageBar = new SimpleImageBar();
         _loc1_.selectedIndex = 0;
         this.bar = _loc1_;
         BindingManager.executeBindings(this,"bar",this.bar);
         return _loc1_;
      }
      
      private function _MailScreen_ViewStack1_i() : ViewStack
      {
         var _loc1_:ViewStack = new ViewStack();
         _loc1_.backgroundColor = 16711680;
         _loc1_.children = [this._MailScreen_InboxScreen1_i(),this._MailScreen_ComposeScreen1_i()];
         this._MailScreen_ViewStack1 = _loc1_;
         BindingManager.executeBindings(this,"_MailScreen_ViewStack1",this._MailScreen_ViewStack1);
         return _loc1_;
      }
      
      private function _MailScreen_InboxScreen1_i() : InboxScreen
      {
         var _loc1_:InboxScreen = new InboxScreen();
         this.inbox = _loc1_;
         BindingManager.executeBindings(this,"inbox",this.inbox);
         return _loc1_;
      }
      
      private function _MailScreen_ComposeScreen1_i() : ComposeScreen
      {
         var _loc1_:ComposeScreen = new ComposeScreen();
         this.compose = _loc1_;
         BindingManager.executeBindings(this,"compose",this.compose);
         return _loc1_;
      }
      
      public function ___MailScreen_VBox1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _MailScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Array
         {
            var _loc1_:* = TABS;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"bar.dataProvider");
         result[1] = new Binding(this,function():int
         {
            return bar.selectedIndex;
         },null,"_MailScreen_ViewStack1.selectedIndex");
         result[2] = new Binding(this,null,null,"inbox.model","model");
         result[3] = new Binding(this,null,null,"compose.model","model");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = characterModel.name;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"compose.characterName");
         return result;
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
      public function get compose() : ComposeScreen
      {
         return this._950497682compose;
      }
      
      public function set compose(param1:ComposeScreen) : void
      {
         var _loc2_:Object = this._950497682compose;
         if(_loc2_ !== param1)
         {
            this._950497682compose = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"compose",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get inbox() : InboxScreen
      {
         return this._100344454inbox;
      }
      
      public function set inbox(param1:InboxScreen) : void
      {
         var _loc2_:Object = this._100344454inbox;
         if(_loc2_ !== param1)
         {
            this._100344454inbox = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inbox",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get model() : MailModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:MailModel) : void
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
   }
}

