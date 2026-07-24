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
   import soul.controller.interaction.AchievementManager;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.achievement.AchievementModel;
   import soul.model.achievement.AchievementSubgroup;
   import soul.net.ServerLayer;
   import soul.view.assets.Assets;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Container;
   import soul.view.ui.List;
   
   use namespace mx_internal;
   
   public class AchievementScreenExternal extends Container implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _AchievementScreenExternal_CachedImage1:CachedImage;
      
      public var _AchievementScreenExternal_CachedImage2:CachedImage;
      
      private var _621118573achievementList:AchievementList;
      
      private var _1296516636categories:AchievementCategories;
      
      private var _1503365320categorySummary:List;
      
      private var _1001078227progress:PointsProgress;
      
      private var _104069929model:AchievementModel;
      
      private var _1434352804selectedGroup:AchievementSubgroup;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function AchievementScreenExternal()
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
         bindings = this._AchievementScreenExternal_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_achievement_AchievementScreenExternalWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return AchievementScreenExternal[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 784;
         this.height = 452;
         this.children = [this._AchievementScreenExternal_PointsProgress1_i(),this._AchievementScreenExternal_CachedImage1_i(),this._AchievementScreenExternal_CachedImage2_i(),this._AchievementScreenExternal_AchievementCategories1_i(),this._AchievementScreenExternal_List1_i(),this._AchievementScreenExternal_AchievementList1_i()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         AchievementScreenExternal._watcherSetupUtil = param1;
      }
      
      public function set characterId(value:String) : void
      {
         ServerLayer.call(AchievementManager.SERVICE,"getAchievements",this.setAchievements,null,value);
      }
      
      private function setAchievements(groups:Array) : void
      {
         var model:AchievementModel = new AchievementModel(null);
         model.load(groups);
         this.model = model;
         InteractionWindow.findInteractionParent(this).label = LocaleManager.getString(BundleName.INTERFACE,"achievements.title");
         this.onCategoryChange();
      }
      
      private function onCategoryChange() : void
      {
         var icon:String = null;
         this.categorySummary.visible = this.achievementList.visible = false;
         var lastCategory:AchievementCategoryRenderer = this.categories.lastSelectedCategorie;
         if(lastCategory is LastAchievementsRenderer)
         {
            this.selectedGroup = null;
            icon = LastAchievementsRenderer.IMAGE_URL;
            this.achievementList.visible = true;
            this.achievementList.dataProvider = this.model.lastAchievements;
         }
         else if(lastCategory is AllAchievementsRenderer)
         {
            this.selectedGroup = null;
            icon = AllAchievementsRenderer.IMAGE_URL;
            this.categorySummary.visible = true;
         }
         else if(lastCategory is GroupRenderer)
         {
            this.selectedGroup = GroupRenderer(lastCategory).group;
            icon = GroupRenderer(lastCategory).group.imagePath;
            this.achievementList.visible = true;
            this.achievementList.dataProvider = GroupRenderer(lastCategory).group.achievements;
            this.achievementList.focusAchievement(this.model.toFocus);
            this.model.toFocus = null;
         }
         else
         {
            this.selectedGroup = null;
         }
         this.progress.iconSource = icon;
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _AchievementScreenExternal_PointsProgress1_i() : PointsProgress
      {
         var _loc1_:PointsProgress = new PointsProgress();
         _loc1_.x = 10;
         _loc1_.y = 5;
         this.progress = _loc1_;
         BindingManager.executeBindings(this,"progress",this.progress);
         return _loc1_;
      }
      
      private function _AchievementScreenExternal_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.x = -1;
         _loc1_.y = 43;
         _loc1_.mouseEnabled = false;
         this._AchievementScreenExternal_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_AchievementScreenExternal_CachedImage1",this._AchievementScreenExternal_CachedImage1);
         return _loc1_;
      }
      
      private function _AchievementScreenExternal_CachedImage2_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.x = 306;
         this._AchievementScreenExternal_CachedImage2 = _loc1_;
         BindingManager.executeBindings(this,"_AchievementScreenExternal_CachedImage2",this._AchievementScreenExternal_CachedImage2);
         return _loc1_;
      }
      
      private function _AchievementScreenExternal_AchievementCategories1_i() : AchievementCategories
      {
         var _loc1_:AchievementCategories = new AchievementCategories();
         _loc1_.x = 28;
         _loc1_.y = 72;
         _loc1_.width = 267;
         _loc1_.height = 359;
         _loc1_.verticalScrollPolicy = "auto";
         _loc1_.addEventListener("change",this.__categories_change);
         this.categories = _loc1_;
         BindingManager.executeBindings(this,"categories",this.categories);
         return _loc1_;
      }
      
      public function __categories_change(event:Event) : void
      {
         this.onCategoryChange();
      }
      
      private function _AchievementScreenExternal_List1_i() : List
      {
         var _loc1_:List = new List();
         _loc1_.width = 420;
         _loc1_.height = 400;
         _loc1_.x = 336;
         _loc1_.y = 28;
         _loc1_.gap = 4;
         this.categorySummary = _loc1_;
         BindingManager.executeBindings(this,"categorySummary",this.categorySummary);
         return _loc1_;
      }
      
      private function _AchievementScreenExternal_AchievementList1_i() : AchievementList
      {
         var _loc1_:AchievementList = new AchievementList();
         _loc1_.width = 420;
         _loc1_.height = 400;
         _loc1_.x = 336;
         _loc1_.y = 28;
         _loc1_.gap = 4;
         this.achievementList = _loc1_;
         BindingManager.executeBindings(this,"achievementList",this.achievementList);
         return _loc1_;
      }
      
      private function _AchievementScreenExternal_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():int
         {
            return Boolean(selectedGroup) ? int(selectedGroup.pointsCollected) : int(model.pointsCollected);
         },null,"progress.current");
         result[1] = new Binding(this,function():int
         {
            return Boolean(selectedGroup) ? int(selectedGroup.pointsTotal) : int(model.pointsTotal);
         },null,"progress.maximum");
         result[2] = new Binding(this,function():Object
         {
            return Assets.questScrollLeft;
         },null,"_AchievementScreenExternal_CachedImage1.source");
         result[3] = new Binding(this,function():Object
         {
            return Assets.questBg;
         },null,"_AchievementScreenExternal_CachedImage2.source");
         result[4] = new Binding(this,null,null,"categories.model","model");
         result[5] = new Binding(this,function():Class
         {
            return CategorySummaryRenderer;
         },null,"categorySummary.itemRenderer");
         result[6] = new Binding(this,function():Object
         {
            return model.groups;
         },null,"categorySummary.dataProvider");
         result[7] = new Binding(this,function():Class
         {
            return AchievementRendererExternal;
         },null,"achievementList.itemRenderer");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get achievementList() : AchievementList
      {
         return this._621118573achievementList;
      }
      
      public function set achievementList(param1:AchievementList) : void
      {
         var _loc2_:Object = this._621118573achievementList;
         if(_loc2_ !== param1)
         {
            this._621118573achievementList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"achievementList",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get categories() : AchievementCategories
      {
         return this._1296516636categories;
      }
      
      public function set categories(param1:AchievementCategories) : void
      {
         var _loc2_:Object = this._1296516636categories;
         if(_loc2_ !== param1)
         {
            this._1296516636categories = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"categories",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get categorySummary() : List
      {
         return this._1503365320categorySummary;
      }
      
      public function set categorySummary(param1:List) : void
      {
         var _loc2_:Object = this._1503365320categorySummary;
         if(_loc2_ !== param1)
         {
            this._1503365320categorySummary = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"categorySummary",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get progress() : PointsProgress
      {
         return this._1001078227progress;
      }
      
      public function set progress(param1:PointsProgress) : void
      {
         var _loc2_:Object = this._1001078227progress;
         if(_loc2_ !== param1)
         {
            this._1001078227progress = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"progress",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get model() : AchievementModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:AchievementModel) : void
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
      private function get selectedGroup() : AchievementSubgroup
      {
         return this._1434352804selectedGroup;
      }
      
      private function set selectedGroup(param1:AchievementSubgroup) : void
      {
         var _loc2_:Object = this._1434352804selectedGroup;
         if(_loc2_ !== param1)
         {
            this._1434352804selectedGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedGroup",_loc2_,param1));
            }
         }
      }
   }
}

