package soul.model.talents
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class TalentsModel extends EventDispatcher
   {
      
      private var _1668383879changePrice:int;
      
      private var _289847265changeCurrency:String;
      
      private var _510780122pointsAvailable:int;
      
      private var _1543869177talents:Array;
      
      public function TalentsModel()
      {
         super();
      }
      
      public function load(value:TalentData) : void
      {
         this.changeCurrency = value.changeCurrency;
         this.changePrice = value.changePrice;
         this.pointsAvailable = value.ranks;
         this.talents = value.talents;
      }
      
      public function getTalentById(talentId:String) : Talent
      {
         var tier:Array = null;
         var talent:Talent = null;
         for each(tier in this.talents)
         {
            for each(talent in tier)
            {
               if(Boolean(talent) && talent.id == talentId)
               {
                  return talent;
               }
            }
         }
         return null;
      }
      
      [Bindable(event="propertyChange")]
      public function get changePrice() : int
      {
         return this._1668383879changePrice;
      }
      
      public function set changePrice(param1:int) : void
      {
         var _loc2_:Object = this._1668383879changePrice;
         if(_loc2_ !== param1)
         {
            this._1668383879changePrice = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"changePrice",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get changeCurrency() : String
      {
         return this._289847265changeCurrency;
      }
      
      public function set changeCurrency(param1:String) : void
      {
         var _loc2_:Object = this._289847265changeCurrency;
         if(_loc2_ !== param1)
         {
            this._289847265changeCurrency = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"changeCurrency",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get pointsAvailable() : int
      {
         return this._510780122pointsAvailable;
      }
      
      public function set pointsAvailable(param1:int) : void
      {
         var _loc2_:Object = this._510780122pointsAvailable;
         if(_loc2_ !== param1)
         {
            this._510780122pointsAvailable = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pointsAvailable",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get talents() : Array
      {
         return this._1543869177talents;
      }
      
      public function set talents(param1:Array) : void
      {
         var _loc2_:Object = this._1543869177talents;
         if(_loc2_ !== param1)
         {
            this._1543869177talents = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"talents",_loc2_,param1));
            }
         }
      }
   }
}

