package soul.model.field
{
   import mx.events.PropertyChangeEvent;
   import soul.model.ability.Ability;
   import soul.model.rtm.TargetSign;
   
   public class FieldUnit extends BaseUnit
   {
      
      private var _120x:Number;
      
      private var _121y:Number;
      
      private var _90495162objectId:String;
      
      private var _1595195515visualId:String;
      
      private var _103672hue:int;
      
      private var _686441581lightness:int;
      
      private var _3212242hsls:Object;
      
      private var _2017000393wardrobes:Object;
      
      private var _1434370496acceptsNegative:Boolean;
      
      private var _1261064068acceptsPositive:Boolean;
      
      private var _110844025types:Array;
      
      private var _1564195625character:Boolean;
      
      private var _1271107579tradable:Boolean;
      
      private var _3056214clan:String;
      
      private var _338699124questStatus:String;
      
      private var _1489585863objective:Boolean;
      
      private var _1829500859difficulty:String;
      
      private var _2008465092species:String;
      
      private var _1596724832sightRange:int;
      
      private var _1157746096castingTime:int;
      
      public function FieldUnit()
      {
         super();
      }
      
      public function accepts(a:Ability) : Boolean
      {
         if(!a)
         {
            return false;
         }
         return a.sign == TargetSign.ANY || a.sign == TargetSign.POSITIVE && this.acceptsPositive || a.sign == TargetSign.NEGATIVE && this.acceptsNegative;
      }
      
      [Bindable(event="propertyChange")]
      public function get x() : Number
      {
         return this._120x;
      }
      
      public function set x(param1:Number) : void
      {
         var _loc2_:Object = this._120x;
         if(_loc2_ !== param1)
         {
            this._120x = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"x",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get y() : Number
      {
         return this._121y;
      }
      
      public function set y(param1:Number) : void
      {
         var _loc2_:Object = this._121y;
         if(_loc2_ !== param1)
         {
            this._121y = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"y",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get objectId() : String
      {
         return this._90495162objectId;
      }
      
      public function set objectId(param1:String) : void
      {
         var _loc2_:Object = this._90495162objectId;
         if(_loc2_ !== param1)
         {
            this._90495162objectId = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"objectId",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get visualId() : String
      {
         return this._1595195515visualId;
      }
      
      public function set visualId(param1:String) : void
      {
         var _loc2_:Object = this._1595195515visualId;
         if(_loc2_ !== param1)
         {
            this._1595195515visualId = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"visualId",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hue() : int
      {
         return this._103672hue;
      }
      
      public function set hue(param1:int) : void
      {
         var _loc2_:Object = this._103672hue;
         if(_loc2_ !== param1)
         {
            this._103672hue = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hue",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lightness() : int
      {
         return this._686441581lightness;
      }
      
      public function set lightness(param1:int) : void
      {
         var _loc2_:Object = this._686441581lightness;
         if(_loc2_ !== param1)
         {
            this._686441581lightness = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lightness",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hsls() : Object
      {
         return this._3212242hsls;
      }
      
      public function set hsls(param1:Object) : void
      {
         var _loc2_:Object = this._3212242hsls;
         if(_loc2_ !== param1)
         {
            this._3212242hsls = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hsls",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get wardrobes() : Object
      {
         return this._2017000393wardrobes;
      }
      
      public function set wardrobes(param1:Object) : void
      {
         var _loc2_:Object = this._2017000393wardrobes;
         if(_loc2_ !== param1)
         {
            this._2017000393wardrobes = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"wardrobes",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get acceptsNegative() : Boolean
      {
         return this._1434370496acceptsNegative;
      }
      
      public function set acceptsNegative(param1:Boolean) : void
      {
         var _loc2_:Object = this._1434370496acceptsNegative;
         if(_loc2_ !== param1)
         {
            this._1434370496acceptsNegative = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"acceptsNegative",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get acceptsPositive() : Boolean
      {
         return this._1261064068acceptsPositive;
      }
      
      public function set acceptsPositive(param1:Boolean) : void
      {
         var _loc2_:Object = this._1261064068acceptsPositive;
         if(_loc2_ !== param1)
         {
            this._1261064068acceptsPositive = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"acceptsPositive",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get types() : Array
      {
         return this._110844025types;
      }
      
      public function set types(param1:Array) : void
      {
         var _loc2_:Object = this._110844025types;
         if(_loc2_ !== param1)
         {
            this._110844025types = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"types",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get character() : Boolean
      {
         return this._1564195625character;
      }
      
      public function set character(param1:Boolean) : void
      {
         var _loc2_:Object = this._1564195625character;
         if(_loc2_ !== param1)
         {
            this._1564195625character = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"character",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get tradable() : Boolean
      {
         return this._1271107579tradable;
      }
      
      public function set tradable(param1:Boolean) : void
      {
         var _loc2_:Object = this._1271107579tradable;
         if(_loc2_ !== param1)
         {
            this._1271107579tradable = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tradable",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get clan() : String
      {
         return this._3056214clan;
      }
      
      public function set clan(param1:String) : void
      {
         var _loc2_:Object = this._3056214clan;
         if(_loc2_ !== param1)
         {
            this._3056214clan = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clan",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get questStatus() : String
      {
         return this._338699124questStatus;
      }
      
      public function set questStatus(param1:String) : void
      {
         var _loc2_:Object = this._338699124questStatus;
         if(_loc2_ !== param1)
         {
            this._338699124questStatus = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questStatus",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get objective() : Boolean
      {
         return this._1489585863objective;
      }
      
      public function set objective(param1:Boolean) : void
      {
         var _loc2_:Object = this._1489585863objective;
         if(_loc2_ !== param1)
         {
            this._1489585863objective = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"objective",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get difficulty() : String
      {
         return this._1829500859difficulty;
      }
      
      public function set difficulty(param1:String) : void
      {
         var _loc2_:Object = this._1829500859difficulty;
         if(_loc2_ !== param1)
         {
            this._1829500859difficulty = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"difficulty",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get species() : String
      {
         return this._2008465092species;
      }
      
      public function set species(param1:String) : void
      {
         var _loc2_:Object = this._2008465092species;
         if(_loc2_ !== param1)
         {
            this._2008465092species = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"species",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get sightRange() : int
      {
         return this._1596724832sightRange;
      }
      
      public function set sightRange(param1:int) : void
      {
         var _loc2_:Object = this._1596724832sightRange;
         if(_loc2_ !== param1)
         {
            this._1596724832sightRange = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sightRange",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get castingTime() : int
      {
         return this._1157746096castingTime;
      }
      
      public function set castingTime(param1:int) : void
      {
         var _loc2_:Object = this._1157746096castingTime;
         if(_loc2_ !== param1)
         {
            this._1157746096castingTime = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"castingTime",_loc2_,param1));
            }
         }
      }
   }
}

