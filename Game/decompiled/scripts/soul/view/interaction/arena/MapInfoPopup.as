package soul.view.interaction.arena
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
   import soul.event.SimpleUIEvent;
   import soul.model.interaction.arena.ArenaInfo;
   import soul.model.system.Configuration;
   import soul.view.assets.Assets;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.CachedImage;
   import soul.view.ui.controls.PopupManager;
   
   use namespace mx_internal;
   
   public class MapInfoPopup extends InteractionWindow implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _MapInfoPopup_BorderedContainer1:BorderedContainer;
      
      public var _MapInfoPopup_CachedImage1:CachedImage;
      
      private var _272121941arenaInfo:ArenaInfo;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function MapInfoPopup()
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
         bindings = this._MapInfoPopup_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_arena_MapInfoPopupWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return MapInfoPopup[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.children = [this._MapInfoPopup_BorderedContainer1_i()];
         this.addEventListener("creationComplete",this.___MapInfoPopup_InteractionWindow1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         MapInfoPopup._watcherSetupUtil = param1;
      }
      
      private function center() : void
      {
         PopupManager.centerPopup(this);
      }
      
      override protected function exit(e:Event) : void
      {
         PopupManager.removePopup(this);
      }
      
      private function _MapInfoPopup_BorderedContainer1_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.minWidth = 100;
         _loc1_.minHeight = 100;
         _loc1_.backgroundColor = 2105358;
         _loc1_.children = [this._MapInfoPopup_CachedImage1_i()];
         _loc1_.addEventListener("click",this.___MapInfoPopup_BorderedContainer1_click);
         this._MapInfoPopup_BorderedContainer1 = _loc1_;
         BindingManager.executeBindings(this,"_MapInfoPopup_BorderedContainer1",this._MapInfoPopup_BorderedContainer1);
         return _loc1_;
      }
      
      private function _MapInfoPopup_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.addEventListener("change",this.___MapInfoPopup_CachedImage1_change);
         this._MapInfoPopup_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_MapInfoPopup_CachedImage1",this._MapInfoPopup_CachedImage1);
         return _loc1_;
      }
      
      public function ___MapInfoPopup_CachedImage1_change(event:Event) : void
      {
         this.center();
      }
      
      public function ___MapInfoPopup_BorderedContainer1_click(event:MouseEvent) : void
      {
         this.exit(event);
      }
      
      public function ___MapInfoPopup_InteractionWindow1_creationComplete(event:SimpleUIEvent) : void
      {
         this.center();
      }
      
      private function _MapInfoPopup_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return Assets.simpleBorder;
         },null,"_MapInfoPopup_BorderedContainer1.borderSkin");
         result[1] = new Binding(this,function():Object
         {
            return Configuration.getArenaMapUrl(arenaInfo,false);
         },null,"_MapInfoPopup_CachedImage1.source");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get arenaInfo() : ArenaInfo
      {
         return this._272121941arenaInfo;
      }
      
      public function set arenaInfo(param1:ArenaInfo) : void
      {
         var _loc2_:Object = this._272121941arenaInfo;
         if(_loc2_ !== param1)
         {
            this._272121941arenaInfo = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"arenaInfo",_loc2_,param1));
            }
         }
      }
   }
}

