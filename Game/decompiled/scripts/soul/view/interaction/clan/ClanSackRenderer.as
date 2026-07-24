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
   import soul.model.interaction.clan.ClanSack;
   import soul.view.ui.Tile;
   
   use namespace mx_internal;
   
   public class ClanSackRenderer extends Tile implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private var _3522358sack:ClanSack;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ClanSackRenderer()
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
         bindings = this._ClanSackRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_clan_ClanSackRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return ClanSackRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.percentWidth = 100;
         this.gap = 2;
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ClanSackRenderer._watcherSetupUtil = param1;
      }
      
      private function set items(items:Array) : void
      {
         var child:StorageItem = null;
         removeAllChildren();
         for(var i:int = 0; i < items.length; i++)
         {
            child = new StorageItem();
            child.item = items[i];
            child.slotIndex = i;
            child.sack = this.sack.role;
            addChild(child);
         }
      }
      
      private function _ClanSackRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():*
         {
            return sack.items;
         },function(param1:*):void
         {
            items = param1;
         },"items");
         return result;
      }
      
      private function _ClanSackRenderer_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         this.items = this.sack.items;
      }
      
      [Bindable(event="propertyChange")]
      public function get sack() : ClanSack
      {
         return this._3522358sack;
      }
      
      public function set sack(param1:ClanSack) : void
      {
         var _loc2_:Object = this._3522358sack;
         if(_loc2_ !== param1)
         {
            this._3522358sack = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sack",_loc2_,param1));
            }
         }
      }
   }
}

