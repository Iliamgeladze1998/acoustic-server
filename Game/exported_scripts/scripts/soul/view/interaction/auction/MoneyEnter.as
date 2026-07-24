package soul.view.interaction.auction
{
   import flash.events.Event;
   import soul.view.common.Currency;
   import soul.view.common.CurrencyType;
   import soul.view.ui.CachedImage;
   import soul.view.ui.HBox;
   
   public class MoneyEnter extends HBox
   {
      
      private var goldLabel:MoneyInput = new MoneyInput();
      
      private var silverLabel:MoneyInput = new MoneyInput();
      
      private var copperLabel:MoneyInput = new MoneyInput();
      
      private var rubyLabel:MoneyInput = new MoneyInput();
      
      private var goldImg:CachedImage = new CachedImage();
      
      private var silverImg:CachedImage = new CachedImage();
      
      private var copperImg:CachedImage = new CachedImage();
      
      private var rubyImg:CachedImage = new CachedImage();
      
      private var _type:String;
      
      public function MoneyEnter()
      {
         super();
         verticalAlign = "middle";
         gap = 2;
         this.goldLabel.width = 57;
         this.silverLabel.width = 34;
         this.silverLabel.maxChars = 2;
         this.copperLabel.width = 34;
         this.copperLabel.maxChars = 2;
         this.rubyLabel.width = 57;
         this.goldImg.source = Currency.goldImg;
         this.silverImg.source = Currency.silverImg;
         this.copperImg.source = Currency.copperImg;
         this.rubyImg.source = Currency.rubiesImg;
         this.goldLabel.addEventListener(Event.CHANGE,this.textChange);
         this.silverLabel.addEventListener(Event.CHANGE,this.textChange);
         this.copperLabel.addEventListener(Event.CHANGE,this.textChange);
         this.rubyLabel.addEventListener(Event.CHANGE,this.textChange);
         this.type = CurrencyType.COPPER;
      }
      
      private function textChange(e:Event) : void
      {
         dispatchEvent(new Event("valueChanged"));
      }
      
      public function set type(value:String) : void
      {
         if(value == this._type)
         {
            return;
         }
         this._type = value;
         removeAllChildren();
         if(value == CurrencyType.COPPER)
         {
            addChild(this.goldLabel);
            addChild(this.goldImg);
            addChild(this.silverLabel);
            addChild(this.silverImg);
            addChild(this.copperLabel);
            addChild(this.copperImg);
         }
         else
         {
            addChild(this.rubyLabel);
            addChild(this.rubyImg);
         }
         dispatchEvent(new Event("valueChanged"));
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      [Bindable("valueChanged")]
      public function set value(value:uint) : void
      {
         var gold:uint = 0;
         var sgold:String = null;
         var silver:uint = 0;
         var ssilver:String = null;
         var scopper:String = null;
         if(this._type == CurrencyType.COPPER)
         {
            gold = value / 10000;
            sgold = gold < 1 ? "0" : String(gold);
            value -= gold * 10000;
            silver = value / 100;
            ssilver = (silver < 10 ? "0" : "") + silver;
            value -= silver * 100;
            scopper = (value < 10 ? "0" : "") + value;
            this.goldLabel.text = sgold;
            this.silverLabel.text = ssilver;
            this.copperLabel.text = value > 0 ? String(value) : "00";
         }
         else
         {
            this.rubyLabel.text = String(value);
         }
         this.textChange(null);
      }
      
      public function get value() : uint
      {
         if(this._type == CurrencyType.COPPER)
         {
            return uint(this.goldLabel.text) * 10000 + uint(this.silverLabel.text) * 100 + uint(this.copperLabel.text);
         }
         return uint(this.rubyLabel.text);
      }
      
      override public function set enabled(value:Boolean) : void
      {
         if(value == _enabled)
         {
            return;
         }
         super.enabled = mouseChildren = value;
      }
   }
}

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.EventDispatcher;
import soul.view.assets.Assets;
import soul.view.ui.Component;
import soul.view.ui.Input;
import soul.view.ui.Label;

class MoneyInput extends Input
{
   
   public function MoneyInput()
   {
      super();
      height = 21;
      maxChars = 6;
      restrict = "0-9";
      align = "center";
      color = 0;
      borderSkin = Assets.chatInput;
      fontSize = 12;
   }
}
