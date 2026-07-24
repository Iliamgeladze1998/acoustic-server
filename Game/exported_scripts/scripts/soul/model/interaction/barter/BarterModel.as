package soul.model.interaction.barter
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   import soul.model.item.Item;
   
   public class BarterModel extends EventDispatcher
   {
      
      private var _1116313165waiting:Boolean = false;
      
      private var _930899922iAmReady:Boolean = false;
      
      private var _255810118opponentReady:Boolean = false;
      
      private var _308803752opponentId:String;
      
      private var _407512696opponentName:String;
      
      private var _247736830opponentImage:String;
      
      private var _247949344opponentItem0:Item;
      
      private var _247949345opponentItem1:Item;
      
      private var _247949346opponentItem2:Item;
      
      private var _247949347opponentItem3:Item;
      
      private var _1079565098opponentCopper:uint;
      
      private var _645010507opponentRubies:uint;
      
      private var _1488753969myItem0:Item;
      
      private var _1488753970myItem1:Item;
      
      private var _1488753971myItem2:Item;
      
      private var _1488753972myItem3:Item;
      
      private var _1269327387myCopper:uint;
      
      private var _834772796myRubies:uint;
      
      public function BarterModel()
      {
         super();
      }
      
      public function clean() : void
      {
         this.iAmReady = false;
         this.opponentReady = false;
         this.opponentImage = null;
         this.opponentName = null;
         for(var i:int = 0; i < 4; i++)
         {
            this["opponentItem" + i] = null;
            this["myItem" + i] = null;
         }
         this.opponentCopper = 0;
         this.opponentRubies = 0;
      }
      
      [Bindable(event="propertyChange")]
      public function get waiting() : Boolean
      {
         return this._1116313165waiting;
      }
      
      public function set waiting(param1:Boolean) : void
      {
         var _loc2_:Object = this._1116313165waiting;
         if(_loc2_ !== param1)
         {
            this._1116313165waiting = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"waiting",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get iAmReady() : Boolean
      {
         return this._930899922iAmReady;
      }
      
      public function set iAmReady(param1:Boolean) : void
      {
         var _loc2_:Object = this._930899922iAmReady;
         if(_loc2_ !== param1)
         {
            this._930899922iAmReady = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"iAmReady",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get opponentReady() : Boolean
      {
         return this._255810118opponentReady;
      }
      
      public function set opponentReady(param1:Boolean) : void
      {
         var _loc2_:Object = this._255810118opponentReady;
         if(_loc2_ !== param1)
         {
            this._255810118opponentReady = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"opponentReady",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get opponentId() : String
      {
         return this._308803752opponentId;
      }
      
      public function set opponentId(param1:String) : void
      {
         var _loc2_:Object = this._308803752opponentId;
         if(_loc2_ !== param1)
         {
            this._308803752opponentId = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"opponentId",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get opponentName() : String
      {
         return this._407512696opponentName;
      }
      
      public function set opponentName(param1:String) : void
      {
         var _loc2_:Object = this._407512696opponentName;
         if(_loc2_ !== param1)
         {
            this._407512696opponentName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"opponentName",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get opponentImage() : String
      {
         return this._247736830opponentImage;
      }
      
      public function set opponentImage(param1:String) : void
      {
         var _loc2_:Object = this._247736830opponentImage;
         if(_loc2_ !== param1)
         {
            this._247736830opponentImage = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"opponentImage",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get opponentItem0() : Item
      {
         return this._247949344opponentItem0;
      }
      
      public function set opponentItem0(param1:Item) : void
      {
         var _loc2_:Object = this._247949344opponentItem0;
         if(_loc2_ !== param1)
         {
            this._247949344opponentItem0 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"opponentItem0",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get opponentItem1() : Item
      {
         return this._247949345opponentItem1;
      }
      
      public function set opponentItem1(param1:Item) : void
      {
         var _loc2_:Object = this._247949345opponentItem1;
         if(_loc2_ !== param1)
         {
            this._247949345opponentItem1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"opponentItem1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get opponentItem2() : Item
      {
         return this._247949346opponentItem2;
      }
      
      public function set opponentItem2(param1:Item) : void
      {
         var _loc2_:Object = this._247949346opponentItem2;
         if(_loc2_ !== param1)
         {
            this._247949346opponentItem2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"opponentItem2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get opponentItem3() : Item
      {
         return this._247949347opponentItem3;
      }
      
      public function set opponentItem3(param1:Item) : void
      {
         var _loc2_:Object = this._247949347opponentItem3;
         if(_loc2_ !== param1)
         {
            this._247949347opponentItem3 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"opponentItem3",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get opponentCopper() : uint
      {
         return this._1079565098opponentCopper;
      }
      
      public function set opponentCopper(param1:uint) : void
      {
         var _loc2_:Object = this._1079565098opponentCopper;
         if(_loc2_ !== param1)
         {
            this._1079565098opponentCopper = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"opponentCopper",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get opponentRubies() : uint
      {
         return this._645010507opponentRubies;
      }
      
      public function set opponentRubies(param1:uint) : void
      {
         var _loc2_:Object = this._645010507opponentRubies;
         if(_loc2_ !== param1)
         {
            this._645010507opponentRubies = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"opponentRubies",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get myItem0() : Item
      {
         return this._1488753969myItem0;
      }
      
      public function set myItem0(param1:Item) : void
      {
         var _loc2_:Object = this._1488753969myItem0;
         if(_loc2_ !== param1)
         {
            this._1488753969myItem0 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"myItem0",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get myItem1() : Item
      {
         return this._1488753970myItem1;
      }
      
      public function set myItem1(param1:Item) : void
      {
         var _loc2_:Object = this._1488753970myItem1;
         if(_loc2_ !== param1)
         {
            this._1488753970myItem1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"myItem1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get myItem2() : Item
      {
         return this._1488753971myItem2;
      }
      
      public function set myItem2(param1:Item) : void
      {
         var _loc2_:Object = this._1488753971myItem2;
         if(_loc2_ !== param1)
         {
            this._1488753971myItem2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"myItem2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get myItem3() : Item
      {
         return this._1488753972myItem3;
      }
      
      public function set myItem3(param1:Item) : void
      {
         var _loc2_:Object = this._1488753972myItem3;
         if(_loc2_ !== param1)
         {
            this._1488753972myItem3 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"myItem3",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get myCopper() : uint
      {
         return this._1269327387myCopper;
      }
      
      public function set myCopper(param1:uint) : void
      {
         var _loc2_:Object = this._1269327387myCopper;
         if(_loc2_ !== param1)
         {
            this._1269327387myCopper = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"myCopper",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get myRubies() : uint
      {
         return this._834772796myRubies;
      }
      
      public function set myRubies(param1:uint) : void
      {
         var _loc2_:Object = this._834772796myRubies;
         if(_loc2_ !== param1)
         {
            this._834772796myRubies = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"myRubies",_loc2_,param1));
            }
         }
      }
   }
}

