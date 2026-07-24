package soul.view.interaction.social
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
   import soul.event.SimpleUIEvent;
   import soul.event.SocialEvent;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.ui.Input;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   import soul.view.ui.controls.Window;
   
   use namespace mx_internal;
   
   public class NickPrompt extends Window implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _NickPrompt_Button11:Button1;
      
      public var _NickPrompt_Label1:Label;
      
      private var _97739box:VBox;
      
      private var _3381091nick:Input;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function NickPrompt()
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
         bindings = this._NickPrompt_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_social_NickPromptWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return NickPrompt[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.children = [this._NickPrompt_VBox1_i()];
         this.addEventListener("creationComplete",this.___NickPrompt_Window1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         NickPrompt._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         this.nick.setFocus();
      }
      
      override public function tryToConfirm(e:Event) : void
      {
         e.stopImmediatePropagation();
         this.onConfirm();
      }
      
      private function onConfirm() : void
      {
         var ne:SocialEvent = new SocialEvent(SocialEvent.ADD);
         ne.characterName = this.nick.text;
         dispatchEvent(ne);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _NickPrompt_VBox1_i() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.gap = 4;
         _loc1_.horizontalAlign = "center";
         _loc1_.padding = 10;
         _loc1_.children = [this._NickPrompt_Label1_i(),this._NickPrompt_Input1_i(),this._NickPrompt_Button11_i()];
         this.box = _loc1_;
         BindingManager.executeBindings(this,"box",this.box);
         return _loc1_;
      }
      
      private function _NickPrompt_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         this._NickPrompt_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_NickPrompt_Label1",this._NickPrompt_Label1);
         return _loc1_;
      }
      
      private function _NickPrompt_Input1_i() : Input
      {
         var _loc1_:Input = new Input();
         _loc1_.width = 157;
         _loc1_.height = 20;
         _loc1_.align = "center";
         _loc1_.fontSize = 12;
         this.nick = _loc1_;
         BindingManager.executeBindings(this,"nick",this.nick);
         return _loc1_;
      }
      
      private function _NickPrompt_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.padding = 5;
         _loc1_.addEventListener("click",this.___NickPrompt_Button11_click);
         this._NickPrompt_Button11 = _loc1_;
         BindingManager.executeBindings(this,"_NickPrompt_Button11",this._NickPrompt_Button11);
         return _loc1_;
      }
      
      public function ___NickPrompt_Button11_click(event:MouseEvent) : void
      {
         this.onConfirm();
      }
      
      public function ___NickPrompt_Window1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _NickPrompt_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = getString("social.enterNick");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_NickPrompt_Label1.text");
         result[1] = new Binding(this,function():Object
         {
            return Assets.chatInput;
         },null,"nick.borderSkin");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = getString("social.add");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_NickPrompt_Button11.label");
         result[3] = new Binding(this,function():Boolean
         {
            return nick.text.length > 0;
         },null,"_NickPrompt_Button11.enabled");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get box() : VBox
      {
         return this._97739box;
      }
      
      public function set box(param1:VBox) : void
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
   }
}

