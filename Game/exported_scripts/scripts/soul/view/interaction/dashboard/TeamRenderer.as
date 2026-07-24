package soul.view.interaction.dashboard
{
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.DropShadowFilter;
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
   import soul.model.interaction.dashboard.Combatant;
   import soul.model.interaction.dashboard.Team;
   import soul.model.item.Item;
   import soul.view.assets.Assets;
   import soul.view.common.Icons;
   import soul.view.interaction.inventory.ItemRenderer;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Canvas;
   import soul.view.ui.Component;
   import soul.view.ui.Container;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class TeamRenderer extends BorderedContainer implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const SHADOW:Array = [new DropShadowFilter(2,45,0,1,0,0,1)];
      
      public var _TeamRenderer_CachedImage1:CachedImage;
      
      public var _TeamRenderer_CachedImage3:CachedImage;
      
      public var _TeamRenderer_CachedImage4:CachedImage;
      
      public var _TeamRenderer_CachedImage5:CachedImage;
      
      public var _TeamRenderer_CachedImage6:CachedImage;
      
      public var _TeamRenderer_CachedImage7:CachedImage;
      
      public var _TeamRenderer_Canvas1:Canvas;
      
      public var _TeamRenderer_Label1:Label;
      
      private var _1405038154awards:VBox;
      
      private var _382982048combatants:VBox;
      
      private var _3226745icon:CachedImage;
      
      private var _100526016items:HBox;
      
      private var _1668760952teamName:Label;
      
      private var _117724win:Boolean;
      
      private var _1060041175myTeam:Boolean;
      
      public var myCombatantId:String;
      
      private var _team:Team;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function TeamRenderer()
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
         bindings = this._TeamRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_dashboard_TeamRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return TeamRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 372;
         this.minHeight = 209;
         this.direction = "vertical";
         this.padding = 3;
         this.children = [this._TeamRenderer_Canvas1_i(),this._TeamRenderer_HBox2_c(),this._TeamRenderer_HBox3_c(),this._TeamRenderer_VBox2_i()];
         this._TeamRenderer_VBox1_i();
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         TeamRenderer._watcherSetupUtil = param1;
      }
      
      public function set team(value:Team) : void
      {
         var itemChild:ItemRenderer = null;
         var combatant:Combatant = null;
         var item:Item = null;
         var combatantChild:CombatantRenderer = null;
         this._team = value;
         if(Boolean(value.awards) && value.awards.length > 0)
         {
            for each(item in value.awards)
            {
               itemChild = new ItemRenderer();
               itemChild.item = item;
               itemChild.width = itemChild.height = 51;
               this.items.addChild(itemChild);
            }
            addChild(this.awards);
         }
         for each(combatant in value.combatants)
         {
            combatantChild = new CombatantRenderer();
            combatantChild.combatant = combatant;
            if(combatant.id == this.myCombatantId)
            {
               combatantChild.color = 439851;
            }
            this.combatants.addChild(combatantChild);
         }
         this.teamName.text = value.name;
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _TeamRenderer_VBox1_i() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 82;
         _loc1_.padding = 9;
         _loc1_.backgroundColor = 0;
         _loc1_.backgroundAlpha = 0.4;
         _loc1_.children = [this._TeamRenderer_Label1_i(),this._TeamRenderer_HBox1_i()];
         this.awards = _loc1_;
         BindingManager.executeBindings(this,"awards",this.awards);
         return _loc1_;
      }
      
      private function _TeamRenderer_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.bold = true;
         _loc1_.color = 439851;
         this._TeamRenderer_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_TeamRenderer_Label1",this._TeamRenderer_Label1);
         return _loc1_;
      }
      
      private function _TeamRenderer_HBox1_i() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 5;
         _loc1_.height = 51;
         this.items = _loc1_;
         BindingManager.executeBindings(this,"items",this.items);
         return _loc1_;
      }
      
      private function _TeamRenderer_Canvas1_i() : Canvas
      {
         var _loc1_:Canvas = new Canvas();
         _loc1_.percentWidth = 100;
         _loc1_.children = [this._TeamRenderer_CachedImage1_i()];
         this._TeamRenderer_Canvas1 = _loc1_;
         BindingManager.executeBindings(this,"_TeamRenderer_Canvas1",this._TeamRenderer_Canvas1);
         return _loc1_;
      }
      
      private function _TeamRenderer_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.horizontalCenter = 0;
         _loc1_.verticalCenter = 0;
         this._TeamRenderer_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_TeamRenderer_CachedImage1",this._TeamRenderer_CachedImage1);
         return _loc1_;
      }
      
      private function _TeamRenderer_HBox2_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 10;
         _loc1_.height = 36;
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._TeamRenderer_Component1_c(),this._TeamRenderer_CachedImage2_i(),this._TeamRenderer_Label2_i()];
         return _loc1_;
      }
      
      private function _TeamRenderer_Component1_c() : Component
      {
         return new Component();
      }
      
      private function _TeamRenderer_CachedImage2_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this.icon = _loc1_;
         BindingManager.executeBindings(this,"icon",this.icon);
         return _loc1_;
      }
      
      private function _TeamRenderer_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.bold = true;
         this.teamName = _loc1_;
         BindingManager.executeBindings(this,"teamName",this.teamName);
         return _loc1_;
      }
      
      private function _TeamRenderer_HBox3_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 10;
         _loc1_.percentWidth = 100;
         _loc1_.height = 30;
         _loc1_.backgroundColor = 0;
         _loc1_.backgroundAlpha = 0.4;
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._TeamRenderer_Component2_c(),this._TeamRenderer_CachedImage3_i(),this._TeamRenderer_Container1_c(),this._TeamRenderer_CachedImage5_i(),this._TeamRenderer_CachedImage6_i(),this._TeamRenderer_Component3_c(),this._TeamRenderer_CachedImage7_i()];
         return _loc1_;
      }
      
      private function _TeamRenderer_Component2_c() : Component
      {
         return new Component();
      }
      
      private function _TeamRenderer_CachedImage3_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._TeamRenderer_CachedImage3 = _loc1_;
         BindingManager.executeBindings(this,"_TeamRenderer_CachedImage3",this._TeamRenderer_CachedImage3);
         return _loc1_;
      }
      
      private function _TeamRenderer_Container1_c() : Container
      {
         var _loc1_:Container = new Container();
         _loc1_.width = 165;
         _loc1_.height = 26;
         _loc1_.children = [this._TeamRenderer_CachedImage4_i()];
         return _loc1_;
      }
      
      private function _TeamRenderer_CachedImage4_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._TeamRenderer_CachedImage4 = _loc1_;
         BindingManager.executeBindings(this,"_TeamRenderer_CachedImage4",this._TeamRenderer_CachedImage4);
         return _loc1_;
      }
      
      private function _TeamRenderer_CachedImage5_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._TeamRenderer_CachedImage5 = _loc1_;
         BindingManager.executeBindings(this,"_TeamRenderer_CachedImage5",this._TeamRenderer_CachedImage5);
         return _loc1_;
      }
      
      private function _TeamRenderer_CachedImage6_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._TeamRenderer_CachedImage6 = _loc1_;
         BindingManager.executeBindings(this,"_TeamRenderer_CachedImage6",this._TeamRenderer_CachedImage6);
         return _loc1_;
      }
      
      private function _TeamRenderer_Component3_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.width = 5;
         return _loc1_;
      }
      
      private function _TeamRenderer_CachedImage7_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._TeamRenderer_CachedImage7 = _loc1_;
         BindingManager.executeBindings(this,"_TeamRenderer_CachedImage7",this._TeamRenderer_CachedImage7);
         return _loc1_;
      }
      
      private function _TeamRenderer_VBox2_i() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 144;
         _loc1_.gap = 1;
         this.combatants = _loc1_;
         BindingManager.executeBindings(this,"combatants",this.combatants);
         return _loc1_;
      }
      
      private function _TeamRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return Assets.shadedBorderRound;
         },null,"this.borderSkin");
         result[1] = new Binding(this,function():Object
         {
            return Assets.pattern_06;
         },null,"this.backgroundImage");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = getString("award") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_TeamRenderer_Label1.text");
         result[3] = new Binding(this,null,null,"_TeamRenderer_Canvas1.visible","win");
         result[4] = new Binding(this,function():Object
         {
            return Icons.bg_win;
         },null,"_TeamRenderer_CachedImage1.source");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = getString("winner_team");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_TeamRenderer_CachedImage1.toolTip");
         result[6] = new Binding(this,function():Object
         {
            return myTeam ? Icons.bg_team_green : Icons.bg_team_red;
         },null,"icon.source");
         result[7] = new Binding(this,function():uint
         {
            return myTeam ? 439851 : 15215403;
         },null,"teamName.color");
         result[8] = new Binding(this,function():Array
         {
            var _loc1_:* = SHADOW;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"teamName.filters");
         result[9] = new Binding(this,function():String
         {
            var _loc1_:* = getString("disposition");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_TeamRenderer_CachedImage3.toolTip");
         result[10] = new Binding(this,function():Object
         {
            return Icons.bg_disposition;
         },null,"_TeamRenderer_CachedImage3.source");
         result[11] = new Binding(this,function():String
         {
            var _loc1_:* = getString("level");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_TeamRenderer_CachedImage4.toolTip");
         result[12] = new Binding(this,function():Object
         {
            return Icons.level;
         },null,"_TeamRenderer_CachedImage4.source");
         result[13] = new Binding(this,function():String
         {
            var _loc1_:* = getString("kills");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_TeamRenderer_CachedImage5.toolTip");
         result[14] = new Binding(this,function():Object
         {
            return Icons.bg_kills;
         },null,"_TeamRenderer_CachedImage5.source");
         result[15] = new Binding(this,function():String
         {
            var _loc1_:* = getString("deaths");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_TeamRenderer_CachedImage6.toolTip");
         result[16] = new Binding(this,function():Object
         {
            return Icons.bg_deaths;
         },null,"_TeamRenderer_CachedImage6.source");
         result[17] = new Binding(this,function():String
         {
            var _loc1_:* = getString("score");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_TeamRenderer_CachedImage7.toolTip");
         result[18] = new Binding(this,function():Object
         {
            return Icons.bg_award;
         },null,"_TeamRenderer_CachedImage7.source");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get awards() : VBox
      {
         return this._1405038154awards;
      }
      
      public function set awards(param1:VBox) : void
      {
         var _loc2_:Object = this._1405038154awards;
         if(_loc2_ !== param1)
         {
            this._1405038154awards = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"awards",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get combatants() : VBox
      {
         return this._382982048combatants;
      }
      
      public function set combatants(param1:VBox) : void
      {
         var _loc2_:Object = this._382982048combatants;
         if(_loc2_ !== param1)
         {
            this._382982048combatants = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"combatants",_loc2_,param1));
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
      
      [Bindable(event="propertyChange")]
      public function get items() : HBox
      {
         return this._100526016items;
      }
      
      public function set items(param1:HBox) : void
      {
         var _loc2_:Object = this._100526016items;
         if(_loc2_ !== param1)
         {
            this._100526016items = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"items",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get teamName() : Label
      {
         return this._1668760952teamName;
      }
      
      public function set teamName(param1:Label) : void
      {
         var _loc2_:Object = this._1668760952teamName;
         if(_loc2_ !== param1)
         {
            this._1668760952teamName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamName",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get win() : Boolean
      {
         return this._117724win;
      }
      
      public function set win(param1:Boolean) : void
      {
         var _loc2_:Object = this._117724win;
         if(_loc2_ !== param1)
         {
            this._117724win = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"win",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get myTeam() : Boolean
      {
         return this._1060041175myTeam;
      }
      
      public function set myTeam(param1:Boolean) : void
      {
         var _loc2_:Object = this._1060041175myTeam;
         if(_loc2_ !== param1)
         {
            this._1060041175myTeam = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"myTeam",_loc2_,param1));
            }
         }
      }
   }
}

