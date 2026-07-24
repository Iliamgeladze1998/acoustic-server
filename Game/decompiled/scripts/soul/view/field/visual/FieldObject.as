package soul.view.field.visual
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import mx.events.PropertyChangeEvent;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.field.LibraryManager;
   import soul.model.field.spriteconfig.ObjectLayout;
   import soul.model.field.spriteconfig.SpriteConfig;
   import soul.model.field.spriteconfig.SpritePhase;
   import soul.model.field.spriteconfig.SpriteType;
   import soul.sorting.ISortableSprite;
   import soul.sorting.Pair;
   import soul.utils.BitmapUtils;
   import soul.view.assets.Colors;
   import soul.view.toolTip.ToolTipManager;
   import soul.view.ui.CachedMovieClip;
   import soul.view.ui.Label;
   import soul.view.ui.SimpleLabel;
   
   public class FieldObject extends Sprite implements IBitmapSprite, ISortableSprite
   {
      
      private static const namePlateFilters:Array = [new GlowFilter(0,1,2,2,2,1),new DropShadowFilter(4,45,0,0.5)];
      
      public var namePlate:Sprite = new Sprite();
      
      public var layout:ObjectLayout;
      
      public var bounds:Rectangle;
      
      protected var spriteHolder:Sprite = new Sprite();
      
      private var hitZone:Sprite;
      
      private var tooltipText:String;
      
      private var nameLabel:TextField = new SimpleLabel(Label.TEXT_TOOLTIP);
      
      private var innerBounds:Rectangle;
      
      private var _over:Boolean;
      
      public var phaseIndex:int;
      
      private var _phase:String;
      
      private var _tooltipId:String;
      
      private var _id:String = "";
      
      private var _interactive:Boolean;
      
      private var _objective:Boolean;
      
      private var _mirrored:Boolean;
      
      private var p1:Point = new Point();
      
      private var p2:Point = new Point();
      
      private var pair:Pair = new Pair(this.p1,this.p2);
      
      public function FieldObject(layout:ObjectLayout = null, phase:String = null)
      {
         super();
         this.layout = layout;
         mouseEnabled = false;
         mouseChildren = false;
         addChild(this.spriteHolder);
         this.nameLabel.autoSize = TextFieldAutoSize.CENTER;
         this.nameLabel.textColor = 16777215;
         this.namePlate.filters = namePlateFilters;
         this.namePlate.addChild(this.nameLabel);
         this.setPhase(phase);
      }
      
      public function dispose() : void
      {
         this.disposeChildren(this.spriteHolder);
      }
      
      private function disposeChildren(container:DisplayObjectContainer) : void
      {
         var child:DisplayObject = null;
         while(container.numChildren > 0)
         {
            child = container.getChildAt(0);
            if(child is Bitmap)
            {
               Bitmap(child).bitmapData.dispose();
            }
            if(child is DisplayObjectContainer && !child is CachedMovieClip)
            {
               this.disposeChildren(child as DisplayObjectContainer);
            }
            container.removeChildAt(0);
         }
      }
      
      private function mouseOver(e:MouseEvent) : void
      {
         this._over = true;
         this.applyFilters();
      }
      
      private function mouseOut(e:Event) : void
      {
         this._over = false;
         this.applyFilters();
      }
      
      private function namePlateClicked(e:MouseEvent) : void
      {
         dispatchEvent(e);
      }
      
      private function applyFilters() : void
      {
         var f:Array = [];
         if(this._objective)
         {
            f.push(Colors.QUEST_OBJECTIVE_FILTER);
         }
         if(this._over)
         {
            f.push(Colors.OBJECT_HOVER_FILTER);
         }
         filters = f;
      }
      
      public function setPhase(value:String) : SpritePhase
      {
         var phase:SpritePhase = null;
         var sprite:DisplayObject = null;
         var phase_:SpritePhase = null;
         var cfg:SpriteConfig = null;
         if(this.spriteHolder.numChildren > 0 && value == this._phase || !this.layout)
         {
            return null;
         }
         this._phase = value;
         this.dispose();
         for each(phase_ in this.layout.phases)
         {
            if(phase_.id == value)
            {
               phase = phase_;
               this.phaseIndex = this.layout.phases.indexOf(phase_);
               break;
            }
         }
         if(!phase)
         {
            this.phaseIndex = 0;
            phase = this.layout.phases[this.phaseIndex];
         }
         if(!phase)
         {
            return null;
         }
         for each(cfg in phase.sprites)
         {
            sprite = this.createSprite(cfg);
            if(sprite)
            {
               sprite.x = cfg.x;
               sprite.y = cfg.y;
               this.spriteHolder.addChild(sprite);
            }
         }
         if(this._interactive)
         {
            this.generateHitZone();
         }
         if(Boolean(this.layout) && this.layout.type == SpriteType.RAISED)
         {
            this.generateBounds();
         }
         return phase;
      }
      
      protected function createSprite(cfg:SpriteConfig) : DisplayObject
      {
         return LibraryManager.getObject(cfg.id,cfg.library);
      }
      
      private function generateHitZone() : void
      {
         this.hitZone = BitmapUtils.makeHitArea(this.spriteHolder);
         if(!this.hitZone)
         {
            return;
         }
         addChild(this.hitZone);
         this.hitZone.visible = false;
         hitArea = this.hitZone;
      }
      
      private function generateBounds() : void
      {
         this.innerBounds = this.spriteHolder.getBounds(this);
         this.createOuterBounds();
      }
      
      private function createOuterBounds() : void
      {
         if(!this.innerBounds)
         {
            return;
         }
         this.bounds = this.innerBounds.clone();
         this.bounds.x += x;
         this.bounds.y += y;
      }
      
      public function set tooltipId(value:String) : void
      {
         this._tooltipId = value;
         this.tooltipText = LocaleManager.getString(BundleName.HINT,value);
         this.nameLabel.text = this.tooltipText;
         this.nameLabel.y = -this.nameLabel.height - 10;
         this.nameLabel.x = -int(this.nameLabel.width / 2);
         ToolTipManager.register(this,this.tooltipText);
      }
      
      public function get tooltipId() : String
      {
         return this._tooltipId;
      }
      
      private function set _3355id(value:String) : void
      {
         this._id = value;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function set interactive(value:Boolean) : void
      {
         if(this._interactive == value)
         {
            return;
         }
         this._interactive = value;
         mouseEnabled = value;
         if(Boolean(this.hitZone) && contains(this.hitZone))
         {
            removeChild(this.hitZone);
         }
         if(value)
         {
            this.generateHitZone();
            addEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
            addEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
            this.namePlate.addEventListener(MouseEvent.CLICK,this.namePlateClicked);
            this.namePlate.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
            this.namePlate.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
         }
         else
         {
            hitArea = null;
            removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
            removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
            this.namePlate.removeEventListener(MouseEvent.CLICK,this.namePlateClicked);
            this.namePlate.removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
            this.namePlate.removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
         }
      }
      
      public function get interactive() : Boolean
      {
         return this._interactive;
      }
      
      public function set objective(value:Boolean) : void
      {
         if(this._objective == value)
         {
            return;
         }
         this._objective = value;
         this.applyFilters();
      }
      
      public function get objective() : Boolean
      {
         return this._objective;
      }
      
      public function set mirrored(value:Boolean) : void
      {
         this._mirrored = value;
         scaleX = value ? -1 : 1;
      }
      
      public function get mirrored() : Boolean
      {
         return this._mirrored;
      }
      
      override public function set x(value:Number) : void
      {
         super.x = value;
         this.namePlate.x = value;
         this.createOuterBounds();
      }
      
      override public function set y(value:Number) : void
      {
         super.y = value;
         this.namePlate.y = value;
         this.createOuterBounds();
      }
      
      public function getSpriteLine() : Pair
      {
         if(this.layout.type != SpriteType.RAISED)
         {
            return null;
         }
         if(this._mirrored)
         {
            this.p1.x = x - this.layout.p1.x;
            this.p1.y = y + this.layout.p1.y;
            this.p2.x = x - this.layout.p2.x;
            this.p2.y = y + this.layout.p2.y;
         }
         else
         {
            this.p1.x = x + this.layout.p1.x;
            this.p1.y = y + this.layout.p1.y;
            this.p2.x = x + this.layout.p2.x;
            this.p2.y = y + this.layout.p2.y;
         }
         return this.pair;
      }
      
      [Bindable(event="propertyChange")]
      public function set id(param1:String) : void
      {
         var _loc2_:Object = this.id;
         if(_loc2_ !== param1)
         {
            this._3355id = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"id",_loc2_,param1));
            }
         }
      }
   }
}

