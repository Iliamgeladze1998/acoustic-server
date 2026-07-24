package soul.view.interaction.lfg
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
   import soul.model.interaction.lfg.LFGCriteria;
   import soul.model.interaction.lfg.QuestCriteria;
   import soul.model.interaction.lfg.SectorCriteria;
   import soul.view.assets.Colors;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Checkbox;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class CategoryGroupRenderer extends VBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private var _1472470539_label:Label;
      
      private var _94415084cbBox:Checkbox;
      
      private var _1361400105childs:VBox;
      
      private var _3226745icon:CachedImage;
      
      [Bindable("totalChanged")]
      public var total:uint;
      
      private var expanded:Boolean = true;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function CategoryGroupRenderer()
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
         bindings = this._CategoryGroupRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_lfg_CategoryGroupRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return CategoryGroupRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.percentWidth = 100;
         this.children = [this._CategoryGroupRenderer_HBox1_c(),this._CategoryGroupRenderer_VBox2_i()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         CategoryGroupRenderer._watcherSetupUtil = param1;
      }
      
      public function getSelected() : Array
      {
         var child:SubCategoryRenderer = null;
         if(this.cbBox.selected)
         {
            return ["all"];
         }
         var ret:Array = [];
         for(var i:uint = 0; i < this.childs.numChildren; i++)
         {
            child = this.childs.getChildAt(i) as SubCategoryRenderer;
            if(Boolean(child) && child.selected)
            {
               ret.push(child.id);
            }
         }
         return ret;
      }
      
      private function onSelect() : void
      {
         var child:SubCategoryRenderer = null;
         for(var i:uint = 0; i < this.childs.numChildren; i++)
         {
            child = this.childs.getChildAt(i) as SubCategoryRenderer;
            if(Boolean(child))
            {
               child.selected = this.cbBox.selected;
               child.enabled = !this.cbBox.selected && !child.disabled;
            }
         }
         this.onChange(null);
      }
      
      private function onChange(e:Event) : void
      {
         callLater(this.recountTotal);
      }
      
      private function expand() : void
      {
         this.expanded = !this.expanded;
         this.childs.scaleY = this.expanded ? 1 : 0;
      }
      
      public function set source(value:Object) : void
      {
         this.icon.source = value;
      }
      
      public function set label(value:String) : void
      {
         this._label.text = value;
      }
      
      public function set dataProvider(value:Array) : void
      {
         var record:LFGCriteria = null;
         var child:SubCategoryRenderer = null;
         var locale:String = null;
         this.childs.removeAllChildren();
         for each(record in value)
         {
            child = new SubCategoryRenderer();
            locale = "";
            if(record is QuestCriteria)
            {
               locale = LocaleManager.getString(BundleName.QUESTS,QuestCriteria(record).questId);
               child.id = QuestCriteria(record).questId;
            }
            else if(record is SectorCriteria)
            {
               locale = LocaleManager.getString(BundleName.SECTOR,SectorCriteria(record).sectorId);
               child.id = SectorCriteria(record).sectorId;
            }
            child.selected = record.selected;
            child.label = locale;
            child.addEventListener(Event.CHANGE,this.onChange,false,0,true);
            if(Boolean(record.disabledBy) && record.disabledBy.length > 0)
            {
               child.enabled = false;
               child.toolTip = LocaleManager.getString(BundleName.TOOLTIP,"lfg.disabled.by") + ":\n" + record.disabledBy.join(",\n");
               child.disabled = true;
            }
            this.childs.addChild(child);
         }
         this.recountTotal();
      }
      
      private function recountTotal() : void
      {
         var i:uint = 0;
         var child:SubCategoryRenderer = null;
         this.total = 0;
         if(this.cbBox.selected)
         {
            this.total = 1;
         }
         else
         {
            for(i = 0; i < this.childs.numChildren; i++)
            {
               child = this.childs.getChildAt(i) as SubCategoryRenderer;
               if(Boolean(child) && child.selected)
               {
                  ++this.total;
               }
            }
         }
         dispatchEvent(new Event("totalChanged"));
      }
      
      override public function set enabled(value:Boolean) : void
      {
         mouseChildren = super._enabled = value;
         filters = value ? [] : Colors.DISABLED_FILTER;
      }
      
      private function _CategoryGroupRenderer_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.gap = 5;
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._CategoryGroupRenderer_CachedImage1_i(),this._CategoryGroupRenderer_Checkbox1_i(),this._CategoryGroupRenderer_Label1_i()];
         return _loc1_;
      }
      
      private function _CategoryGroupRenderer_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.addEventListener("click",this.__icon_click);
         this.icon = _loc1_;
         BindingManager.executeBindings(this,"icon",this.icon);
         return _loc1_;
      }
      
      public function __icon_click(event:MouseEvent) : void
      {
         this.expand();
      }
      
      private function _CategoryGroupRenderer_Checkbox1_i() : Checkbox
      {
         var _loc1_:Checkbox = new Checkbox();
         _loc1_.addEventListener("change",this.__cbBox_change);
         this.cbBox = _loc1_;
         BindingManager.executeBindings(this,"cbBox",this.cbBox);
         return _loc1_;
      }
      
      public function __cbBox_change(event:Event) : void
      {
         this.onSelect();
      }
      
      private function _CategoryGroupRenderer_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.bold = true;
         _loc1_.addEventListener("click",this.___label_click);
         this._label = _loc1_;
         BindingManager.executeBindings(this,"_label",this._label);
         return _loc1_;
      }
      
      public function ___label_click(event:MouseEvent) : void
      {
         this.expand();
      }
      
      private function _CategoryGroupRenderer_VBox2_i() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.padding = 5;
         _loc1_.gap = 1;
         this.childs = _loc1_;
         BindingManager.executeBindings(this,"childs",this.childs);
         return _loc1_;
      }
      
      private function _CategoryGroupRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = LocaleManager.getString(BundleName.INTERFACE,"lfg.all");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"cbBox.toolTip");
         result[1] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_label.color");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get _label() : Label
      {
         return this._1472470539_label;
      }
      
      public function set _label(param1:Label) : void
      {
         var _loc2_:Object = this._1472470539_label;
         if(_loc2_ !== param1)
         {
            this._1472470539_label = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_label",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get cbBox() : Checkbox
      {
         return this._94415084cbBox;
      }
      
      public function set cbBox(param1:Checkbox) : void
      {
         var _loc2_:Object = this._94415084cbBox;
         if(_loc2_ !== param1)
         {
            this._94415084cbBox = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cbBox",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get childs() : VBox
      {
         return this._1361400105childs;
      }
      
      public function set childs(param1:VBox) : void
      {
         var _loc2_:Object = this._1361400105childs;
         if(_loc2_ !== param1)
         {
            this._1361400105childs = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"childs",_loc2_,param1));
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

