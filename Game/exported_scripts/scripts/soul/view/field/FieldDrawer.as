package soul.view.field
{
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import soul.model.field.LibraryManager;
   import soul.model.field.mapconfig.ContourPoint;
   import soul.model.field.mapconfig.MapFillZone;
   import soul.model.field.mapconfig.MapLayout;
   import soul.model.field.mapconfig.MapLight;
   import soul.model.field.mapconfig.MapLights;
   import soul.model.field.spriteconfig.SpritePoint;
   import soul.sorting.EdgeOrder;
   import soul.view.field.visual.FieldObject;
   import soul.view.field.visual.IBitmapSprite;
   import soul.view.filters.ColorShader;
   import soul.view.ui.Component;
   
   public class FieldDrawer extends Component
   {
      
      protected var deepBg:Shape = new Shape();
      
      protected var mc:Sprite = new Sprite();
      
      private var maskRect:Rectangle = new Rectangle();
      
      protected var mcBg:Sprite = new Sprite();
      
      protected var mcGround:Sprite = new Sprite();
      
      protected var mcRaised:Sprite = new Sprite();
      
      protected var mcLights:Sprite = new Sprite();
      
      protected var mcAmbient:Sprite = new Sprite();
      
      protected var maskWidth:Number;
      
      protected var maskHeight:Number;
      
      protected var _layout:MapLayout;
      
      public var objectLayouts:Object;
      
      protected var groundObjects:Vector.<FieldObject>;
      
      protected var raisedObjects:Vector.<FieldObject>;
      
      protected var edgeOrder:EdgeOrder;
      
      protected var bgBitmaps:Vector.<BitmapData> = new Vector.<BitmapData>();
      
      protected var deepBackground:BitmapData;
      
      private var _showLighting:Boolean = true;
      
      public function FieldDrawer()
      {
         super();
         addChild(this.deepBg);
         addChild(this.mc);
         this.mc.addChild(this.mcBg);
         this.mc.addChild(this.mcGround);
         this.mc.addChild(this.mcRaised);
         this.mc.addChild(this.mcLights);
         this.mc.addChild(this.mcAmbient);
         this.mcGround.mouseEnabled = false;
         this.mcRaised.mouseEnabled = false;
         this.mcLights.mouseEnabled = false;
         this.mcLights.mouseChildren = false;
         this.mcAmbient.mouseEnabled = false;
         this.mcAmbient.cacheAsBitmap = true;
         this.mcAmbient.blendMode = BlendMode.MULTIPLY;
         addEventListener(Event.RESIZE,this.onResize);
         this.onResize(null);
      }
      
      private static function goComparator(o1:FieldObject, o2:FieldObject) : int
      {
         if(o1.y > o2.y)
         {
            return -1;
         }
         if(o1.y < o2.y)
         {
            return 1;
         }
         if(o1.x > o2.x)
         {
            return -1;
         }
         if(o1.x < o2.x)
         {
            return 1;
         }
         return 0;
      }
      
      protected function clearObjects() : void
      {
         var child:DisplayObject = null;
         this.groundObjects = new Vector.<FieldObject>();
         this.raisedObjects = new Vector.<FieldObject>();
         while(this.mcGround.numChildren > 0)
         {
            child = this.mcGround.getChildAt(0);
            if(child is IBitmapSprite)
            {
               IBitmapSprite(child).dispose();
            }
            this.mcGround.removeChildAt(0);
         }
         while(this.mcRaised.numChildren > 0)
         {
            child = this.mcRaised.getChildAt(0);
            if(child is IBitmapSprite)
            {
               IBitmapSprite(child).dispose();
            }
            this.mcRaised.removeChildAt(0);
         }
         if(this.edgeOrder != null)
         {
            this.edgeOrder.stop();
         }
         this.edgeOrder = null;
      }
      
      protected function clearMap() : void
      {
         this.clearBg();
         this.clearLights();
         if(Boolean(this.deepBackground))
         {
            this.deepBackground.dispose();
            this.deepBackground = null;
         }
         this.onResize(null);
         this.clearObjects();
         this.mc.x = 0;
         this.mc.y = 0;
      }
      
      protected function clearBg() : void
      {
         var bmp:BitmapData = null;
         this.mcBg.graphics.clear();
         while(this.mcBg.numChildren > 0)
         {
            this.mcBg.removeChildAt(0);
         }
         for each(bmp in this.bgBitmaps)
         {
            bmp.dispose();
         }
         this.bgBitmaps.length = 0;
      }
      
      protected function clearLights() : void
      {
         this.mcAmbient.graphics.clear();
         while(this.mcLights.numChildren > 0)
         {
            this.mcLights.removeChildAt(0);
         }
      }
      
      protected function drawMap() : void
      {
         this.drawObjects();
      }
      
      protected function drawBg() : void
      {
         var f:MapFillZone = null;
         var t:TextField = null;
         var zoneSprite:Sprite = null;
         var zoneMask:Sprite = null;
         var bgBmp:BitmapData = LibraryManager.getBitmapData(this.layout.background.id,this.layout.background.library);
         this.clearBg();
         if(Boolean(bgBmp))
         {
            this.mcBg.graphics.beginBitmapFill(bgBmp);
         }
         else
         {
            t = new TextField();
            t.autoSize = "left";
            t.textColor = 2258722;
            t.defaultTextFormat = new TextFormat("Tahoma, sans",8);
            t.text = "background " + this.layout.background.library + "." + this.layout.background.id + " not found";
            bgBmp = new BitmapData(t.textWidth + 10,t.textHeight,false,0);
            bgBmp.draw(t);
            this.mcBg.graphics.beginBitmapFill(bgBmp);
         }
         this.bgBitmaps.push(bgBmp);
         this.drawBgZone(bgBmp);
         this.mcBg.graphics.endFill();
         for each(f in this.layout.fillZones)
         {
            if(!(!f.points || f.points.length < 3 || !f.visible))
            {
               bgBmp = LibraryManager.getBitmapData(f.background.id,f.background.library);
               if(f.blur > 0)
               {
                  zoneSprite = new Sprite();
                  zoneSprite.blendMode = BlendMode.LAYER;
                  this.drawContour(zoneSprite.graphics,f.points,bgBmp);
                  zoneMask = new Sprite();
                  zoneMask.blendMode = BlendMode.ERASE;
                  this.drawContour(zoneMask.graphics,f.points,null);
                  zoneMask.filters = [new DropShadowFilter(0,0,0,1,f.blur,f.blur,2,1,true,false,true)];
                  zoneSprite.addChild(zoneMask);
                  zoneSprite.cacheAsBitmap = true;
                  this.mcBg.addChild(zoneSprite);
               }
               else
               {
                  this.drawContour(this.mcBg.graphics,f.points,bgBmp);
               }
               if(Boolean(bgBmp))
               {
                  this.bgBitmaps.push(bgBmp);
               }
            }
         }
      }
      
      protected function drawBgZone(bgBmp:BitmapData) : void
      {
         var borderPoints:Array = this._layout.borderPoints;
         if(borderPoints == null || borderPoints.length < 3)
         {
            borderPoints = [];
            borderPoints.push(new SpritePoint(0,0));
            borderPoints.push(new SpritePoint(this.layout.width,0));
            borderPoints.push(new SpritePoint(this.layout.width,this.layout.height));
            borderPoints.push(new SpritePoint(0,this.layout.height));
         }
         this.drawPoly(this.mcBg.graphics,borderPoints,bgBmp);
      }
      
      protected function drawPoly(graphics:Graphics, points:Array, fill:BitmapData) : void
      {
         var borderPoint:SpritePoint = null;
         var pointIndex:int = 0;
         if(Boolean(fill))
         {
            graphics.beginBitmapFill(fill);
         }
         else
         {
            graphics.beginFill(16711935);
         }
         for each(borderPoint in points)
         {
            pointIndex = points.indexOf(borderPoint);
            if(pointIndex == 0)
            {
               graphics.moveTo(borderPoint.x,borderPoint.y);
            }
            else
            {
               graphics.lineTo(borderPoint.x,borderPoint.y);
            }
         }
         graphics.endFill();
      }
      
      protected function drawContour(graphics:Graphics, points:Array, fill:BitmapData) : void
      {
         var prevPoint:ContourPoint = null;
         var numPoints:uint = points.length;
         if(numPoints < 1)
         {
            return;
         }
         if(Boolean(fill))
         {
            graphics.beginBitmapFill(fill);
         }
         else
         {
            graphics.beginFill(16711935);
         }
         var p:SpritePoint = points[0];
         graphics.moveTo(p.x,p.y);
         for(var i:int = 1; i <= numPoints; i++)
         {
            p = points[i == numPoints ? 0 : i];
            prevPoint = points[i - 1] as ContourPoint;
            if(Boolean(prevPoint) && Boolean(prevPoint.controlX != 0) && prevPoint.controlY != 0)
            {
               graphics.curveTo(prevPoint.x + prevPoint.controlX,prevPoint.y + prevPoint.controlY,p.x,p.y);
            }
            else
            {
               graphics.lineTo(p.x,p.y);
            }
         }
         graphics.endFill();
      }
      
      protected function drawObjects() : void
      {
         this.clearObjects();
         this.edgeOrder = new EdgeOrder(new SpriteContainer(this.mcRaised));
      }
      
      protected function drawLights() : void
      {
         var mapLight:MapLight = null;
         var m:Matrix = null;
         var max:uint = 0;
         var max2:uint = 0;
         var l:Sprite = null;
         var blendMode:String = null;
         this.clearLights();
         var g:Graphics = this.mcAmbient.graphics;
         if(this._layout.lights == null || !this._layout.lights.enabled)
         {
            this.mcLights.visible = this.mcAmbient.visible = false;
            return;
         }
         this.mcLights.visible = this.mcAmbient.visible = this._showLighting;
         var lights:MapLights = this._layout.lights;
         g.beginFill(lights.color);
         g.drawRect(0,0,this._layout.width,this._layout.height);
         g.endFill();
         for each(mapLight in lights.lights)
         {
            m = new Matrix();
            max = mapLight.max;
            max2 = mapLight.max / 2;
            if(mapLight.blendMode == BlendMode.MULTIPLY)
            {
               m.createGradientBox(max * 2,max,0,mapLight.x - max,mapLight.y - max2);
               g.beginGradientFill(GradientType.RADIAL,[mapLight.color,mapLight.color],[mapLight.alpha,0],[255 / max * mapLight.min,255],m);
               g.drawEllipse(mapLight.x - max,mapLight.y - max2,max * 2,max);
               g.endFill();
            }
            else
            {
               l = new Sprite();
               m.createGradientBox(max * 2,max,0,-max,-max2);
               l.graphics.beginGradientFill(GradientType.RADIAL,[mapLight.color,mapLight.color],[mapLight.alpha,0],[255 / max * mapLight.min,255],m);
               l.graphics.drawEllipse(-max,-max2,max * 2,max);
               l.graphics.endFill();
               l.x = mapLight.x;
               l.y = mapLight.y;
               blendMode = mapLight.blendMode == ColorShader.BLEND_MODE ? BlendMode.SHADER : mapLight.blendMode;
               if(blendMode == BlendMode.SHADER)
               {
                  l.blendShader = new ColorShader();
               }
               if(Boolean(mapLight.blendMode) && mapLight.blendMode.length > 0)
               {
                  l.blendMode = blendMode;
               }
               l.cacheAsBitmap = true;
               this.mcLights.addChild(l);
            }
         }
      }
      
      protected function sortGroundObjects() : void
      {
         var i:String = null;
         this.groundObjects.sort(goComparator);
         for(i in this.groundObjects)
         {
            this.mcGround.setChildIndex(this.groundObjects[i],i as Number);
         }
      }
      
      protected function onResize(e:Event) : void
      {
         var deepWidth:uint = 0;
         var deepHeight:uint = 0;
         graphics.clear();
         graphics.beginFill(0);
         graphics.drawRect(0,0,width,height);
         graphics.endFill();
         this.deepBg.graphics.clear();
         if(Boolean(this.layout) && Boolean(this.deepBackground))
         {
            deepWidth = width + this.layout.width * this.layout.deepBgScrollSpeed;
            deepHeight = height + this.layout.height * this.layout.deepBgScrollSpeed;
            this.deepBg.graphics.beginBitmapFill(this.deepBackground);
            this.deepBg.graphics.drawRect(0,0,deepWidth,deepHeight);
            this.deepBg.graphics.endFill();
         }
         this.maskWidth = width;
         this.maskHeight = height;
         if(Boolean(this.layout))
         {
            this.maskWidth = Math.min(this.layout.width,this.maskWidth);
            this.maskHeight = Math.min(this.layout.height,this.maskHeight);
         }
         this.maskRect.width = this.maskWidth;
         this.maskRect.height = this.maskHeight;
         scrollRect = this.maskRect;
      }
      
      public function set showLighting(value:Boolean) : void
      {
         if(this._showLighting == value)
         {
            return;
         }
         this._showLighting = this.mcAmbient.visible = this.mcLights.visible = value;
      }
      
      public function set layout(value:MapLayout) : void
      {
         trace("FieldDrawer.layout()");
         this._layout = value;
         this.clearMap();
         if(value == null)
         {
            return;
         }
         if(Boolean(this.layout.deepBackground))
         {
            this.deepBackground = LibraryManager.getBitmapData(this.layout.deepBackground.id,this.layout.deepBackground.library);
         }
         this.onResize(null);
         this.drawMap();
      }
      
      public function get layout() : MapLayout
      {
         return this._layout;
      }
   }
}

