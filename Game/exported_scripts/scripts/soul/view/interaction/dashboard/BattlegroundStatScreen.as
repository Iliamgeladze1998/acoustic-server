package soul.view.interaction.dashboard
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
   import soul.event.SimpleUIEvent;
   import soul.model.character.DispositionGroup;
   import soul.model.interaction.dashboard.BattlegroundStatistics;
   import soul.model.interaction.dashboard.Combatant;
   import soul.model.interaction.dashboard.Team;
   import soul.model.item.Item;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.HBox;
   
   use namespace mx_internal;
   
   public class BattlegroundStatScreen extends HBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _BattlegroundStatScreen_Combatant1:Combatant;
      
      public var _BattlegroundStatScreen_Combatant2:Combatant;
      
      public var _BattlegroundStatScreen_Combatant3:Combatant;
      
      public var _BattlegroundStatScreen_Combatant4:Combatant;
      
      public var _BattlegroundStatScreen_Combatant5:Combatant;
      
      public var _BattlegroundStatScreen_Combatant6:Combatant;
      
      public var _BattlegroundStatScreen_Combatant7:Combatant;
      
      public var _BattlegroundStatScreen_Combatant8:Combatant;
      
      public var _BattlegroundStatScreen_Combatant9:Combatant;
      
      public var _BattlegroundStatScreen_TeamRenderer1:TeamRenderer;
      
      public var _BattlegroundStatScreen_TeamRenderer2:TeamRenderer;
      
      private var _892481678stats1:BattlegroundStatistics;
      
      private var _109757599stats:BattlegroundStatistics;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function BattlegroundStatScreen()
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
         bindings = this._BattlegroundStatScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_dashboard_BattlegroundStatScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return BattlegroundStatScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.gap = 10;
         this.padding = 9;
         this.children = [this._BattlegroundStatScreen_TeamRenderer1_i(),this._BattlegroundStatScreen_TeamRenderer2_i()];
         this._BattlegroundStatScreen_BattlegroundStatistics1_i();
         this.addEventListener("creationComplete",this.___BattlegroundStatScreen_HBox1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         BattlegroundStatScreen._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         InteractionWindow.setLabelToInteractionParent(this,this.getString("statistics.title"));
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _BattlegroundStatScreen_BattlegroundStatistics1_i() : BattlegroundStatistics
      {
         var _loc1_:BattlegroundStatistics = new BattlegroundStatistics();
         _loc1_.winningTeam = 0;
         _loc1_.myTeam = 0;
         _loc1_.myCombatantId = "id3";
         _loc1_.teams = [this._BattlegroundStatScreen_Team1_c(),this._BattlegroundStatScreen_Team2_c()];
         this.stats1 = _loc1_;
         BindingManager.executeBindings(this,"stats1",this.stats1);
         return _loc1_;
      }
      
      private function _BattlegroundStatScreen_Team1_c() : Team
      {
         var _loc1_:Team = new Team();
         _loc1_.name = "team1";
         _loc1_.combatants = [this._BattlegroundStatScreen_Combatant1_i(),this._BattlegroundStatScreen_Combatant2_i(),this._BattlegroundStatScreen_Combatant3_i(),this._BattlegroundStatScreen_Combatant4_i(),this._BattlegroundStatScreen_Combatant5_i()];
         _loc1_.awards = [this._BattlegroundStatScreen_Item1_c(),this._BattlegroundStatScreen_Item2_c(),this._BattlegroundStatScreen_Item3_c(),this._BattlegroundStatScreen_Item4_c(),this._BattlegroundStatScreen_Item5_c()];
         return _loc1_;
      }
      
      private function _BattlegroundStatScreen_Combatant1_i() : Combatant
      {
         var _loc1_:Combatant = new Combatant();
         _loc1_.name = "Player 1";
         _loc1_.kills = 23;
         _loc1_.deaths = 15;
         _loc1_.score = 230;
         _loc1_.level = 12;
         this._BattlegroundStatScreen_Combatant1 = _loc1_;
         BindingManager.executeBindings(this,"_BattlegroundStatScreen_Combatant1",this._BattlegroundStatScreen_Combatant1);
         return _loc1_;
      }
      
      private function _BattlegroundStatScreen_Combatant2_i() : Combatant
      {
         var _loc1_:Combatant = new Combatant();
         _loc1_.name = "Player 2";
         _loc1_.kills = 15;
         _loc1_.deaths = 25;
         _loc1_.level = 10;
         this._BattlegroundStatScreen_Combatant2 = _loc1_;
         BindingManager.executeBindings(this,"_BattlegroundStatScreen_Combatant2",this._BattlegroundStatScreen_Combatant2);
         return _loc1_;
      }
      
      private function _BattlegroundStatScreen_Combatant3_i() : Combatant
      {
         var _loc1_:Combatant = new Combatant();
         _loc1_.name = "Player 3";
         _loc1_.kills = 22;
         _loc1_.deaths = 2;
         _loc1_.score = 120;
         _loc1_.level = 15;
         this._BattlegroundStatScreen_Combatant3 = _loc1_;
         BindingManager.executeBindings(this,"_BattlegroundStatScreen_Combatant3",this._BattlegroundStatScreen_Combatant3);
         return _loc1_;
      }
      
      private function _BattlegroundStatScreen_Combatant4_i() : Combatant
      {
         var _loc1_:Combatant = new Combatant();
         _loc1_.name = "Player 4";
         _loc1_.kills = 10;
         _loc1_.deaths = 12;
         _loc1_.level = 7;
         _loc1_.score = 4300;
         this._BattlegroundStatScreen_Combatant4 = _loc1_;
         BindingManager.executeBindings(this,"_BattlegroundStatScreen_Combatant4",this._BattlegroundStatScreen_Combatant4);
         return _loc1_;
      }
      
      private function _BattlegroundStatScreen_Combatant5_i() : Combatant
      {
         var _loc1_:Combatant = new Combatant();
         _loc1_.name = "Player 5";
         _loc1_.kills = 9;
         _loc1_.deaths = 63;
         _loc1_.level = 22;
         this._BattlegroundStatScreen_Combatant5 = _loc1_;
         BindingManager.executeBindings(this,"_BattlegroundStatScreen_Combatant5",this._BattlegroundStatScreen_Combatant5);
         return _loc1_;
      }
      
      private function _BattlegroundStatScreen_Item1_c() : Item
      {
         var _loc1_:Item = new Item();
         _loc1_.templateId = "COPPER";
         _loc1_.count = 600;
         _loc1_.imagePath = "money/copper.png";
         _loc1_.itemClass = "CLASS1";
         return _loc1_;
      }
      
      private function _BattlegroundStatScreen_Item2_c() : Item
      {
         var _loc1_:Item = new Item();
         _loc1_.templateId = "PVP";
         _loc1_.count = 560;
         _loc1_.imagePath = "money/pvp_money.png";
         _loc1_.itemClass = "CLASS1";
         return _loc1_;
      }
      
      private function _BattlegroundStatScreen_Item3_c() : Item
      {
         var _loc1_:Item = new Item();
         _loc1_.templateId = "bow_01";
         _loc1_.count = 1;
         _loc1_.imagePath = "weapon/bow/bow_default.png";
         _loc1_.itemClass = "CLASS1";
         return _loc1_;
      }
      
      private function _BattlegroundStatScreen_Item4_c() : Item
      {
         var _loc1_:Item = new Item();
         _loc1_.templateId = "boots_01";
         _loc1_.count = 1;
         _loc1_.imagePath = "other/sword_030.png";
         _loc1_.itemClass = "CLASS1";
         return _loc1_;
      }
      
      private function _BattlegroundStatScreen_Item5_c() : Item
      {
         var _loc1_:Item = new Item();
         _loc1_.templateId = "boots_01";
         _loc1_.count = 1;
         _loc1_.imagePath = "other/sword_030.png";
         _loc1_.itemClass = "CLASS1";
         return _loc1_;
      }
      
      private function _BattlegroundStatScreen_Team2_c() : Team
      {
         var _loc1_:Team = new Team();
         _loc1_.name = "team2";
         _loc1_.combatants = [this._BattlegroundStatScreen_Combatant6_i(),this._BattlegroundStatScreen_Combatant7_i(),this._BattlegroundStatScreen_Combatant8_i(),this._BattlegroundStatScreen_Combatant9_i()];
         _loc1_.awards = [this._BattlegroundStatScreen_Item6_c(),this._BattlegroundStatScreen_Item7_c()];
         return _loc1_;
      }
      
      private function _BattlegroundStatScreen_Combatant6_i() : Combatant
      {
         var _loc1_:Combatant = new Combatant();
         _loc1_.name = "Player 6";
         _loc1_.kills = 35;
         _loc1_.deaths = 25;
         _loc1_.level = 16;
         this._BattlegroundStatScreen_Combatant6 = _loc1_;
         BindingManager.executeBindings(this,"_BattlegroundStatScreen_Combatant6",this._BattlegroundStatScreen_Combatant6);
         return _loc1_;
      }
      
      private function _BattlegroundStatScreen_Combatant7_i() : Combatant
      {
         var _loc1_:Combatant = new Combatant();
         _loc1_.name = "Player 7";
         _loc1_.kills = 20;
         _loc1_.deaths = 35;
         _loc1_.level = 12;
         this._BattlegroundStatScreen_Combatant7 = _loc1_;
         BindingManager.executeBindings(this,"_BattlegroundStatScreen_Combatant7",this._BattlegroundStatScreen_Combatant7);
         return _loc1_;
      }
      
      private function _BattlegroundStatScreen_Combatant8_i() : Combatant
      {
         var _loc1_:Combatant = new Combatant();
         _loc1_.name = "Player 8";
         _loc1_.kills = 2;
         _loc1_.deaths = 64;
         _loc1_.level = 12;
         this._BattlegroundStatScreen_Combatant8 = _loc1_;
         BindingManager.executeBindings(this,"_BattlegroundStatScreen_Combatant8",this._BattlegroundStatScreen_Combatant8);
         return _loc1_;
      }
      
      private function _BattlegroundStatScreen_Combatant9_i() : Combatant
      {
         var _loc1_:Combatant = new Combatant();
         _loc1_.name = "Player 9";
         _loc1_.kills = 3;
         _loc1_.deaths = 1;
         _loc1_.level = 25;
         this._BattlegroundStatScreen_Combatant9 = _loc1_;
         BindingManager.executeBindings(this,"_BattlegroundStatScreen_Combatant9",this._BattlegroundStatScreen_Combatant9);
         return _loc1_;
      }
      
      private function _BattlegroundStatScreen_Item6_c() : Item
      {
         var _loc1_:Item = new Item();
         _loc1_.templateId = "COPPER";
         _loc1_.count = 600;
         _loc1_.imagePath = "money/copper.png";
         _loc1_.itemClass = "CLASS1";
         return _loc1_;
      }
      
      private function _BattlegroundStatScreen_Item7_c() : Item
      {
         var _loc1_:Item = new Item();
         _loc1_.templateId = "PVP";
         _loc1_.count = 560;
         _loc1_.imagePath = "money/pvp_money.png";
         _loc1_.itemClass = "CLASS1";
         return _loc1_;
      }
      
      private function _BattlegroundStatScreen_TeamRenderer1_i() : TeamRenderer
      {
         var _loc1_:TeamRenderer = new TeamRenderer();
         this._BattlegroundStatScreen_TeamRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_BattlegroundStatScreen_TeamRenderer1",this._BattlegroundStatScreen_TeamRenderer1);
         return _loc1_;
      }
      
      private function _BattlegroundStatScreen_TeamRenderer2_i() : TeamRenderer
      {
         var _loc1_:TeamRenderer = new TeamRenderer();
         this._BattlegroundStatScreen_TeamRenderer2 = _loc1_;
         BindingManager.executeBindings(this,"_BattlegroundStatScreen_TeamRenderer2",this._BattlegroundStatScreen_TeamRenderer2);
         return _loc1_;
      }
      
      public function ___BattlegroundStatScreen_HBox1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _BattlegroundStatScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = DispositionGroup.PRIEST;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BattlegroundStatScreen_Combatant1.disposition");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = DispositionGroup.MAGICIAN;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BattlegroundStatScreen_Combatant2.disposition");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = DispositionGroup.THIEF;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BattlegroundStatScreen_Combatant3.disposition");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = DispositionGroup.WARRIOR;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BattlegroundStatScreen_Combatant4.disposition");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = DispositionGroup.WARRIOR;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BattlegroundStatScreen_Combatant5.disposition");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = DispositionGroup.PRIEST;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BattlegroundStatScreen_Combatant6.disposition");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = DispositionGroup.MAGICIAN;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BattlegroundStatScreen_Combatant7.disposition");
         result[7] = new Binding(this,function():String
         {
            var _loc1_:* = DispositionGroup.THIEF;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BattlegroundStatScreen_Combatant8.disposition");
         result[8] = new Binding(this,function():String
         {
            var _loc1_:* = DispositionGroup.WARRIOR;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BattlegroundStatScreen_Combatant9.disposition");
         result[9] = new Binding(this,function():String
         {
            var _loc1_:* = stats.myCombatantId;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BattlegroundStatScreen_TeamRenderer1.myCombatantId");
         result[10] = new Binding(this,function():Team
         {
            return stats.teams[0];
         },null,"_BattlegroundStatScreen_TeamRenderer1.team");
         result[11] = new Binding(this,function():Boolean
         {
            return stats.winningTeam == 0;
         },null,"_BattlegroundStatScreen_TeamRenderer1.win");
         result[12] = new Binding(this,function():Boolean
         {
            return stats.myTeam == 0;
         },null,"_BattlegroundStatScreen_TeamRenderer1.myTeam");
         result[13] = new Binding(this,function():String
         {
            var _loc1_:* = stats.myCombatantId;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BattlegroundStatScreen_TeamRenderer2.myCombatantId");
         result[14] = new Binding(this,function():Team
         {
            return stats.teams[1];
         },null,"_BattlegroundStatScreen_TeamRenderer2.team");
         result[15] = new Binding(this,function():Boolean
         {
            return stats.winningTeam == 1;
         },null,"_BattlegroundStatScreen_TeamRenderer2.win");
         result[16] = new Binding(this,function():Boolean
         {
            return stats.myTeam == 1;
         },null,"_BattlegroundStatScreen_TeamRenderer2.myTeam");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get stats1() : BattlegroundStatistics
      {
         return this._892481678stats1;
      }
      
      public function set stats1(param1:BattlegroundStatistics) : void
      {
         var _loc2_:Object = this._892481678stats1;
         if(_loc2_ !== param1)
         {
            this._892481678stats1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"stats1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get stats() : BattlegroundStatistics
      {
         return this._109757599stats;
      }
      
      public function set stats(param1:BattlegroundStatistics) : void
      {
         var _loc2_:Object = this._109757599stats;
         if(_loc2_ !== param1)
         {
            this._109757599stats = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"stats",_loc2_,param1));
            }
         }
      }
   }
}

