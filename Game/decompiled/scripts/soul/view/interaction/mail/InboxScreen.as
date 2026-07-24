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
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.interaction.mail.Mail;
   import soul.model.interaction.mail.MailModel;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.common.Icons;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Canvas;
   import soul.view.ui.HBox;
   import soul.view.ui.ScrollBase;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class InboxScreen extends VBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _InboxScreen_CachedImage1:CachedImage;
      
      private var _3029410body:BodyRenderer;
      
      private var _97739box:BorderedContainer;
      
      private var _358736719deleteBtn:Button1;
      
      private var _10520843mailList:MailList;
      
      private var _934979389reader:Canvas;
      
      private var _108401386reply:Button1;
      
      private var _104069929model:MailModel;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function InboxScreen()
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
         bindings = this._InboxScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_mail_InboxScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return InboxScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.gap = 5;
         this.children = [this._InboxScreen_BorderedContainer1_i()];
         this._InboxScreen_Canvas1_i();
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         InboxScreen._watcherSetupUtil = param1;
      }
      
      public function set selectedMail(value:Mail) : void
      {
         if(value == null)
         {
            if(this.box.contains(this.reader))
            {
               this.box.removeChild(this.reader);
            }
         }
         else
         {
            if(!this.box.contains(this.reader))
            {
               this.box.addChild(this.reader);
            }
            this.body.mail = value;
         }
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _InboxScreen_Canvas1_i() : Canvas
      {
         var _loc1_:Canvas = null;
         _loc1_ = new Canvas();
         _loc1_.width = 310;
         _loc1_.height = 396;
         _loc1_.children = [this._InboxScreen_CachedImage1_i(),this._InboxScreen_VBox2_c()];
         this.reader = _loc1_;
         BindingManager.executeBindings(this,"reader",this.reader);
         return _loc1_;
      }
      
      private function _InboxScreen_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._InboxScreen_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_InboxScreen_CachedImage1",this._InboxScreen_CachedImage1);
         return _loc1_;
      }
      
      private function _InboxScreen_VBox2_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.horizontalAlign = "right";
         _loc1_.gap = 10;
         _loc1_.children = [this._InboxScreen_BodyRenderer1_i(),this._InboxScreen_HBox1_c()];
         return _loc1_;
      }
      
      private function _InboxScreen_BodyRenderer1_i() : BodyRenderer
      {
         var _loc1_:BodyRenderer = new BodyRenderer();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         this.body = _loc1_;
         BindingManager.executeBindings(this,"body",this.body);
         return _loc1_;
      }
      
      private function _InboxScreen_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 5;
         _loc1_.children = [this._InboxScreen_Button11_i(),this._InboxScreen_Button12_i()];
         return _loc1_;
      }
      
      private function _InboxScreen_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 27;
         this.reply = _loc1_;
         BindingManager.executeBindings(this,"reply",this.reply);
         return _loc1_;
      }
      
      private function _InboxScreen_Button12_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 27;
         this.deleteBtn = _loc1_;
         BindingManager.executeBindings(this,"deleteBtn",this.deleteBtn);
         return _loc1_;
      }
      
      private function _InboxScreen_BorderedContainer1_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.padding = 10;
         _loc1_.gap = 10;
         _loc1_.children = [this._InboxScreen_ScrollBase1_c()];
         this.box = _loc1_;
         BindingManager.executeBindings(this,"box",this.box);
         return _loc1_;
      }
      
      private function _InboxScreen_ScrollBase1_c() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.width = 309;
         _loc1_.height = 396;
         _loc1_.verticalScrollPolicy = "auto";
         _loc1_.children = [this._InboxScreen_MailList1_i()];
         return _loc1_;
      }
      
      private function _InboxScreen_MailList1_i() : MailList
      {
         var _loc1_:MailList = new MailList();
         _loc1_.percentWidth = 100;
         _loc1_.maxHeight = 355;
         _loc1_.gap = 4;
         this.mailList = _loc1_;
         BindingManager.executeBindings(this,"mailList",this.mailList);
         return _loc1_;
      }
      
      private function _InboxScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return Assets.mailBackground;
         },null,"_InboxScreen_CachedImage1.source");
         result[1] = new Binding(this,function():Object
         {
            return Icons.reply;
         },null,"reply.icon");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = getString("mail.reply");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"reply.toolTip");
         result[3] = new Binding(this,function():Boolean
         {
            return mailList.selectedMail.plainText;
         },null,"reply.enabled");
         result[4] = new Binding(this,function():Object
         {
            return Icons.cancel;
         },null,"deleteBtn.icon");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = getString("mail.delete");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"deleteBtn.toolTip");
         result[6] = new Binding(this,function():*
         {
            return mailList.selectedMail;
         },function(param1:*):void
         {
            selectedMail = param1;
         },"selectedMail");
         result[7] = new Binding(this,function():Object
         {
            return Assets.shadedBorderRound;
         },null,"box.borderSkin");
         result[8] = new Binding(this,function():Object
         {
            return Assets.pattern_06;
         },null,"box.backgroundImage");
         result[9] = new Binding(this,function():Array
         {
            var _loc1_:* = model.inbox;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"mailList.inbox");
         return result;
      }
      
      private function _InboxScreen_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         this.selectedMail = this.mailList.selectedMail;
      }
      
      [Bindable(event="propertyChange")]
      public function get body() : BodyRenderer
      {
         return this._3029410body;
      }
      
      public function set body(param1:BodyRenderer) : void
      {
         var _loc2_:Object = this._3029410body;
         if(_loc2_ !== param1)
         {
            this._3029410body = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"body",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get box() : BorderedContainer
      {
         return this._97739box;
      }
      
      public function set box(param1:BorderedContainer) : void
      {
         var _loc2_:Object = this._97739box;
         if(_loc2_ !== param1)
         {
            this._97739box = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"box",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get deleteBtn() : Button1
      {
         return this._358736719deleteBtn;
      }
      
      public function set deleteBtn(param1:Button1) : void
      {
         var _loc2_:Object = this._358736719deleteBtn;
         if(_loc2_ !== param1)
         {
            this._358736719deleteBtn = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"deleteBtn",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mailList() : MailList
      {
         return this._10520843mailList;
      }
      
      public function set mailList(param1:MailList) : void
      {
         var _loc2_:Object = this._10520843mailList;
         if(_loc2_ !== param1)
         {
            this._10520843mailList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mailList",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get reader() : Canvas
      {
         return this._934979389reader;
      }
      
      public function set reader(param1:Canvas) : void
      {
         var _loc2_:Object = this._934979389reader;
         if(_loc2_ !== param1)
         {
            this._934979389reader = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"reader",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get reply() : Button1
      {
         return this._108401386reply;
      }
      
      public function set reply(param1:Button1) : void
      {
         var _loc2_:Object = this._108401386reply;
         if(_loc2_ !== param1)
         {
            this._108401386reply = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"reply",_loc2_,param1));
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
   }
}

