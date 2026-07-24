package soul.model.location.academy
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class AcademyModel extends EventDispatcher
   {
      
      private var _2139763272currentPreset:String;
      
      private var _635036892currentPresetDescription:String;
      
      private var _318277260presets:AcademyOptionData;
      
      private var _934441724resets:Object = {};
      
      private var _1352352227wastelandAllowed:Boolean;
      
      private var _440840076empireAllowed:Boolean;
      
      private var _2088542724visualMap:Object;
      
      public function AcademyModel()
      {
         super();
      }
      
      public function load(value:AcademyData) : void
      {
         this.currentPreset = value.currentPreset;
         this.presets = value.presets;
         this.resets[AcademyResetType.STATS] = value.stats;
         this.resets[AcademyResetType.SCHOOLS] = value.skills;
         this.resets[AcademyResetType.TALENTS] = value.talents;
         this.resets[AcademyResetType.PROFESSIONS] = value.professions;
         this.wastelandAllowed = value.wastelandAllowed;
         this.empireAllowed = value.empireAllowed;
         this.visualMap = value.visualMap;
      }
      
      [Bindable(event="propertyChange")]
      public function get currentPreset() : String
      {
         return this._2139763272currentPreset;
      }
      
      public function set currentPreset(param1:String) : void
      {
         var _loc2_:Object = this._2139763272currentPreset;
         if(_loc2_ !== param1)
         {
            this._2139763272currentPreset = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentPreset",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get currentPresetDescription() : String
      {
         return this._635036892currentPresetDescription;
      }
      
      public function set currentPresetDescription(param1:String) : void
      {
         var _loc2_:Object = this._635036892currentPresetDescription;
         if(_loc2_ !== param1)
         {
            this._635036892currentPresetDescription = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentPresetDescription",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get presets() : AcademyOptionData
      {
         return this._318277260presets;
      }
      
      public function set presets(param1:AcademyOptionData) : void
      {
         var _loc2_:Object = this._318277260presets;
         if(_loc2_ !== param1)
         {
            this._318277260presets = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"presets",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get resets() : Object
      {
         return this._934441724resets;
      }
      
      public function set resets(param1:Object) : void
      {
         var _loc2_:Object = this._934441724resets;
         if(_loc2_ !== param1)
         {
            this._934441724resets = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"resets",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get wastelandAllowed() : Boolean
      {
         return this._1352352227wastelandAllowed;
      }
      
      public function set wastelandAllowed(param1:Boolean) : void
      {
         var _loc2_:Object = this._1352352227wastelandAllowed;
         if(_loc2_ !== param1)
         {
            this._1352352227wastelandAllowed = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"wastelandAllowed",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get empireAllowed() : Boolean
      {
         return this._440840076empireAllowed;
      }
      
      public function set empireAllowed(param1:Boolean) : void
      {
         var _loc2_:Object = this._440840076empireAllowed;
         if(_loc2_ !== param1)
         {
            this._440840076empireAllowed = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"empireAllowed",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get visualMap() : Object
      {
         return this._2088542724visualMap;
      }
      
      public function set visualMap(param1:Object) : void
      {
         var _loc2_:Object = this._2088542724visualMap;
         if(_loc2_ !== param1)
         {
            this._2088542724visualMap = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"visualMap",_loc2_,param1));
            }
         }
      }
   }
}

