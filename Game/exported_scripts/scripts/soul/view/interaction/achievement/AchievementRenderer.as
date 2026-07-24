package soul.view.interaction.achievement
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
   import soul.model.GameModel;
   import soul.model.achievement.Achievement;
   import soul.model.condition.Condition;
   import soul.model.interaction.dialog.MetaItem;
   import soul.model.item.Item;
   import soul.model.system.Configuration;
   import soul.utils.NumberUtils;
   import soul.view.assets.Assets;
   import soul.view.assets.Colors;
   import soul.view.common.IconRenderer;
   import soul.view.common.Icons;
   import soul.view.interaction.quest.ConditionRenderer;
   import soul.view.interaction.quest.MetaItemRenderer;
   import soul.view.toolTip.TipSplitter;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.CachedImage;
   import soul.view.ui.HBox;
   import soul.view.ui.IDataRenderer;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class AchievementRenderer extends BorderedContainer implements IBindingClient, IDataRenderer
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private var _1536891843checkbox:CachedImage;
      
      private var _410496889completeDate:Label;
      
      private var _930859336conditions:VBox;
      
      private var _1724546052description:Label;
      
      private var _1281286352detailContainer:VBox;
      
      private var _3226745icon:IconRenderer;
      
      private var _982754077points:AchievementPoints;
      
      private var _1100650276rewards:HBox;
      
      private var _110371416title:Label;
      
      private var _data:Achievement;
      
      private var expanded:Boolean;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function AchievementRenderer()
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
         bindings = this._AchievementRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_achievement_AchievementRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return AchievementRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.padding = 5;
         this.width = 405;
         this.backgroundPadding = 2;
         this.direction = "vertical";
         this.children = [this._AchievementRenderer_HBox2_c()];
         this._AchievementRenderer_VBox1_i();
         this._AchievementRenderer_HBox1_i();
         this.addEventListener("click",this.___AchievementRenderer_BorderedContainer1_click);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         AchievementRenderer._watcherSetupUtil = param1;
      }
      
      public function set data(value:Object) : void
      {
         this._data = value as Achievement;
         if(!this._data)
         {
            return;
         }
         this._data.addEventListener(Event.CHANGE,this.dataUpdated,false,0,true);
         this.dataUpdated(null);
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      private function dataUpdated(e:Event) : void
      {
         var condition:Condition = null;
         var mitem:MetaItem = null;
         var item:Item = null;
         var date:Date = null;
         var child:ConditionRenderer = null;
         var mir:MetaItemRenderer = null;
         var ir:TextItemRenderer = null;
         this.icon.source = Configuration.getAchievementImage(this._data.imagePath);
         this.title.text = LocaleManager.getAchievementName(this._data.id);
         this.description.text = LocaleManager.getAchievementDescription(this._data.id);
         this.points.points = this._data.points;
         this.trackedChanged();
         if(this._data.completeDate > 0)
         {
            this.checkbox.visible = false;
            this.points.alpha = 1;
            date = new Date(this._data.completeDate);
            this.completeDate.text = NumberUtils.addZero(date.date) + "." + NumberUtils.addZero(date.month + 1) + "." + date.fullYear;
         }
         else
         {
            this.points.filters = Colors.DISABLED_ALPHA_FILTER;
            this.completeDate.text = "";
            backgroundColor = 11834725;
            backgroundAlpha = 0.5;
         }
         this.conditions.removeAllChildren();
         for each(condition in this._data.conditions)
         {
            child = new ConditionRenderer(true);
            child.condition = condition;
            this.conditions.addChild(child);
         }
         this.rewards.removeAllChildren();
         for each(mitem in this._data.metaRewards)
         {
            mir = new MetaItemRenderer();
            mir.item = mitem;
            this.rewards.addChild(mir);
         }
         for each(item in this._data.rewards)
         {
            ir = new TextItemRenderer();
            ir.item = item;
            this.rewards.addChild(ir);
         }
      }
      
      private function expand() : void
      {
         this.expanded = !this.expanded;
         if(this.expanded)
         {
            if(!this.detailContainer.contains(this.conditions))
            {
               this.detailContainer.addChild(this.conditions);
            }
            if(!contains(this.rewards))
            {
               addChild(this.rewards);
            }
         }
         else
         {
            if(this.detailContainer.contains(this.conditions))
            {
               this.detailContainer.removeChild(this.conditions);
            }
            if(contains(this.rewards))
            {
               removeChild(this.rewards);
            }
         }
      }
      
      private function track(e:Event) : void
      {
         e.stopPropagation();
         this._data.tracked = !this._data.tracked;
         GameModel.getInstance().settingsModel.setAchievementTracked(this._data.id,this._data.tracked);
         this.trackedChanged();
      }
      
      private function trackedChanged() : void
      {
         this.checkbox.source = this._data.tracked ? Icons.checkbox1 : Icons.checkbox0;
      }
      
      private function _AchievementRenderer_VBox1_i() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         this.conditions = _loc1_;
         BindingManager.executeBindings(this,"conditions",this.conditions);
         return _loc1_;
      }
      
      private function _AchievementRenderer_HBox1_i() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.padding = 2;
         _loc1_.gap = 10;
         _loc1_.backgroundColor = 11109199;
         _loc1_.percentWidth = 100;
         this.rewards = _loc1_;
         BindingManager.executeBindings(this,"rewards",this.rewards);
         return _loc1_;
      }
      
      private function _AchievementRenderer_HBox2_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.gap = 2;
         _loc1_.children = [this._AchievementRenderer_IconRenderer1_i(),this._AchievementRenderer_VBox2_c()];
         return _loc1_;
      }
      
      private function _AchievementRenderer_IconRenderer1_i() : IconRenderer
      {
         var _loc1_:IconRenderer = new IconRenderer();
         _loc1_.width = 51;
         _loc1_.height = 51;
         _loc1_.padding = 3;
         this.icon = _loc1_;
         BindingManager.executeBindings(this,"icon",this.icon);
         return _loc1_;
      }
      
      private function _AchievementRenderer_VBox2_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.children = [this._AchievementRenderer_HBox3_c()];
         return _loc1_;
      }
      
      private function _AchievementRenderer_HBox3_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.gap = 5;
         _loc1_.children = [this._AchievementRenderer_VBox3_i(),this._AchievementRenderer_VBox4_c()];
         return _loc1_;
      }
      
      private function _AchievementRenderer_VBox3_i() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.children = [this._AchievementRenderer_HBox4_c(),this._AchievementRenderer_TipSplitter1_c(),this._AchievementRenderer_Label2_i()];
         this.detailContainer = _loc1_;
         BindingManager.executeBindings(this,"detailContainer",this.detailContainer);
         return _loc1_;
      }
      
      private function _AchievementRenderer_HBox4_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.children = [this._AchievementRenderer_CachedImage1_i(),this._AchievementRenderer_Label1_i()];
         return _loc1_;
      }
      
      private function _AchievementRenderer_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.addEventListener("click",this.__checkbox_click);
         this.checkbox = _loc1_;
         BindingManager.executeBindings(this,"checkbox",this.checkbox);
         return _loc1_;
      }
      
      public function __checkbox_click(event:MouseEvent) : void
      {
         this.track(event);
      }
      
      private function _AchievementRenderer_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.bold = true;
         _loc1_.percentWidth = 100;
         _loc1_.color = 0;
         _loc1_.align = "center";
         this.title = _loc1_;
         BindingManager.executeBindings(this,"title",this.title);
         return _loc1_;
      }
      
      private function _AchievementRenderer_TipSplitter1_c() : TipSplitter
      {
         var _loc1_:TipSplitter = new TipSplitter();
         _loc1_.height = 1;
         _loc1_.percentWidth = 100;
         return _loc1_;
      }
      
      private function _AchievementRenderer_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.multiline = true;
         _loc1_.wordWrap = true;
         _loc1_.percentWidth = 100;
         _loc1_.color = 0;
         _loc1_.align = "center";
         this.description = _loc1_;
         BindingManager.executeBindings(this,"description",this.description);
         return _loc1_;
      }
      
      private function _AchievementRenderer_VBox4_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.gap = 2;
         _loc1_.horizontalAlign = "center";
         _loc1_.children = [this._AchievementRenderer_AchievementPoints1_i(),this._AchievementRenderer_Label3_i()];
         return _loc1_;
      }
      
      private function _AchievementRenderer_AchievementPoints1_i() : AchievementPoints
      {
         var _loc1_:AchievementPoints = new AchievementPoints();
         this.points = _loc1_;
         BindingManager.executeBindings(this,"points",this.points);
         return _loc1_;
      }
      
      private function _AchievementRenderer_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.y = 44;
         _loc1_.color = 0;
         _loc1_.fontSize = 10;
         _loc1_.align = "center";
         _loc1_.width = 65;
         this.completeDate = _loc1_;
         BindingManager.executeBindings(this,"completeDate",this.completeDate);
         return _loc1_;
      }
      
      public function ___AchievementRenderer_BorderedContainer1_click(event:MouseEvent) : void
      {
         this.expand();
      }
      
      private function _AchievementRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return Assets.mailBorder;
         },null,"this.borderSkin");
         result[1] = new Binding(this,function():Object
         {
            return Assets.simpleBorderRound;
         },null,"icon.borderSkin");
         result[2] = new Binding(this,function():Object
         {
            return Assets.iconGlow;
         },null,"icon.glowSource");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = LocaleManager.getString(BundleName.INTERFACE,"track");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"checkbox.toolTip");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get checkbox() : CachedImage
      {
         return this._1536891843checkbox;
      }
      
      public function set checkbox(param1:CachedImage) : void
      {
         var _loc2_:Object = this._1536891843checkbox;
         if(_loc2_ !== param1)
         {
            this._1536891843checkbox = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"checkbox",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get completeDate() : Label
      {
         return this._410496889completeDate;
      }
      
      public function set completeDate(param1:Label) : void
      {
         var _loc2_:Object = this._410496889completeDate;
         if(_loc2_ !== param1)
         {
            this._410496889completeDate = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"completeDate",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get conditions() : VBox
      {
         return this._930859336conditions;
      }
      
      public function set conditions(param1:VBox) : void
      {
         var _loc2_:Object = this._930859336conditions;
         if(_loc2_ !== param1)
         {
            this._930859336conditions = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"conditions",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get description() : Label
      {
         return this._1724546052description;
      }
      
      public function set description(param1:Label) : void
      {
         var _loc2_:Object = this._1724546052description;
         if(_loc2_ !== param1)
         {
            this._1724546052description = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"description",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get detailContainer() : VBox
      {
         return this._1281286352detailContainer;
      }
      
      public function set detailContainer(param1:VBox) : void
      {
         var _loc2_:Object = this._1281286352detailContainer;
         if(_loc2_ !== param1)
         {
            this._1281286352detailContainer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"detailContainer",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get icon() : IconRenderer
      {
         return this._3226745icon;
      }
      
      public function set icon(param1:IconRenderer) : void
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
      public function get points() : AchievementPoints
      {
         return this._982754077points;
      }
      
      public function set points(param1:AchievementPoints) : void
      {
         var _loc2_:Object = this._982754077points;
         if(_loc2_ !== param1)
         {
            this._982754077points = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"points",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rewards() : HBox
      {
         return this._1100650276rewards;
      }
      
      public function set rewards(param1:HBox) : void
      {
         var _loc2_:Object = this._1100650276rewards;
         if(_loc2_ !== param1)
         {
            this._1100650276rewards = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rewards",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get title() : Label
      {
         return this._110371416title;
      }
      
      public function set title(param1:Label) : void
      {
         var _loc2_:Object = this._110371416title;
         if(_loc2_ !== param1)
         {
            this._110371416title = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"title",_loc2_,param1));
            }
         }
      }
   }
}

