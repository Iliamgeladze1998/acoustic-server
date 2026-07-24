package soul.view.interaction.academy
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
   import soul.model.character.Disposition;
   import soul.model.character.DispositionGroup;
   import soul.model.system.Configuration;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientLabel;
   import soul.view.toolTip.ToolTipManager;
   import soul.view.ui.Box;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Container;
   import soul.view.ui.Label;
   import soul.view.ui.ScrollBase;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class ClassDescription extends ScrollBase implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _ClassDescription_GradientLabel1:GradientLabel;
      
      public var _ClassDescription_GradientLabel2:GradientLabel;
      
      public var _ClassDescription_GradientLabel3:GradientLabel;
      
      public var _ClassDescription_Label2:Label;
      
      private var _1405959847avatar:CachedImage;
      
      private var _9888733className:Label;
      
      private var _1724546052description:Label;
      
      private var _1064900894minuses:Label;
      
      private var _985162808pluses:Label;
      
      private var _1917457213school1:CachedImage;
      
      private var _1917457214school2:CachedImage;
      
      private var _1917457215school3:CachedImage;
      
      private var _sex:String = "";
      
      private var _side:String;
      
      private var _klass:String;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ClassDescription()
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
         bindings = this._ClassDescription_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_academy_ClassDescriptionWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return ClassDescription[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.verticalScrollPolicy = "on";
         this.horizontalScrollPolicy = "off";
         this.backgroundColor = 1;
         this.backgroundAlpha = 0;
         this.wheelMultiplier = 4;
         this.children = [this._ClassDescription_VBox1_c()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ClassDescription._watcherSetupUtil = param1;
      }
      
      public function set sex(value:String) : void
      {
         if(this._sex == value)
         {
            return;
         }
         this._sex = value;
         this.compose();
      }
      
      public function set side(value:String) : void
      {
         if(this._side == value)
         {
            return;
         }
         this._side = value;
         this.compose();
      }
      
      public function set klass(value:String) : void
      {
         if(this._klass == value)
         {
            return;
         }
         this._klass = value;
         this.compose();
      }
      
      private function compose() : void
      {
         var disposition:String = null;
         disposition = Disposition.getBySideAndClass(this._side,this._klass);
         this.className.text = this.getString(disposition) + "\n" + this.getString(this._side);
         this.pluses.text = this.getInfo(disposition + ".pluses");
         this.minuses.text = this.getInfo(disposition + ".minuses");
         this.description.text = this.getInfo(disposition);
         this.avatar.source = Configuration.getSmallAvatarUrl(disposition.toLowerCase() + "/" + this._sex.toLowerCase() + "/default.jpg");
         var arr:Array = DispositionGroup.getSchoolIcons(this._klass);
         this.school1.source = arr[0];
         ToolTipManager.register(this.school1,this.getString(this._klass + "_tab0"));
         this.school2.source = arr[1];
         ToolTipManager.register(this.school2,this.getString(this._klass + "_tab1"));
         this.school3.source = arr[2];
         ToolTipManager.register(this.school3,this.getString(this._klass + "_tab2"));
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function getInfo(key:String) : String
      {
         return LocaleManager.getString(BundleName.DISPOSITION_INFO,key);
      }
      
      private function _ClassDescription_VBox1_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.width = 207;
         _loc1_.children = [this._ClassDescription_Box1_c(),this._ClassDescription_GradientLabel1_i(),this._ClassDescription_Label3_i(),this._ClassDescription_GradientLabel2_i(),this._ClassDescription_Label4_i(),this._ClassDescription_GradientLabel3_i(),this._ClassDescription_Label5_i()];
         return _loc1_;
      }
      
      private function _ClassDescription_Box1_c() : Box
      {
         var _loc1_:Box = new Box();
         _loc1_.percentWidth = 100;
         _loc1_.height = 90;
         _loc1_.gap = 5;
         _loc1_.children = [this._ClassDescription_Container1_c(),this._ClassDescription_Box2_c()];
         return _loc1_;
      }
      
      private function _ClassDescription_Container1_c() : Container
      {
         var _loc1_:Container = new Container();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.children = [this._ClassDescription_CachedImage1_i()];
         return _loc1_;
      }
      
      private function _ClassDescription_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.x = 10;
         this.avatar = _loc1_;
         BindingManager.executeBindings(this,"avatar",this.avatar);
         return _loc1_;
      }
      
      private function _ClassDescription_Box2_c() : Box
      {
         var _loc1_:Box = new Box();
         _loc1_.direction = "vertical";
         _loc1_.width = 110;
         _loc1_.height = 87;
         _loc1_.children = [this._ClassDescription_Label1_i(),this._ClassDescription_Container2_c(),this._ClassDescription_Label2_i(),this._ClassDescription_Box3_c()];
         return _loc1_;
      }
      
      private function _ClassDescription_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.multiline = true;
         this.className = _loc1_;
         BindingManager.executeBindings(this,"className",this.className);
         return _loc1_;
      }
      
      private function _ClassDescription_Container2_c() : Container
      {
         var _loc1_:Container = new Container();
         _loc1_.percentHeight = 100;
         _loc1_.width = 10;
         return _loc1_;
      }
      
      private function _ClassDescription_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         this._ClassDescription_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_ClassDescription_Label2",this._ClassDescription_Label2);
         return _loc1_;
      }
      
      private function _ClassDescription_Box3_c() : Box
      {
         var _loc1_:Box = new Box();
         _loc1_.gap = 1;
         _loc1_.children = [this._ClassDescription_CachedImage2_i(),this._ClassDescription_CachedImage3_i(),this._ClassDescription_CachedImage4_i()];
         return _loc1_;
      }
      
      private function _ClassDescription_CachedImage2_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this.school1 = _loc1_;
         BindingManager.executeBindings(this,"school1",this.school1);
         return _loc1_;
      }
      
      private function _ClassDescription_CachedImage3_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this.school2 = _loc1_;
         BindingManager.executeBindings(this,"school2",this.school2);
         return _loc1_;
      }
      
      private function _ClassDescription_CachedImage4_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this.school3 = _loc1_;
         BindingManager.executeBindings(this,"school3",this.school3);
         return _loc1_;
      }
      
      private function _ClassDescription_GradientLabel1_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.bold = true;
         _loc1_.percentWidth = 100;
         _loc1_.height = 20;
         this._ClassDescription_GradientLabel1 = _loc1_;
         BindingManager.executeBindings(this,"_ClassDescription_GradientLabel1",this._ClassDescription_GradientLabel1);
         return _loc1_;
      }
      
      private function _ClassDescription_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.multiline = true;
         _loc1_.wordWrap = true;
         _loc1_.percentWidth = 100;
         _loc1_.padding = 5;
         this.pluses = _loc1_;
         BindingManager.executeBindings(this,"pluses",this.pluses);
         return _loc1_;
      }
      
      private function _ClassDescription_GradientLabel2_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.bold = true;
         _loc1_.percentWidth = 100;
         _loc1_.height = 20;
         this._ClassDescription_GradientLabel2 = _loc1_;
         BindingManager.executeBindings(this,"_ClassDescription_GradientLabel2",this._ClassDescription_GradientLabel2);
         return _loc1_;
      }
      
      private function _ClassDescription_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.multiline = true;
         _loc1_.wordWrap = true;
         _loc1_.percentWidth = 100;
         _loc1_.padding = 5;
         this.minuses = _loc1_;
         BindingManager.executeBindings(this,"minuses",this.minuses);
         return _loc1_;
      }
      
      private function _ClassDescription_GradientLabel3_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.bold = true;
         _loc1_.percentWidth = 100;
         _loc1_.height = 20;
         this._ClassDescription_GradientLabel3 = _loc1_;
         BindingManager.executeBindings(this,"_ClassDescription_GradientLabel3",this._ClassDescription_GradientLabel3);
         return _loc1_;
      }
      
      private function _ClassDescription_Label5_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.multiline = true;
         _loc1_.wordWrap = true;
         _loc1_.percentWidth = 100;
         _loc1_.padding = 5;
         this.description = _loc1_;
         BindingManager.executeBindings(this,"description",this.description);
         return _loc1_;
      }
      
      private function _ClassDescription_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():uint
         {
            return Colors.LABEL;
         },null,"className.color");
         result[1] = new Binding(this,function():uint
         {
            return Colors.GOLD_DARK;
         },null,"_ClassDescription_Label2.color");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = getString("academy.schools") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClassDescription_Label2.text");
         result[3] = new Binding(this,function():uint
         {
            return Colors.PLUSES;
         },null,"_ClassDescription_GradientLabel1.color");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = getString("academy.pluses") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClassDescription_GradientLabel1.text");
         result[5] = new Binding(this,function():uint
         {
            return Colors.LABEL;
         },null,"pluses.color");
         result[6] = new Binding(this,function():uint
         {
            return Colors.MINUSES;
         },null,"_ClassDescription_GradientLabel2.color");
         result[7] = new Binding(this,function():String
         {
            var _loc1_:* = getString("academy.minuses") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClassDescription_GradientLabel2.text");
         result[8] = new Binding(this,function():uint
         {
            return Colors.LABEL;
         },null,"minuses.color");
         result[9] = new Binding(this,function():uint
         {
            return Colors.GOLD_DARK;
         },null,"_ClassDescription_GradientLabel3.color");
         result[10] = new Binding(this,function():String
         {
            var _loc1_:* = getString("academy.description") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClassDescription_GradientLabel3.text");
         result[11] = new Binding(this,function():uint
         {
            return Colors.LABEL;
         },null,"description.color");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get avatar() : CachedImage
      {
         return this._1405959847avatar;
      }
      
      public function set avatar(param1:CachedImage) : void
      {
         var _loc2_:Object = this._1405959847avatar;
         if(_loc2_ !== param1)
         {
            this._1405959847avatar = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"avatar",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get className() : Label
      {
         return this._9888733className;
      }
      
      public function set className(param1:Label) : void
      {
         var _loc2_:Object = this._9888733className;
         if(_loc2_ !== param1)
         {
            this._9888733className = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"className",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get description() : Label
      {
         return this._1724546052description;
      }
      
      public function set description(param1:Label) : void
      {
         var _loc2_:Object = this._1724546052description;
         if(_loc2_ !== param1)
         {
            this._1724546052description = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"description",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get minuses() : Label
      {
         return this._1064900894minuses;
      }
      
      public function set minuses(param1:Label) : void
      {
         var _loc2_:Object = this._1064900894minuses;
         if(_loc2_ !== param1)
         {
            this._1064900894minuses = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minuses",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get pluses() : Label
      {
         return this._985162808pluses;
      }
      
      public function set pluses(param1:Label) : void
      {
         var _loc2_:Object = this._985162808pluses;
         if(_loc2_ !== param1)
         {
            this._985162808pluses = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pluses",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get school1() : CachedImage
      {
         return this._1917457213school1;
      }
      
      public function set school1(param1:CachedImage) : void
      {
         var _loc2_:Object = this._1917457213school1;
         if(_loc2_ !== param1)
         {
            this._1917457213school1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"school1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get school2() : CachedImage
      {
         return this._1917457214school2;
      }
      
      public function set school2(param1:CachedImage) : void
      {
         var _loc2_:Object = this._1917457214school2;
         if(_loc2_ !== param1)
         {
            this._1917457214school2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"school2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get school3() : CachedImage
      {
         return this._1917457215school3;
      }
      
      public function set school3(param1:CachedImage) : void
      {
         var _loc2_:Object = this._1917457215school3;
         if(_loc2_ !== param1)
         {
            this._1917457215school3 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"school3",_loc2_,param1));
            }
         }
      }
   }
}

