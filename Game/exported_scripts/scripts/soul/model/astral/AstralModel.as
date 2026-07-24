package soul.model.astral
{
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.events.PropertyChangeEvent;
   
   public class AstralModel extends EventDispatcher
   {
      
      private var _120x:int;
      
      private var _121y:int;
      
      private var _113126854width:int;
      
      private var _1221029593height:int;
      
      private var _1622491524cellWidth:int;
      
      private var _1675365079cellHeight:int;
      
      private var _510906048globalMapHeight:int;
      
      private var _2513267globalMapWidth:int;
      
      private var _2007745357screenHeight:int;
      
      private var _50798406screenWidth:int;
      
      private var _100313435image:String;
      
      private var _782949795circles:Array;
      
      private var _94544721cells:Array;
      
      private var _948881689members:Array;
      
      private var _2094363978entrance:Boolean;
      
      private var _1609594047enabled:Boolean;
      
      private var _1195732166viewPort:Rectangle;
      
      private var _1060223401myName:String;
      
      private var _3365863myId:String;
      
      private var _2143000587estimation:int;
      
      private var _1200802073destinaton:Point;
      
      private var _1068259250moving:Boolean;
      
      public function AstralModel()
      {
         super();
      }
      
      public function load(data:AstralData) : void
      {
         this.x = data.x;
         this.y = data.y;
         this.width = data.width;
         this.height = data.height;
         this.cellWidth = data.cellWidth;
         this.cellHeight = data.cellHeight;
         this.image = data.image;
         this.circles = data.circles;
         this.cells = data.cells;
         this.members = data.members;
         this.entrance = data.entrance;
         this.destinaton = null;
      }
      
      public function changeCircleProperty(id:String, property:String, value:Object) : void
      {
         var circle:AstralCircle = null;
         for each(circle in this.circles)
         {
            if(circle.id == id)
            {
               try
               {
                  circle[property] = value;
               }
               catch(e:Error)
               {
               }
               break;
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get x() : int
      {
         return this._120x;
      }
      
      public function set x(param1:int) : void
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
      public function get y() : int
      {
         return this._121y;
      }
      
      public function set y(param1:int) : void
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
      public function get width() : int
      {
         return this._113126854width;
      }
      
      public function set width(param1:int) : void
      {
         var _loc2_:Object = this._113126854width;
         if(_loc2_ !== param1)
         {
            this._113126854width = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"width",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get height() : int
      {
         return this._1221029593height;
      }
      
      public function set height(param1:int) : void
      {
         var _loc2_:Object = this._1221029593height;
         if(_loc2_ !== param1)
         {
            this._1221029593height = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"height",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get cellWidth() : int
      {
         return this._1622491524cellWidth;
      }
      
      public function set cellWidth(param1:int) : void
      {
         var _loc2_:Object = this._1622491524cellWidth;
         if(_loc2_ !== param1)
         {
            this._1622491524cellWidth = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cellWidth",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get cellHeight() : int
      {
         return this._1675365079cellHeight;
      }
      
      public function set cellHeight(param1:int) : void
      {
         var _loc2_:Object = this._1675365079cellHeight;
         if(_loc2_ !== param1)
         {
            this._1675365079cellHeight = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cellHeight",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get globalMapHeight() : int
      {
         return this._510906048globalMapHeight;
      }
      
      public function set globalMapHeight(param1:int) : void
      {
         var _loc2_:Object = this._510906048globalMapHeight;
         if(_loc2_ !== param1)
         {
            this._510906048globalMapHeight = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"globalMapHeight",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get globalMapWidth() : int
      {
         return this._2513267globalMapWidth;
      }
      
      public function set globalMapWidth(param1:int) : void
      {
         var _loc2_:Object = this._2513267globalMapWidth;
         if(_loc2_ !== param1)
         {
            this._2513267globalMapWidth = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"globalMapWidth",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get screenHeight() : int
      {
         return this._2007745357screenHeight;
      }
      
      public function set screenHeight(param1:int) : void
      {
         var _loc2_:Object = this._2007745357screenHeight;
         if(_loc2_ !== param1)
         {
            this._2007745357screenHeight = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"screenHeight",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get screenWidth() : int
      {
         return this._50798406screenWidth;
      }
      
      public function set screenWidth(param1:int) : void
      {
         var _loc2_:Object = this._50798406screenWidth;
         if(_loc2_ !== param1)
         {
            this._50798406screenWidth = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"screenWidth",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get image() : String
      {
         return this._100313435image;
      }
      
      public function set image(param1:String) : void
      {
         var _loc2_:Object = this._100313435image;
         if(_loc2_ !== param1)
         {
            this._100313435image = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"image",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get circles() : Array
      {
         return this._782949795circles;
      }
      
      public function set circles(param1:Array) : void
      {
         var _loc2_:Object = this._782949795circles;
         if(_loc2_ !== param1)
         {
            this._782949795circles = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"circles",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get cells() : Array
      {
         return this._94544721cells;
      }
      
      public function set cells(param1:Array) : void
      {
         var _loc2_:Object = this._94544721cells;
         if(_loc2_ !== param1)
         {
            this._94544721cells = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cells",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get members() : Array
      {
         return this._948881689members;
      }
      
      public function set members(param1:Array) : void
      {
         var _loc2_:Object = this._948881689members;
         if(_loc2_ !== param1)
         {
            this._948881689members = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"members",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get entrance() : Boolean
      {
         return this._2094363978entrance;
      }
      
      public function set entrance(param1:Boolean) : void
      {
         var _loc2_:Object = this._2094363978entrance;
         if(_loc2_ !== param1)
         {
            this._2094363978entrance = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"entrance",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get enabled() : Boolean
      {
         return this._1609594047enabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._1609594047enabled;
         if(_loc2_ !== param1)
         {
            this._1609594047enabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enabled",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get viewPort() : Rectangle
      {
         return this._1195732166viewPort;
      }
      
      public function set viewPort(param1:Rectangle) : void
      {
         var _loc2_:Object = this._1195732166viewPort;
         if(_loc2_ !== param1)
         {
            this._1195732166viewPort = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"viewPort",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get myName() : String
      {
         return this._1060223401myName;
      }
      
      public function set myName(param1:String) : void
      {
         var _loc2_:Object = this._1060223401myName;
         if(_loc2_ !== param1)
         {
            this._1060223401myName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"myName",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get myId() : String
      {
         return this._3365863myId;
      }
      
      public function set myId(param1:String) : void
      {
         var _loc2_:Object = this._3365863myId;
         if(_loc2_ !== param1)
         {
            this._3365863myId = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"myId",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get estimation() : int
      {
         return this._2143000587estimation;
      }
      
      public function set estimation(param1:int) : void
      {
         var _loc2_:Object = this._2143000587estimation;
         if(_loc2_ !== param1)
         {
            this._2143000587estimation = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"estimation",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get destinaton() : Point
      {
         return this._1200802073destinaton;
      }
      
      public function set destinaton(param1:Point) : void
      {
         var _loc2_:Object = this._1200802073destinaton;
         if(_loc2_ !== param1)
         {
            this._1200802073destinaton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"destinaton",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get moving() : Boolean
      {
         return this._1068259250moving;
      }
      
      public function set moving(param1:Boolean) : void
      {
         var _loc2_:Object = this._1068259250moving;
         if(_loc2_ !== param1)
         {
            this._1068259250moving = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"moving",_loc2_,param1));
            }
         }
      }
   }
}

