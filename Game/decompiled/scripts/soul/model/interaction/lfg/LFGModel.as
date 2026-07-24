package soul.model.interaction.lfg
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class LFGModel extends EventDispatcher
   {
      
      private var _948698159quests:Array;
      
      private var _29097598instances:Array;
      
      private var _1197189282locations:Array;
      
      private var _937207075applications:Array;
      
      private var _772864535currentApplication:GroupApplication;
      
      public function LFGModel()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get quests() : Array
      {
         return this._948698159quests;
      }
      
      public function set quests(param1:Array) : void
      {
         var _loc2_:Object = this._948698159quests;
         if(_loc2_ !== param1)
         {
            this._948698159quests = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"quests",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get instances() : Array
      {
         return this._29097598instances;
      }
      
      public function set instances(param1:Array) : void
      {
         var _loc2_:Object = this._29097598instances;
         if(_loc2_ !== param1)
         {
            this._29097598instances = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"instances",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get locations() : Array
      {
         return this._1197189282locations;
      }
      
      public function set locations(param1:Array) : void
      {
         var _loc2_:Object = this._1197189282locations;
         if(_loc2_ !== param1)
         {
            this._1197189282locations = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"locations",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get applications() : Array
      {
         return this._937207075applications;
      }
      
      public function set applications(param1:Array) : void
      {
         var _loc2_:Object = this._937207075applications;
         if(_loc2_ !== param1)
         {
            this._937207075applications = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"applications",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get currentApplication() : GroupApplication
      {
         return this._772864535currentApplication;
      }
      
      public function set currentApplication(param1:GroupApplication) : void
      {
         var _loc2_:Object = this._772864535currentApplication;
         if(_loc2_ !== param1)
         {
            this._772864535currentApplication = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentApplication",_loc2_,param1));
            }
         }
      }
   }
}

