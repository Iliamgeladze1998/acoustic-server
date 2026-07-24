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
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.condition.Condition;
   import soul.model.interaction.dialog.DialogBranch;
   import soul.model.interaction.dialog.MetaItem;
   import soul.model.item.Item;
   import soul.model.system.Configuration;
   import soul.view.assets.Assets;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientLabel;
   import soul.view.assets.RoundImage;
   import soul.view.interaction.inventory.ItemRenderer;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Canvas;
   import soul.view.ui.Container;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.ScrollBase;
   import soul.view.ui.Tile;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class QuestDescription extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const BR:String = "<br>\n";
      
      private static const WIDTH:uint = 420;
      
      private static const GRADIENT:Array = [[4292194952,200],[14004872,255]];
      
      private static const bundles:Array = [BundleName.INTERFACE,BundleName.QUESTS,BundleName.DIALOG,BundleName.MAPS];
      
      private static const bundles2:Array = [BundleName.SECTOR,BundleName.MAPS];
      
      public var _QuestDescription_CachedImage1:CachedImage;
      
      public var _QuestDescription_Container1:Container;
      
      public var _QuestDescription_Container2:Container;
      
      public var _QuestDescription_GradientLabel1:GradientLabel;
      
      public var _QuestDescription_VBox2:VBox;
      
      private var _1405959847avatar:RoundImage;
      
      private var _930859336conditions:VBox;
      
      private var _830994770mainBox:VBox;
      
      private var _159303329metaRewards:VBox;
      
      private var _1782869713questText:QuestText;
      
      private var _431257354reqLabel:Label;
      
      private var _871541406rewardBlock:VBox;
      
      private var _1162916892rewardBox:HBox;
      
      private var _1100650276rewards:Tile;
      
      private var _1165897982questLog:Boolean;
      
      private var _dialogBranch:DialogBranch;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function QuestDescription()
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
         bindings = this._QuestDescription_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_quest_QuestDescriptionWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return QuestDescription[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.children = [this._QuestDescription_VBox4_i(),this._QuestDescription_Container2_i()];
         this._QuestDescription_VBox3_i();
         this._QuestDescription_Label1_i();
         this._QuestDescription_VBox1_i();
         this._QuestDescription_Tile1_i();
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         QuestDescription._watcherSetupUtil = param1;
      }
      
      public function set dialogBranch(value:DialogBranch) : void
      {
         var reputation:String = null;
         var arr:Array = null;
         var locs:Array = null;
         var location:String = null;
         var qc:Condition = null;
         var qcr:ConditionRenderer = null;
         var item:Item = null;
         var ir:ItemRenderer = null;
         var mitem:MetaItem = null;
         var mir:MetaItemRenderer = null;
         if(this._dialogBranch == value)
         {
            return;
         }
         this._dialogBranch = value;
         this.avatar.source = Boolean(value) ? Configuration.getImage(value.image) : null;
         this.conditions.removeAllChildren();
         this.rewardBox.removeAllChildren();
         this.rewards.removeAllChildren();
         this.metaRewards.removeAllChildren();
         if(!value)
         {
            this.questText.htmlText = "";
            return;
         }
         var localizedText:String = "";
         var headerAdded:Boolean = false;
         if(value.minLevel > 0 || value.maxLevel > 0)
         {
            localizedText += this.getRequirement("level") + Math.max(value.minLevel,1);
            if(value.maxLevel > value.minLevel)
            {
               localizedText += "-" + value.maxLevel;
            }
            localizedText += BR;
            headerAdded = true;
         }
         var reps:Object = {};
         for(reputation in value.maxReputations)
         {
            reps[reputation] = [value.minReputations[reputation],value.maxReputations[reputation]];
         }
         for(reputation in value.minReputations)
         {
            reps[reputation] = reps[reputation] || [value.minReputations[reputation],0];
         }
         for(reputation in reps)
         {
            arr = reps[reputation];
            localizedText += this.getRequirement("level") + this.renderLevels(arr) + " (" + this.getReputation(reputation) + ")";
            localizedText += BR;
         }
         if(value.difficulty != null)
         {
            localizedText += this.getRequirement("quest.difficulty") + this.getString(value.difficulty) + BR;
            headerAdded = true;
         }
         if(value.questGiver != null)
         {
            localizedText += this.getRequirement("quest.giver") + LocaleManager.getString(BundleName.NPC,value.questGiver);
            if(value.questGiverLocation != null)
            {
               localizedText += " (" + this.getLocation(value.questGiverLocation) + ")";
            }
            localizedText += BR;
            headerAdded = true;
         }
         if(value.questTargetLocation != null && value.questTargetLocation.length > 0)
         {
            localizedText += this.getRequirement("quest.targetLocation");
            locs = [];
            for each(location in value.questTargetLocation)
            {
               locs.push(this.getLocation(location));
            }
            localizedText += locs.join(", ") + BR;
            headerAdded = true;
         }
         if(headerAdded)
         {
            localizedText += BR;
         }
         localizedText += this.getString(Boolean(value.locId) ? value.locId : value.id);
         this.questText.htmlText = localizedText;
         if(Boolean(value.requirements) && value.requirements.length > 0)
         {
            this.conditions.addChild(this.reqLabel);
            for each(qc in value.requirements)
            {
               qcr = new ConditionRenderer(this.questLog);
               qcr.condition = qc;
               this.conditions.addChild(qcr);
            }
         }
         if(this.mainBox.contains(this.rewardBlock))
         {
            this.mainBox.removeChild(this.rewardBlock);
         }
         if(Boolean(value.rewards) && Boolean(value.rewards.length > 0) || Boolean(value.metaRewards) && Boolean(value.metaRewards.length > 0))
         {
            this.mainBox.addChild(this.rewardBlock);
            if(Boolean(value.rewards) && value.rewards.length > 0)
            {
               this.rewardBox.addChild(this.rewards);
               for each(item in value.rewards)
               {
                  ir = new ItemRenderer();
                  ir.width = ir.height = 51;
                  ir.item = item;
                  this.rewards.addChild(ir);
               }
            }
            if(Boolean(value.metaRewards) && value.metaRewards.length > 0)
            {
               this.rewardBox.addChild(this.metaRewards);
               for each(mitem in value.metaRewards)
               {
                  mir = new MetaItemRenderer();
                  mir.item = mitem;
                  this.metaRewards.addChild(mir);
               }
            }
         }
      }
      
      private function renderLevels(levels:Array) : String
      {
         var min:uint = uint(levels[0]);
         var max:uint = uint(levels[1]);
         return (min > 0 ? min : 1) + (max > 0 ? "-" + max : "");
      }
      
      private function getRequirement(key:String) : String
      {
         return "<b>" + this.getString(key) + "</b>: ";
      }
      
      private function getReputation(reputation:String) : String
      {
         return LocaleManager.getString(BundleName.REPUTATION,reputation);
      }
      
      private function getString(key:String) : String
      {
         var bundle:String = null;
         var str:String = null;
         for each(bundle in bundles)
         {
            str = LocaleManager.getString(bundle,key);
            if(str != key)
            {
               return str;
            }
         }
         return key;
      }
      
      private function getLocation(key:String) : String
      {
         var bundle:String = null;
         var str:String = null;
         for each(bundle in bundles2)
         {
            str = LocaleManager.getString(bundle,key);
            if(str != key)
            {
               return str;
            }
         }
         return key;
      }
      
      private function _QuestDescription_VBox3_i() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.width = 200;
         _loc1_.gap = -3;
         this.metaRewards = _loc1_;
         BindingManager.executeBindings(this,"metaRewards",this.metaRewards);
         return _loc1_;
      }
      
      private function _QuestDescription_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.color = 12915475;
         _loc1_.bold = true;
         this.reqLabel = _loc1_;
         BindingManager.executeBindings(this,"reqLabel",this.reqLabel);
         return _loc1_;
      }
      
      private function _QuestDescription_VBox1_i() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.gap = 1;
         _loc1_.percentWidth = 100;
         _loc1_.children = [this._QuestDescription_Container1_i(),this._QuestDescription_ScrollBase1_c()];
         this.rewardBlock = _loc1_;
         BindingManager.executeBindings(this,"rewardBlock",this.rewardBlock);
         return _loc1_;
      }
      
      private function _QuestDescription_Container1_i() : Container
      {
         var _loc1_:Container = new Container();
         _loc1_.height = 1;
         _loc1_.percentWidth = 100;
         this._QuestDescription_Container1 = _loc1_;
         BindingManager.executeBindings(this,"_QuestDescription_Container1",this._QuestDescription_Container1);
         return _loc1_;
      }
      
      private function _QuestDescription_ScrollBase1_c() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.percentWidth = 100;
         _loc1_.height = 80;
         _loc1_.verticalScrollPolicy = "auto";
         _loc1_.children = [this._QuestDescription_VBox2_i()];
         return _loc1_;
      }
      
      private function _QuestDescription_VBox2_i() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.gap = 5;
         _loc1_.children = [this._QuestDescription_GradientLabel1_i(),this._QuestDescription_HBox1_i()];
         this._QuestDescription_VBox2 = _loc1_;
         BindingManager.executeBindings(this,"_QuestDescription_VBox2",this._QuestDescription_VBox2);
         return _loc1_;
      }
      
      private function _QuestDescription_GradientLabel1_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.bold = true;
         _loc1_.color = 2649624;
         _loc1_.percentWidth = 100;
         this._QuestDescription_GradientLabel1 = _loc1_;
         BindingManager.executeBindings(this,"_QuestDescription_GradientLabel1",this._QuestDescription_GradientLabel1);
         return _loc1_;
      }
      
      private function _QuestDescription_HBox1_i() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.gap = 1;
         this.rewardBox = _loc1_;
         BindingManager.executeBindings(this,"rewardBox",this.rewardBox);
         return _loc1_;
      }
      
      private function _QuestDescription_Tile1_i() : Tile
      {
         var _loc1_:Tile = new Tile();
         _loc1_.percentWidth = 100;
         _loc1_.gap = 5;
         this.rewards = _loc1_;
         BindingManager.executeBindings(this,"rewards",this.rewards);
         return _loc1_;
      }
      
      private function _QuestDescription_VBox4_i() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.gap = 1;
         _loc1_.children = [this._QuestDescription_ScrollBase2_c()];
         this.mainBox = _loc1_;
         BindingManager.executeBindings(this,"mainBox",this.mainBox);
         return _loc1_;
      }
      
      private function _QuestDescription_ScrollBase2_c() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.verticalScrollPolicy = "auto";
         _loc1_.children = [this._QuestDescription_VBox5_c()];
         return _loc1_;
      }
      
      private function _QuestDescription_VBox5_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.children = [this._QuestDescription_QuestText1_i(),this._QuestDescription_VBox6_i()];
         return _loc1_;
      }
      
      private function _QuestDescription_QuestText1_i() : QuestText
      {
         var _loc1_:QuestText = new QuestText();
         this.questText = _loc1_;
         BindingManager.executeBindings(this,"questText",this.questText);
         return _loc1_;
      }
      
      private function _QuestDescription_VBox6_i() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.gap = -3;
         this.conditions = _loc1_;
         BindingManager.executeBindings(this,"conditions",this.conditions);
         return _loc1_;
      }
      
      private function _QuestDescription_Container2_i() : Container
      {
         var _loc1_:Container = new Container();
         _loc1_.x = -33;
         _loc1_.y = -70;
         _loc1_.children = [this._QuestDescription_RoundImage1_i(),this._QuestDescription_CachedImage1_i()];
         this._QuestDescription_Container2 = _loc1_;
         BindingManager.executeBindings(this,"_QuestDescription_Container2",this._QuestDescription_Container2);
         return _loc1_;
      }
      
      private function _QuestDescription_RoundImage1_i() : RoundImage
      {
         var _loc1_:RoundImage = new RoundImage();
         _loc1_.x = 2;
         _loc1_.width = 66;
         _loc1_.height = 69;
         this.avatar = _loc1_;
         BindingManager.executeBindings(this,"avatar",this.avatar);
         return _loc1_;
      }
      
      private function _QuestDescription_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._QuestDescription_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_QuestDescription_CachedImage1",this._QuestDescription_CachedImage1);
         return _loc1_;
      }
      
      private function _QuestDescription_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = getString("quest.requirements");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"reqLabel.text");
         result[1] = new Binding(this,function():int
         {
            return Colors.QUEST_SPLITTER;
         },null,"_QuestDescription_Container1.backgroundColor");
         result[2] = new Binding(this,function():Number
         {
            return WIDTH;
         },null,"_QuestDescription_VBox2.width");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = getString("quest.rewards");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_QuestDescription_GradientLabel1.text");
         result[4] = new Binding(this,function():Array
         {
            var _loc1_:* = GRADIENT;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_QuestDescription_GradientLabel1.gradient");
         result[5] = new Binding(this,function():Number
         {
            return WIDTH - 15;
         },null,"questText.width");
         result[6] = new Binding(this,function():Boolean
         {
            return !questLog && avatar.source != null;
         },null,"_QuestDescription_Container2.visible");
         result[7] = new Binding(this,function():Object
         {
            return Assets.roundFrameBig;
         },null,"_QuestDescription_CachedImage1.source");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get avatar() : RoundImage
      {
         return this._1405959847avatar;
      }
      
      public function set avatar(param1:RoundImage) : void
      {
         var _loc2_:Object = this._1405959847avatar;
         if(_loc2_ !== param1)
         {
            this._1405959847avatar = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"avatar",_loc2_,param1));
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
      public function get mainBox() : VBox
      {
         return this._830994770mainBox;
      }
      
      public function set mainBox(param1:VBox) : void
      {
         var _loc2_:Object = this._830994770mainBox;
         if(_loc2_ !== param1)
         {
            this._830994770mainBox = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mainBox",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get metaRewards() : VBox
      {
         return this._159303329metaRewards;
      }
      
      public function set metaRewards(param1:VBox) : void
      {
         var _loc2_:Object = this._159303329metaRewards;
         if(_loc2_ !== param1)
         {
            this._159303329metaRewards = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"metaRewards",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get questText() : QuestText
      {
         return this._1782869713questText;
      }
      
      public function set questText(param1:QuestText) : void
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
      public function get reqLabel() : Label
      {
         return this._431257354reqLabel;
      }
      
      public function set reqLabel(param1:Label) : void
      {
         var _loc2_:Object = this._431257354reqLabel;
         if(_loc2_ !== param1)
         {
            this._431257354reqLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"reqLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rewardBlock() : VBox
      {
         return this._871541406rewardBlock;
      }
      
      public function set rewardBlock(param1:VBox) : void
      {
         var _loc2_:Object = this._871541406rewardBlock;
         if(_loc2_ !== param1)
         {
            this._871541406rewardBlock = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rewardBlock",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rewardBox() : HBox
      {
         return this._1162916892rewardBox;
      }
      
      public function set rewardBox(param1:HBox) : void
      {
         var _loc2_:Object = this._1162916892rewardBox;
         if(_loc2_ !== param1)
         {
            this._1162916892rewardBox = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rewardBox",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rewards() : Tile
      {
         return this._1100650276rewards;
      }
      
      public function set rewards(param1:Tile) : void
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
      public function get questLog() : Boolean
      {
         return this._1165897982questLog;
      }
      
      public function set questLog(param1:Boolean) : void
      {
         var _loc2_:Object = this._1165897982questLog;
         if(_loc2_ !== param1)
         {
            this._1165897982questLog = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questLog",_loc2_,param1));
            }
         }
      }
   }
}

