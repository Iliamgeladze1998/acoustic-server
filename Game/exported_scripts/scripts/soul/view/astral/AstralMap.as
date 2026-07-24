package soul.view.astral
{
   import com.gskinner.motion.GTween;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import soul.event.AstralEvent;
   import soul.event.SimpleUIEvent;
   import soul.model.astral.AstralCircle;
   import soul.model.astral.AstralMember;
   import soul.model.astral.AstralModel;
   import soul.model.system.Configuration;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Component;
   
   public class AstralMap extends Component
   {
      
      private static const PPS:uint = 500;
      
      public var model:AstralModel;
      
      private var content:Sprite = new Sprite();
      
      private var image:CachedImage = new CachedImage();
      
      private var mcCircles:Sprite = new Sprite();
      
      private var mcRoute:Sprite = new Sprite();
      
      private var mcPlayers:Sprite = new Sprite();
      
      private var myPlayer:AstralPlayer = new AstralPlayer();
      
      private var cross:Cross = new Cross();
      
      private var players:Object = {};
      
      private var timer:Timer = new Timer(100);
      
      private var endTime:uint;
      
      private var focusTween:GTween;
      
      private var startPoint:Point;
      
      public function AstralMap()
      {
         super();
         addChild(this.content);
         this.content.addChild(this.image);
         this.content.addChild(this.mcCircles);
         this.content.addChild(this.mcRoute);
         this.content.addChild(this.mcPlayers);
         this.mcRoute.mouseEnabled = false;
         this.mcRoute.addChild(this.cross);
         doubleClickEnabled = true;
         this.content.doubleClickEnabled = true;
         this.image.doubleClickEnabled = true;
         this.image.addEventListener(Event.CHANGE,this.imageLoaded);
         addEventListener(SimpleUIEvent.CREATION_COMPLETE,this.creationComplete);
         addEventListener(Event.RESIZE,this.onResize);
         this.content.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         this.content.addEventListener(MouseEvent.DOUBLE_CLICK,this.mapDblClick);
         this.timer.addEventListener(TimerEvent.TIMER,this.drawRoute);
      }
      
      private function creationComplete(e:SimpleUIEvent) : void
      {
         this.model.addEventListener(AstralEvent.INIT,this.init);
         if(this.model.enabled)
         {
            this.init(null);
         }
      }
      
      private function imageLoaded(e:Event) : void
      {
         this.centerScreenAt(this.model.x,this.model.y);
         this.model.globalMapHeight = Math.round(Math.max(this.image.height,this.model.height));
         this.model.globalMapWidth = Math.round(Math.max(this.image.width,this.model.width));
         this.model.dispatchEvent(new AstralEvent(AstralEvent.IMAGE_LOADED));
      }
      
      private function focus(e:AstralEvent) : void
      {
         if(Boolean(this.focusTween))
         {
            this.focusTween.paused = true;
            this.focusTween = null;
         }
         var maxWidth:uint = Math.max(this.image.width,this.model.width);
         var maxHeight:uint = Math.max(this.image.height,this.model.height);
         var w2:int = width / 2;
         var h2:int = height / 2;
         var x:int = Math.max(0,e.x - w2);
         var y:int = Math.max(0,e.y - h2);
         x = Math.min(maxWidth - width,x);
         y = Math.min(maxHeight - height,y);
         var dx:int = x + this.content.x;
         var dy:int = y + this.content.y;
         var distance:int = Math.sqrt(dx * dx + dy * dy);
         this.model.x = x;
         this.model.y = y;
         this.focusTween = new GTween(this.content,distance / PPS,{
            "x":-x,
            "y":-y
         });
         this.model.dispatchEvent(new AstralEvent(AstralEvent.FOCUS_COMLETED));
      }
      
      private function instantFocus(e:AstralEvent = null) : void
      {
         this.content.x = -this.model.x;
         this.content.y = -this.model.y;
         this.checkBounds();
      }
      
      private function centerScreenAt(x:int, y:int) : void
      {
         var w2:int = width / 2;
         var h2:int = height / 2;
         this.content.x = w2 - x;
         this.content.y = h2 - y;
         this.checkBounds();
      }
      
      private function mouseDown(e:MouseEvent) : void
      {
         stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
         var maxWidth:uint = Math.max(this.image.width,this.model.width);
         var maxHeight:uint = Math.max(this.image.height,this.model.height);
         this.startPoint = new Point(mouseX,mouseY);
         this.content.addEventListener(MouseEvent.MOUSE_MOVE,this.dragMiniMap);
         this.content.startDrag(false,new Rectangle(0,0,width - maxWidth,height - maxHeight));
      }
      
      private function mouseUp(e:MouseEvent) : void
      {
         var ne:AstralEvent = null;
         this.content.stopDrag();
         this.content.removeEventListener(MouseEvent.MOUSE_MOVE,this.dragMiniMap);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
         this.model.x = this.content.x;
         this.model.y = this.content.y;
         var dx:uint = Math.abs(mouseX - this.startPoint.x);
         var dy:uint = Math.abs(mouseY - this.startPoint.y);
         if(dx < 5 && dy < 5)
         {
            ne = new AstralEvent(AstralEvent.ESTIMATE);
            ne.x = this.content.mouseX;
            ne.y = this.content.mouseY;
            this.model.dispatchEvent(ne);
         }
      }
      
      private function dragMiniMap(e:MouseEvent) : void
      {
         this.model.x = this.content.x;
         this.model.y = this.content.y;
         var ae:AstralEvent = new AstralEvent(AstralEvent.DRAG);
         this.model.dispatchEvent(ae);
      }
      
      private function mapDblClick(e:MouseEvent) : void
      {
         var ne:AstralEvent = new AstralEvent(AstralEvent.MOVE_TO);
         ne.x = this.content.mouseX;
         ne.y = this.content.mouseY;
         this.model.dispatchEvent(ne);
      }
      
      private function drawRoute(e:TimerEvent) : void
      {
         var x:Number = NaN;
         var y:Number = NaN;
         this.mcRoute.graphics.clear();
         if(this.timer.running)
         {
            this.model.estimation = Math.max(0,this.endTime - getTimer());
         }
         if(!this.model.destinaton)
         {
            return;
         }
         var start:Point = this.model.destinaton;
         var end:Point = new Point(this.myPlayer.x,this.myPlayer.y);
         var dx:Number = end.x - start.x;
         var dy:Number = end.y - start.y;
         var length:Number = Math.sqrt(dx * dx + dy * dy);
         var step:uint = 10;
         var taken:uint = 0;
         while(taken + step < length)
         {
            taken += step;
            x = start.x + taken * (dx / length);
            y = start.y + taken * (dy / length);
            this.mcRoute.graphics.beginFill(0);
            this.mcRoute.graphics.drawCircle(x + 1,y + 1,2);
            this.mcRoute.graphics.endFill();
            this.mcRoute.graphics.beginFill(16776960);
            this.mcRoute.graphics.drawCircle(x,y,2);
            this.mcRoute.graphics.endFill();
         }
      }
      
      private function onResize(e:Event) : void
      {
         this.model.screenHeight = Math.round(height);
         this.model.screenWidth = Math.round(width);
         this.model.dispatchEvent(new AstralEvent(AstralEvent.RESIZE));
      }
      
      public function init(e:AstralEvent) : void
      {
         var member:AstralMember = null;
         this.model.addEventListener(AstralEvent.FOCUS,this.focus,false,0,true);
         this.model.addEventListener(AstralEvent.INSTANT_FOCUS,this.instantFocus,false,0,true);
         this.model.screenHeight = height;
         this.model.screenWidth = width;
         this.image.source = Configuration.getImage(this.model.image);
         this.myPlayer.label = this.model.myName;
         this.myPlayer.x = this.model.x;
         this.myPlayer.y = this.model.y;
         this.drawCircles();
         while(this.mcPlayers.numChildren > 0)
         {
            this.mcPlayers.removeChildAt(0);
         }
         this.mcPlayers.addChild(this.myPlayer);
         this.players = {};
         for each(member in this.model.members)
         {
            this.create(member);
         }
         this.centerScreenAt(this.model.x,this.model.y);
      }
      
      public function drawCircles() : void
      {
         var circle:AstralCircle = null;
         var cChild:CircleRenderer = null;
         while(this.mcCircles.numChildren > 0)
         {
            this.mcCircles.removeChildAt(0);
         }
         for each(circle in this.model.circles)
         {
            cChild = new CircleRenderer(circle);
            this.mcCircles.addChild(cChild);
         }
      }
      
      public function stopAt(id:String, x:int, y:int) : void
      {
         var player:AstralPlayer = id == this.model.myId ? this.myPlayer : this.players[id];
         if(!player)
         {
            return;
         }
         player.stopAt(x,y);
         this.timer.stop();
      }
      
      public function moveTo(id:String, x:int, y:int, duration:int) : void
      {
         var player:AstralPlayer = id == this.model.myId ? this.myPlayer : this.players[id];
         if(!player)
         {
            return;
         }
         player.moveTo(x,y,duration);
         if(id == this.model.myId)
         {
            this.endTime = getTimer() + duration;
            this.timer.start();
         }
      }
      
      public function create(member:AstralMember) : void
      {
         if(member.id in this.players)
         {
            return;
         }
         var player:AstralPlayer = new AstralPlayer();
         player.label = member.name;
         player.x = member.x;
         player.y = member.y;
         this.mcPlayers.addChild(player);
         this.players[member.id] = player;
      }
      
      public function remove(id:String) : void
      {
         var player:AstralPlayer = this.players[id];
         if(!player)
         {
            return;
         }
         player.stopAt(player.x,player.y);
         this.mcPlayers.removeChild(player);
         delete this.players[id];
      }
      
      public function set destination(value:Point) : void
      {
         if(Boolean(value))
         {
            this.cross.visible = true;
            this.cross.x = value.x;
            this.cross.y = value.y;
         }
         else
         {
            this.cross.visible = false;
         }
         this.drawRoute(null);
      }
      
      private function checkBounds() : void
      {
         if(!this.model)
         {
            return;
         }
         var maxWidth:uint = Math.max(this.image.width,this.model.width);
         var maxHeight:uint = Math.max(this.image.height,this.model.height);
         this.model.globalMapHeight = Math.round(maxHeight);
         this.model.globalMapWidth = Math.round(maxWidth);
         if(maxWidth == 0 || maxHeight == 0)
         {
            return;
         }
         if(this.content.x < width - maxWidth)
         {
            this.content.x = width - maxWidth;
         }
         if(this.content.y < height - maxHeight)
         {
            this.content.y = height - maxHeight;
         }
         if(this.content.x > 0)
         {
            this.content.x = 0;
         }
         if(this.content.y > 0)
         {
            this.content.y = 0;
         }
      }
      
      override protected function redraw() : void
      {
         scrollRect = new Rectangle(0,0,width,height);
         this.checkBounds();
      }
   }
}

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.EventDispatcher;
import flash.filters.GlowFilter;
import soul.controller.locale.BundleName;
import soul.controller.locale.LocaleManager;
import soul.model.astral.AstralCircle;
import soul.model.character.Side;
import soul.model.field.QuestGiverStatus;
import soul.model.field.mapconfig.PvpState;
import soul.model.system.Configuration;
import soul.view.assets.Assets;
import soul.view.assets.Colors;
import soul.view.chat.ClanIcon;
import soul.view.common.Icons;
import soul.view.toolTip.AstralCircleTip;
import soul.view.toolTip.ToolTipManager;
import soul.view.ui.CachedImage;
import soul.view.ui.Canvas;
import soul.view.ui.Component;
import soul.view.ui.Container;
import soul.view.ui.Label;

