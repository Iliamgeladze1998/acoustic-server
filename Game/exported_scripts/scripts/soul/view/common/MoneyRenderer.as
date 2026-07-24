package soul.view.common
{
   import flash.display.DisplayObject;
   import soul.view.ui.Box;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Label;
   import soul.view.ui.VerticalAlign;
   
   public class MoneyRenderer extends Box
   {
      
      private var goldLabel:Label = new Label(Label.MONEY_LABEL);
      
      private var silverLabel:Label = new Label(Label.MONEY_LABEL);
      
      private var copperLabel:Label = new Label(Label.MONEY_LABEL);
      
      private var rubyLabel:Label = new Label(Label.MONEY_LABEL);
      
      private var goldIcon:CachedImage = new CoinRenderer();
      
      private var silverIcon:CachedImage = new CoinRenderer();
      
      private var copperIcon:CachedImage = new CoinRenderer();
      
      private var rubyIcon:CachedImage = new CoinRenderer();
      
      private var pvpIcon:CachedImage = new CoinRenderer();
      
      private var _type:String;
      
      private var _value:int;
      
      public function MoneyRenderer()
      {
         super();
         verticalAlign = VerticalAlign.MIDDLE;
         gap = 3;
         this.goldIcon.source = Currency.goldImg;
         this.silverIcon.source = Currency.silverImg;
         this.copperIcon.source = Currency.copperImg;
         this.rubyIcon.source = Currency.rubiesImg;
         this.pvpIcon.source = Currency.pvpImg;
         this.type = CurrencyType.COPPER;
         this.value = 0;
      }
      
      public function set type(value:String) : void
      {
         if(this._type == value)
         {
            return;
         }
         this._type = value;
         this.draw();
      }
      
      public function set value(v:uint) : void
      {
         if(this._value == v)
         {
            return;
         }
         this._value = v;
         this.draw();
      }
      
      public function set color(value:uint) : void
      {
         this.goldLabel.color = this.silverLabel.color = this.copperLabel.color = this.rubyLabel.color = value;
      }
      
      public function set fontSize(value:uint) : void
      {
         this.goldLabel.fontSize = this.silverLabel.fontSize = this.copperLabel.fontSize = this.rubyLabel.fontSize = value;
      }
      
      private function draw() : void
      {
         var gold:uint = 0;
         var silver:uint = 0;
         removeAllChildren();
         var value:int = this._value;
         if(this._type == CurrencyType.COPPER)
         {
            gold = value / 10000;
            value -= gold * 10000;
            silver = value / 100;
            value -= silver * 100;
            if(gold > 0)
            {
               this.goldLabel.text = String(gold);
               addChild(this.goldLabel);
               addChild(this.goldIcon);
            }
            if(gold > 0 || silver > 0)
            {
               this.silverLabel.text = String(silver);
               addChild(this.silverLabel);
               addChild(this.silverIcon);
            }
            this.copperLabel.text = String(value);
            addChild(this.copperLabel);
            addChild(this.copperIcon);
         }
         else
         {
            this.rubyLabel.text = String(value);
            addChild(this.rubyLabel);
            addChild(this._type == CurrencyType.RUBIES ? this.rubyIcon : this.pvpIcon);
         }
         updateNow();
      }
   }
}

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.EventDispatcher;
import soul.view.ui.CachedImage;
import soul.view.ui.Component;

class CoinRenderer extends CachedImage
{
   
   public function CoinRenderer()
   {
      super();
   }
   
   override public function destroy() : void
   {
   }
}
