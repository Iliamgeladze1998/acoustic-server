package soul.model.interaction.mail
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   import mx.utils.StringUtil;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.TypedParam;
   
   public class Mail implements IEventDispatcher
   {
      
      private var _3355id:String;
      
      private var _3151786from:String;
      
      private var _3707to:String;
      
      private var _1867885268subject:String;
      
      private var _3029410body:String;
      
      private var _3560141time:Number;
      
      private var _1309235404expires:Number;
      
      private var _3496342read:Boolean;
      
      private var _1972280855plainText:Boolean;
      
      private var _995427962params:Array;
      
      private var _738997328attachments:Array;
      
      private var _575402001currency:String;
      
      private var _localizedParams:Array;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function Mail()
      {
         super();
      }
      
      public function get localizedFrom() : String
      {
         return this.plainText ? this.from : this.getString(this.from);
      }
      
      private function get localizedParams() : Array
      {
         var mp:TypedParam = null;
         if(!this._localizedParams)
         {
            this._localizedParams = [];
            for each(mp in this.params)
            {
               this._localizedParams.push(LocaleManager.getTypedParam(mp.type,mp.value));
            }
         }
         return this._localizedParams;
      }
      
      public function get localizedSubject() : String
      {
         return this.plainText ? this.subject : StringUtil.substitute(this.getString(this.subject),this.localizedParams);
      }
      
      public function get localizedBody() : String
      {
         return this.plainText ? this.body : StringUtil.substitute(this.getString(this.body),this.localizedParams);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.MAIL,key);
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
      public function get from() : String
      {
         return this._3151786from;
      }
      
      public function set from(param1:String) : void
      {
         var _loc2_:Object = this._3151786from;
         if(_loc2_ !== param1)
         {
            this._3151786from = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"from",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get to() : String
      {
         return this._3707to;
      }
      
      public function set to(param1:String) : void
      {
         var _loc2_:Object = this._3707to;
         if(_loc2_ !== param1)
         {
            this._3707to = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"to",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get subject() : String
      {
         return this._1867885268subject;
      }
      
      public function set subject(param1:String) : void
      {
         var _loc2_:Object = this._1867885268subject;
         if(_loc2_ !== param1)
         {
            this._1867885268subject = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"subject",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get body() : String
      {
         return this._3029410body;
      }
      
      public function set body(param1:String) : void
      {
         var _loc2_:Object = this._3029410body;
         if(_loc2_ !== param1)
         {
            this._3029410body = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"body",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get time() : Number
      {
         return this._3560141time;
      }
      
      public function set time(param1:Number) : void
      {
         var _loc2_:Object = this._3560141time;
         if(_loc2_ !== param1)
         {
            this._3560141time = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"time",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get expires() : Number
      {
         return this._1309235404expires;
      }
      
      public function set expires(param1:Number) : void
      {
         var _loc2_:Object = this._1309235404expires;
         if(_loc2_ !== param1)
         {
            this._1309235404expires = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"expires",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get read() : Boolean
      {
         return this._3496342read;
      }
      
      public function set read(param1:Boolean) : void
      {
         var _loc2_:Object = this._3496342read;
         if(_loc2_ !== param1)
         {
            this._3496342read = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"read",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get plainText() : Boolean
      {
         return this._1972280855plainText;
      }
      
      public function set plainText(param1:Boolean) : void
      {
         var _loc2_:Object = this._1972280855plainText;
         if(_loc2_ !== param1)
         {
            this._1972280855plainText = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"plainText",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get params() : Array
      {
         return this._995427962params;
      }
      
      public function set params(param1:Array) : void
      {
         var _loc2_:Object = this._995427962params;
         if(_loc2_ !== param1)
         {
            this._995427962params = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"params",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get attachments() : Array
      {
         return this._738997328attachments;
      }
      
      public function set attachments(param1:Array) : void
      {
         var _loc2_:Object = this._738997328attachments;
         if(_loc2_ !== param1)
         {
            this._738997328attachments = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"attachments",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get currency() : String
      {
         return this._575402001currency;
      }
      
      public function set currency(param1:String) : void
      {
         var _loc2_:Object = this._575402001currency;
         if(_loc2_ !== param1)
         {
            this._575402001currency = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currency",_loc2_,param1));
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

