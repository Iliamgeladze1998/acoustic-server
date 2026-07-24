package soul.view.rtm.targetFrame
{
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.GlowFilter;
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
   import soul.event.SimpleUIEvent;
   import soul.model.field.FieldUnit;
   import soul.model.rtm.RTMModel;
   import soul.model.system.Configuration;
   import soul.view.assets.Assets;
   import soul.view.rtm.BarDrawer;
   import soul.view.rtm.Effects;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Canvas;
   import soul.view.ui.Container;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class GenericFrame extends VBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public static const fightFilter:Array = [new GlowFilter(16711680,1,6,6,3,2,true)];
      
      public var _GenericFrame_BarDrawer1:BarDrawer;
      
      public var _GenericFrame_BarDrawer2:BarDrawer;
      
      public var _GenericFrame_BarDrawer3:BarDrawer;
      
      public var _GenericFrame_Effects1:Effects;
      
      public var _GenericFrame_Label1:Label;
      
      public var _GenericFrame_Label2:Label;
      
      public var _GenericFrame_Label3:Label;
      
      private var _1405959847avatar:CachedImage;
      
      private var _1367706280canvas:Canvas;
      
      private var _97692013frame:CachedImage;
      
      public var model:RTMModel;
      
      private var _3594628unit:FieldUnit;
      
      private var _1354707501fightMode:Boolean;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function GenericFrame()
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
         bindings = this._GenericFrame_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_rtm_targetFrame_GenericFrameWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return GenericFrame[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.children = [this._GenericFrame_Canvas1_i(),this._GenericFrame_Effects1_i()];
         this.addEventListener("creationComplete",this.___GenericFrame_VBox1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         GenericFrame._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         var avatarMask:Shape = new Shape();
         avatarMask.graphics.beginFill(0);
         avatarMask.graphics.drawEllipse(0,0,this.avatar.width,this.avatar.height);
         avatarMask.graphics.endFill();
         this.avatar.addChild(avatarMask);
         this.avatar.mask = avatarMask;
      }
      
      protected function avatarClick() : void
      {
      }
      
      protected function menuClick() : void
      {
      }
      
      protected function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      protected function getDifficulty(key:String) : String
      {
         return LocaleManager.getString(BundleName.NPC,key);
      }
      
      private function _GenericFrame_Canvas1_i() : Canvas
      {
         var _loc1_:Canvas = new Canvas();
         _loc1_.width = 207;
         _loc1_.height = 70;
         _loc1_.children = [this._GenericFrame_Container1_c(),this._GenericFrame_BarDrawer1_i(),this._GenericFrame_BarDrawer2_i(),this._GenericFrame_BarDrawer3_i(),this._GenericFrame_Label1_i(),this._GenericFrame_CachedImage1_i(),this._GenericFrame_CachedImage2_i(),this._GenericFrame_Container2_c(),this._GenericFrame_Label2_i(),this._GenericFrame_Label3_i()];
         this.canvas = _loc1_;
         BindingManager.executeBindings(this,"canvas",this.canvas);
         return _loc1_;
      }
      
      private function _GenericFrame_Container1_c() : Container
      {
         var _loc1_:Container = null;
         _loc1_ = new Container();
         _loc1_.x = 70;
         _loc1_.y = 17;
         _loc1_.width = 136;
         _loc1_.height = 45;
         _loc1_.backgroundColor = 0;
         return _loc1_;
      }
      
      private function _GenericFrame_BarDrawer1_i() : BarDrawer
      {
         var _loc1_:BarDrawer = new BarDrawer();
         _loc1_.labelVisible = false;
         _loc1_.width = 126;
         _loc1_.height = 10;
         _loc1_.x = 77;
         _loc1_.y = 19;
         this._GenericFrame_BarDrawer1 = _loc1_;
         BindingManager.executeBindings(this,"_GenericFrame_BarDrawer1",this._GenericFrame_BarDrawer1);
         return _loc1_;
      }
      
      private function _GenericFrame_BarDrawer2_i() : BarDrawer
      {
         var _loc1_:BarDrawer = new BarDrawer();
         _loc1_.labelVisible = false;
         _loc1_.width = 124;
         _loc1_.height = 10;
         _loc1_.barColor = 20354;
         _loc1_.x = 80;
         _loc1_.y = 34;
         this._GenericFrame_BarDrawer2 = _loc1_;
         BindingManager.executeBindings(this,"_GenericFrame_BarDrawer2",this._GenericFrame_BarDrawer2);
         return _loc1_;
      }
      
      private function _GenericFrame_BarDrawer3_i() : BarDrawer
      {
         var _loc1_:BarDrawer = new BarDrawer();
         _loc1_.labelVisible = false;
         _loc1_.width = 132;
         _loc1_.height = 10;
         _loc1_.barColor = 8285001;
         _loc1_.x = 73;
         _loc1_.y = 49;
         this._GenericFrame_BarDrawer3 = _loc1_;
         BindingManager.executeBindings(this,"_GenericFrame_BarDrawer3",this._GenericFrame_BarDrawer3);
         return _loc1_;
      }
      
      private function _GenericFrame_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.x = 73;
         _loc1_.y = 45;
         _loc1_.width = 132;
         _loc1_.height = 16;
         _loc1_.align = "center";
         _loc1_.backgroundColor = 0;
         this._GenericFrame_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_GenericFrame_Label1",this._GenericFrame_Label1);
         return _loc1_;
      }
      
      private function _GenericFrame_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.x = 16;
         _loc1_.y = 3;
         _loc1_.width = 62;
         _loc1_.height = 62;
         _loc1_.addEventListener("click",this.__avatar_click);
         this.avatar = _loc1_;
         BindingManager.executeBindings(this,"avatar",this.avatar);
         return _loc1_;
      }
      
      public function __avatar_click(event:MouseEvent) : void
      {
         this.avatarClick();
      }
      
      private function _GenericFrame_CachedImage2_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.mouseEnabled = false;
         this.frame = _loc1_;
         BindingManager.executeBindings(this,"frame",this.frame);
         return _loc1_;
      }
      
      private function _GenericFrame_Container2_c() : Container
      {
         var _loc1_:Container = new Container();
         _loc1_.x = 4;
         _loc1_.y = 45;
         _loc1_.width = 20;
         _loc1_.height = 20;
         _loc1_.backgroundColor = 16773120;
         _loc1_.backgroundAlpha = 0;
         _loc1_.addEventListener("click",this.___GenericFrame_Container2_click);
         return _loc1_;
      }
      
      public function ___GenericFrame_Container2_click(event:MouseEvent) : void
      {
         this.menuClick();
      }
      
      private function _GenericFrame_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.x = 73;
         _loc1_.y = 1;
         _loc1_.fontSize = 10;
         _loc1_.width = 130;
         _loc1_.height = 17;
         _loc1_.bold = true;
         this._GenericFrame_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_GenericFrame_Label2",this._GenericFrame_Label2);
         return _loc1_;
      }
      
      private function _GenericFrame_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.x = 0;
         _loc1_.y = 6;
         _loc1_.fontSize = 10;
         _loc1_.width = 28;
         _loc1_.height = 17;
         _loc1_.align = "center";
         _loc1_.bold = true;
         this._GenericFrame_Label3 = _loc1_;
         BindingManager.executeBindings(this,"_GenericFrame_Label3",this._GenericFrame_Label3);
         return _loc1_;
      }
      
      private function _GenericFrame_Effects1_i() : Effects
      {
         var _loc1_:Effects = new Effects();
         this._GenericFrame_Effects1 = _loc1_;
         BindingManager.executeBindings(this,"_GenericFrame_Effects1",this._GenericFrame_Effects1);
         return _loc1_;
      }
      
      public function ___GenericFrame_VBox1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _GenericFrame_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Boolean
         {
            return unit != null;
         },null,"this.visible");
         result[1] = new Binding(this,function():int
         {
            return unit.stats.HP;
         },null,"_GenericFrame_BarDrawer1.value");
         result[2] = new Binding(this,function():int
         {
            return unit.stats.MAX_HP;
         },null,"_GenericFrame_BarDrawer1.maxValue");
         result[3] = new Binding(this,function():Array
         {
            var _loc1_:* = BarDrawer.HP_COLORS;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_GenericFrame_BarDrawer1.colors");
         result[4] = new Binding(this,function():int
         {
            return unit.stats.MP;
         },null,"_GenericFrame_BarDrawer2.value");
         result[5] = new Binding(this,function():int
         {
            return unit.stats.MAX_MP;
         },null,"_GenericFrame_BarDrawer2.maxValue");
         result[6] = new Binding(this,function():int
         {
            return unit.stats.STAMINA;
         },null,"_GenericFrame_BarDrawer3.value");
         result[7] = new Binding(this,function():int
         {
            return unit.stats.MAX_STAMINA;
         },null,"_GenericFrame_BarDrawer3.maxValue");
         result[8] = new Binding(this,function():Boolean
         {
            return unit.difficulty == null;
         },null,"_GenericFrame_BarDrawer3.visible");
         result[9] = new Binding(this,function():String
         {
            var _loc1_:* = getDifficulty(unit.difficulty);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_GenericFrame_Label1.text");
         result[10] = new Binding(this,function():Boolean
         {
            return unit.difficulty != null;
         },null,"_GenericFrame_Label1.visible");
         result[11] = new Binding(this,function():Array
         {
            var _loc1_:* = fightMode ? fightFilter : [];
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"avatar.filters");
         result[12] = new Binding(this,function():Object
         {
            return Configuration.getSmallAvatarUrl(unit.avatarImagePath);
         },null,"avatar.source");
         result[13] = new Binding(this,function():Object
         {
            return Assets.targetFrame;
         },null,"frame.source");
         result[14] = new Binding(this,function():String
         {
            var _loc1_:* = unit.name;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_GenericFrame_Label2.text");
         result[15] = new Binding(this,function():String
         {
            var _loc1_:* = unit.stats.LEVEL;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_GenericFrame_Label3.text");
         result[16] = new Binding(this,function():Array
         {
            var _loc1_:* = unit.effects;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_GenericFrame_Effects1.effects");
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
      public function get canvas() : Canvas
      {
         return this._1367706280canvas;
      }
      
      public function set canvas(param1:Canvas) : void
      {
         var _loc2_:Object = this._1367706280canvas;
         if(_loc2_ !== param1)
         {
            this._1367706280canvas = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"canvas",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get frame() : CachedImage
      {
         return this._97692013frame;
      }
      
      public function set frame(param1:CachedImage) : void
      {
         var _loc2_:Object = this._97692013frame;
         if(_loc2_ !== param1)
         {
            this._97692013frame = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"frame",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get unit() : FieldUnit
      {
         return this._3594628unit;
      }
      
      public function set unit(param1:FieldUnit) : void
      {
         var _loc2_:Object = this._3594628unit;
         if(_loc2_ !== param1)
         {
            this._3594628unit = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"unit",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get fightMode() : Boolean
      {
         return this._1354707501fightMode;
      }
      
      public function set fightMode(param1:Boolean) : void
      {
         var _loc2_:Object = this._1354707501fightMode;
         if(_loc2_ !== param1)
         {
            this._1354707501fightMode = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fightMode",_loc2_,param1));
            }
         }
      }
   }
}

