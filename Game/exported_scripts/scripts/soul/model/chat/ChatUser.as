package soul.model.chat
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class ChatUser implements IEventDispatcher
   {
      
      private var _3355id:String;
      
      private var _3373707name:String;
      
      private var _102865796level:int;
      
      private var _113766sex:String;
      
      private var _3506294role:String;
      
      private var _1357943279clanId:Number;
      
      private var _686716417clanName:String;
      
      private var _1634682932punished:Boolean;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function ChatUser()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get id() : String
      {
         return this._3355id;
      }
      
      public function set id(param1:String) : void
      {
         var _loc2_:Object = this._3355id;
         if(_loc2_ !== param1)
         {
            this._3355id = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"id",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get name() : String
      {
         return this._3373707name;
      }
      
      public function set name(param1:String) : void
      {
         var _loc2_:Object = this._3373707name;
         if(_loc2_ !== param1)
         {
            this._3373707name = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"name",_loc2_,param1));
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
      
      [Bindable(event="propertyChange")]
      public function get sex() : String
      {
         return this._113766sex;
      }
      
      public function set sex(param1:String) : void
      {
         var _loc2_:Object = this._113766sex;
         if(_loc2_ !== param1)
         {
            this._113766sex = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sex",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get role() : String
      {
         return this._3506294role;
      }
      
      public function set role(param1:String) : void
      {
         var _loc2_:Object = this._3506294role;
         if(_loc2_ !== param1)
         {
            this._3506294role = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"role",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get clanId() : Number
      {
         return this._1357943279clanId;
      }
      
      public function set clanId(param1:Number) : void
      {
         var _loc2_:Object = this._1357943279clanId;
         if(_loc2_ !== param1)
         {
            this._1357943279clanId = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clanId",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get clanName() : String
      {
         return this._686716417clanName;
      }
      
      public function set clanName(param1:String) : void
      {
         var _loc2_:Object = this._686716417clanName;
         if(_loc2_ !== param1)
         {
            this._686716417clanName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clanName",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get punished() : Boolean
      {
         return this._1634682932punished;
      }
      
      public function set punished(param1:Boolean) : void
      {
         var _loc2_:Object = this._1634682932punished;
         if(_loc2_ !== param1)
         {
            this._1634682932punished = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"punished",_loc2_,param1));
            }
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}