class CircleRenderer extends Canvas
{
   
   private static const LABEL_FILTERS:Array = [new GlowFilter(2626048,1,2,2,10,3)];
   
   private static const QUEST_FILTERS:Array = [new GlowFilter(65280,0.5,15,15,3)];
   
   private const icon:CachedImage;
   
   private const sideIcon:CachedImage;
   
   private const pvpIcon:CachedImage;
   
   private const questIcon:CachedImage;
   
   private const label:Label;
   
   public function CircleRenderer(circle:AstralCircle)
   {
      var clanBanner:CachedImage = null;
      var clanIcon:ClanIcon = null;
      this.icon = new CachedImage();
      this.sideIcon = new CachedImage();
      this.pvpIcon = new CachedImage();
      this.questIcon = new CachedImage();
      this.label = new Label();
      super();
      mouseChildren = false;
      doubleClickEnabled = true;
      this.sideIcon.x = -27;
      this.sideIcon.y = 21;
      this.pvpIcon.x = -8;
      this.pvpIcon.y = 18;
      this.questIcon.x = 12;
      this.questIcon.y = 14;
      if(circle.objective)
      {
         this.questIcon.filters = QUEST_FILTERS;
         this.label.color = 62470;
      }
      else if(Boolean(circle.citadelInfo) && circle.citadelInfo.assault)
      {
         this.label.color = 16656681;
      }
      else
      {
         this.label.color = 16509362;
      }
      this.icon.horizontalCenter = 0;
      this.icon.verticalCenter = 0;
      this.label.fontSize = 12;
      this.label.horizontalCenter = 0;
      this.label.y = 40;
      this.label.filters = LABEL_FILTERS;
      addChild(this.icon);
      addChild(this.sideIcon);
      addChild(this.pvpIcon);
      addChild(this.questIcon);
      addChild(this.label);
      x = circle.x;
      y = circle.y;
      this.icon.source = Configuration.getAstralImageUrl(circle.imagePath);
      this.icon.filters = circle.accessible ? [] : Colors.DISABLED_FILTER;
      this.sideIcon.source = Side.getRoundIcon(circle.side);
      this.pvpIcon.source = PvpState.getRoundIcon(circle.pvpState) || (Boolean(circle.citadelInfo) ? Icons.citadel : null);
      this.questIcon.source = Boolean(circle.questStatus) ? QuestGiverStatus.getRoundIcon(circle.questStatus) : null;
      this.label.text = LocaleManager.getString(BundleName.ASTRAL,circle.id + ".name");
      if(Boolean(circle.citadelInfo) && Boolean(circle.citadelInfo.clanId))
      {
         clanBanner = new CachedImage();
         clanBanner.source = Icons.astralBanner;
         clanBanner.x = 20;
         clanBanner.y = -45;
         addChild(clanBanner);
         clanIcon = new ClanIcon();
         clanIcon.clanId = circle.citadelInfo.clanId;
         clanIcon.x = 26;
         clanIcon.y = -38;
         addChild(clanIcon);
      }
      ToolTipManager.register(this,circle,AstralCircleTip);
   }
}

class Cross extends Sprite
{
   
   private var image:CachedImage = new CachedImage();
   
   public function Cross()
   {
      super();
      mouseEnabled = false;
      mouseChildren = false;
      doubleClickEnabled = true;
      this.image.x = -9;
      this.image.y = -8;
      addChild(this.image);
      this.image.source = Assets.astralCross;
   }
}
