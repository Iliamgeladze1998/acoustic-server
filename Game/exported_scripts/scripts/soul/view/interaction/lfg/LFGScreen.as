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
   import soul.event.LFGEvent;
   import soul.event.SimpleUIEvent;
   import soul.model.interaction.lfg.ApplicationType;
   import soul.model.interaction.lfg.GroupApplication;
   import soul.model.interaction.lfg.LFGCriteria;
   import soul.model.interaction.lfg.LFGModel;
   import soul.model.interaction.lfg.QuestCriteria;
   import soul.model.interaction.lfg.SectorCriteria;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientBox;
   import soul.view.assets.GradientLabel;
   import soul.view.assets.SimpleImageBar;
   import soul.view.common.Icons;
   import soul.view.common.TabIcons;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.Box;
   import soul.view.ui.Canvas;
   import soul.view.ui.ComboBox;
   import soul.view.ui.Component;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.List;
   import soul.view.ui.ScrollBase;
   import soul.view.ui.VBox;
   import soul.view.ui.ViewStack;
   import soul.view.ui.controls.Alert;
   
   use namespace mx_internal;
   
   public class LFGScreen extends VBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const TABS:Array = [[TabIcons.look0,TabIcons.look1],[TabIcons.list0,TabIcons.list1]];
      
      public var _LFGScreen_BorderedContainer1:BorderedContainer;
      
      public var _LFGScreen_BorderedContainer2:BorderedContainer;
      
      public var _LFGScreen_Button11:Button1;
      
      public var _LFGScreen_Button12:Button1;
      
      public var _LFGScreen_Button13:Button1;
      
      public var _LFGScreen_GradientLabel1:GradientLabel;
      
      public var _LFGScreen_HBox4:HBox;
      
      public var _LFGScreen_LFGIcon1:LFGIcon;
      
      public var _LFGScreen_Label1:Label;
      
      public var _LFGScreen_Label2:Label;
      
      public var _LFGScreen_Label3:Label;
      
      public var _LFGScreen_Label4:Label;
      
      public var _LFGScreen_ViewStack1:ViewStack;
      
      private var _937207075applications:List;
      
      private var _97299bar:SimpleImageBar;
      
      private var _1991428355categorySelector:CategorySelector;
      
      private var _29097598instances:CategoryGroupRenderer;
      
      private var _1197189282locations:CategoryGroupRenderer;
      
      private var _948698159quests:CategoryGroupRenderer;
      
      private var _1300380478subcategory:ComboBox;
      
      private var _104069929model:LFGModel;
      
      private var _1790120620characterName:String;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function LFGScreen()
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
         bindings = this._LFGScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_lfg_LFGScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return LFGScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 400;
         this.height = 426;
         this.padding = 9;
         this.children = [this._LFGScreen_SimpleImageBar1_i(),this._LFGScreen_ViewStack1_i(),this._LFGScreen_Component3_c(),this._LFGScreen_GradientBox2_c()];
         this.addEventListener("creationComplete",this.___LFGScreen_VBox1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         LFGScreen._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         InteractionWindow.findInteractionParent(this).label = this.getString("lfg.title");
         this.model.dispatchEvent(new LFGEvent(LFGEvent.GET_RECORDS));
         this.model.applications = null;
      }
      
      private function categorySelected() : void
      {
         var list:Array = null;
         var record:LFGCriteria = null;
         var child:SubCategoryRenderer = null;
         var locale:String = null;
         var id:String = null;
         var ret:Array = [];
         switch(this.categorySelector.selectedType)
         {
            case ApplicationType.QUEST:
               list = this.model.quests;
               break;
            case ApplicationType.INSTANCE:
               list = this.model.instances;
               break;
            case ApplicationType.LOCATION:
               list = this.model.locations;
         }
         ret.push({
            "id":null,
            "label":this.getString("lfg.all")
         });
         for each(record in list)
         {
            child = new SubCategoryRenderer();
            locale = "";
            id = null;
            if(record is QuestCriteria)
            {
               locale = LocaleManager.getString(BundleName.QUESTS,QuestCriteria(record).questId);
               id = QuestCriteria(record).questId;
            }
            else if(record is SectorCriteria)
            {
               locale = LocaleManager.getString(BundleName.SECTOR,SectorCriteria(record).sectorId);
               id = SectorCriteria(record).sectorId;
            }
            ret.push({
               "label":locale,
               "id":id
            });
         }
         this.subcategory.dataProvider = ret;
         this.subcategory.selectedIndex = 0;
         this.model.applications = [];
         this.subcategoryChanged();
      }
      
      private function subcategoryChanged() : void
      {
         var applicationType:String = this.categorySelector.selectedType;
         var criteriaId:String = this.subcategory.selectedItem.id;
         var ne:LFGEvent = new LFGEvent(LFGEvent.GET_APPLICATIONS);
         ne.applicationType = applicationType;
         ne.criteriaId = criteriaId;
         this.model.dispatchEvent(ne);
      }
      
      private function create() : void
      {
         var ne:LFGEvent = new LFGEvent(LFGEvent.SUBSCRIBE);
         ne.questIds = this.quests.getSelected();
         ne.instanceIds = this.instances.getSelected();
         ne.locationIds = this.locations.getSelected();
         this.model.dispatchEvent(ne);
      }
      
      private function cancel() : void
      {
         var ne:LFGEvent = null;
         if(this.model.currentApplication.leader.name == this.characterName)
         {
            ne = new LFGEvent(LFGEvent.UNSUBSCRIBE);
            this.model.dispatchEvent(ne);
         }
         else
         {
            Alert.show("lfg.youMustLeaveGroupToCancel");
         }
      }
      
      private function join() : void
      {
         var ne:LFGEvent = new LFGEvent(LFGEvent.JOIN);
         ne.applicationId = GroupApplication(this.applications.selectedItem).id;
         this.model.dispatchEvent(ne);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _LFGScreen_SimpleImageBar1_i() : SimpleImageBar
      {
         var _loc1_:SimpleImageBar = new SimpleImageBar();
         _loc1_.selectedIndex = 0;
         _loc1_.gap = 1;
         this.bar = _loc1_;
         BindingManager.executeBindings(this,"bar",this.bar);
         return _loc1_;
      }
      
      private function _LFGScreen_ViewStack1_i() : ViewStack
      {
         var _loc1_:ViewStack = new ViewStack();
         _loc1_.children = [this._LFGScreen_BorderedContainer1_i(),this._LFGScreen_BorderedContainer2_i()];
         this._LFGScreen_ViewStack1 = _loc1_;
         BindingManager.executeBindings(this,"_LFGScreen_ViewStack1",this._LFGScreen_ViewStack1);
         return _loc1_;
      }
      
      private function _LFGScreen_BorderedContainer1_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.width = 380;
         _loc1_.height = 345;
         _loc1_.direction = "vertical";
         _loc1_.padding = 3;
         _loc1_.children = [this._LFGScreen_GradientLabel1_i(),this._LFGScreen_ScrollBase1_c()];
         this._LFGScreen_BorderedContainer1 = _loc1_;
         BindingManager.executeBindings(this,"_LFGScreen_BorderedContainer1",this._LFGScreen_BorderedContainer1);
         return _loc1_;
      }
      
      private function _LFGScreen_GradientLabel1_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.percentWidth = 100;
         _loc1_.padding = 5;
         _loc1_.bold = true;
         this._LFGScreen_GradientLabel1 = _loc1_;
         BindingManager.executeBindings(this,"_LFGScreen_GradientLabel1",this._LFGScreen_GradientLabel1);
         return _loc1_;
      }
      
      private function _LFGScreen_ScrollBase1_c() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.verticalScrollPolicy = "auto";
         _loc1_.children = [this._LFGScreen_VBox2_c()];
         return _loc1_;
      }
      
      private function _LFGScreen_VBox2_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.padding = 5;
         _loc1_.gap = 2;
         _loc1_.children = [this._LFGScreen_CategoryGroupRenderer1_i(),this._LFGScreen_CategoryGroupRenderer2_i(),this._LFGScreen_CategoryGroupRenderer3_i()];
         return _loc1_;
      }
      
      private function _LFGScreen_CategoryGroupRenderer1_i() : CategoryGroupRenderer
      {
         var _loc1_:CategoryGroupRenderer = new CategoryGroupRenderer();
         this.quests = _loc1_;
         BindingManager.executeBindings(this,"quests",this.quests);
         return _loc1_;
      }
      
      private function _LFGScreen_CategoryGroupRenderer2_i() : CategoryGroupRenderer
      {
         var _loc1_:CategoryGroupRenderer = new CategoryGroupRenderer();
         this.instances = _loc1_;
         BindingManager.executeBindings(this,"instances",this.instances);
         return _loc1_;
      }
      
      private function _LFGScreen_CategoryGroupRenderer3_i() : CategoryGroupRenderer
      {
         var _loc1_:CategoryGroupRenderer = new CategoryGroupRenderer();
         this.locations = _loc1_;
         BindingManager.executeBindings(this,"locations",this.locations);
         return _loc1_;
      }
      
      private function _LFGScreen_BorderedContainer2_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.width = 380;
         _loc1_.height = 345;
         _loc1_.padding = 3;
         _loc1_.direction = "vertical";
         _loc1_.children = [this._LFGScreen_GradientBox1_c(),this._LFGScreen_Box1_c()];
         this._LFGScreen_BorderedContainer2 = _loc1_;
         BindingManager.executeBindings(this,"_LFGScreen_BorderedContainer2",this._LFGScreen_BorderedContainer2);
         return _loc1_;
      }
      
      private function _LFGScreen_GradientBox1_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 73;
         _loc1_.children = [this._LFGScreen_VBox3_c()];
         return _loc1_;
      }
      
      private function _LFGScreen_VBox3_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.padding = 5;
         _loc1_.gap = 5;
         _loc1_.children = [this._LFGScreen_HBox1_c(),this._LFGScreen_HBox2_c()];
         return _loc1_;
      }
      
      private function _LFGScreen_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._LFGScreen_Label1_i(),this._LFGScreen_Component1_c(),this._LFGScreen_CategorySelector1_i(),this._LFGScreen_Component2_c()];
         return _loc1_;
      }
      
      private function _LFGScreen_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.bold = true;
         this._LFGScreen_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_LFGScreen_Label1",this._LFGScreen_Label1);
         return _loc1_;
      }
      
      private function _LFGScreen_Component1_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.percentWidth = 100;
         return _loc1_;
      }
      
      private function _LFGScreen_CategorySelector1_i() : CategorySelector
      {
         var _loc1_:CategorySelector = new CategorySelector();
         _loc1_.addEventListener("change",this.__categorySelector_change);
         this.categorySelector = _loc1_;
         BindingManager.executeBindings(this,"categorySelector",this.categorySelector);
         return _loc1_;
      }
      
      public function __categorySelector_change(event:Event) : void
      {
         this.categorySelected();
      }
      
      private function _LFGScreen_Component2_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.percentWidth = 100;
         return _loc1_;
      }
      
      private function _LFGScreen_HBox2_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.verticalAlign = "middle";
         _loc1_.gap = 5;
         _loc1_.children = [this._LFGScreen_ComboBox1_i(),this._LFGScreen_Button11_i()];
         return _loc1_;
      }
      
      private function _LFGScreen_ComboBox1_i() : ComboBox
      {
         var _loc1_:ComboBox = new ComboBox();
         _loc1_.percentWidth = 100;
         _loc1_.addEventListener("change",this.__subcategory_change);
         this.subcategory = _loc1_;
         BindingManager.executeBindings(this,"subcategory",this.subcategory);
         return _loc1_;
      }
      
      public function __subcategory_change(event:Event) : void
      {
         this.subcategoryChanged();
      }
      
      private function _LFGScreen_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 37;
         _loc1_.height = 28;
         _loc1_.addEventListener("click",this.___LFGScreen_Button11_click);
         this._LFGScreen_Button11 = _loc1_;
         BindingManager.executeBindings(this,"_LFGScreen_Button11",this._LFGScreen_Button11);
         return _loc1_;
      }
      
      public function ___LFGScreen_Button11_click(event:MouseEvent) : void
      {
         this.subcategoryChanged();
      }
      
      private function _LFGScreen_Box1_c() : Box
      {
         var _loc1_:Box = new Box();
         _loc1_.padding = 5;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.children = [this._LFGScreen_Canvas1_c()];
         return _loc1_;
      }
      
      private function _LFGScreen_Canvas1_c() : Canvas
      {
         var _loc1_:Canvas = new Canvas();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.children = [this._LFGScreen_List1_i(),this._LFGScreen_Label2_i(),this._LFGScreen_Label3_i()];
         return _loc1_;
      }
      
      private function _LFGScreen_List1_i() : List
      {
         var _loc1_:List = new List();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.gap = 2;
         this.applications = _loc1_;
         BindingManager.executeBindings(this,"applications",this.applications);
         return _loc1_;
      }
      
      private function _LFGScreen_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.horizontalCenter = 0;
         _loc1_.verticalCenter = 0;
         this._LFGScreen_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_LFGScreen_Label2",this._LFGScreen_Label2);
         return _loc1_;
      }
      
      private function _LFGScreen_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.horizontalCenter = 0;
         _loc1_.verticalCenter = 0;
         this._LFGScreen_Label3 = _loc1_;
         BindingManager.executeBindings(this,"_LFGScreen_Label3",this._LFGScreen_Label3);
         return _loc1_;
      }
      
      private function _LFGScreen_Component3_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.height = 5;
         return _loc1_;
      }
      
      private function _LFGScreen_GradientBox2_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 24;
         _loc1_.bgPaddingLeft = -9;
         _loc1_.children = [this._LFGScreen_HBox3_c()];
         return _loc1_;
      }
      
      private function _LFGScreen_HBox3_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 5;
         _loc1_.percentWidth = 100;
         _loc1_.verticalAlign = "middle";
         _loc1_.verticalCenter = 0;
         _loc1_.children = [this._LFGScreen_HBox4_i(),this._LFGScreen_Component4_c(),this._LFGScreen_Button12_i(),this._LFGScreen_Button13_i()];
         return _loc1_;
      }
      
      private function _LFGScreen_HBox4_i() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._LFGScreen_LFGIcon1_i(),this._LFGScreen_Label4_i()];
         this._LFGScreen_HBox4 = _loc1_;
         BindingManager.executeBindings(this,"_LFGScreen_HBox4",this._LFGScreen_HBox4);
         return _loc1_;
      }
      
      private function _LFGScreen_LFGIcon1_i() : LFGIcon
      {
         var _loc1_:LFGIcon = new LFGIcon();
         this._LFGScreen_LFGIcon1 = _loc1_;
         BindingManager.executeBindings(this,"_LFGScreen_LFGIcon1",this._LFGScreen_LFGIcon1);
         return _loc1_;
      }
      
      private function _LFGScreen_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.bold = true;
         this._LFGScreen_Label4 = _loc1_;
         BindingManager.executeBindings(this,"_LFGScreen_Label4",this._LFGScreen_Label4);
         return _loc1_;
      }
      
      private function _LFGScreen_Component4_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.percentWidth = 100;
         return _loc1_;
      }
      
      private function _LFGScreen_Button12_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 51;
         _loc1_.height = 28;
         _loc1_.addEventListener("click",this.___LFGScreen_Button12_click);
         this._LFGScreen_Button12 = _loc1_;
         BindingManager.executeBindings(this,"_LFGScreen_Button12",this._LFGScreen_Button12);
         return _loc1_;
      }
      
      public function ___LFGScreen_Button12_click(event:MouseEvent) : void
      {
         if(this.bar.selectedIndex == 0)
         {
            this.create();
         }
         else
         {
            this.join();
         }
      }
      
      private function _LFGScreen_Button13_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 51;
         _loc1_.height = 28;
         _loc1_.addEventListener("click",this.___LFGScreen_Button13_click);
         this._LFGScreen_Button13 = _loc1_;
         BindingManager.executeBindings(this,"_LFGScreen_Button13",this._LFGScreen_Button13);
         return _loc1_;
      }
      
      public function ___LFGScreen_Button13_click(event:MouseEvent) : void
      {
         this.cancel();
      }
      
      public function ___LFGScreen_VBox1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _LFGScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Array
         {
            var _loc1_:* = TABS;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"bar.dataProvider");
         result[1] = new Binding(this,function():Array
         {
            var _loc1_:* = [getString("lfg.find"),getString("lfg.list")];
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"bar.toolTips");
         result[2] = new Binding(this,function():int
         {
            return bar.selectedIndex;
         },null,"_LFGScreen_ViewStack1.selectedIndex");
         result[3] = new Binding(this,function():Object
         {
            return Assets.pattern_06;
         },null,"_LFGScreen_BorderedContainer1.backgroundImage");
         result[4] = new Binding(this,function():Object
         {
            return Assets.simpleBorderRound;
         },null,"_LFGScreen_BorderedContainer1.borderSkin");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = getString("lfg.find.group") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LFGScreen_GradientLabel1.text");
         result[6] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_LFGScreen_GradientLabel1.color");
         result[7] = new Binding(this,function():Object
         {
            return Icons.quest;
         },null,"quests.source");
         result[8] = new Binding(this,function():String
         {
            var _loc1_:* = getString("lfg.quests");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"quests.label");
         result[9] = new Binding(this,function():Array
         {
            var _loc1_:* = model.quests;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"quests.dataProvider");
         result[10] = new Binding(this,function():Boolean
         {
            return model.currentApplication == null;
         },null,"quests.enabled");
         result[11] = new Binding(this,function():Object
         {
            return Icons.instance;
         },null,"instances.source");
         result[12] = new Binding(this,function():String
         {
            var _loc1_:* = getString("lfg.instances");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"instances.label");
         result[13] = new Binding(this,function():Array
         {
            var _loc1_:* = model.instances;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"instances.dataProvider");
         result[14] = new Binding(this,function():Boolean
         {
            return model.currentApplication == null;
         },null,"instances.enabled");
         result[15] = new Binding(this,function():Object
         {
            return Icons.location;
         },null,"locations.source");
         result[16] = new Binding(this,function():String
         {
            var _loc1_:* = getString("lfg.locations");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"locations.label");
         result[17] = new Binding(this,function():Array
         {
            var _loc1_:* = model.locations;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"locations.dataProvider");
         result[18] = new Binding(this,function():Boolean
         {
            return model.currentApplication == null;
         },null,"locations.enabled");
         result[19] = new Binding(this,function():Object
         {
            return Assets.pattern_06;
         },null,"_LFGScreen_BorderedContainer2.backgroundImage");
         result[20] = new Binding(this,function():Object
         {
            return Assets.simpleBorderRound;
         },null,"_LFGScreen_BorderedContainer2.borderSkin");
         result[21] = new Binding(this,function():String
         {
            var _loc1_:* = getString("lfg.list.applications") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LFGScreen_Label1.text");
         result[22] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_LFGScreen_Label1.color");
         result[23] = new Binding(this,function():Boolean
         {
            return categorySelector.selectedType != null;
         },null,"subcategory.enabled");
         result[24] = new Binding(this,function():Object
         {
            return Icons.refresh;
         },null,"_LFGScreen_Button11.icon");
         result[25] = new Binding(this,function():Boolean
         {
            return subcategory.selectedIndex > -1;
         },null,"_LFGScreen_Button11.enabled");
         result[26] = new Binding(this,function():Class
         {
            return ApplicationRenderer;
         },null,"applications.itemRenderer");
         result[27] = new Binding(this,function():Object
         {
            return model.applications;
         },null,"applications.dataProvider");
         result[28] = new Binding(this,function():String
         {
            var _loc1_:* = getString("lfg.selectCategorie");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LFGScreen_Label2.text");
         result[29] = new Binding(this,function():Boolean
         {
            return model.applications == null;
         },null,"_LFGScreen_Label2.visible");
         result[30] = new Binding(this,function():String
         {
            var _loc1_:* = getString("lfg.noApplications");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LFGScreen_Label3.text");
         result[31] = new Binding(this,function():Boolean
         {
            return model.applications != null && model.applications.length == 0;
         },null,"_LFGScreen_Label3.visible");
         result[32] = new Binding(this,function():Boolean
         {
            return model.currentApplication != null;
         },null,"_LFGScreen_HBox4.visible");
         result[33] = new Binding(this,function():GroupApplication
         {
            return model.currentApplication;
         },null,"_LFGScreen_LFGIcon1.application");
         result[34] = new Binding(this,function():String
         {
            var _loc1_:* = getString("lfg.current.application");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LFGScreen_Label4.text");
         result[35] = new Binding(this,function():Object
         {
            return Icons.accept;
         },null,"_LFGScreen_Button12.icon");
         result[36] = new Binding(this,function():String
         {
            var _loc1_:* = getString(bar.selectedIndex == 0 ? "lfg.application.create" : "lfg.application.join");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LFGScreen_Button12.toolTip");
         result[37] = new Binding(this,function():Boolean
         {
            return bar.selectedIndex == 0 && model.currentApplication == null && quests.total + instances.total + locations.total > 0 || bar.selectedIndex == 1 && model.currentApplication == null && applications.selectedItem != null;
         },null,"_LFGScreen_Button12.enabled");
         result[38] = new Binding(this,function():Object
         {
            return Icons.cancel;
         },null,"_LFGScreen_Button13.icon");
         result[39] = new Binding(this,function():String
         {
            var _loc1_:* = getString("lfg.application.cancel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LFGScreen_Button13.toolTip");
         result[40] = new Binding(this,function():Boolean
         {
            return model.currentApplication != null;
         },null,"_LFGScreen_Button13.enabled");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get applications() : List
      {
         return this._937207075applications;
      }
      
      public function set applications(param1:List) : void
      {
         var _loc2_:Object = this._937207075applications;
         if(_loc2_ !== param1)
         {
            this._937207075applications = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"applications",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bar() : SimpleImageBar
      {
         return this._97299bar;
      }
      
      public function set bar(param1:SimpleImageBar) : void
      {
         var _loc2_:Object = this._97299bar;
         if(_loc2_ !== param1)
         {
            this._97299bar = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bar",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get categorySelector() : CategorySelector
      {
         return this._1991428355categorySelector;
      }
      
      public function set categorySelector(param1:CategorySelector) : void
      {
         var _loc2_:Object = this._1991428355categorySelector;
         if(_loc2_ !== param1)
         {
            this._1991428355categorySelector = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"categorySelector",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get instances() : CategoryGroupRenderer
      {
         return this._29097598instances;
      }
      
      public function set instances(param1:CategoryGroupRenderer) : void
      {
         var _loc2_:Object = this._29097598instances;
         if(_loc2_ !== param1)
         {
            this._29097598instances = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"instances",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get locations() : CategoryGroupRenderer
      {
         return this._1197189282locations;
      }
      
      public function set locations(param1:CategoryGroupRenderer) : void
      {
         var _loc2_:Object = this._1197189282locations;
         if(_loc2_ !== param1)
         {
            this._1197189282locations = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"locations",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get quests() : CategoryGroupRenderer
      {
         return this._948698159quests;
      }
      
      public function set quests(param1:CategoryGroupRenderer) : void
      {
         var _loc2_:Object = this._948698159quests;
         if(_loc2_ !== param1)
         {
            this._948698159quests = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"quests",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get subcategory() : ComboBox
      {
         return this._1300380478subcategory;
      }
      
      public function set subcategory(param1:ComboBox) : void
      {
         var _loc2_:Object = this._1300380478subcategory;
         if(_loc2_ !== param1)
         {
            this._1300380478subcategory = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"subcategory",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get model() : LFGModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:LFGModel) : void
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
      public function get characterName() : String
      {
         return this._1790120620characterName;
      }
      
      public function set characterName(param1:String) : void
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
   }
}

