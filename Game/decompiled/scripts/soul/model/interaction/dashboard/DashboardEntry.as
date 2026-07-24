package soul.model.interaction.dashboard
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientLabel;
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   
   public class DashboardEntry extends EventDispatcher
   {
      
      protected static const canBeAcceptedEvent:String = "canBeAcceptedChanged";
      
      protected static const canBeDeniedEvent:String = "canBeDeniedChanged";
      
      private static const bundles:Array = [BundleName.TOOLTIP,BundleName.INTERFACE];
      
      private var _3355id:uint;
      
      private var _1900800277localeId:String;
      
      private var _3076014date:Date;
      
      private var _1422950650active:Boolean;
      
      public function DashboardEntry()
      {
         super();
      }
      
      protected static function getString(key:String) : String
      {
         var bundle:String = null;
         var str:String = null;
         for each(bundle in bundles)
         {
            str = LocaleManager.getString(bundle,key);
            if(str != key)
            {
               return str;
            }
         }
         return key;
      }
      
      protected static function getEvent(key:String) : String
      {
         return LocaleManager.getString(BundleName.EVENT,key);
      }
      
      public function get icon() : Object
      {
         return null;
      }
      
      [Bindable("canBeAcceptedChanged")]
      public function get canBeAccepted() : Boolean
      {
         return false;
      }
      
      [Bindable("canBeDeniedChanged")]
      public function get canBeDenied() : Boolean
      {
         return false;
      }
      
      public function getDescriptors() : Vector.<Component>
      {
         var ret:Vector.<Component> = null;
         var label:GradientLabel = null;
         ret = new Vector.<Component>();
         label = new GradientLabel();
         label.color = Colors.GOLD_DARK;
         label.bgPaddingLeft = -5;
         label.bold = true;
         label.percentWidth = 100;
         label.height = 20;
         label.text = getString("description") + ":";
         ret.push(label);
         var description:Label = new Label();
         description.color = Colors.LABEL;
         description.multiline = true;
         description.wordWrap = true;
         description.percentWidth = 100;
         description.htmlText = getEvent(this.localeId + ".description");
         ret.push(description);
         return ret;
      }
      
      [Bindable(event="propertyChange")]
      public function get id() : uint
      {
         return this._3355id;
      }
      
      public function set id(param1:uint) : void
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
      public function get localeId() : String
      {
         return this._1900800277localeId;
      }
      
      public function set localeId(param1:String) : void
      {
         var _loc2_:Object = this._1900800277localeId;
         if(_loc2_ !== param1)
         {
            this._1900800277localeId = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"localeId",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get date() : Date
      {
         return this._3076014date;
      }
      
      public function set date(param1:Date) : void
      {
         var _loc2_:Object = this._3076014date;
         if(_loc2_ !== param1)
         {
            this._3076014date = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"date",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get active() : Boolean
      {
         return this._1422950650active;
      }
      
      public function set active(param1:Boolean) : void
      {
         var _loc2_:Object = this._1422950650active;
         if(_loc2_ !== param1)
         {
            this._1422950650active = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"active",_loc2_,param1));
            }
         }
      }
   }
}

