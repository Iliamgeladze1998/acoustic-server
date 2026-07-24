package soul.view.chat
{
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.GlowFilter;
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
   import soul.model.chat.ChatTabModel;
   import soul.view.assets.Assets;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.CachedImage;
   
   use namespace mx_internal;
   
   public class ChatTab extends BorderedContainer implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const NEW_MSG_FILTERS:Array = [new GlowFilter(65526,0.5,10,10)];
      
      private var _100313435image:CachedImage;
      
      private var _104069929model:ChatTabModel;
      
      private var _1191572123selected:Boolean;
      
      private var _1726194350transparent:Boolean;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ChatTab()
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
         bindings = this._ChatTab_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_chat_ChatTabWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return ChatTab[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 38;
         this.height = 25;
         this.horizontalAlign = "center";
         this.verticalAlign = "middle";
         this.children = [this._ChatTab_CachedImage1_i()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ChatTab._watcherSetupUtil = param1;
      }
      
      private function _ChatTab_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this.image = _loc1_;
         BindingManager.executeBindings(this,"image",this.image);
         return _loc1_;
      }
      
      private function _ChatTab_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = model.label;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"this.toolTip");
         result[1] = new Binding(this,function():Object
         {
            return selected ? Assets.chatTab : null;
         },null,"this.borderSkin");
         result[2] = new Binding(this,function():Object
         {
            return ChatIcons.getTabIcon(model.key);
         },null,"image.source");
         result[3] = new Binding(this,function():Array
         {
            var _loc1_:* = model.newMessages ? NEW_MSG_FILTERS : [];
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"image.filters");
         result[4] = new Binding(this,function():Number
         {
            return model.newMessages || selected || !transparent ? 1 : 0.6;
         },null,"image.alpha");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get image() : CachedImage
      {
         return this._100313435image;
      }
      
      public function set image(param1:CachedImage) : void
      {
         var _loc2_:Object = this._100313435image;
         if(_loc2_ !== param1)
         {
            this._100313435image = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"image",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get model() : ChatTabModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:ChatTabModel) : void
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
      public function get selected() : Boolean
      {
         return this._1191572123selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         var _loc2_:Object = this._1191572123selected;
         if(_loc2_ !== param1)
         {
            this._1191572123selected = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selected",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get transparent() : Boolean
      {
         return this._1726194350transparent;
      }
      
      public function set transparent(param1:Boolean) : void
      {
         var _loc2_:Object = this._1726194350transparent;
         if(_loc2_ !== param1)
         {
            this._1726194350transparent = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"transparent",_loc2_,param1));
            }
         }
      }
   }
}

