package soul.view.interaction.quest
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
   import mx.events.ItemClickEvent;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.event.CloseEvent;
   import soul.event.QuestEvent;
   import soul.event.SimpleUIEvent;
   import soul.model.interaction.dialog.DialogBranch;
   import soul.model.interaction.quest.HintEntry;
   import soul.model.interaction.quest.QuestEntry;
   import soul.model.interaction.quest.QuestModel;
   import soul.model.interaction.quest.QuestState;
   import soul.view.assets.Assets;
   import soul.view.assets.Colors;
   import soul.view.assets.SimpleImageBar;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Container;
   import soul.view.ui.ScrollBase;
   import soul.view.ui.controls.Alert;
   
   use namespace mx_internal;
   
   public class QuestLog extends Container implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const TABS:Array = [[Assets.questOff,Assets.questOn],[Assets.questDoneOff,Assets.questDoneOn],[Assets.hintOff,Assets.hintOn]];
      
      public var _QuestLog_CachedImage1:CachedImage;
      
      public var _QuestLog_CachedImage2:CachedImage;
      
      public var _QuestLog_CachedImage3:CachedImage;
      
      public var _QuestLog_CachedImage4:CachedImage;
      
      public var _QuestLog_Container3:Container;
      
      public var _QuestLog_QuestText1:QuestText;
      
      private var _1724546052description:Container;
      
      private var _1474009147hintList:HintListRenderer;
      
      private var _752822871navigator:ScrollBase;
      
      private var _1562710458questDescription:QuestDescription;
      
      private var _1783104352questList:QuestListRenderer;
      
      private var _1782869713questText:ScrollBase;
      
      private var _3552126tabs:SimpleImageBar;
      
      private var _104069929model:QuestModel;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function QuestLog()
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
         bindings = this._QuestLog_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_quest_QuestLogWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return QuestLog[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 784;
         this.height = 452;
         this.children = [this._QuestLog_SimpleImageBar1_i(),this._QuestLog_CachedImage1_i(),this._QuestLog_CachedImage2_i(),this._QuestLog_ScrollBase2_i(),this._QuestLog_Container2_i(),this._QuestLog_Container3_i(),this._QuestLog_CachedImage3_i(),this._QuestLog_CachedImage4_i()];
         this._QuestLog_HintListRenderer1_i();
         this._QuestLog_QuestDescription1_i();
         this._QuestLog_QuestListRenderer1_i();
         this._QuestLog_ScrollBase1_i();
         this.addEventListener("creationComplete",this.___QuestLog_Container1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         QuestLog._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         InteractionWindow.findInteractionParent(this).label = LocaleManager.getString(BundleName.INTERFACE,"questLog.title");
         addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
         this.questList.addEventListener(QuestEvent.QUESTS_SELECTED,this.questClick);
         this.model.addEventListener(QuestEvent.QUESTS_UPDATED,this.questsUpdated);
         this.tabClick();
      }
      
      private function removed(e:Event) : void
      {
         if(e.target != this)
         {
            return;
         }
         this.questList.removeEventListener(QuestEvent.QUESTS_SELECTED,this.questClick);
         this.model.removeEventListener(QuestEvent.QUESTS_UPDATED,this.questsUpdated);
      }
      
      private function tabClick() : void
      {
         this.navigator.removeAllChildren();
         this.description.removeAllChildren();
         switch(this.tabs.selectedIndex)
         {
            case 2:
               this.navigator.addChild(this.hintList);
               this.description.addChild(this.questText);
               break;
            default:
               this.navigator.addChild(this.questList);
               this.description.addChild(this.questDescription);
               this.showQuestList();
         }
         this.model.selectedTab = this.tabs.selectedIndex;
      }
      
      private function questClick(e:QuestEvent) : void
      {
         this.model.selectedQuest = this.model.findQuestById(e.id);
      }
      
      private function hintClick(e:ItemClickEvent) : void
      {
         var he:HintEntry = null;
         var ne:QuestEvent = null;
         var hint:HintEntry = HintEntry(e.item);
         if(!hint)
         {
            return;
         }
         this.model.selectedHint = hint;
         hint.read = true;
         var hasNew:Boolean = false;
         for each(he in this.model.hints)
         {
            if(!he.read)
            {
               hasNew = true;
               break;
            }
         }
         this.model.hasNewHints = hasNew;
         ne = new QuestEvent(QuestEvent.HINT_READ);
         ne.id = hint.id;
         this.model.dispatchEvent(ne);
      }
      
      private function cancel() : void
      {
         Alert.show(this.getString("quest.cancel.text"),"",Alert.YES | Alert.NO,null,this.cancelConfirm);
      }
      
      private function cancelConfirm(e:CloseEvent) : void
      {
         if(e.detail != Alert.YES)
         {
            return;
         }
         var ne:QuestEvent = new QuestEvent(QuestEvent.QUESTS_CANCEL);
         ne.id = this.model.selectedQuest.questId;
         this.model.dispatchEvent(ne);
      }
      
      private function track() : void
      {
         var ne:QuestEvent = new QuestEvent(QuestEvent.QUESTS_PIN);
         ne.id = this.model.selectedQuest.questId;
         this.model.dispatchEvent(ne);
      }
      
      private function questsUpdated(e:Event) : void
      {
         this.showQuestList();
      }
      
      private function showQuestList() : void
      {
         this.questList.questList = this.getQuestList(this.tabs.selectedIndex);
      }
      
      private function getQuestList(selectedTab:int) : Array
      {
         var qe:QuestEntry = null;
         if(selectedTab < 0)
         {
            return null;
         }
         var arr:Array = [];
         for each(qe in this.model.quests)
         {
            if(selectedTab == 0)
            {
               if(qe.state != QuestState.FINISHED && qe.state != QuestState.FAILED)
               {
                  arr.push(qe);
               }
            }
            else if(selectedTab == 1)
            {
               if(qe.state == QuestState.FINISHED || qe.state == QuestState.FAILED)
               {
                  arr.push(qe);
               }
            }
         }
         return arr;
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function getHintText(key:String) : String
      {
         return LocaleManager.getString(BundleName.HELPER,key);
      }
      
      private function _QuestLog_HintListRenderer1_i() : HintListRenderer
      {
         var _loc1_:HintListRenderer = new HintListRenderer();
         _loc1_.x = 28;
         _loc1_.addEventListener("itemClick",this.__hintList_itemClick);
         this.hintList = _loc1_;
         BindingManager.executeBindings(this,"hintList",this.hintList);
         return _loc1_;
      }
      
      public function __hintList_itemClick(event:ItemClickEvent) : void
      {
         this.hintClick(event);
      }
      
      private function _QuestLog_QuestDescription1_i() : QuestDescription
      {
         var _loc1_:QuestDescription = null;
         _loc1_ = new QuestDescription();
         _loc1_.width = 420;
         _loc1_.height = 335;
         _loc1_.questLog = true;
         this.questDescription = _loc1_;
         BindingManager.executeBindings(this,"questDescription",this.questDescription);
         return _loc1_;
      }
      
      private function _QuestLog_QuestListRenderer1_i() : QuestListRenderer
      {
         var _loc1_:QuestListRenderer = new QuestListRenderer();
         this.questList = _loc1_;
         BindingManager.executeBindings(this,"questList",this.questList);
         return _loc1_;
      }
      
      private function _QuestLog_ScrollBase1_i() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.width = 420;
         _loc1_.height = 335;
         _loc1_.wheelMultiplier = 7;
         _loc1_.verticalScrollPolicy = "auto";
         _loc1_.children = [this._QuestLog_QuestText1_i()];
         this.questText = _loc1_;
         BindingManager.executeBindings(this,"questText",this.questText);
         return _loc1_;
      }
      
      private function _QuestLog_QuestText1_i() : QuestText
      {
         var _loc1_:QuestText = new QuestText();
         _loc1_.width = 420;
         this._QuestLog_QuestText1 = _loc1_;
         BindingManager.executeBindings(this,"_QuestLog_QuestText1",this._QuestLog_QuestText1);
         return _loc1_;
      }
      
      private function _QuestLog_SimpleImageBar1_i() : SimpleImageBar
      {
         var _loc1_:SimpleImageBar = new SimpleImageBar();
         _loc1_.x = 25;
         _loc1_.y = 5;
         _loc1_.gap = -10;
         _loc1_.direction = "horizontal";
         _loc1_.verticalAlign = "bottom";
         _loc1_.addEventListener("itemClick",this.__tabs_itemClick);
         this.tabs = _loc1_;
         BindingManager.executeBindings(this,"tabs",this.tabs);
         return _loc1_;
      }
      
      public function __tabs_itemClick(event:ItemClickEvent) : void
      {
         this.tabClick();
      }
      
      private function _QuestLog_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.x = -1;
         _loc1_.y = 43;
         _loc1_.mouseEnabled = false;
         this._QuestLog_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_QuestLog_CachedImage1",this._QuestLog_CachedImage1);
         return _loc1_;
      }
      
      private function _QuestLog_CachedImage2_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.x = 306;
         this._QuestLog_CachedImage2 = _loc1_;
         BindingManager.executeBindings(this,"_QuestLog_CachedImage2",this._QuestLog_CachedImage2);
         return _loc1_;
      }
      
      private function _QuestLog_ScrollBase2_i() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.x = 10;
         _loc1_.y = 73;
         _loc1_.width = 290;
         _loc1_.height = 359;
         _loc1_.verticalScrollPolicy = "auto";
         this.navigator = _loc1_;
         BindingManager.executeBindings(this,"navigator",this.navigator);
         return _loc1_;
      }
      
      private function _QuestLog_Container2_i() : Container
      {
         var _loc1_:Container = new Container();
         _loc1_.x = 335;
         _loc1_.y = 35;
         this.description = _loc1_;
         BindingManager.executeBindings(this,"description",this.description);
         return _loc1_;
      }
      
      private function _QuestLog_Container3_i() : Container
      {
         var _loc1_:Container = new Container();
         _loc1_.x = 333;
         _loc1_.y = 365;
         _loc1_.width = 420;
         _loc1_.height = 1;
         this._QuestLog_Container3 = _loc1_;
         BindingManager.executeBindings(this,"_QuestLog_Container3",this._QuestLog_Container3);
         return _loc1_;
      }
      
      private function _QuestLog_CachedImage3_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.x = 620;
         _loc1_.y = 385;
         _loc1_.addEventListener("click",this.___QuestLog_CachedImage3_click);
         this._QuestLog_CachedImage3 = _loc1_;
         BindingManager.executeBindings(this,"_QuestLog_CachedImage3",this._QuestLog_CachedImage3);
         return _loc1_;
      }
      
      public function ___QuestLog_CachedImage3_click(event:MouseEvent) : void
      {
         this.track();
      }
      
      private function _QuestLog_CachedImage4_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.x = 700;
         _loc1_.y = 385;
         _loc1_.addEventListener("click",this.___QuestLog_CachedImage4_click);
         this._QuestLog_CachedImage4 = _loc1_;
         BindingManager.executeBindings(this,"_QuestLog_CachedImage4",this._QuestLog_CachedImage4);
         return _loc1_;
      }
      
      public function ___QuestLog_CachedImage4_click(event:MouseEvent) : void
      {
         this.cancel();
      }
      
      public function ___QuestLog_Container1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _QuestLog_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():QuestEntry
         {
            return model.selectedQuest;
         },null,"questList.selectedQuest");
         result[1] = new Binding(this,function():Array
         {
            var _loc1_:* = model.hints;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"hintList.hintList");
         result[2] = new Binding(this,function():DialogBranch
         {
            return model.selectedQuest.description;
         },null,"questDescription.dialogBranch");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = getHintText(model.selectedHint.id);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_QuestLog_QuestText1.htmlText");
         result[4] = new Binding(this,function():int
         {
            return model.selectedTab;
         },null,"tabs.selectedIndex");
         result[5] = new Binding(this,function():Array
         {
            var _loc1_:* = TABS;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"tabs.dataProvider");
         result[6] = new Binding(this,function():Array
         {
            var _loc1_:* = model.tabs;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"tabs.toolTips");
         result[7] = new Binding(this,function():Object
         {
            return Assets.questScrollLeft;
         },null,"_QuestLog_CachedImage1.source");
         result[8] = new Binding(this,function():Object
         {
            return Assets.questBg;
         },null,"_QuestLog_CachedImage2.source");
         result[9] = new Binding(this,function():int
         {
            return Colors.QUEST_SPLITTER;
         },null,"_QuestLog_Container3.backgroundColor");
         result[10] = new Binding(this,function():Object
         {
            return Assets.questTrack;
         },null,"_QuestLog_CachedImage3.source");
         result[11] = new Binding(this,function():Boolean
         {
            return tabs.selectedIndex == 0 && model.selectedQuest != null && !model.selectedQuest.tracked;
         },null,"_QuestLog_CachedImage3.enabled");
         result[12] = new Binding(this,function():String
         {
            var _loc1_:* = getString("quest.track");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_QuestLog_CachedImage3.toolTip");
         result[13] = new Binding(this,function():Object
         {
            return Assets.questCancel;
         },null,"_QuestLog_CachedImage4.source");
         result[14] = new Binding(this,function():Boolean
         {
            return tabs.selectedIndex == 0 && model.selectedQuest != null && model.selectedQuest.state != QuestState.FINISHED;
         },null,"_QuestLog_CachedImage4.enabled");
         result[15] = new Binding(this,function():String
         {
            var _loc1_:* = getString("quest.cancel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_QuestLog_CachedImage4.toolTip");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get description() : Container
      {
         return this._1724546052description;
      }
      
      public function set description(param1:Container) : void
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
      public function get hintList() : HintListRenderer
      {
         return this._1474009147hintList;
      }
      
      public function set hintList(param1:HintListRenderer) : void
      {
         var _loc2_:Object = this._1474009147hintList;
         if(_loc2_ !== param1)
         {
            this._1474009147hintList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hintList",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get navigator() : ScrollBase
      {
         return this._752822871navigator;
      }
      
      public function set navigator(param1:ScrollBase) : void
      {
         var _loc2_:Object = this._752822871navigator;
         if(_loc2_ !== param1)
         {
            this._752822871navigator = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"navigator",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get questDescription() : QuestDescription
      {
         return this._1562710458questDescription;
      }
      
      public function set questDescription(param1:QuestDescription) : void
      {
         var _loc2_:Object = this._1562710458questDescription;
         if(_loc2_ !== param1)
         {
            this._1562710458questDescription = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questDescription",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get questList() : QuestListRenderer
      {
         return this._1783104352questList;
      }
      
      public function set questList(param1:QuestListRenderer) : void
      {
         var _loc2_:Object = this._1783104352questList;
         if(_loc2_ !== param1)
         {
            this._1783104352questList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questList",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get questText() : ScrollBase
      {
         return this._1782869713questText;
      }
      
      public function set questText(param1:ScrollBase) : void
      {
         var _loc2_:Object = this._1782869713questText;
         if(_loc2_ !== param1)
         {
            this._1782869713questText = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questText",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get tabs() : SimpleImageBar
      {
         return this._3552126tabs;
      }
      
      public function set tabs(param1:SimpleImageBar) : void
      {
         var _loc2_:Object = this._3552126tabs;
         if(_loc2_ !== param1)
         {
            this._3552126tabs = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tabs",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get model() : QuestModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:QuestModel) : void
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
   }
}

