package soul.view.avatar
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
   import soul.model.avatar.Avatar;
   import soul.model.common.InteractionType;
   import soul.net.ServerLayer;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientBox;
   import soul.view.common.CurrencyType;
   import soul.view.common.Icons;
   import soul.view.common.MoneyRenderer;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.Box;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Component;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.ScrollBase;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class AvatarScreen extends Box implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const SERVICE:String = "avatarService";
      
      public var _AvatarScreen_BorderedContainer1:BorderedContainer;
      
      public var _AvatarScreen_Button11:Button1;
      
      public var _AvatarScreen_CachedImage1:CachedImage;
      
      public var _AvatarScreen_CachedImage2:CachedImage;
      
      public var _AvatarScreen_HBox5:HBox;
      
      public var _AvatarScreen_Label1:Label;
      
      public var _AvatarScreen_Label2:Label;
      
      public var _AvatarScreen_Label3:Label;
      
      private var _3059661cost:MoneyRenderer;
      
      private var _1557690022moneyAvatars:AvatarTile;
      
      private var _208077568rubyAvatars:AvatarTile;
      
      private var _1346764756selectedAvatar:Avatar;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function AvatarScreen()
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
         bindings = this._AvatarScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_avatar_AvatarScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return AvatarScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 564;
         this.height = 415;
         this.padding = 9;
         this.children = [this._AvatarScreen_BorderedContainer1_i()];
         this.addEventListener("creationComplete",this.___AvatarScreen_Box1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         AvatarScreen._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         addEventListener(Event.COMPLETE,this.accept);
         InteractionWindow.findInteractionParent(this).label = this.getString("avatars.title");
         ServerLayer.call(SERVICE,"getAvatars",this.setAvatars);
      }
      
      private function setAvatars(r:Array) : void
      {
         var avatar:Avatar = null;
         var rubies:Vector.<Avatar> = new Vector.<Avatar>();
         var coppers:Vector.<Avatar> = new Vector.<Avatar>();
         for each(avatar in r)
         {
            if(avatar.currency == CurrencyType.RUBIES)
            {
               rubies.push(avatar);
            }
            else
            {
               coppers.push(avatar);
            }
         }
         this.rubyAvatars.dataProvider = rubies;
         this.moneyAvatars.dataProvider = coppers;
      }
      
      private function onMoneyChange() : void
      {
         this.rubyAvatars.unselect();
         this.selectedAvatar = this.moneyAvatars.selectedAvatar;
      }
      
      private function onRubyChange() : void
      {
         this.moneyAvatars.unselect();
         this.selectedAvatar = this.rubyAvatars.selectedAvatar;
      }
      
      private function accept(e:Event) : void
      {
         if(!this.selectedAvatar)
         {
            return;
         }
         ServerLayer.call(SERVICE,"buy",this.avatarUpdated,null,this.selectedAvatar.path);
      }
      
      private function avatarUpdated(r:* = null) : void
      {
         this.close();
      }
      
      private function close() : void
      {
         Interaction.hide(InteractionType.AVATARS);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _AvatarScreen_BorderedContainer1_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.padding = 3;
         _loc1_.gap = 5;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.direction = "vertical";
         _loc1_.children = [this._AvatarScreen_HBox1_c(),this._AvatarScreen_GradientBox3_c(),this._AvatarScreen_Component6_c()];
         this._AvatarScreen_BorderedContainer1 = _loc1_;
         BindingManager.executeBindings(this,"_AvatarScreen_BorderedContainer1",this._AvatarScreen_BorderedContainer1);
         return _loc1_;
      }
      
      private function _AvatarScreen_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.children = [this._AvatarScreen_ScrollBase1_c(),this._AvatarScreen_Component2_c()];
         return _loc1_;
      }
      
      private function _AvatarScreen_ScrollBase1_c() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.verticalScrollPolicy = "on";
         _loc1_.children = [this._AvatarScreen_VBox1_c()];
         return _loc1_;
      }
      
      private function _AvatarScreen_VBox1_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.gap = 5;
         _loc1_.padding = 10;
         _loc1_.children = [this._AvatarScreen_Component1_c(),this._AvatarScreen_GradientBox1_c(),this._AvatarScreen_AvatarTile1_i(),this._AvatarScreen_GradientBox2_c(),this._AvatarScreen_AvatarTile2_i()];
         return _loc1_;
      }
      
      private function _AvatarScreen_Component1_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.height = -15;
         return _loc1_;
      }
      
      private function _AvatarScreen_GradientBox1_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 25;
         _loc1_.bgPaddingLeft = -10;
         _loc1_.children = [this._AvatarScreen_HBox2_c()];
         return _loc1_;
      }
      
      private function _AvatarScreen_HBox2_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.verticalCenter = 0;
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._AvatarScreen_CachedImage1_i(),this._AvatarScreen_Label1_i()];
         return _loc1_;
      }
      
      private function _AvatarScreen_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._AvatarScreen_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_AvatarScreen_CachedImage1",this._AvatarScreen_CachedImage1);
         return _loc1_;
      }
      
      private function _AvatarScreen_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.fontSize = 12;
         this._AvatarScreen_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_AvatarScreen_Label1",this._AvatarScreen_Label1);
         return _loc1_;
      }
      
      private function _AvatarScreen_AvatarTile1_i() : AvatarTile
      {
         var _loc1_:AvatarTile = new AvatarTile();
         _loc1_.percentWidth = 100;
         _loc1_.addEventListener("change",this.__moneyAvatars_change);
         this.moneyAvatars = _loc1_;
         BindingManager.executeBindings(this,"moneyAvatars",this.moneyAvatars);
         return _loc1_;
      }
      
      public function __moneyAvatars_change(event:Event) : void
      {
         this.onMoneyChange();
      }
      
      private function _AvatarScreen_GradientBox2_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 25;
         _loc1_.bgPaddingLeft = -10;
         _loc1_.children = [this._AvatarScreen_HBox3_c()];
         return _loc1_;
      }
      
      private function _AvatarScreen_HBox3_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.verticalCenter = 0;
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._AvatarScreen_CachedImage2_i(),this._AvatarScreen_Label2_i()];
         return _loc1_;
      }
      
      private function _AvatarScreen_CachedImage2_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._AvatarScreen_CachedImage2 = _loc1_;
         BindingManager.executeBindings(this,"_AvatarScreen_CachedImage2",this._AvatarScreen_CachedImage2);
         return _loc1_;
      }
      
      private function _AvatarScreen_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.fontSize = 12;
         this._AvatarScreen_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_AvatarScreen_Label2",this._AvatarScreen_Label2);
         return _loc1_;
      }
      
      private function _AvatarScreen_AvatarTile2_i() : AvatarTile
      {
         var _loc1_:AvatarTile = new AvatarTile();
         _loc1_.percentWidth = 100;
         _loc1_.addEventListener("change",this.__rubyAvatars_change);
         this.rubyAvatars = _loc1_;
         BindingManager.executeBindings(this,"rubyAvatars",this.rubyAvatars);
         return _loc1_;
      }
      
      public function __rubyAvatars_change(event:Event) : void
      {
         this.onRubyChange();
      }
      
      private function _AvatarScreen_Component2_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.width = 5;
         return _loc1_;
      }
      
      private function _AvatarScreen_GradientBox3_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 25;
         _loc1_.children = [this._AvatarScreen_HBox4_c()];
         return _loc1_;
      }
      
      private function _AvatarScreen_HBox4_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.gap = 5;
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._AvatarScreen_Component3_c(),this._AvatarScreen_HBox5_i(),this._AvatarScreen_Component4_c(),this._AvatarScreen_Button11_i(),this._AvatarScreen_Component5_c()];
         return _loc1_;
      }
      
      private function _AvatarScreen_Component3_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.width = 5;
         return _loc1_;
      }
      
      private function _AvatarScreen_HBox5_i() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._AvatarScreen_Label3_i(),this._AvatarScreen_MoneyRenderer1_i()];
         this._AvatarScreen_HBox5 = _loc1_;
         BindingManager.executeBindings(this,"_AvatarScreen_HBox5",this._AvatarScreen_HBox5);
         return _loc1_;
      }
      
      private function _AvatarScreen_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.fontSize = 12;
         this._AvatarScreen_Label3 = _loc1_;
         BindingManager.executeBindings(this,"_AvatarScreen_Label3",this._AvatarScreen_Label3);
         return _loc1_;
      }
      
      private function _AvatarScreen_MoneyRenderer1_i() : MoneyRenderer
      {
         var _loc1_:MoneyRenderer = new MoneyRenderer();
         _loc1_.color = 16777215;
         this.cost = _loc1_;
         BindingManager.executeBindings(this,"cost",this.cost);
         return _loc1_;
      }
      
      private function _AvatarScreen_Component4_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.percentWidth = 100;
         return _loc1_;
      }
      
      private function _AvatarScreen_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.height = 27;
         _loc1_.addEventListener("click",this.___AvatarScreen_Button11_click);
         this._AvatarScreen_Button11 = _loc1_;
         BindingManager.executeBindings(this,"_AvatarScreen_Button11",this._AvatarScreen_Button11);
         return _loc1_;
      }
      
      public function ___AvatarScreen_Button11_click(event:MouseEvent) : void
      {
         this.accept(event);
      }
      
      private function _AvatarScreen_Component5_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.width = 20;
         return _loc1_;
      }
      
      private function _AvatarScreen_Component6_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.height = 6;
         return _loc1_;
      }
      
      public function ___AvatarScreen_Box1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _AvatarScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return Assets.simpleBorderRound;
         },null,"_AvatarScreen_BorderedContainer1.borderSkin");
         result[1] = new Binding(this,function():Object
         {
            return Assets.pattern_06;
         },null,"_AvatarScreen_BorderedContainer1.backgroundImage");
         result[2] = new Binding(this,function():Object
         {
            return Icons.moneySmall;
         },null,"_AvatarScreen_CachedImage1.source");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = getString("avatars.money");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_AvatarScreen_Label1.text");
         result[4] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_AvatarScreen_Label1.color");
         result[5] = new Binding(this,function():Object
         {
            return Icons.rubySmall;
         },null,"_AvatarScreen_CachedImage2.source");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = getString("avatars.rubies");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_AvatarScreen_Label2.text");
         result[7] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_AvatarScreen_Label2.color");
         result[8] = new Binding(this,function():Boolean
         {
            return selectedAvatar != null;
         },null,"_AvatarScreen_HBox5.visible");
         result[9] = new Binding(this,function():String
         {
            var _loc1_:* = getString("avatar.cost") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_AvatarScreen_Label3.text");
         result[10] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_AvatarScreen_Label3.color");
         result[11] = new Binding(this,function():String
         {
            var _loc1_:* = selectedAvatar.currency;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"cost.type");
         result[12] = new Binding(this,function():uint
         {
            return selectedAvatar.price;
         },null,"cost.value");
         result[13] = new Binding(this,function():String
         {
            var _loc1_:* = getString("accept");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_AvatarScreen_Button11.label");
         result[14] = new Binding(this,function():Boolean
         {
            return selectedAvatar != null;
         },null,"_AvatarScreen_Button11.enabled");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get cost() : MoneyRenderer
      {
         return this._3059661cost;
      }
      
      public function set cost(param1:MoneyRenderer) : void
      {
         var _loc2_:Object = this._3059661cost;
         if(_loc2_ !== param1)
         {
            this._3059661cost = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cost",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get moneyAvatars() : AvatarTile
      {
         return this._1557690022moneyAvatars;
      }
      
      public function set moneyAvatars(param1:AvatarTile) : void
      {
         var _loc2_:Object = this._1557690022moneyAvatars;
         if(_loc2_ !== param1)
         {
            this._1557690022moneyAvatars = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"moneyAvatars",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rubyAvatars() : AvatarTile
      {
         return this._208077568rubyAvatars;
      }
      
      public function set rubyAvatars(param1:AvatarTile) : void
      {
         var _loc2_:Object = this._208077568rubyAvatars;
         if(_loc2_ !== param1)
         {
            this._208077568rubyAvatars = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rubyAvatars",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get selectedAvatar() : Avatar
      {
         return this._1346764756selectedAvatar;
      }
      
      private function set selectedAvatar(param1:Avatar) : void
      {
         var _loc2_:Object = this._1346764756selectedAvatar;
         if(_loc2_ !== param1)
         {
            this._1346764756selectedAvatar = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedAvatar",_loc2_,param1));
            }
         }
      }
   }
}

