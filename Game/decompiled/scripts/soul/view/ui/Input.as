package soul.view.ui
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextFormat;
   import flash.text.TextLineMetrics;
   
   [Event(name="change",type="flash.events.Event")]
   public class Input extends Label
   {
      
      protected var background:Sprite;
      
      public function Input()
      {
         super();
         width = 100;
         height = 20;
         textField.autoSize = "none";
         textField.selectable = true;
         editable = true;
         textField.mouseEnabled = true;
         textField.addEventListener(Event.CHANGE,this.textChanged);
         this.borderSkin = LabelBorder;
         color = 0;
         updateLater();
      }
      
      private function textChanged(e:Event) : void
      {
         _text = textField.text;
         if(hasEventListener("textChanged"))
         {
            dispatchEvent(new Event("textChanged"));
         }
         if(hasEventListener(Event.CHANGE))
         {
            dispatchEvent(new Event(Event.CHANGE));
         }
         this.redraw();
      }
      
      override public function set align(value:String) : void
      {
         var tf:TextFormat = textField.defaultTextFormat;
         tf.align = value;
         textField.defaultTextFormat = tf;
         textField.setTextFormat(tf);
      }
      
      public function set displayAsPassword(value:Boolean) : void
      {
         textField.displayAsPassword = value;
      }
      
      public function set borderSkin(value:Object) : void
      {
         if(value is Class)
         {
            if(Boolean(this.background))
            {
               removeChild(this.background);
            }
            this.background = new value();
            addChildAt(this.background,0);
         }
         this.redraw();
      }
      
      public function set restrict(value:String) : void
      {
         textField.restrict = value;
      }
      
      public function set maxChars(value:uint) : void
      {
         textField.maxChars = value;
      }
      
      public function setFocus() : void
      {
         if(!stage)
         {
            return;
         }
         stage.focus = textField;
      }
      
      public function getFocus() : Boolean
      {
         return Boolean(stage) ? stage.focus == textField : false;
      }
      
      override public function set tabIndex(index:int) : void
      {
         textField.tabIndex = index;
      }
      
      override public function get tabIndex() : int
      {
         return textField.tabIndex;
      }
      
      override protected function redraw() : void
      {
         var p2:int = padding * 2;
         var tm:TextLineMetrics = textField.getLineMetrics(0);
         if(_verticalAlign == "middle")
         {
            textField.y = int((_height - tm.height) / 2) - 3;
         }
         else if(_verticalAlign == "bottom")
         {
            textField.y = _height - tm.height;
         }
         else
         {
            textField.y = 0;
         }
         textField.x = padding;
         textField.height = _height - textField.y;
         textField.width = _width - p2;
         if(Boolean(this.background))
         {
            this.background.width = _width;
            this.background.height = _height;
         }
      }
   }
}

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.EventDispatcher;

class LabelBorder extends Sprite
{
   
   private var _width:int;
   
   private var _height:int;
   
   public function LabelBorder()
   {
      super();
   }
   
   override public function set width(value:Number) : void
   {
      this._width = value;
      this.redraw();
   }
   
   override public function set height(value:Number) : void
   {
      this._height = value;
      this.redraw();
   }
   
   private function redraw() : void
   {
      graphics.clear();
      graphics.lineStyle(0,0);
      graphics.beginFill(15658734);
      graphics.drawRect(0,0,this._width,this._height);
      graphics.endFill();
   }
}
