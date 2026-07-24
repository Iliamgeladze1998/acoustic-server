package soul.view.interaction.mail
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
   import soul.model.interaction.mail.Mail;
   import soul.model.system.Configuration;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientBox;
   import soul.view.common.Icons;
   import soul.view.ui.CachedImage;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class MailRenderer extends HBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const SECOND:int = 1000;
      
      private static const MINUTE:int = SECOND * 60;
      
      private static const HOUR:int = MINUTE * 60;
      
      private static const DAY:int = HOUR * 24;
      
      private static const MONTH:Number = DAY * 30;
      
      private static const YEAR:Number = DAY * 365;
      
      private static const selectedFilters:Array = [new GlowFilter(65280,1,8,8,1,1,true),new GlowFilter(65280,0.2,5,5)];
      
      private static const SELECTED:Array = [[3713668105,127],5903369];
      
      private static const ACTIVE:Array = [[3709602307,127],1837571];
      
      public var _MailRenderer_CachedImage1:CachedImage;
      
      public var _MailRenderer_Label1:Label;
      
      public var _MailRenderer_Label2:Label;
      
      public var _MailRenderer_Label3:Label;
      
      public var _MailRenderer_Label4:Label;
      
      public var _MailRenderer_Label5:Label;
      
      private var _3141bg:GradientBox;
      
      private var _3343799mail:Mail;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function MailRenderer()
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
         bindings = this._MailRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_mail_MailRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return MailRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.verticalAlign = "middle";
         this.width = 290;
         this.height = 36;
         this.children = [this._MailRenderer_CachedImage1_i(),this._MailRenderer_GradientBox1_i()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         MailRenderer._watcherSetupUtil = param1;
      }
      
      private function getExpiration(tStamp:Number) : String
      {
         var realDate:Number = Configuration.serverTimeToLocal(tStamp);
         var timeLeft:Number = realDate - new Date().time;
         if(timeLeft < 0)
         {
            return this.getString("expired");
         }
         var days:int = timeLeft / DAY;
         if(days > 0)
         {
            return days + this.getString("days");
         }
         var hours:int = timeLeft / HOUR;
         if(hours > 0)
         {
            return hours + this.getString("hours");
         }
         var mins:int = timeLeft / MINUTE;
         if(mins > 0)
         {
            return mins + this.getString("minutes");
         }
         return String(timeLeft);
      }
      
      public function set selected(value:Boolean) : void
      {
         this.bg.gradient = value ? SELECTED : ACTIVE;
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _MailRenderer_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._MailRenderer_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_MailRenderer_CachedImage1",this._MailRenderer_CachedImage1);
         return _loc1_;
      }
      
      private function _MailRenderer_GradientBox1_i() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 34;
         _loc1_.children = [this._MailRenderer_VBox1_c()];
         this.bg = _loc1_;
         BindingManager.executeBindings(this,"bg",this.bg);
         return _loc1_;
      }
      
      private function _MailRenderer_VBox1_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.gap = 2;
         _loc1_.children = [this._MailRenderer_HBox2_c(),this._MailRenderer_HBox3_c()];
         return _loc1_;
      }
      
      private function _MailRenderer_HBox2_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.gap = 5;
         _loc1_.children = [this._MailRenderer_Label1_i(),this._MailRenderer_Label2_i(),this._MailRenderer_Label3_i()];
         return _loc1_;
      }
      
      private function _MailRenderer_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         this._MailRenderer_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_MailRenderer_Label1",this._MailRenderer_Label1);
         return _loc1_;
      }
      
      private function _MailRenderer_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         this._MailRenderer_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_MailRenderer_Label2",this._MailRenderer_Label2);
         return _loc1_;
      }
      
      private function _MailRenderer_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         this._MailRenderer_Label3 = _loc1_;
         BindingManager.executeBindings(this,"_MailRenderer_Label3",this._MailRenderer_Label3);
         return _loc1_;
      }
      
      private function _MailRenderer_HBox3_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.gap = 5;
         _loc1_.children = [this._MailRenderer_Label4_i(),this._MailRenderer_Label5_i()];
         return _loc1_;
      }
      
      private function _MailRenderer_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         this._MailRenderer_Label4 = _loc1_;
         BindingManager.executeBindings(this,"_MailRenderer_Label4",this._MailRenderer_Label4);
         return _loc1_;
      }
      
      private function _MailRenderer_Label5_i() : Label
      {
         var _loc1_:Label = new Label();
         this._MailRenderer_Label5 = _loc1_;
         BindingManager.executeBindings(this,"_MailRenderer_Label5",this._MailRenderer_Label5);
         return _loc1_;
      }
      
      private function _MailRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return mail.read ? Icons.mail0 : Icons.mail1;
         },null,"_MailRenderer_CachedImage1.source");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = getString("mail.from");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_MailRenderer_Label1.text");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = mail.localizedFrom;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_MailRenderer_Label2.text");
         result[3] = new Binding(this,function():uint
         {
            return Colors.GOLD_DARK;
         },null,"_MailRenderer_Label2.color");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = getExpiration(mail.expires);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_MailRenderer_Label3.text");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = getString("mail.subject");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_MailRenderer_Label4.text");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = mail.localizedSubject;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_MailRenderer_Label5.text");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get bg() : GradientBox
      {
         return this._3141bg;
      }
      
      public function set bg(param1:GradientBox) : void
      {
         var _loc2_:Object = this._3141bg;
         if(_loc2_ !== param1)
         {
            this._3141bg = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bg",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mail() : Mail
      {
         return this._3343799mail;
      }
      
      public function set mail(param1:Mail) : void
      {
         var _loc2_:Object = this._3343799mail;
         if(_loc2_ !== param1)
         {
            this._3343799mail = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mail",_loc2_,param1));
            }
         }
      }
   }
}

