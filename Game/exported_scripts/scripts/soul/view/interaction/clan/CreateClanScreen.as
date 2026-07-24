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
   import soul.event.SimpleUIEvent;
   import soul.model.character.CharacterModel;
   import soul.model.interaction.clan.ClanModel;
   import soul.view.assets.Assets;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Container;
   
   use namespace mx_internal;
   
   public class CreateClanScreen extends Container implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _CreateClanScreen_CachedImage1:CachedImage;
      
      private var _1081434779manage:ClanManage;
      
      private var _104069929model:ClanModel;
      
      private var _340320640characterModel:CharacterModel;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function CreateClanScreen()
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
         bindings = this._CreateClanScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_clan_CreateClanScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return CreateClanScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 480;
         this.height = 344;
         this.children = [this._CreateClanScreen_CachedImage1_i(),this._CreateClanScreen_ClanManage1_i()];
         this.addEventListener("creationComplete",this.___CreateClanScreen_Container1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         CreateClanScreen._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         InteractionWindow.findInteractionParent(this).label = this.getString("clan.create.title");
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _CreateClanScreen_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.x = 12;
         _loc1_.y = 8;
         this._CreateClanScreen_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_CreateClanScreen_CachedImage1",this._CreateClanScreen_CachedImage1);
         return _loc1_;
      }
      
      private function _CreateClanScreen_ClanManage1_i() : ClanManage
      {
         var _loc1_:ClanManage = new ClanManage();
         _loc1_.x = 21;
         _loc1_.y = 17;
         this.manage = _loc1_;
         BindingManager.executeBindings(this,"manage",this.manage);
         return _loc1_;
      }
      
      public function ___CreateClanScreen_Container1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _CreateClanScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return Assets.panelSet;
         },null,"_CreateClanScreen_CachedImage1.source");
         result[1] = new Binding(this,null,null,"manage.model","model");
         result[2] = new Binding(this,null,null,"manage.characterModel","characterModel");
         return result;
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
   }
}

