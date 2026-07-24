package soul.view.login
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
   import soul.controller.Interaction;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.event.GameEvent;
   import soul.event.SimpleUIEvent;
   import soul.model.GameModel;
   import soul.model.common.InteractionType;
   import soul.model.system.Configuration;
   import soul.view.assets.Button1;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class LogoutScreen extends VBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const bundles:Array = [BundleName.INTERFACE,BundleName.CONTROLS];
      
      public var _LogoutScreen_Label1:Label;
      
      private var _1092797764closeBtn:Button1;
      
      private var _1315418018exitBtn:Button1;
      
      public var model:GameModel;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function LogoutScreen()
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
         bindings = this._LogoutScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_login_LogoutScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return LogoutScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 280;
         this.height = 120;
         this.gap = 10;
         this.padding = 10;
         this.horizontalAlign = "center";
         this.verticalAlign = "middle";
         this.children = [this._LogoutScreen_Label1_i(),this._LogoutScreen_HBox1_c()];
         this.addEventListener("creationComplete",this.___LogoutScreen_VBox1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         LogoutScreen._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         InteractionWindow.findInteractionParent(this).label = this.getString("logout.title");
         addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
         this.exitBtn.addEventListener(MouseEvent.CLICK,this.exitPressed);
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.closePressed);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
      }
      
      private function removed(e:Event) : void
      {
         if(e.target != this)
         {
            return;
         }
         this.exitBtn.removeEventListener(MouseEvent.CLICK,this.exitPressed);
         this.closeBtn.removeEventListener(MouseEvent.CLICK,this.closePressed);
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
      }
      
      private function onKeyUp(e:KeyboardEvent) : void
      {
         if(e.keyCode == Keyboard.ESCAPE)
         {
            this.closePressed(null);
         }
         else if(e.keyCode == Keyboard.ENTER)
         {
            this.exitPressed(null);
         }
      }
      
      private function logoutPressed(e:Event) : void
      {
         Interaction.hide(InteractionType.LOGOUT);
         this.model.dispatchEvent(new GameEvent(GameEvent.CHARACTER_LOGOUT));
      }
      
      private function exitPressed(e:Event) : void
      {
         Interaction.hide(InteractionType.LOGOUT);
         this.model.dispatchEvent(new Event(GameEvent.USER_LOGOUT));
      }
      
      private function closePressed(e:Event) : void
      {
         Interaction.hide(InteractionType.LOGOUT);
      }
      
      private function getString(key:String) : String
      {
         var bundle:String = null;
         var str:String = null;
         for each(bundle in bundles)
         {
            str = LocaleManager.getString(bundle,key);
            if(str != key)
            {
               return str;
            }
         }
         return key;
      }
      
      private function _LogoutScreen_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.multiline = true;
         _loc1_.wordWrap = true;
         this._LogoutScreen_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_LogoutScreen_Label1",this._LogoutScreen_Label1);
         return _loc1_;
      }
      
      private function _LogoutScreen_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 5;
         _loc1_.children = [this._LogoutScreen_Button11_i(),this._LogoutScreen_Button12_i()];
         return _loc1_;
      }
      
      private function _LogoutScreen_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.padding = 5;
         _loc1_.width = 100;
         this.exitBtn = _loc1_;
         BindingManager.executeBindings(this,"exitBtn",this.exitBtn);
         return _loc1_;
      }
      
      private function _LogoutScreen_Button12_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.padding = 5;
         _loc1_.width = 100;
         this.closeBtn = _loc1_;
         BindingManager.executeBindings(this,"closeBtn",this.closeBtn);
         return _loc1_;
      }
      
      public function ___LogoutScreen_VBox1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _LogoutScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = StringUtil.substitute(getString("logout.text"),int(Configuration.logoutTimeout / 1000));
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LogoutScreen_Label1.htmlText");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = getString("yesLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"exitBtn.label");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = getString("noLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"closeBtn.label");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get closeBtn() : Button1
      {
         return this._1092797764closeBtn;
      }
      
      public function set closeBtn(param1:Button1) : void
      {
         var _loc2_:Object = this._1092797764closeBtn;
         if(_loc2_ !== param1)
         {
            this._1092797764closeBtn = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"closeBtn",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get exitBtn() : Button1
      {
         return this._1315418018exitBtn;
      }
      
      public function set exitBtn(param1:Button1) : void
      {
         var _loc2_:Object = this._1315418018exitBtn;
         if(_loc2_ !== param1)
         {
            this._1315418018exitBtn = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"exitBtn",_loc2_,param1));
            }
         }
      }
   }
}

