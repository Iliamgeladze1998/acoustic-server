package soul.view.rtm
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweenTimeline;
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
   import soul.controller.Interaction;
   import soul.controller.locale.LocaleManager;
   import soul.model.achievement.Achievement;
   import soul.model.achievement.AchievementModel;
   import soul.model.common.InteractionType;
   import soul.model.system.Configuration;
   import soul.view.assets.Assets;
   import soul.view.common.IconRenderer;
   import soul.view.interaction.achievement.AchievementPoints;
   import soul.view.toolTip.TipSplitter;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Canvas;
   import soul.view.ui.Container;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class AchievementAnnounce extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const GLOW:Array = [new GlowFilter(16777215)];
      
      public var _AchievementAnnounce_CachedImage1:CachedImage;
      
      private var _1724546052description:Label;
      
      private var _3175821glow:Container;
      
      private var _3226745icon:IconRenderer;
      
      private var _3343801main:Canvas;
      
      private var _982754077points:AchievementPoints;
      
      private var _110371416title:Label;
      
      private var tween:GTween;
      
      private var _model:AchievementModel;
      
      private var _achievement:Achievement;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function AchievementAnnounce()
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
         bindings = this._AchievementAnnounce_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_rtm_AchievementAnnounceWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return AchievementAnnounce[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 342;
         this.height = 72;
         this.mouseChildren = false;
         this.visible = false;
         this.children = [this._AchievementAnnounce_Canvas2_i(),this._AchievementAnnounce_Container1_i()];
         this.addEventListener("click",this.___AchievementAnnounce_Canvas1_click);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         AchievementAnnounce._watcherSetupUtil = param1;
      }
      
      public function set model(value:AchievementModel) : void
      {
         this._model = value;
         value.addEventListener(Event.CHANGE,this.lastAchevementChanged,false,0,true);
      }
      
      private function lastAchevementChanged(e:Event) : void
      {
         this.achievement = this._model.lastAchievement;
      }
      
      private function onClick() : void
      {
         if(!this._achievement)
         {
            return;
         }
         Interaction.show(InteractionType.ACHIEVEMENT,false,this._achievement.id);
      }
      
      public function set achievement(value:Achievement) : void
      {
         var tween:GTween = null;
         this._achievement = value;
         if(Boolean(tween))
         {
            tween.paused = true;
         }
         if(!value)
         {
            return;
         }
         this.main.alpha = 0;
         visible = true;
         this.title.text = LocaleManager.getAchievementName(value.id);
         this.description.text = LocaleManager.getAchievementDescription(value.id);
         this.icon.source = Configuration.getAchievementImage(value.imagePath);
         this.points.points = value.points;
         tween = new GTweenTimeline(this.glow,4.5,null,{"onComplete":this.fadeComplete},null,[0,new GTween(this.main,0.5,{"alpha":1}),0,new GTween(this.glow,0.3,{"alpha":1}),0.3,new GTween(this.glow,0.3,{"alpha":0}),3.5,new GTween(this.main,1,{"alpha":0})]);
      }
      
      private function fadeComplete(tween:GTween) : void
      {
         tween = null;
         visible = false;
      }
      
      private function _AchievementAnnounce_Canvas2_i() : Canvas
      {
         var _loc1_:Canvas = new Canvas();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.alpha = 0;
         _loc1_.padding = 9;
         _loc1_.children = [this._AchievementAnnounce_CachedImage1_i(),this._AchievementAnnounce_HBox1_c()];
         this.main = _loc1_;
         BindingManager.executeBindings(this,"main",this.main);
         return _loc1_;
      }
      
      private function _AchievementAnnounce_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._AchievementAnnounce_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_AchievementAnnounce_CachedImage1",this._AchievementAnnounce_CachedImage1);
         return _loc1_;
      }
      
      private function _AchievementAnnounce_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.left = 0;
         _loc1_.top = 0;
         _loc1_.gap = 4;
         _loc1_.children = [this._AchievementAnnounce_IconRenderer1_i(),this._AchievementAnnounce_VBox1_c(),this._AchievementAnnounce_AchievementPoints1_i()];
         return _loc1_;
      }
      
      private function _AchievementAnnounce_IconRenderer1_i() : IconRenderer
      {
         var _loc1_:IconRenderer = new IconRenderer();
         _loc1_.x = 10;
         _loc1_.y = 10;
         _loc1_.width = 51;
         _loc1_.height = 51;
         _loc1_.padding = 3;
         this.icon = _loc1_;
         BindingManager.executeBindings(this,"icon",this.icon);
         return _loc1_;
      }
      
      private function _AchievementAnnounce_VBox1_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.children = [this._AchievementAnnounce_Label1_i(),this._AchievementAnnounce_TipSplitter1_c(),this._AchievementAnnounce_Label2_i()];
         return _loc1_;
      }
      
      private function _AchievementAnnounce_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.bold = true;
         _loc1_.percentWidth = 100;
         _loc1_.color = 15248760;
         _loc1_.align = "center";
         this.title = _loc1_;
         BindingManager.executeBindings(this,"title",this.title);
         return _loc1_;
      }
      
      private function _AchievementAnnounce_TipSplitter1_c() : TipSplitter
      {
         var _loc1_:TipSplitter = new TipSplitter();
         _loc1_.height = 1;
         _loc1_.percentWidth = 100;
         return _loc1_;
      }
      
      private function _AchievementAnnounce_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.multiline = true;
         _loc1_.wordWrap = true;
         _loc1_.percentWidth = 100;
         _loc1_.color = 15248760;
         _loc1_.align = "center";
         this.description = _loc1_;
         BindingManager.executeBindings(this,"description",this.description);
         return _loc1_;
      }
      
      private function _AchievementAnnounce_AchievementPoints1_i() : AchievementPoints
      {
         var _loc1_:AchievementPoints = new AchievementPoints();
         this.points = _loc1_;
         BindingManager.executeBindings(this,"points",this.points);
         return _loc1_;
      }
      
      private function _AchievementAnnounce_Container1_i() : Container
      {
         var _loc1_:Container = new Container();
         _loc1_.backgroundColor = 16777215;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.alpha = 0;
         this.glow = _loc1_;
         BindingManager.executeBindings(this,"glow",this.glow);
         return _loc1_;
      }
      
      public function ___AchievementAnnounce_Canvas1_click(event:MouseEvent) : void
      {
         this.onClick();
      }
      
      private function _AchievementAnnounce_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return Assets.lastAchievementBg;
         },null,"_AchievementAnnounce_CachedImage1.source");
         result[1] = new Binding(this,function():Object
         {
            return Assets.simpleBorderRound;
         },null,"icon.borderSkin");
         result[2] = new Binding(this,function():Object
         {
            return Assets.iconGlow;
         },null,"icon.glowSource");
         result[3] = new Binding(this,function():Array
         {
            var _loc1_:* = GLOW;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"glow.filters");
         return result;
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
      public function get glow() : Container
      {
         return this._3175821glow;
      }
      
      public function set glow(param1:Container) : void
      {
         var _loc2_:Object = this._3175821glow;
         if(_loc2_ !== param1)
         {
            this._3175821glow = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"glow",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get icon() : IconRenderer
      {
         return this._3226745icon;
      }
      
      public function set icon(param1:IconRenderer) : void
      {
         var _loc2_:Object = this._3226745icon;
         if(_loc2_ !== param1)
         {
            this._3226745icon = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"icon",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get main() : Canvas
      {
         return this._3343801main;
      }
      
      public function set main(param1:Canvas) : void
      {
         var _loc2_:Object = this._3343801main;
         if(_loc2_ !== param1)
         {
            this._3343801main = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"main",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get points() : AchievementPoints
      {
         return this._982754077points;
      }
      
      public function set points(param1:AchievementPoints) : void
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
      public function get title() : Label
      {
         return this._110371416title;
      }
      
      public function set title(param1:Label) : void
      {
         var _loc2_:Object = this._110371416title;
         if(_loc2_ !== param1)
         {
            this._110371416title = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"title",_loc2_,param1));
            }
         }
      }
   }
}

