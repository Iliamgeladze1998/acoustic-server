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
   import soul.model.interaction.dialog.DialogAnswer;
   import soul.model.interaction.dialog.DialogBranch;
   import soul.view.assets.Assets;
   import soul.view.assets.Colors;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Canvas;
   import soul.view.ui.Component;
   import soul.view.ui.Container;
   import soul.view.ui.ScrollBase;
   import soul.view.ui.VBox;
   import soul.view.ui.controls.PopupManager;
   
   use namespace mx_internal;
   
   public class QuestDialog extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _QuestDialog_CachedImage1:CachedImage;
      
      public var _QuestDialog_ScrollBase1:ScrollBase;
      
      private var _847398795answers:VBox;
      
      private var _1067478618objectives:QuestDescription;
      
      private var _1926588729splitter:Container;
      
      private var dialog:DialogBranch;
      
      private var messageId:String;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function QuestDialog()
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
         bindings = this._QuestDialog_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_quest_QuestDialogWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return QuestDialog[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 480;
         this.height = 452;
         this.children = [this._QuestDialog_CachedImage1_i(),this._QuestDialog_VBox1_c()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         QuestDialog._watcherSetupUtil = param1;
      }
      
      public function init(dialog:DialogBranch) : void
      {
         var answer:DialogAnswer = null;
         var child:AnswerRenderer = null;
         this.answers.removeAllChildren();
         this.dialog = dialog;
         this.objectives.dialogBranch = dialog;
         if(!dialog.answers || dialog.answers.length < 1)
         {
            return;
         }
         this.splitter.visible = true;
         for each(answer in dialog.answers)
         {
            child = new AnswerRenderer();
            child.answer = answer;
            child.addEventListener(MouseEvent.CLICK,this.answerClick,false,0,true);
            this.answers.addChild(child);
         }
      }
      
      private function center() : void
      {
         var realParent:InteractionWindow = InteractionWindow.findInteractionParent(this);
         if(Boolean(realParent))
         {
            PopupManager.centerPopup(realParent);
         }
      }
      
      private function answerClick(e:MouseEvent) : void
      {
         var ne:ItemClickEvent = null;
         this.answers.mouseChildren = false;
         var answer:DialogAnswer = AnswerRenderer(e.currentTarget).answer;
         if(Boolean(answer.branch))
         {
            this.answers.mouseChildren = true;
            this.init(answer.branch);
         }
         else
         {
            ne = new ItemClickEvent(ItemClickEvent.ITEM_CLICK);
            ne.item = this.dialog;
            ne.label = answer.id;
            dispatchEvent(ne);
         }
      }
      
      public function unlock() : void
      {
         this.answers.mouseChildren = true;
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.QUESTS,key);
      }
      
      private function _QuestDialog_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._QuestDialog_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_QuestDialog_CachedImage1",this._QuestDialog_CachedImage1);
         return _loc1_;
      }
      
      private function _QuestDialog_VBox1_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.padding = 30;
         _loc1_.gap = 3;
         _loc1_.children = [this._QuestDialog_Component1_c(),this._QuestDialog_QuestDescription1_i(),this._QuestDialog_Container1_i(),this._QuestDialog_ScrollBase1_i()];
         return _loc1_;
      }
      
      private function _QuestDialog_Component1_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.height = 8;
         return _loc1_;
      }
      
      private function _QuestDialog_QuestDescription1_i() : QuestDescription
      {
         var _loc1_:QuestDescription = new QuestDescription();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         this.objectives = _loc1_;
         BindingManager.executeBindings(this,"objectives",this.objectives);
         return _loc1_;
      }
      
      private function _QuestDialog_Container1_i() : Container
      {
         var _loc1_:Container = new Container();
         _loc1_.percentWidth = 100;
         _loc1_.height = 1;
         _loc1_.visible = false;
         this.splitter = _loc1_;
         BindingManager.executeBindings(this,"splitter",this.splitter);
         return _loc1_;
      }
      
      private function _QuestDialog_ScrollBase1_i() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.percentWidth = 100;
         _loc1_.verticalScrollPolicy = "auto";
         _loc1_.children = [this._QuestDialog_VBox2_i()];
         this._QuestDialog_ScrollBase1 = _loc1_;
         BindingManager.executeBindings(this,"_QuestDialog_ScrollBase1",this._QuestDialog_ScrollBase1);
         return _loc1_;
      }
      
      private function _QuestDialog_VBox2_i() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.gap = 2;
         this.answers = _loc1_;
         BindingManager.executeBindings(this,"answers",this.answers);
         return _loc1_;
      }
      
      private function _QuestDialog_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return Assets.questBg;
         },null,"_QuestDialog_CachedImage1.source");
         result[1] = new Binding(this,function():int
         {
            return Colors.QUEST_SPLITTER;
         },null,"splitter.backgroundColor");
         result[2] = new Binding(this,function():Number
         {
            return Math.min(answers.height,127);
         },null,"_QuestDialog_ScrollBase1.height");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get answers() : VBox
      {
         return this._847398795answers;
      }
      
      public function set answers(param1:VBox) : void
      {
         var _loc2_:Object = this._847398795answers;
         if(_loc2_ !== param1)
         {
            this._847398795answers = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"answers",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get objectives() : QuestDescription
      {
         return this._1067478618objectives;
      }
      
      public function set objectives(param1:QuestDescription) : void
      {
         var _loc2_:Object = this._1067478618objectives;
         if(_loc2_ !== param1)
         {
            this._1067478618objectives = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"objectives",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get splitter() : Container
      {
         return this._1926588729splitter;
      }
      
      public function set splitter(param1:Container) : void
      {
         var _loc2_:Object = this._1926588729splitter;
         if(_loc2_ !== param1)
         {
            this._1926588729splitter = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"splitter",_loc2_,param1));
            }
         }
      }
   }
}

