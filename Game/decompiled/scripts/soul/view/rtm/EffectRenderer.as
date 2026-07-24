package soul.view.rtm
{
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import soul.model.buff.Effect;
   import soul.model.system.Configuration;
   import soul.utils.DateUtils;
   import soul.view.assets.Assets;
   import soul.view.toolTip.EffectTip;
   import soul.view.toolTip.ToolTipManager;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Canvas;
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   
   public class EffectRenderer extends VBox
   {
      
      private static const SIZE:uint = 29;
      
      private static const PADDING:uint = 3;
      
      private static const SHIELD_SIZE:uint = SIZE - PADDING * 2;
      
      private static const FILTERS:Array = [new GlowFilter(0,1,6,6,3)];
      
      private var icon:CachedImage = new CachedImage();
      
      private var border:BorderedContainer = new BorderedContainer();
      
      private var canvas:Canvas = new Canvas();
      
      private var shield:Component = new Component();
      
      private var label:Label = new Label();
      
      private var _textPosition:String;
      
      private var _effect:Effect;
      
      public function EffectRenderer()
      {
         super();
         width = SIZE;
         gap = -2;
         horizontalAlign = "center";
         this.border.padding = PADDING;
         this.border.borderSkin = Assets.simpleBorderRound;
         this.border.width = SIZE;
         this.border.height = SIZE;
         this.border.addChild(this.canvas);
         this.canvas.percentWidth = 100;
         this.canvas.percentHeight = 100;
         this.canvas.addChild(this.icon);
         this.icon.percentWidth = 100;
         this.icon.percentHeight = 100;
         this.label.color = 16777215;
         this.label.fontSize = 10;
         this.label.filters = FILTERS;
         this.shield.backgroundColor = 0;
         this.shield.backgroundAlpha = 0.75;
         this.shield.width = this.shield.height = SHIELD_SIZE;
         this.textPosition = "bottom";
         this.border.mouseChildren = false;
         addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
      }
      
      private function removed(e:Event) : void
      {
         if(e.target != this)
         {
            return;
         }
         this._effect.removeEventListener("ttlChanged",this.tllChanged);
      }
      
      [Inspectable(category="General",enumeration="top,bottom",defaultValue="bottom")]
      public function set textPosition(value:String) : void
      {
         if(this._textPosition == value)
         {
            return;
         }
         this._textPosition = value;
         removeAllChildren();
         if(value == "top")
         {
            addChild(this.label);
            addChild(this.border);
         }
         else
         {
            addChild(this.border);
            addChild(this.label);
         }
      }
      
      public function set effect(value:Effect) : void
      {
         this.icon.source = Configuration.getAbilityImageUrl(value.imagePath);
         ToolTipManager.register(this,value,EffectTip);
         this._effect = value;
         if(value.ttl > 0)
         {
            this._effect.addEventListener("ttlChanged",this.tllChanged);
            this.tllChanged(null);
         }
         if(value.maxHp > 0)
         {
            this._effect.addEventListener("hpChanged",this.hpChanged);
            this.hpChanged(null);
            this.canvas.addChild(this.shield);
         }
      }
      
      private function tllChanged(e:Event) : void
      {
         this.label.text = Boolean(this._effect) ? DateUtils.getBuffTimeLeft(this._effect.ttl) : "";
      }
      
      private function hpChanged(e:Event) : void
      {
         var percents:Number = this._effect.hp / this._effect.maxHp;
         this.shield.height = SHIELD_SIZE * (1 - percents);
      }
   }
}

