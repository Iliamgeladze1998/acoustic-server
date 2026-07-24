package soul.view.astral
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
   import soul.controller.shortcut.InteractShortcut;
   import soul.controller.shortcut.ShortcutManager;
   import soul.event.AstralEvent;
   import soul.model.astral.AstralCircle;
   import soul.model.astral.AstralModel;
   import soul.model.system.Configuration;
   import soul.utils.DateUtils;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Canvas;
   import soul.view.ui.Label;
   import soul.view.ui.List;
   import soul.view.ui.RepeatingBitmap;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class AstralPanel extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const FILTERS:Array = [new GlowFilter(0)];
      
      private static const ICON_GLOW:Array = [new GlowFilter(12512545,1,3,3,5),new GlowFilter(12512545,0.7,4,4,1)];
      
      private static const ESTIMATION_GLOW:Array = [new GlowFilter(0,1,6,6,4)];
      
      public var _AstralPanel_CachedImage1:CachedImage;
      
      public var _AstralPanel_CachedImage2:CachedImage;
      
      public var _AstralPanel_CachedImage3:CachedImage;
      
      public var _AstralPanel_CachedImage4:CachedImage;
      
      public var _AstralPanel_CachedImage5:CachedImage;
      
      public var _AstralPanel_Label1:Label;
      
      public var _AstralPanel_Label2:Label;
      
      public var _AstralPanel_Label3:Label;
      
      public var _AstralPanel_RepeatingBitmap1:RepeatingBitmap;
      
      private var _912501148actButton:Button1;
      
      private var _58531341locationList:List;
      
      private var _1064537509minimap:AstralMinimap;
      
      private var _352919633buttonEnabled:Boolean;
      
      private var _104069929model:AstralModel;
      
      private var _goEnabled:Boolean;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function AstralPanel()
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
         bindings = this._AstralPanel_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_astral_AstralPanelWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return AstralPanel[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 240;
         this.children = [this._AstralPanel_AstralMinimap1_i(),this._AstralPanel_VBox1_c(),this._AstralPanel_Label1_i(),this._AstralPanel_CachedImage5_i(),this._AstralPanel_Label2_i(),this._AstralPanel_List1_i(),this._AstralPanel_Label3_i(),this._AstralPanel_Button11_i()];
         this.addEventListener("addedToStage",this.___AstralPanel_Canvas1_addedToStage);
         this.addEventListener("removedFromStage",this.___AstralPanel_Canvas1_removedFromStage);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         AstralPanel._watcherSetupUtil = param1;
      }
      
      private function added() : void
      {
         stage.addEventListener(KeyboardEvent.KEY_UP,this.keyUp);
         ShortcutManager.addShortcutListener(InteractShortcut.instance,this.interact,0,false);
      }
      
      private function removed() : void
      {
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.keyUp);
         ShortcutManager.removeShortcutListener(InteractShortcut.instance,this.interact,false);
      }
      
      private function set goEnabled(value:Boolean) : void
      {
         this._goEnabled = value;
      }
      
      private function keyUp(e:KeyboardEvent) : void
      {
         if(e.keyCode == Keyboard.ESCAPE)
         {
            this.cancel(e);
         }
      }
      
      private function interact(e:KeyboardEvent = null) : void
      {
         if(!this.actButton.enabled || !this.model.enabled)
         {
            return;
         }
         var move:Boolean = Boolean(this.model.destinaton) && !this.model.moving;
         var ne:AstralEvent = new AstralEvent(move ? AstralEvent.MOVE_TO : AstralEvent.ENTER);
         if(move)
         {
            ne.x = this.model.destinaton.x;
            ne.y = this.model.destinaton.y;
         }
         this.model.dispatchEvent(ne);
      }
      
      private function cancel(e:KeyboardEvent) : void
      {
         if(this.model.moving)
         {
            this.model.dispatchEvent(new AstralEvent(AstralEvent.STOP));
         }
         else
         {
            this.model.destinaton = null;
            this.model.estimation = 0;
         }
      }
      
      private function selectedItemChanged() : void
      {
         var data:AstralCircle = this.locationList.selectedItem as AstralCircle;
         var ne:AstralEvent = new AstralEvent(AstralEvent.FOCUS);
         ne.x = data.x;
         ne.y = data.y;
         this.model.dispatchEvent(ne);
         ne = new AstralEvent(AstralEvent.ESTIMATE);
         ne.x = data.x;
         ne.y = data.y;
         this.model.dispatchEvent(ne);
      }
      
      private function listDoubleClick() : void
      {
         var data:AstralCircle = this.locationList.selectedItem as AstralCircle;
         var ne:AstralEvent = new AstralEvent(AstralEvent.MOVE_TO);
         ne.x = data.x;
         ne.y = data.y;
         this.model.dispatchEvent(ne);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _AstralPanel_AstralMinimap1_i() : AstralMinimap
      {
         var _loc1_:AstralMinimap = new AstralMinimap();
         _loc1_.x = 9;
         _loc1_.y = 9;
         this.minimap = _loc1_;
         BindingManager.executeBindings(this,"minimap",this.minimap);
         return _loc1_;
      }
      
      private function _AstralPanel_VBox1_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentHeight = 100;
         _loc1_.mouseEnabled = false;
         _loc1_.mouseChildren = false;
         _loc1_.children = [this._AstralPanel_CachedImage1_i(),this._AstralPanel_CachedImage2_i(),this._AstralPanel_CachedImage3_i(),this._AstralPanel_RepeatingBitmap1_i(),this._AstralPanel_CachedImage4_i()];
         return _loc1_;
      }
      
      private function _AstralPanel_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._AstralPanel_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_AstralPanel_CachedImage1",this._AstralPanel_CachedImage1);
         return _loc1_;
      }
      
      private function _AstralPanel_CachedImage2_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._AstralPanel_CachedImage2 = _loc1_;
         BindingManager.executeBindings(this,"_AstralPanel_CachedImage2",this._AstralPanel_CachedImage2);
         return _loc1_;
      }
      
      private function _AstralPanel_CachedImage3_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._AstralPanel_CachedImage3 = _loc1_;
         BindingManager.executeBindings(this,"_AstralPanel_CachedImage3",this._AstralPanel_CachedImage3);
         return _loc1_;
      }
      
      private function _AstralPanel_RepeatingBitmap1_i() : RepeatingBitmap
      {
         var _loc1_:RepeatingBitmap = new RepeatingBitmap();
         _loc1_.percentHeight = 100;
         _loc1_.percentWidth = 100;
         this._AstralPanel_RepeatingBitmap1 = _loc1_;
         BindingManager.executeBindings(this,"_AstralPanel_RepeatingBitmap1",this._AstralPanel_RepeatingBitmap1);
         return _loc1_;
      }
      
      private function _AstralPanel_CachedImage4_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._AstralPanel_CachedImage4 = _loc1_;
         BindingManager.executeBindings(this,"_AstralPanel_CachedImage4",this._AstralPanel_CachedImage4);
         return _loc1_;
      }
      
      private function _AstralPanel_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.horizontalCenter = 0;
         _loc1_.y = 220;
         _loc1_.fontSize = 12;
         this._AstralPanel_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_AstralPanel_Label1",this._AstralPanel_Label1);
         return _loc1_;
      }
      
      private function _AstralPanel_CachedImage5_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.x = 15;
         _loc1_.y = 250;
         this._AstralPanel_CachedImage5 = _loc1_;
         BindingManager.executeBindings(this,"_AstralPanel_CachedImage5",this._AstralPanel_CachedImage5);
         return _loc1_;
      }
      
      private function _AstralPanel_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.horizontalCenter = 0;
         _loc1_.y = 312;
         _loc1_.fontSize = 12;
         this._AstralPanel_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_AstralPanel_Label2",this._AstralPanel_Label2);
         return _loc1_;
      }
      
      private function _AstralPanel_List1_i() : List
      {
         var _loc1_:List = new List();
         _loc1_.x = 16;
         _loc1_.top = 346;
         _loc1_.bottom = 65;
         _loc1_.width = 211;
         _loc1_.percentHeight = 100;
         _loc1_.gap = 1;
         _loc1_.addEventListener("childDoubleClick",this.__locationList_childDoubleClick);
         _loc1_.addEventListener("selectedItemChanged",this.__locationList_selectedItemChanged);
         this.locationList = _loc1_;
         BindingManager.executeBindings(this,"locationList",this.locationList);
         return _loc1_;
      }
      
      public function __locationList_childDoubleClick(event:Event) : void
      {
         this.listDoubleClick();
      }
      
      public function __locationList_selectedItemChanged(event:Event) : void
      {
         this.selectedItemChanged();
      }
      
      private function _AstralPanel_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.x = 18;
         _loc1_.bottom = 16;
         _loc1_.fontSize = 12;
         this._AstralPanel_Label3 = _loc1_;
         BindingManager.executeBindings(this,"_AstralPanel_Label3",this._AstralPanel_Label3);
         return _loc1_;
      }
      
      private function _AstralPanel_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.fontSize = 14;
         _loc1_.y = 495;
         _loc1_.right = 12;
         _loc1_.bottom = 11;
         _loc1_.width = 110;
         _loc1_.height = 28;
         _loc1_.addEventListener("click",this.__actButton_click);
         this.actButton = _loc1_;
         BindingManager.executeBindings(this,"actButton",this.actButton);
         return _loc1_;
      }
      
      public function __actButton_click(event:MouseEvent) : void
      {
         this.interact();
      }
      
      public function ___AstralPanel_Canvas1_addedToStage(event:Event) : void
      {
         this.added();
      }
      
      public function ___AstralPanel_Canvas1_removedFromStage(event:Event) : void
      {
         this.removed();
      }
      
      private function _AstralPanel_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():*
         {
            return model.entrance || model.destinaton && !model.moving;
         },function(param1:*):void
         {
            buttonEnabled = param1;
         },"buttonEnabled");
         result[1] = new Binding(this,function():*
         {
            return buttonEnabled;
         },function(param1:*):void
         {
            goEnabled = param1;
         },"goEnabled");
         result[2] = new Binding(this,null,null,"minimap.model","model");
         result[3] = new Binding(this,function():Object
         {
            return Assets.frameMap;
         },null,"_AstralPanel_CachedImage1.source");
         result[4] = new Binding(this,function():Object
         {
            return Assets.frameMounts;
         },null,"_AstralPanel_CachedImage2.source");
         result[5] = new Binding(this,function():Object
         {
            return Assets.scrollTop;
         },null,"_AstralPanel_CachedImage3.source");
         result[6] = new Binding(this,function():BitmapData
         {
            return new Assets.scrollMid().bitmapData;
         },null,"_AstralPanel_RepeatingBitmap1.bitmapData");
         result[7] = new Binding(this,function():Object
         {
            return Assets.scrollBot;
         },null,"_AstralPanel_CachedImage4.source");
         result[8] = new Binding(this,function():String
         {
            var _loc1_:* = "- " + getString("astral.vehicle") + " -";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_AstralPanel_Label1.text");
         result[9] = new Binding(this,function():Object
         {
            return Configuration.getImage("astral/icons/foot_icon_01.jpg");
         },null,"_AstralPanel_CachedImage5.source");
         result[10] = new Binding(this,function():Array
         {
            var _loc1_:* = ICON_GLOW;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_AstralPanel_CachedImage5.filters");
         result[11] = new Binding(this,function():String
         {
            var _loc1_:* = "- " + getString("astral.locations") + " -";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_AstralPanel_Label2.text");
         result[12] = new Binding(this,function():Class
         {
            return AstralLocationRenderer;
         },null,"locationList.itemRenderer");
         result[13] = new Binding(this,function():Object
         {
            return model.circles;
         },null,"locationList.dataProvider");
         result[14] = new Binding(this,function():String
         {
            var _loc1_:* = DateUtils.getTime(model.estimation);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_AstralPanel_Label3.text");
         result[15] = new Binding(this,function():Array
         {
            var _loc1_:* = ESTIMATION_GLOW;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_AstralPanel_Label3.filters");
         result[16] = new Binding(this,function():Boolean
         {
            return buttonEnabled;
         },null,"actButton.enabled");
         result[17] = new Binding(this,function():String
         {
            var _loc1_:* = Boolean(model.destinaton) && !model.moving ? getString("astral.go") : getString("astral.enter");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"actButton.label");
         return result;
      }
      
      private function _AstralPanel_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         this.buttonEnabled = this.model.entrance || Boolean(this.model.destinaton) && !this.model.moving;
         this.goEnabled = this.buttonEnabled;
      }
      
      [Bindable(event="propertyChange")]
      public function get actButton() : Button1
      {
         return this._912501148actButton;
      }
      
      public function set actButton(param1:Button1) : void
      {
         var _loc2_:Object = this._912501148actButton;
         if(_loc2_ !== param1)
         {
            this._912501148actButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"actButton",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get locationList() : List
      {
         return this._58531341locationList;
      }
      
      public function set locationList(param1:List) : void
      {
         var _loc2_:Object = this._58531341locationList;
         if(_loc2_ !== param1)
         {
            this._58531341locationList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"locationList",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get minimap() : AstralMinimap
      {
         return this._1064537509minimap;
      }
      
      public function set minimap(param1:AstralMinimap) : void
      {
         var _loc2_:Object = this._1064537509minimap;
         if(_loc2_ !== param1)
         {
            this._1064537509minimap = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minimap",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get buttonEnabled() : Boolean
      {
         return this._352919633buttonEnabled;
      }
      
      private function set buttonEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._352919633buttonEnabled;
         if(_loc2_ !== param1)
         {
            this._352919633buttonEnabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"buttonEnabled",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get model() : AstralModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:AstralModel) : void
      {
         var _loc2_:Object = this._104069929model;
         if(_loc2_ !== param1)
         {
            this._104069929model = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"model",_loc2_,param1));
            }
         }
      }
   }
}

