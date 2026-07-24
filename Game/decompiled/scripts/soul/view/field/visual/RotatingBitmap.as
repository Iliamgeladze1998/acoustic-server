package soul.view.field.visual
{
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import soul.view.field.visual.players.PlayerModelFactory;
   import soul.view.field.visual.players.effect.EffectLocation;
   import soul.view.sprite.SpriteEntry;
   import soul.view.sprite.SpriteSheet;
   import soul.view.sprite.SpriteSheetLoder;
   
   public class RotatingBitmap extends EventDispatcher
   {
      
      private static const animationSpriteCache:Object = {};
      
      private static const instanceByClassCache:Dictionary = new Dictionary();
      
      public var visualId:String;
      
      public var linkages:Array;
      
      public var library:String;
      
      public var pps:Number;
      
      public var fps:uint;
      
      public var defaultFps:int = 24;
      
      public var frameWidth:int = 1;
      
      public var frameHeight:int = 1;
      
      public var hitArea:Rectangle;
      
      public var nameHeight:int;
      
      public var frameList:Object = {};
      
      public var fpsList:Object = {};
      
      public var fppList:Object = {};
      
      public var modelCenter:Point = new Point(0,-60);
      
      public var spriteCenter:Point;
      
      public var hasShadow:Boolean;
      
      public var effectLocations:Object = {};
      
      private var animationMap:Object;
      
      public var currentSprites:Vector.<Vector.<SpriteEntry>>;
      
      protected var fullBitmaps:Vector.<BitmapData>;
      
      private var loader:SpriteSheetLoder;
      
      public function RotatingBitmap()
      {
         super();
         this.effectLocations[EffectLocation.FEET] = 0;
         this.effectLocations[EffectLocation.TORSO] = -50;
         this.effectLocations[EffectLocation.HEAD] = -100;
      }
      
      public static function getUnitInstanceByVisualId(visualId:String) : RotatingBitmap
      {
         var unitClass:Class = PlayerModelFactory.getClassByVisualId(visualId);
         var instance:RotatingBitmap = instanceByClassCache[unitClass];
         if(!instance && Boolean(unitClass))
         {
            instance = new unitClass() as RotatingBitmap;
            if(Boolean(instance))
            {
               instanceByClassCache[unitClass] = instance;
            }
         }
         return instance;
      }
      
      public function initSprite() : void
      {
         this.visualId = this.linkages.join("_");
         this.loader = SpriteSheetLoder.getSpriteLoader(this.visualId,this.linkages);
         if(!this.loader.loaded)
         {
            this.loader.loadSprite(this.frameWidth,this.frameHeight);
         }
         this.createAnimationMap(this.loader.spriteSheets);
      }
      
      public function initCharacter() : void
      {
         if(Boolean(this.loader))
         {
            this.loader.removeEventListener(Event.COMPLETE,this.onCharacterLoadComplete);
         }
         this.loader = SpriteSheetLoder.getCharacterLoader(this.visualId);
         if(this.loader.loaded)
         {
            this.onCharacterLoadComplete(null);
         }
         else
         {
            this.loader.addEventListener(Event.COMPLETE,this.onCharacterLoadComplete);
            this.loader.loadCharacter();
         }
      }
      
      private function onCharacterLoadComplete(e:Event) : void
      {
         if(Boolean(e))
         {
            this.loader.removeEventListener(Event.COMPLETE,this.onCharacterLoadComplete);
         }
         if(this.loader.loaded)
         {
            this.createAnimationMap(this.loader.spriteSheets);
         }
         this.loader = null;
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function createAnimationMap(spriteSheets:Vector.<SpriteSheet>) : void
      {
         var animationType:String = null;
         var data:Array = null;
         var sheetNumber:uint = 0;
         var frameNumbers:Array = null;
         var spriteSheet:SpriteSheet = null;
         var frameCount:uint = 0;
         var frames:Vector.<Vector.<SpriteEntry>> = null;
         var i:uint = 0;
         var frame:uint = 0;
         this.animationMap = animationSpriteCache[this.visualId];
         if(Boolean(this.animationMap))
         {
            return;
         }
         this.animationMap = {};
         for(animationType in this.frameList)
         {
            data = this.frameList[animationType];
            sheetNumber = uint(data[0]);
            frameNumbers = data[1];
            spriteSheet = spriteSheets[sheetNumber];
            frameCount = frameNumbers.length;
            frames = new Vector.<Vector.<SpriteEntry>>(frameCount,true);
            for(i = 0; i < frameCount; i++)
            {
               frame = uint(frameNumbers[i]);
               frames[i] = spriteSheet.getAnglesByFrame(frame);
            }
            this.animationMap[animationType] = frames;
         }
         animationSpriteCache[this.visualId] = this.animationMap;
      }
      
      public function setAnimation(type:String) : void
      {
         if(!this.animationMap)
         {
            return;
         }
         this.currentSprites = this.animationMap[type];
         if(!this.currentSprites)
         {
            this.currentSprites = this.animationMap[AnimationType.IDLE];
         }
         if(Boolean(this.fppList[type]) && Boolean(this.pps))
         {
            this.fps = uint(this.fppList[type] * this.pps);
            this.fps = Math.max(1,this.fps);
         }
         else if(Boolean(this.fpsList[type]))
         {
            this.fps = this.fpsList[type];
         }
         else
         {
            this.fps = this.defaultFps;
         }
      }
      
      public function getCurrentFrame(frameNo:uint, angle:uint) : SpriteEntry
      {
         if(!this.currentSprites)
         {
            return null;
         }
         var angles:Vector.<SpriteEntry> = this.currentSprites[frameNo];
         return angles[angle];
      }
   }
}

