package soul.view.interaction.character.parts
{
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import mx.binding.*;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.character.CharacterPublicData;
   import soul.model.character.ParamType;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class StatViewer extends VBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _StatViewer_SecondaryStatRenderer1:SecondaryStatRenderer;
      
      public var _StatViewer_SecondaryStatRenderer2:SecondaryStatRenderer;
      
      public var _StatViewer_SecondaryStatRenderer3:SecondaryStatRenderer;
      
      public var _StatViewer_SecondaryStatRenderer4:SecondaryStatRenderer;
      
      public var _StatViewer_SecondaryStatRenderer5:SecondaryStatRenderer;
      
      public var _StatViewer_SecondaryStatRenderer6:SecondaryStatRenderer;
      
      public var _StatViewer_SecondaryStatRenderer7:SecondaryStatRenderer;
      
      public var _StatViewer_SecondaryStatRenderer8:SecondaryStatRenderer;
      
      public var _StatViewer_StatRenderer1:StatRenderer;
      
      public var _StatViewer_StatRenderer2:StatRenderer;
      
      private var _2131707655accuracy:StatRenderer;
      
      private var _497265024intellect:StatRenderer;
      
      private var _1435065376charData:CharacterPublicData;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function StatViewer()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         bindings = this._StatViewer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_character_parts_StatViewerWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return StatViewer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.percentWidth = 100;
         this.gap = -2;
         this.children = [this._StatViewer_VBox2_c(),this._StatViewer_SecondaryStatRenderer1_i(),this._StatViewer_SecondaryStatRenderer2_i(),this._StatViewer_SecondaryStatRenderer3_i(),this._StatViewer_SecondaryStatRenderer4_i(),this._StatViewer_SecondaryStatRenderer5_i(),this._StatViewer_SecondaryStatRenderer6_i(),this._StatViewer_SecondaryStatRenderer7_i(),this._StatViewer_SecondaryStatRenderer8_i()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         StatViewer._watcherSetupUtil = param1;
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _StatViewer_VBox2_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.gap = 1;
         _loc1_.percentWidth = 100;
         _loc1_.children = [this._StatViewer_StatRenderer1_i(),this._StatViewer_StatRenderer2_i(),this._StatViewer_StatRenderer3_i(),this._StatViewer_StatRenderer4_i()];
         return _loc1_;
      }
      
      private function _StatViewer_StatRenderer1_i() : StatRenderer
      {
         var _loc1_:StatRenderer = new StatRenderer();
         this._StatViewer_StatRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_StatViewer_StatRenderer1",this._StatViewer_StatRenderer1);
         return _loc1_;
      }
      
      private function _StatViewer_StatRenderer2_i() : StatRenderer
      {
         var _loc1_:StatRenderer = new StatRenderer();
         this._StatViewer_StatRenderer2 = _loc1_;
         BindingManager.executeBindings(this,"_StatViewer_StatRenderer2",this._StatViewer_StatRenderer2);
         return _loc1_;
      }
      
      private function _StatViewer_StatRenderer3_i() : StatRenderer
      {
         var _loc1_:StatRenderer = new StatRenderer();
         this.accuracy = _loc1_;
         BindingManager.executeBindings(this,"accuracy",this.accuracy);
         return _loc1_;
      }
      
      private function _StatViewer_StatRenderer4_i() : StatRenderer
      {
         var _loc1_:StatRenderer = new StatRenderer();
         this.intellect = _loc1_;
         BindingManager.executeBindings(this,"intellect",this.intellect);
         return _loc1_;
      }
      
      private function _StatViewer_SecondaryStatRenderer1_i() : SecondaryStatRenderer
      {
         var _loc1_:SecondaryStatRenderer = new SecondaryStatRenderer();
         this._StatViewer_SecondaryStatRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_StatViewer_SecondaryStatRenderer1",this._StatViewer_SecondaryStatRenderer1);
         return _loc1_;
      }
      
      private function _StatViewer_SecondaryStatRenderer2_i() : SecondaryStatRenderer
      {
         var _loc1_:SecondaryStatRenderer = new SecondaryStatRenderer();
         this._StatViewer_SecondaryStatRenderer2 = _loc1_;
         BindingManager.executeBindings(this,"_StatViewer_SecondaryStatRenderer2",this._StatViewer_SecondaryStatRenderer2);
         return _loc1_;
      }
      
      private function _StatViewer_SecondaryStatRenderer3_i() : SecondaryStatRenderer
      {
         var _loc1_:SecondaryStatRenderer = new SecondaryStatRenderer();
         this._StatViewer_SecondaryStatRenderer3 = _loc1_;
         BindingManager.executeBindings(this,"_StatViewer_SecondaryStatRenderer3",this._StatViewer_SecondaryStatRenderer3);
         return _loc1_;
      }
      
      private function _StatViewer_SecondaryStatRenderer4_i() : SecondaryStatRenderer
      {
         var _loc1_:SecondaryStatRenderer = new SecondaryStatRenderer();
         this._StatViewer_SecondaryStatRenderer4 = _loc1_;
         BindingManager.executeBindings(this,"_StatViewer_SecondaryStatRenderer4",this._StatViewer_SecondaryStatRenderer4);
         return _loc1_;
      }
      
      private function _StatViewer_SecondaryStatRenderer5_i() : SecondaryStatRenderer
      {
         var _loc1_:SecondaryStatRenderer = new SecondaryStatRenderer();
         this._StatViewer_SecondaryStatRenderer5 = _loc1_;
         BindingManager.executeBindings(this,"_StatViewer_SecondaryStatRenderer5",this._StatViewer_SecondaryStatRenderer5);
         return _loc1_;
      }
      
      private function _StatViewer_SecondaryStatRenderer6_i() : SecondaryStatRenderer
      {
         var _loc1_:SecondaryStatRenderer = new SecondaryStatRenderer();
         this._StatViewer_SecondaryStatRenderer6 = _loc1_;
         BindingManager.executeBindings(this,"_StatViewer_SecondaryStatRenderer6",this._StatViewer_SecondaryStatRenderer6);
         return _loc1_;
      }
      
      private function _StatViewer_SecondaryStatRenderer7_i() : SecondaryStatRenderer
      {
         var _loc1_:SecondaryStatRenderer = new SecondaryStatRenderer();
         this._StatViewer_SecondaryStatRenderer7 = _loc1_;
         BindingManager.executeBindings(this,"_StatViewer_SecondaryStatRenderer7",this._StatViewer_SecondaryStatRenderer7);
         return _loc1_;
      }
      
      private function _StatViewer_SecondaryStatRenderer8_i() : SecondaryStatRenderer
      {
         var _loc1_:SecondaryStatRenderer = new SecondaryStatRenderer();
         this._StatViewer_SecondaryStatRenderer8 = _loc1_;
         BindingManager.executeBindings(this,"_StatViewer_SecondaryStatRenderer8",this._StatViewer_SecondaryStatRenderer8);
         return _loc1_;
      }
      
      private function _StatViewer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return ParamType.getIcon(ParamType.STRENGTH);
         },null,"_StatViewer_StatRenderer1.source");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.STRENGTH);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatViewer_StatRenderer1.label");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.STRENGTH + ".description");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatViewer_StatRenderer1.toolTip");
         result[3] = new Binding(this,function():int
         {
            return int(charData.params.STRENGTH);
         },null,"_StatViewer_StatRenderer1.value");
         result[4] = new Binding(this,function():Object
         {
            return ParamType.getIcon(ParamType.CONSTITUTION);
         },null,"_StatViewer_StatRenderer2.source");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.CONSTITUTION);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatViewer_StatRenderer2.label");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.CONSTITUTION + ".description");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatViewer_StatRenderer2.toolTip");
         result[7] = new Binding(this,function():int
         {
            return int(charData.params.CONSTITUTION);
         },null,"_StatViewer_StatRenderer2.value");
         result[8] = new Binding(this,function():Object
         {
            return ParamType.getIcon(ParamType.ACCURACY);
         },null,"accuracy.source");
         result[9] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.ACCURACY);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"accuracy.label");
         result[10] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.ACCURACY + ".description");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"accuracy.toolTip");
         result[11] = new Binding(this,function():int
         {
            return int(charData.params.ACCURACY);
         },null,"accuracy.value");
         result[12] = new Binding(this,function():Object
         {
            return ParamType.getIcon(ParamType.INTELLECT);
         },null,"intellect.source");
         result[13] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.INTELLECT);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"intellect.label");
         result[14] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.INTELLECT + ".description");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"intellect.toolTip");
         result[15] = new Binding(this,function():int
         {
            return int(charData.params.INTELLECT);
         },null,"intellect.value");
         result[16] = new Binding(this,function():String
         {
            var _loc1_:* = getString("DAMAGE_PHYSICAL");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatViewer_SecondaryStatRenderer1.label");
         result[17] = new Binding(this,function():String
         {
            var _loc1_:* = charData.params.DAMAGE_PHYSICAL_MIN + "-" + charData.params.DAMAGE_PHYSICAL_MAX;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatViewer_SecondaryStatRenderer1.value");
         result[18] = new Binding(this,function():String
         {
            var _loc1_:* = getString("HP");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatViewer_SecondaryStatRenderer2.label");
         result[19] = new Binding(this,function():String
         {
            var _loc1_:* = int(charData.params.MAX_HP);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatViewer_SecondaryStatRenderer2.value");
         result[20] = new Binding(this,function():String
         {
            var _loc1_:* = getString("MP");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatViewer_SecondaryStatRenderer3.label");
         result[21] = new Binding(this,function():String
         {
            var _loc1_:* = int(charData.params.MAX_MP);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatViewer_SecondaryStatRenderer3.value");
         result[22] = new Binding(this,function():String
         {
            var _loc1_:* = getString("STAMINA");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatViewer_SecondaryStatRenderer4.label");
         result[23] = new Binding(this,function():String
         {
            var _loc1_:* = int(charData.params.MAX_STAMINA);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatViewer_SecondaryStatRenderer4.value");
         result[24] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.HIT_MELEE);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatViewer_SecondaryStatRenderer5.label");
         result[25] = new Binding(this,function():String
         {
            var _loc1_:* = int(charData.params.HIT_MELEE);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatViewer_SecondaryStatRenderer5.value");
         result[26] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.CRIT);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatViewer_SecondaryStatRenderer6.label");
         result[27] = new Binding(this,function():String
         {
            var _loc1_:* = int(charData.params.CRIT);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatViewer_SecondaryStatRenderer6.value");
         result[28] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.DODGE) + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatViewer_SecondaryStatRenderer7.label");
         result[29] = new Binding(this,function():String
         {
            var _loc1_:* = int(charData.params.DODGE);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatViewer_SecondaryStatRenderer7.value");
         result[30] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.ANTICRIT) + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatViewer_SecondaryStatRenderer8.label");
         result[31] = new Binding(this,function():String
         {
            var _loc1_:* = int(charData.params.ANTICRIT);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatViewer_SecondaryStatRenderer8.value");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get accuracy() : StatRenderer
      {
         return this._2131707655accuracy;
      }
      
      public function set accuracy(param1:StatRenderer) : void
      {
         var _loc2_:Object = this._2131707655accuracy;
         if(_loc2_ !== param1)
         {
            this._2131707655accuracy = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"accuracy",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get intellect() : StatRenderer
      {
         return this._497265024intellect;
      }
      
      public function set intellect(param1:StatRenderer) : void
      {
         var _loc2_:Object = this._497265024intellect;
         if(_loc2_ !== param1)
         {
            this._497265024intellect = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"intellect",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get charData() : CharacterPublicData
      {
         return this._1435065376charData;
      }
      
      public function set charData(param1:CharacterPublicData) : void
      {
         var _loc2_:Object = this._1435065376charData;
         if(_loc2_ !== param1)
         {
            this._1435065376charData = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"charData",_loc2_,param1));
            }
         }
      }
   }
}

