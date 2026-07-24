package soul.model.interaction.craft
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class CraftModel extends EventDispatcher
   {
      
      private var _1485985146craftType:String;
      
      private var _102865796level:int;
      
      private var _1082416293recipes:Array;
      
      private var _1664373938craftInProgress:Boolean;
      
      private var _2098868880recipeCrafting:Recipe;
      
      private var _444036701iterationsLeft:uint;
      
      public function CraftModel()
      {
         super();
      }
      
      public function reset() : void
      {
         this.craftType = null;
         this.recipes = null;
         this.recipeCrafting = null;
         this.craftInProgress = false;
         this.iterationsLeft = 0;
      }
      
      [Bindable(event="propertyChange")]
      public function get craftType() : String
      {
         return this._1485985146craftType;
      }
      
      public function set craftType(param1:String) : void
      {
         var _loc2_:Object = this._1485985146craftType;
         if(_loc2_ !== param1)
         {
            this._1485985146craftType = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"craftType",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get level() : int
      {
         return this._102865796level;
      }
      
      public function set level(param1:int) : void
      {
         var _loc2_:Object = this._102865796level;
         if(_loc2_ !== param1)
         {
            this._102865796level = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"level",_loc2_,param1));
            }
         }
      }
      
      [Bindable("recipesChanged")]
      [Bindable(event="propertyChange")]
      public function get recipes() : Array
      {
         return this._1082416293recipes;
      }
      
      public function set recipes(param1:Array) : void
      {
         var _loc2_:Object = this._1082416293recipes;
         if(_loc2_ !== param1)
         {
            this._1082416293recipes = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"recipes",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get craftInProgress() : Boolean
      {
         return this._1664373938craftInProgress;
      }
      
      public function set craftInProgress(param1:Boolean) : void
      {
         var _loc2_:Object = this._1664373938craftInProgress;
         if(_loc2_ !== param1)
         {
            this._1664373938craftInProgress = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"craftInProgress",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get recipeCrafting() : Recipe
      {
         return this._2098868880recipeCrafting;
      }
      
      public function set recipeCrafting(param1:Recipe) : void
      {
         var _loc2_:Object = this._2098868880recipeCrafting;
         if(_loc2_ !== param1)
         {
            this._2098868880recipeCrafting = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"recipeCrafting",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get iterationsLeft() : uint
      {
         return this._444036701iterationsLeft;
      }
      
      public function set iterationsLeft(param1:uint) : void
      {
         var _loc2_:Object = this._444036701iterationsLeft;
         if(_loc2_ !== param1)
         {
            this._444036701iterationsLeft = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"iterationsLeft",_loc2_,param1));
            }
         }
      }
   }
}

