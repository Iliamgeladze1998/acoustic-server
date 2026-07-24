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
   import soul.controller.Interaction;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.event.SimpleUIEvent;
   import soul.event.SocialEvent;
   import soul.model.character.CharacterModel;
   import soul.model.character.ParamType;
   import soul.model.common.InteractionType;
   import soul.model.interaction.social.SocialListType;
   import soul.model.interaction.social.SocialModel;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.assets.SimpleImageBar;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.ScrollBase;
   import soul.view.ui.VBox;
   import soul.view.ui.controls.PopupManager;
   import soul.view.ui.controls.Window;
   
   use namespace mx_internal;
   
   public class SocialScreen extends HBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const IMAGES:Array = [[Assets.friendOff,Assets.friendOn],[Assets.enemyOff,Assets.enemyOn],[Assets.ignoreOff,Assets.ignoreOn]];
      
      private static const tabTypes:Array = [SocialListType.FRIEND,SocialListType.ENEMY,SocialListType.IGNORE];
      
      private static const maxListEntries:Array = [ParamType.FRIEND_LIST_SIZE,ParamType.ENEMY_LIST_SIZE,ParamType.IGNORE_LIST_SIZE];
      
      public var _SocialScreen_BorderedContainer1:BorderedContainer;
      
      public var _SocialScreen_BorderedContainer2:BorderedContainer;
      
      public var _SocialScreen_Label1:Label;
      
      private var _96417add:Button1;
      
      private var _97299bar:SimpleImageBar;
      
      private var _94756344close:Button1;
      
      private var _934610812remove:Button1;
      
      private var _494845757renderer:FriendListRenderer;
      
      private var _104069929model:SocialModel;
      
      private var _340320640characterModel:CharacterModel;
      
      private var _417636724maxEntries:int;
      
      private var popup:NickPrompt;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function SocialScreen()
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
         bindings = this._SocialScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_social_SocialScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return SocialScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 400;
         this.height = 300;
         this.gap = 5;
         this.padding = 10;
         this.children = [this._SocialScreen_VBox1_c(),this._SocialScreen_VBox2_c()];
         this.addEventListener("creationComplete",this.___SocialScreen_HBox1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         SocialScreen._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
         InteractionWindow.findInteractionParent(this).label = this.getString("social.title");
         this.bar.selectedIndex = 0;
         this.add.addEventListener(MouseEvent.CLICK,this.addClick);
         this.remove.addEventListener(MouseEvent.CLICK,this.removeClick);
         this.close.addEventListener(MouseEvent.CLICK,this.closeClick);
         this.model.addEventListener(SocialEvent.LIST_CHANGED,this.listChanged);
      }
      
      private function removed(e:Event) : void
      {
         if(e.target != this)
         {
            return;
         }
         if(Boolean(this.popup))
         {
            PopupManager.removePopup(this.popup);
         }
         this.add.removeEventListener(MouseEvent.CLICK,this.addClick);
         this.remove.removeEventListener(MouseEvent.CLICK,this.removeClick);
         this.close.removeEventListener(MouseEvent.CLICK,this.closeClick);
         this.model.removeEventListener(SocialEvent.LIST_CHANGED,this.listChanged);
      }
      
      private function addClick(e:Event) : void
      {
         this.popup = new NickPrompt();
         PopupManager.addPopup(this.popup,null,true);
         PopupManager.centerPopup(this.popup);
         this.popup.addEventListener(SocialEvent.ADD,this.addConfirm);
         this.popup.addEventListener(Window.DIALOG_CLOSE,this.closePopup);
      }
      
      private function addConfirm(e:SocialEvent) : void
      {
         var ne:SocialEvent = new SocialEvent(e.type);
         ne.characterName = e.characterName;
         ne.listType = tabTypes[this.bar.selectedIndex];
         this.model.dispatchEvent(ne);
         this.closePopup(null);
      }
      
      private function closePopup(e:Event) : void
      {
         PopupManager.removePopup(this.popup);
         this.popup = null;
      }
      
      private function removeClick(e:Event) : void
      {
         var ne:SocialEvent = new SocialEvent(SocialEvent.REMOVE);
         ne.characterId = this.renderer.selectedItem.id;
         ne.listType = tabTypes[this.bar.selectedIndex];
         this.model.dispatchEvent(ne);
      }
      
      private function closeClick(e:Event) : void
      {
         Interaction.hide(InteractionType.SOCIAL);
      }
      
      private function listChanged(e:Event) : void
      {
         dispatchEvent(new Event("listChanged"));
      }
      
      [Bindable("listChanged")]
      private function getListByTab(id:int) : Array
      {
         return this.model.socialLists[tabTypes[id]];
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _SocialScreen_VBox1_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.gap = 5;
         _loc1_.children = [this._SocialScreen_BorderedContainer1_i(),this._SocialScreen_HBox2_c()];
         return _loc1_;
      }
      
      private function _SocialScreen_BorderedContainer1_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.backgroundColor = 1;
         _loc1_.backgroundPadding = 2;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.padding = 4;
         _loc1_.children = [this._SocialScreen_ScrollBase1_c()];
         this._SocialScreen_BorderedContainer1 = _loc1_;
         BindingManager.executeBindings(this,"_SocialScreen_BorderedContainer1",this._SocialScreen_BorderedContainer1);
         return _loc1_;
      }
      
      private function _SocialScreen_ScrollBase1_c() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.verticalScrollPolicy = "auto";
         _loc1_.children = [this._SocialScreen_FriendListRenderer1_i()];
         return _loc1_;
      }
      
      private function _SocialScreen_FriendListRenderer1_i() : FriendListRenderer
      {
         var _loc1_:FriendListRenderer = new FriendListRenderer();
         this.renderer = _loc1_;
         BindingManager.executeBindings(this,"renderer",this.renderer);
         return _loc1_;
      }
      
      private function _SocialScreen_HBox2_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.gap = 5;
         _loc1_.children = [this._SocialScreen_Button11_i(),this._SocialScreen_Button12_i(),this._SocialScreen_Button13_i()];
         return _loc1_;
      }
      
      private function _SocialScreen_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         this.add = _loc1_;
         BindingManager.executeBindings(this,"add",this.add);
         return _loc1_;
      }
      
      private function _SocialScreen_Button12_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         this.remove = _loc1_;
         BindingManager.executeBindings(this,"remove",this.remove);
         return _loc1_;
      }
      
      private function _SocialScreen_Button13_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         this.close = _loc1_;
         BindingManager.executeBindings(this,"close",this.close);
         return _loc1_;
      }
      
      private function _SocialScreen_VBox2_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.gap = 5;
         _loc1_.children = [this._SocialScreen_SimpleImageBar1_i(),this._SocialScreen_BorderedContainer2_i()];
         return _loc1_;
      }
      
      private function _SocialScreen_SimpleImageBar1_i() : SimpleImageBar
      {
         var _loc1_:SimpleImageBar = new SimpleImageBar();
         _loc1_.direction = "vertical";
         _loc1_.gap = 1;
         _loc1_.selectedIndex = -1;
         this.bar = _loc1_;
         BindingManager.executeBindings(this,"bar",this.bar);
         return _loc1_;
      }
      
      private function _SocialScreen_BorderedContainer2_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.percentWidth = 100;
         _loc1_.backgroundPadding = 2;
         _loc1_.padding = 5;
         _loc1_.backgroundColor = 1;
         _loc1_.horizontalAlign = "center";
         _loc1_.children = [this._SocialScreen_Label1_i()];
         this._SocialScreen_BorderedContainer2 = _loc1_;
         BindingManager.executeBindings(this,"_SocialScreen_BorderedContainer2",this._SocialScreen_BorderedContainer2);
         return _loc1_;
      }
      
      private function _SocialScreen_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         this._SocialScreen_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_SocialScreen_Label1",this._SocialScreen_Label1);
         return _loc1_;
      }
      
      public function ___SocialScreen_HBox1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _SocialScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():*
         {
            return characterModel.params[maxListEntries[bar.selectedIndex]];
         },function(param1:*):void
         {
            maxEntries = param1;
         },"maxEntries");
         result[1] = new Binding(this,function():Object
         {
            return Assets.serifeBorder;
         },null,"_SocialScreen_BorderedContainer1.borderSkin");
         result[2] = new Binding(this,function():Array
         {
            var _loc1_:* = getListByTab(bar.selectedIndex);
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"renderer.dataProvider");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = getString("social.add");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"add.label");
         result[4] = new Binding(this,function():Boolean
         {
            return renderer.length < maxEntries;
         },null,"add.enabled");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = getString("social.remove");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"remove.label");
         result[6] = new Binding(this,function():Boolean
         {
            return renderer.selectedItem != null;
         },null,"remove.enabled");
         result[7] = new Binding(this,function():String
         {
            var _loc1_:* = getString("close");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"close.label");
         result[8] = new Binding(this,function():Array
         {
            var _loc1_:* = IMAGES;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"bar.dataProvider");
         result[9] = new Binding(this,function():Array
         {
            var _loc1_:* = [getString("social.friends"),getString("social.enemies"),getString("social.ignores")];
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"bar.toolTips");
         result[10] = new Binding(this,function():Object
         {
            return Assets.serifeBorder;
         },null,"_SocialScreen_BorderedContainer2.borderSkin");
         result[11] = new Binding(this,function():String
         {
            var _loc1_:* = renderer.length + "/" + maxEntries;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SocialScreen_Label1.text");
         return result;
      }
      
      private function _SocialScreen_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         this.maxEntries = this.characterModel.params[maxListEntries[this.bar.selectedIndex]];
      }
      
      [Bindable(event="propertyChange")]
      public function get add() : Button1
      {
         return this._96417add;
      }
      
      public function set add(param1:Button1) : void
      {
         var _loc2_:Object = this._96417add;
         if(_loc2_ !== param1)
         {
            this._96417add = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"add",_loc2_,param1));
            }
         }
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
      public function get close() : Button1
      {
         return this._94756344close;
      }
      
      public function set close(param1:Button1) : void
      {
         var _loc2_:Object = this._94756344close;
         if(_loc2_ !== param1)
         {
            this._94756344close = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"close",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get remove() : Button1
      {
         return this._934610812remove;
      }
      
      public function set remove(param1:Button1) : void
      {
         var _loc2_:Object = this._934610812remove;
         if(_loc2_ !== param1)
         {
            this._934610812remove = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"remove",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get renderer() : FriendListRenderer
      {
         return this._494845757renderer;
      }
      
      public function set renderer(param1:FriendListRenderer) : void
      {
         var _loc2_:Object = this._494845757renderer;
         if(_loc2_ !== param1)
         {
            this._494845757renderer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"renderer",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get model() : SocialModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:SocialModel) : void
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
      private function get maxEntries() : int
      {
         return this._417636724maxEntries;
      }
      
      private function set maxEntries(param1:int) : void
      {
         var _loc2_:Object = this._417636724maxEntries;
         if(_loc2_ !== param1)
         {
            this._417636724maxEntries = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maxEntries",_loc2_,param1));
            }
         }
      }
   }
}

