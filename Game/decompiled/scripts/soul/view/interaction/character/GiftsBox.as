package soul.view.interaction.character
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
   import soul.model.item.Item;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientBox;
   import soul.view.interaction.inventory.ItemRenderer;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Label;
   import soul.view.ui.Tile;
   import soul.view.ui.UIAssets;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class GiftsBox extends VBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const EXPANDED:Object = UIAssets.scrollButtonUp;
      
      private static const CLOSED:Object = UIAssets.scrollButtonDown;
      
      private var _3226745icon:CachedImage;
      
      private var _900811040tLabel:Label;
      
      private var _3560110tile:Tile;
      
      private var _expanded:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function GiftsBox()
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
         bindings = this._GiftsBox_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_character_GiftsBoxWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return GiftsBox[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.children = [this._GiftsBox_GradientBox1_c()];
         this._GiftsBox_Tile1_i();
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         GiftsBox._watcherSetupUtil = param1;
      }
      
      private function onClick() : void
      {
         this.expanded = !this.expanded;
      }
      
      public function set label(value:String) : void
      {
         this.tLabel.text = value;
      }
      
      public function set expanded(value:Boolean) : void
      {
         if(this._expanded == value)
         {
            return;
         }
         this._expanded = value;
         this.icon.source = value ? EXPANDED : CLOSED;
         if(value && !contains(this.tile))
         {
            addChild(this.tile);
         }
         else if(!value && contains(this.tile))
         {
            removeChild(this.tile);
         }
      }
      
      public function get expanded() : Boolean
      {
         return this._expanded;
      }
      
      public function set dataProvider(value:Array) : void
      {
         var item:Item = null;
         var child:ItemRenderer = null;
         this.tile.removeAllChildren();
         for each(item in value)
         {
            child = new ItemRenderer();
            child.width = child.height = 51;
            child.item = item;
            this.tile.addChild(child);
         }
      }
      
      private function _GiftsBox_Tile1_i() : Tile
      {
         var _loc1_:Tile = new Tile();
         _loc1_.width = 360;
         _loc1_.padding = 10;
         _loc1_.gap = 5;
         this.tile = _loc1_;
         BindingManager.executeBindings(this,"tile",this.tile);
         return _loc1_;
      }
      
      private function _GiftsBox_GradientBox1_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.width = 375;
         _loc1_.height = 24;
         _loc1_.children = [this._GiftsBox_CachedImage1_i(),this._GiftsBox_Label1_i()];
         _loc1_.addEventListener("click",this.___GiftsBox_GradientBox1_click);
         return _loc1_;
      }
      
      private function _GiftsBox_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.left = 10;
         _loc1_.verticalCenter = 0;
         this.icon = _loc1_;
         BindingManager.executeBindings(this,"icon",this.icon);
         return _loc1_;
      }
      
      private function _GiftsBox_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.x = 35;
         _loc1_.verticalCenter = 0;
         _loc1_.bold = true;
         this.tLabel = _loc1_;
         BindingManager.executeBindings(this,"tLabel",this.tLabel);
         return _loc1_;
      }
      
      public function ___GiftsBox_GradientBox1_click(event:MouseEvent) : void
      {
         this.onClick();
      }
      
      private function _GiftsBox_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return CLOSED;
         },null,"icon.source");
         result[1] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"tLabel.color");
         return result;
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
      
      [Bindable(event="propertyChange")]
      public function get tLabel() : Label
      {
         return this._900811040tLabel;
      }
      
      public function set tLabel(param1:Label) : void
      {
         var _loc2_:Object = this._900811040tLabel;
         if(_loc2_ !== param1)
         {
            this._900811040tLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get tile() : Tile
      {
         return this._3560110tile;
      }
      
      public function set tile(param1:Tile) : void
      {
         var _loc2_:Object = this._3560110tile;
         if(_loc2_ !== param1)
         {
            this._3560110tile = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tile",_loc2_,param1));
            }
         }
      }
   }
}

