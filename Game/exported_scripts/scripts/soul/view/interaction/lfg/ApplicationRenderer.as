package soul.view.interaction.lfg
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
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.character.DispositionGroup;
   import soul.model.interaction.lfg.GroupApplication;
   import soul.view.assets.GradientBox;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Canvas;
   import soul.view.ui.HBox;
   import soul.view.ui.IListItemRenderer;
   import soul.view.ui.Label;
   
   use namespace mx_internal;
   
   public class ApplicationRenderer extends Canvas implements IBindingClient, IListItemRenderer
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const SELECTED_ICON:Array = [new GlowFilter(16711680,1,4,4)];
      
      private static const SELECTED:Array = [[3713796611,127],6031875];
      
      private var _3141bg:GradientBox;
      
      private var _1790120620characterName:Label;
      
      private var _1557721666details:Label;
      
      private var _3226745icon:CachedImage;
      
      private var _data:GroupApplication;
      
      private var _selected:Boolean;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ApplicationRenderer()
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
         bindings = this._ApplicationRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_lfg_ApplicationRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return ApplicationRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 340;
         this.height = 28;
         this.children = [this._ApplicationRenderer_GradientBox1_i(),this._ApplicationRenderer_HBox1_c()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ApplicationRenderer._watcherSetupUtil = param1;
      }
      
      public function set data(value:Object) : void
      {
         this._data = value as GroupApplication;
         if(!this._data)
         {
            return;
         }
         if(Boolean(this._data.leader))
         {
            this.icon.source = DispositionGroup.getIcon(this._data.leader.disposition);
            this.characterName.text = "[" + this._data.leader.level + "] " + this._data.leader.name;
            this.details.text = LocaleManager.getMapName(this._data.leader.sectorId,this._data.leader.mapId);
         }
         toolTip = this._data.getTooltip();
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set selected(value:Boolean) : void
      {
         this._selected = value;
         this.bg.visible = value;
         this.icon.filters = value ? SELECTED_ICON : [];
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _ApplicationRenderer_GradientBox1_i() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 24;
         _loc1_.verticalCenter = 0;
         _loc1_.visible = false;
         this.bg = _loc1_;
         BindingManager.executeBindings(this,"bg",this.bg);
         return _loc1_;
      }
      
      private function _ApplicationRenderer_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 3;
         _loc1_.verticalAlign = "middle";
         _loc1_.verticalCenter = 0;
         _loc1_.padding = 2;
         _loc1_.children = [this._ApplicationRenderer_CachedImage1_i(),this._ApplicationRenderer_Label1_i(),this._ApplicationRenderer_Label2_i()];
         return _loc1_;
      }
      
      private function _ApplicationRenderer_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this.icon = _loc1_;
         BindingManager.executeBindings(this,"icon",this.icon);
         return _loc1_;
      }
      
      private function _ApplicationRenderer_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.width = 105;
         this.characterName = _loc1_;
         BindingManager.executeBindings(this,"characterName",this.characterName);
         return _loc1_;
      }
      
      private function _ApplicationRenderer_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.width = 200;
         this.details = _loc1_;
         BindingManager.executeBindings(this,"details",this.details);
         return _loc1_;
      }
      
      private function _ApplicationRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Array
         {
            var _loc1_:* = SELECTED;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"bg.gradient");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get bg() : GradientBox
      {
         return this._3141bg;
      }
      
      public function set bg(param1:GradientBox) : void
      {
         var _loc2_:Object = this._3141bg;
         if(_loc2_ !== param1)
         {
            this._3141bg = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bg",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get characterName() : Label
      {
         return this._1790120620characterName;
      }
      
      public function set characterName(param1:Label) : void
      {
         var _loc2_:Object = this._1790120620characterName;
         if(_loc2_ !== param1)
         {
            this._1790120620characterName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"characterName",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get details() : Label
      {
         return this._1557721666details;
      }
      
      public function set details(param1:Label) : void
      {
         var _loc2_:Object = this._1557721666details;
         if(_loc2_ !== param1)
         {
            this._1557721666details = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"details",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get icon() : CachedImage
      {
         return this._3226745icon;
      }
      
      public function set icon(param1:CachedImage) : void
      {
         var _loc2_:Object = this._3226745icon;
         if(_loc2_ !== param1)
         {
            this._3226745icon = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"icon",_loc2_,param1));
            }
         }
      }
   }
}

