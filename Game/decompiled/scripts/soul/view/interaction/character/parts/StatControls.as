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
   import soul.model.character.CharacterModel;
   import soul.model.character.ParamType;
   import soul.view.assets.Button1;
   import soul.view.assets.Colors;
   import soul.view.common.Icons;
   import soul.view.ui.Component;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   [Event(name="complete",type="flash.events.Event")]
   [Event(name="change",type="flash.events.Event")]
   public class StatControls extends VBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _StatControls_Button11:Button1;
      
      public var _StatControls_Button12:Button1;
      
      public var _StatControls_Label1:Label;
      
      public var _StatControls_Label2:Label;
      
      public var _StatControls_SecondaryStatRenderer1:SecondaryStatRenderer;
      
      public var _StatControls_SecondaryStatRenderer2:SecondaryStatRenderer;
      
      public var _StatControls_SecondaryStatRenderer3:SecondaryStatRenderer;
      
      public var _StatControls_SecondaryStatRenderer4:SecondaryStatRenderer;
      
      public var _StatControls_SecondaryStatRenderer5:SecondaryStatRenderer;
      
      public var _StatControls_SecondaryStatRenderer6:SecondaryStatRenderer;
      
      public var _StatControls_SecondaryStatRenderer7:SecondaryStatRenderer;
      
      public var _StatControls_SecondaryStatRenderer8:SecondaryStatRenderer;
      
      private var _2131707655accuracy:StatChanger;
      
      private var _1405564421constitution:StatChanger;
      
      private var _497265024intellect:StatChanger;
      
      private var _1791316033strength:StatChanger;
      
      private var _340320640characterModel:CharacterModel;
      
      private var _982754077points:int;
      
      private var _589054405totalModifier:int = 0;
      
      private var _733902135available:int = 0;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function StatControls()
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
         bindings = this._StatControls_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_character_parts_StatControlsWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return StatControls[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.percentWidth = 100;
         this.gap = -2;
         this.children = [this._StatControls_VBox2_c(),this._StatControls_SecondaryStatRenderer1_i(),this._StatControls_SecondaryStatRenderer2_i(),this._StatControls_SecondaryStatRenderer3_i(),this._StatControls_SecondaryStatRenderer4_i(),this._StatControls_SecondaryStatRenderer5_i(),this._StatControls_SecondaryStatRenderer6_i(),this._StatControls_SecondaryStatRenderer7_i(),this._StatControls_SecondaryStatRenderer8_i(),this._StatControls_Component1_c(),this._StatControls_HBox1_c()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         StatControls._watcherSetupUtil = param1;
      }
      
      private function accept() : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function reset() : void
      {
         this.strength.modifier = this.constitution.modifier = this.accuracy.modifier = this.intellect.modifier = this.totalModifier = 0;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function recountPoint() : void
      {
         this.totalModifier = this.strength.modifier + this.constitution.modifier + this.accuracy.modifier + this.intellect.modifier;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function collectStats() : Object
      {
         var o:Object = {};
         if(this.strength.modifier > 0)
         {
            o[ParamType.STRENGTH] = this.strength.modifier;
         }
         if(this.constitution.modifier > 0)
         {
            o[ParamType.CONSTITUTION] = this.constitution.modifier;
         }
         if(this.accuracy.modifier > 0)
         {
            o[ParamType.ACCURACY] = this.accuracy.modifier;
         }
         if(this.intellect.modifier > 0)
         {
            o[ParamType.INTELLECT] = this.intellect.modifier;
         }
         return o;
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _StatControls_VBox2_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.gap = 1;
         _loc1_.percentWidth = 100;
         _loc1_.children = [this._StatControls_StatChanger1_i(),this._StatControls_StatChanger2_i(),this._StatControls_StatChanger3_i(),this._StatControls_StatChanger4_i()];
         return _loc1_;
      }
      
      private function _StatControls_StatChanger1_i() : StatChanger
      {
         var _loc1_:StatChanger = new StatChanger();
         _loc1_.addEventListener("change",this.__strength_change);
         this.strength = _loc1_;
         BindingManager.executeBindings(this,"strength",this.strength);
         return _loc1_;
      }
      
      public function __strength_change(event:Event) : void
      {
         this.recountPoint();
      }
      
      private function _StatControls_StatChanger2_i() : StatChanger
      {
         var _loc1_:StatChanger = new StatChanger();
         _loc1_.addEventListener("change",this.__constitution_change);
         this.constitution = _loc1_;
         BindingManager.executeBindings(this,"constitution",this.constitution);
         return _loc1_;
      }
      
      public function __constitution_change(event:Event) : void
      {
         this.recountPoint();
      }
      
      private function _StatControls_StatChanger3_i() : StatChanger
      {
         var _loc1_:StatChanger = new StatChanger();
         _loc1_.addEventListener("change",this.__accuracy_change);
         this.accuracy = _loc1_;
         BindingManager.executeBindings(this,"accuracy",this.accuracy);
         return _loc1_;
      }
      
      public function __accuracy_change(event:Event) : void
      {
         this.recountPoint();
      }
      
      private function _StatControls_StatChanger4_i() : StatChanger
      {
         var _loc1_:StatChanger = new StatChanger();
         _loc1_.addEventListener("change",this.__intellect_change);
         this.intellect = _loc1_;
         BindingManager.executeBindings(this,"intellect",this.intellect);
         return _loc1_;
      }
      
      public function __intellect_change(event:Event) : void
      {
         this.recountPoint();
      }
      
      private function _StatControls_SecondaryStatRenderer1_i() : SecondaryStatRenderer
      {
         var _loc1_:SecondaryStatRenderer = new SecondaryStatRenderer();
         this._StatControls_SecondaryStatRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_StatControls_SecondaryStatRenderer1",this._StatControls_SecondaryStatRenderer1);
         return _loc1_;
      }
      
      private function _StatControls_SecondaryStatRenderer2_i() : SecondaryStatRenderer
      {
         var _loc1_:SecondaryStatRenderer = new SecondaryStatRenderer();
         this._StatControls_SecondaryStatRenderer2 = _loc1_;
         BindingManager.executeBindings(this,"_StatControls_SecondaryStatRenderer2",this._StatControls_SecondaryStatRenderer2);
         return _loc1_;
      }
      
      private function _StatControls_SecondaryStatRenderer3_i() : SecondaryStatRenderer
      {
         var _loc1_:SecondaryStatRenderer = new SecondaryStatRenderer();
         this._StatControls_SecondaryStatRenderer3 = _loc1_;
         BindingManager.executeBindings(this,"_StatControls_SecondaryStatRenderer3",this._StatControls_SecondaryStatRenderer3);
         return _loc1_;
      }
      
      private function _StatControls_SecondaryStatRenderer4_i() : SecondaryStatRenderer
      {
         var _loc1_:SecondaryStatRenderer = new SecondaryStatRenderer();
         this._StatControls_SecondaryStatRenderer4 = _loc1_;
         BindingManager.executeBindings(this,"_StatControls_SecondaryStatRenderer4",this._StatControls_SecondaryStatRenderer4);
         return _loc1_;
      }
      
      private function _StatControls_SecondaryStatRenderer5_i() : SecondaryStatRenderer
      {
         var _loc1_:SecondaryStatRenderer = new SecondaryStatRenderer();
         this._StatControls_SecondaryStatRenderer5 = _loc1_;
         BindingManager.executeBindings(this,"_StatControls_SecondaryStatRenderer5",this._StatControls_SecondaryStatRenderer5);
         return _loc1_;
      }
      
      private function _StatControls_SecondaryStatRenderer6_i() : SecondaryStatRenderer
      {
         var _loc1_:SecondaryStatRenderer = new SecondaryStatRenderer();
         this._StatControls_SecondaryStatRenderer6 = _loc1_;
         BindingManager.executeBindings(this,"_StatControls_SecondaryStatRenderer6",this._StatControls_SecondaryStatRenderer6);
         return _loc1_;
      }
      
      private function _StatControls_SecondaryStatRenderer7_i() : SecondaryStatRenderer
      {
         var _loc1_:SecondaryStatRenderer = new SecondaryStatRenderer();
         this._StatControls_SecondaryStatRenderer7 = _loc1_;
         BindingManager.executeBindings(this,"_StatControls_SecondaryStatRenderer7",this._StatControls_SecondaryStatRenderer7);
         return _loc1_;
      }
      
      private function _StatControls_SecondaryStatRenderer8_i() : SecondaryStatRenderer
      {
         var _loc1_:SecondaryStatRenderer = new SecondaryStatRenderer();
         this._StatControls_SecondaryStatRenderer8 = _loc1_;
         BindingManager.executeBindings(this,"_StatControls_SecondaryStatRenderer8",this._StatControls_SecondaryStatRenderer8);
         return _loc1_;
      }
      
      private function _StatControls_Component1_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.height = 33;
         return _loc1_;
      }
      
      private function _StatControls_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.gap = 5;
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._StatControls_HBox2_c(),this._StatControls_Component2_c(),this._StatControls_Button11_i(),this._StatControls_Button12_i()];
         return _loc1_;
      }
      
      private function _StatControls_HBox2_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.children = [this._StatControls_Label1_i(),this._StatControls_Label2_i()];
         return _loc1_;
      }
      
      private function _StatControls_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.fontSize = 12;
         this._StatControls_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_StatControls_Label1",this._StatControls_Label1);
         return _loc1_;
      }
      
      private function _StatControls_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.bold = true;
         _loc1_.color = 16777215;
         _loc1_.fontSize = 12;
         this._StatControls_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_StatControls_Label2",this._StatControls_Label2);
         return _loc1_;
      }
      
      private function _StatControls_Component2_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.percentWidth = 100;
         return _loc1_;
      }
      
      private function _StatControls_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.right = 65;
         _loc1_.height = 28;
         _loc1_.width = 50;
         _loc1_.verticalCenter = 0;
         _loc1_.addEventListener("click",this.___StatControls_Button11_click);
         this._StatControls_Button11 = _loc1_;
         BindingManager.executeBindings(this,"_StatControls_Button11",this._StatControls_Button11);
         return _loc1_;
      }
      
      public function ___StatControls_Button11_click(event:MouseEvent) : void
      {
         this.accept();
      }
      
      private function _StatControls_Button12_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.right = 10;
         _loc1_.height = 28;
         _loc1_.width = 50;
         _loc1_.verticalCenter = 0;
         _loc1_.addEventListener("click",this.___StatControls_Button12_click);
         this._StatControls_Button12 = _loc1_;
         BindingManager.executeBindings(this,"_StatControls_Button12",this._StatControls_Button12);
         return _loc1_;
      }
      
      public function ___StatControls_Button12_click(event:MouseEvent) : void
      {
         this.reset();
      }
      
      private function _StatControls_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():*
         {
            return points - totalModifier;
         },function(param1:*):void
         {
            available = param1;
         },"available");
         result[1] = new Binding(this,function():Object
         {
            return ParamType.getIcon(ParamType.STRENGTH);
         },null,"strength.source");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.STRENGTH);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"strength.label");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.STRENGTH + ".description");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"strength.toolTip");
         result[4] = new Binding(this,function():int
         {
            return int(characterModel.params.STRENGTH) + int(characterModel.previewParams.STRENGTH);
         },null,"strength.value");
         result[5] = new Binding(this,function():int
         {
            return available;
         },null,"strength.available");
         result[6] = new Binding(this,function():Object
         {
            return ParamType.getIcon(ParamType.CONSTITUTION);
         },null,"constitution.source");
         result[7] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.CONSTITUTION);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"constitution.label");
         result[8] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.CONSTITUTION + ".description");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"constitution.toolTip");
         result[9] = new Binding(this,function():int
         {
            return int(characterModel.params.CONSTITUTION) + int(characterModel.previewParams.CONSTITUTION);
         },null,"constitution.value");
         result[10] = new Binding(this,function():int
         {
            return available;
         },null,"constitution.available");
         result[11] = new Binding(this,function():Object
         {
            return ParamType.getIcon(ParamType.ACCURACY);
         },null,"accuracy.source");
         result[12] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.ACCURACY);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"accuracy.label");
         result[13] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.ACCURACY + ".description");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"accuracy.toolTip");
         result[14] = new Binding(this,function():int
         {
            return int(characterModel.params.ACCURACY) + int(characterModel.previewParams.ACCURACY);
         },null,"accuracy.value");
         result[15] = new Binding(this,function():int
         {
            return available;
         },null,"accuracy.available");
         result[16] = new Binding(this,function():Object
         {
            return ParamType.getIcon(ParamType.INTELLECT);
         },null,"intellect.source");
         result[17] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.INTELLECT);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"intellect.label");
         result[18] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.INTELLECT + ".description");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"intellect.toolTip");
         result[19] = new Binding(this,function():int
         {
            return int(characterModel.params.INTELLECT) + int(characterModel.previewParams.INTELLECT);
         },null,"intellect.value");
         result[20] = new Binding(this,function():int
         {
            return available;
         },null,"intellect.available");
         result[21] = new Binding(this,function():String
         {
            var _loc1_:* = getString("DAMAGE_PHYSICAL");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatControls_SecondaryStatRenderer1.label");
         result[22] = new Binding(this,function():Boolean
         {
            return strength.modifier > 0;
         },null,"_StatControls_SecondaryStatRenderer1.highlighted");
         result[23] = new Binding(this,function():String
         {
            var _loc1_:* = int(characterModel.params.DAMAGE_PHYSICAL_MIN) + int(characterModel.previewParams.DAMAGE_PHYSICAL_MIN) + "-" + (int(characterModel.params.DAMAGE_PHYSICAL_MAX) + int(characterModel.previewParams.DAMAGE_PHYSICAL_MAX));
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatControls_SecondaryStatRenderer1.value");
         result[24] = new Binding(this,function():String
         {
            var _loc1_:* = getString("HP");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatControls_SecondaryStatRenderer2.label");
         result[25] = new Binding(this,function():Boolean
         {
            return constitution.modifier > 0;
         },null,"_StatControls_SecondaryStatRenderer2.highlighted");
         result[26] = new Binding(this,function():String
         {
            var _loc1_:* = int(characterModel.params.MAX_HP) + int(characterModel.previewParams.MAX_HP);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatControls_SecondaryStatRenderer2.value");
         result[27] = new Binding(this,function():String
         {
            var _loc1_:* = getString("MP");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatControls_SecondaryStatRenderer3.label");
         result[28] = new Binding(this,function():Boolean
         {
            return intellect.modifier > 0;
         },null,"_StatControls_SecondaryStatRenderer3.highlighted");
         result[29] = new Binding(this,function():String
         {
            var _loc1_:* = int(characterModel.params.MAX_MP) + int(characterModel.previewParams.MAX_MP);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatControls_SecondaryStatRenderer3.value");
         result[30] = new Binding(this,function():String
         {
            var _loc1_:* = getString("STAMINA");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatControls_SecondaryStatRenderer4.label");
         result[31] = new Binding(this,function():Boolean
         {
            return constitution.modifier > 0;
         },null,"_StatControls_SecondaryStatRenderer4.highlighted");
         result[32] = new Binding(this,function():String
         {
            var _loc1_:* = int(characterModel.params.MAX_STAMINA) + int(characterModel.previewParams.MAX_STAMINA);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatControls_SecondaryStatRenderer4.value");
         result[33] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.HIT_MELEE);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatControls_SecondaryStatRenderer5.label");
         result[34] = new Binding(this,function():Boolean
         {
            return accuracy.modifier > 0;
         },null,"_StatControls_SecondaryStatRenderer5.highlighted");
         result[35] = new Binding(this,function():String
         {
            var _loc1_:* = int(characterModel.params.HIT_MELEE) + int(characterModel.previewParams.HIT_MELEE);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatControls_SecondaryStatRenderer5.value");
         result[36] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.CRIT);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatControls_SecondaryStatRenderer6.label");
         result[37] = new Binding(this,function():String
         {
            var _loc1_:* = int(characterModel.params.CRIT) + int(characterModel.previewParams.CRIT);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatControls_SecondaryStatRenderer6.value");
         result[38] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.DODGE) + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatControls_SecondaryStatRenderer7.label");
         result[39] = new Binding(this,function():String
         {
            var _loc1_:* = int(characterModel.params.DODGE) + int(characterModel.previewParams.DODGE);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatControls_SecondaryStatRenderer7.value");
         result[40] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.ANTICRIT) + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatControls_SecondaryStatRenderer8.label");
         result[41] = new Binding(this,function():String
         {
            var _loc1_:* = int(characterModel.params.ANTICRIT) + int(characterModel.previewParams.ANTICRIT);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatControls_SecondaryStatRenderer8.value");
         result[42] = new Binding(this,function():String
         {
            var _loc1_:* = getString("character.additionalPoints") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatControls_Label1.text");
         result[43] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_StatControls_Label1.color");
         result[44] = new Binding(this,function():String
         {
            var _loc1_:* = available;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatControls_Label2.text");
         result[45] = new Binding(this,function():Object
         {
            return Icons.accept;
         },null,"_StatControls_Button11.icon");
         result[46] = new Binding(this,function():Boolean
         {
            return totalModifier > 0;
         },null,"_StatControls_Button11.enabled");
         result[47] = new Binding(this,function():String
         {
            var _loc1_:* = getString("accept");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatControls_Button11.toolTip");
         result[48] = new Binding(this,function():Object
         {
            return Icons.cancel;
         },null,"_StatControls_Button12.icon");
         result[49] = new Binding(this,function():Boolean
         {
            return totalModifier > 0;
         },null,"_StatControls_Button12.enabled");
         result[50] = new Binding(this,function():String
         {
            var _loc1_:* = getString("reset");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatControls_Button12.toolTip");
         return result;
      }
      
      private function _StatControls_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         this.available = this.points - this.totalModifier;
      }
      
      [Bindable(event="propertyChange")]
      public function get accuracy() : StatChanger
      {
         return this._2131707655accuracy;
      }
      
      public function set accuracy(param1:StatChanger) : void
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
      public function get constitution() : StatChanger
      {
         return this._1405564421constitution;
      }
      
      public function set constitution(param1:StatChanger) : void
      {
         var _loc2_:Object = this._1405564421constitution;
         if(_loc2_ !== param1)
         {
            this._1405564421constitution = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"constitution",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get intellect() : StatChanger
      {
         return this._497265024intellect;
      }
      
      public function set intellect(param1:StatChanger) : void
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
      public function get strength() : StatChanger
      {
         return this._1791316033strength;
      }
      
      public function set strength(param1:StatChanger) : void
      {
         var _loc2_:Object = this._1791316033strength;
         if(_loc2_ !== param1)
         {
            this._1791316033strength = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"strength",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get characterModel() : CharacterModel
      {
         return this._340320640characterModel;
      }
      
      public function set characterModel(param1:CharacterModel) : void
      {
         var _loc2_:Object = this._340320640characterModel;
         if(_loc2_ !== param1)
         {
            this._340320640characterModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"characterModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get points() : int
      {
         return this._982754077points;
      }
      
      public function set points(param1:int) : void
      {
         var _loc2_:Object = this._982754077points;
         if(_loc2_ !== param1)
         {
            this._982754077points = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"points",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get totalModifier() : int
      {
         return this._589054405totalModifier;
      }
      
      private function set totalModifier(param1:int) : void
      {
         var _loc2_:Object = this._589054405totalModifier;
         if(_loc2_ !== param1)
         {
            this._589054405totalModifier = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"totalModifier",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get available() : int
      {
         return this._733902135available;
      }
      
      private function set available(param1:int) : void
      {
         var _loc2_:Object = this._733902135available;
         if(_loc2_ !== param1)
         {
            this._733902135available = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"available",_loc2_,param1));
            }
         }
      }
   }
}

