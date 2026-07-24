package soul.view.interaction.map
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
   import mx.filters.*;
   import mx.styles.*;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.event.SimpleUIEvent;
   import soul.model.system.Configuration;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.CachedImage;
   import soul.view.ui.controls.PopupManager;
   
   use namespace mx_internal;
   
   public class GlobalMap extends BorderedContainer implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _GlobalMap_CachedImage1:CachedImage;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function GlobalMap()
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
         bindings = this._GlobalMap_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_map_GlobalMapWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return GlobalMap[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.padding = 9;
         this.minHeight = 200;
         this.minWidth = 300;
         this.children = [this._GlobalMap_CachedImage1_i()];
         this.addEventListener("creationComplete",this.___GlobalMap_BorderedContainer1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         GlobalMap._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         InteractionWindow.findInteractionParent(this).label = LocaleManager.getString(BundleName.INTERFACE,"map.global");
      }
      
      private function onImageResize() : void
      {
         var o:DisplayObject = InteractionWindow.findInteractionParent(this);
         if(Boolean(o))
         {
            PopupManager.centerPopup(o as InteractionWindow);
         }
      }
      
      private function _GlobalMap_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.addEventListener("change",this.___GlobalMap_CachedImage1_change);
         this._GlobalMap_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_GlobalMap_CachedImage1",this._GlobalMap_CachedImage1);
         return _loc1_;
      }
      
      public function ___GlobalMap_CachedImage1_change(event:Event) : void
      {
         this.onImageResize();
      }
      
      public function ___GlobalMap_BorderedContainer1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _GlobalMap_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return Configuration.getGlobalMapUrl();
         },null,"_GlobalMap_CachedImage1.source");
         return result;
      }
   }
}

