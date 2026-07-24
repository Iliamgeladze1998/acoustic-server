package soul.model.interaction.dashboard
{
   import flash.events.Event;
   import mx.events.PropertyChangeEvent;
   import soul.model.item.Item;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientLabel;
   import soul.view.interaction.inventory.ItemRenderer;
   import soul.view.ui.Component;
   import soul.view.ui.Tile;
   
   public class BattlegroundEntry extends DashboardEntry
   {
      
      private var _3575610type:String;
      
      private var _1386076078minLevel:int;
      
      private var _390120576maxLevel:int;
      
      private var _1142598912minPlayers:int;
      
      private var _680369070maxPlayers:int;
      
      private var _1154529463joined:Boolean;
      
      private var _1100650276rewards:Array;
      
      private var _1080232679penalties:Array;
      
      public function BattlegroundEntry()
      {
         super();
      }
      
      private static function createTile(items:Array) : Tile
      {
         var t:Tile = null;
         var item:Item = null;
         var child:ItemRenderer = null;
         t = new Tile();
         t.gap = 4;
         t.percentWidth = 100;
         for each(item in items)
         {
            child = new ItemRenderer();
            child.width = child.height = 52;
            child.item = item;
            t.addChild(child);
         }
         return t;
      }
      
      override public function get icon() : Object
      {
         return BattlegroundType.getIcon(this.type);
      }
      
      override public function get canBeAccepted() : Boolean
      {
         return active && !this.joined;
      }
      
      override public function get canBeDenied() : Boolean
      {
         return this.joined;
      }
      
      override public function getDescriptors() : Vector.<Component>
      {
         var ret:Vector.<Component> = new Vector.<Component>();
         if(Boolean(this.rewards) && this.rewards.length > 0)
         {
            ret.push(this.createRewardLabel());
            ret.push(createTile(this.rewards));
         }
         if(Boolean(this.penalties) && this.penalties.length > 0)
         {
            ret.push(this.createPenaltyLabel());
            ret.push(createTile(this.penalties));
         }
         return ret.concat(super.getDescriptors());
      }
      
      public function setJoined(value:Boolean) : void
      {
         this.joined = value;
         if(hasEventListener("canBeAcceptedChanged"))
         {
            dispatchEvent(new Event("canBeAcceptedChanged"));
         }
         if(hasEventListener("canBeDeniedChanged"))
         {
            dispatchEvent(new Event("canBeDeniedChanged"));
         }
      }
      
      private function createRewardLabel() : GradientLabel
      {
         var label:GradientLabel = new GradientLabel();
         label.color = Colors.PLUSES;
         label.bgPaddingLeft = -5;
         label.bold = true;
         label.percentWidth = 100;
         label.height = 20;
         label.text = getString("dashboard.reward") + ":";
         return label;
      }
      
      private function createPenaltyLabel() : GradientLabel
      {
         var label:GradientLabel = new GradientLabel();
         label.color = Colors.MINUSES;
         label.bgPaddingLeft = -5;
         label.bold = true;
         label.percentWidth = 100;
         label.height = 20;
         label.text = getString("dashboard.penalty") + ":";
         return label;
      }
      
      [Bindable(event="propertyChange")]
      public function get type() : String
      {
         return this._3575610type;
      }
      
      public function set type(param1:String) : void
      {
         var _loc2_:Object = this._3575610type;
         if(_loc2_ !== param1)
         {
            this._3575610type = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"type",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get minLevel() : int
      {
         return this._1386076078minLevel;
      }
      
      public function set minLevel(param1:int) : void
      {
         var _loc2_:Object = this._1386076078minLevel;
         if(_loc2_ !== param1)
         {
            this._1386076078minLevel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minLevel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get maxLevel() : int
      {
         return this._390120576maxLevel;
      }
      
      public function set maxLevel(param1:int) : void
      {
         var _loc2_:Object = this._390120576maxLevel;
         if(_loc2_ !== param1)
         {
            this._390120576maxLevel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maxLevel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get minPlayers() : int
      {
         return this._1142598912minPlayers;
      }
      
      public function set minPlayers(param1:int) : void
      {
         var _loc2_:Object = this._1142598912minPlayers;
         if(_loc2_ !== param1)
         {
            this._1142598912minPlayers = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minPlayers",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get maxPlayers() : int
      {
         return this._680369070maxPlayers;
      }
      
      public function set maxPlayers(param1:int) : void
      {
         var _loc2_:Object = this._680369070maxPlayers;
         if(_loc2_ !== param1)
         {
            this._680369070maxPlayers = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maxPlayers",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get joined() : Boolean
      {
         return this._1154529463joined;
      }
      
      public function set joined(param1:Boolean) : void
      {
         var _loc2_:Object = this._1154529463joined;
         if(_loc2_ !== param1)
         {
            this._1154529463joined = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"joined",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rewards() : Array
      {
         return this._1100650276rewards;
      }
      
      public function set rewards(param1:Array) : void
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
      public function get penalties() : Array
      {
         return this._1080232679penalties;
      }
      
      public function set penalties(param1:Array) : void
      {
         var _loc2_:Object = this._1080232679penalties;
         if(_loc2_ !== param1)
         {
            this._1080232679penalties = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"penalties",_loc2_,param1));
            }
         }
      }
   }
}

