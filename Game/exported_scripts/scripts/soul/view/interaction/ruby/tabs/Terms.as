package soul.view.interaction.ruby.tabs
{
   import flash.events.MouseEvent;
   import mx.events.PropertyChangeEvent;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.interaction.ruby.Subscription;
   import soul.model.interaction.ruby.SubscriptionType;
   import soul.view.ui.Component;
   import soul.view.ui.HBox;
   
   public class Terms extends HBox
   {
      
      private var _1436069623selectedIndex:int = -1;
      
      private var _1447696278selectedValue:int = 0;
      
      private var selectedButton:TermButton;
      
      private var b0:TermButton;
      
      private var b1:TermButton;
      
      private var b2:TermButton;
      
      private var b3:TermButton;
      
      private var b4:TermButton;
      
      private var renew:TermButton;
      
      private var buttons:Vector.<TermButton>;
      
      private var _subscription:Subscription;
      
      public function Terms()
      {
         var btn:TermButton = null;
         this.b0 = new TermButton();
         this.b1 = new TermButton();
         this.b2 = new TermButton();
         this.b3 = new TermButton();
         this.b4 = new TermButton();
         this.renew = new TermButton();
         this.buttons = new Vector.<TermButton>();
         super();
         gap = 5;
         for(var i:int = 0; i < 5; i++)
         {
            btn = this["b" + i];
            btn.source = SubscriptionType.getTermIcon(i);
            btn.enabled = false;
            btn.addEventListener(MouseEvent.CLICK,this.childClick);
            btn.toolTip = LocaleManager.getString(BundleName.INTERFACE,"subscription.term" + i);
            addChild(btn);
            this.buttons.push(btn);
         }
         this.renew.addEventListener(MouseEvent.CLICK,this.renewClick);
         var spacer:Component = new Component();
         spacer.percentWidth = 100;
         addChild(spacer);
         this.renew.source = SubscriptionType.renew;
         this.renew.enabled = false;
         this.renew.toolTip = LocaleManager.getString(BundleName.INTERFACE,"subscription.autoRenew");
         addChild(this.renew);
         this.selectChild(this["b" + 0]);
      }
      
      private function childClick(e:MouseEvent) : void
      {
         this.selectChild(e.currentTarget as TermButton);
      }
      
      private function selectChild(child:TermButton) : void
      {
         if(Boolean(this.selectedButton))
         {
            this.selectedButton.selected = false;
         }
         this.selectedButton = child;
         this.selectedButton.selected = true;
         this.selectedValue = this.selectedButton.value;
         this.selectedIndex = this.buttons.indexOf(this.selectedButton);
      }
      
      private function renewClick(e:MouseEvent) : void
      {
         this.renew.selected = !this.renew.selected;
      }
      
      public function set subscription(value:Subscription) : void
      {
         var btn:TermButton = null;
         if(this._subscription == value)
         {
            return;
         }
         this._subscription = value;
         for(var i:int = 0; i < 5; i++)
         {
            btn = this["b" + i];
            btn.value = value.prices[i];
            btn.enabled = value.prices[i] != null;
         }
         this.renew.enabled = value.autoRenew;
         if(this.selectedIndex != -1)
         {
            btn = this["b" + this.selectedIndex];
            if(Boolean(btn) && btn.enabled)
            {
               this.selectedValue = btn.value;
            }
         }
      }
      
      public function get subscription() : Subscription
      {
         return this._subscription;
      }
      
      public function get autoRenew() : Boolean
      {
         return this.renew.selected;
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedIndex() : int
      {
         return this._1436069623selectedIndex;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         var _loc2_:Object = this._1436069623selectedIndex;
         if(_loc2_ !== param1)
         {
            this._1436069623selectedIndex = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedIndex",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedValue() : int
      {
         return this._1447696278selectedValue;
      }
      
      public function set selectedValue(param1:int) : void
      {
         var _loc2_:Object = this._1447696278selectedValue;
         if(_loc2_ !== param1)
         {
            this._1447696278selectedValue = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedValue",_loc2_,param1));
            }
         }
      }
   }
}

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.EventDispatcher;
import flash.filters.GlowFilter;
import soul.view.assets.Colors;
import soul.view.ui.CachedImage;
import soul.view.ui.Component;

class TermButton extends CachedImage
{
   
   private static const SELECTED:Array = [new GlowFilter(16776960)];
   
   public var value:int;
   
   private var _selected:Boolean;
   
   public function TermButton()
   {
      super();
   }
   
   public function set selected(value:Boolean) : void
   {
      this._selected = value;
      this.draw();
   }
   
   public function get selected() : Boolean
   {
      return this._selected;
   }
   
   override public function set enabled(value:Boolean) : void
   {
      if(_enabled == value)
      {
         return;
      }
      mouseEnabled = _enabled = value;
      this.draw();
   }
   
   private function draw() : void
   {
      filters = !_enabled ? Colors.DISABLED_ALPHA_FILTER : (this._selected ? SELECTED : []);
   }
}
