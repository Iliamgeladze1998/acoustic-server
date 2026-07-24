package soul.controller.astral
{
   import flash.geom.Point;
   import soul.controller.IManager;
   import soul.event.AstralEvent;
   import soul.model.astral.AstralData;
   import soul.model.astral.AstralMember;
   import soul.model.astral.AstralModel;
   import soul.net.ComponentLocator;
   import soul.net.ServerLayer;
   import soul.view.astral.AstralScreen;
   
   public class AstralManager implements IManager
   {
      
      private static const service:String = "astralService";
      
      private var model:AstralModel;
      
      private var view:AstralScreen;
      
      private var lastDestination:Point;
      
      public function AstralManager(view:AstralScreen, model:AstralModel)
      {
         super();
         ComponentLocator.setComponent(ComponentLocator.ASTRAL,this);
         this.model = model;
         this.view = view;
         view.visible = false;
         model.addEventListener(AstralEvent.ESTIMATE,this.requestEstimate);
         model.addEventListener(AstralEvent.MOVE_TO,this.requestMoveTo);
         model.addEventListener(AstralEvent.ENTER,this.requestEnter);
         model.addEventListener(AstralEvent.STOP,this.requestStop);
      }
      
      public function reset() : void
      {
      }
      
      public function init(data:AstralData) : void
      {
         this.model.load(data);
         this.model.enabled = true;
         this.view.visible = true;
         this.model.dispatchEvent(new AstralEvent(AstralEvent.INIT));
      }
      
      public function stopAt(id:String, x:int, y:int) : void
      {
         trace("AstralManager.stopAt()",arguments);
         this.view.stopAt(id,x,y);
         if(this.model.myId == id)
         {
            this.model.destinaton = null;
            this.model.moving = false;
         }
      }
      
      public function moveTo(id:String, x:int, y:int, duration:int) : void
      {
         trace("AstralManager.moveTo()",arguments);
         this.view.moveTo(id,x,y,duration);
         if(this.model.myId == id)
         {
            this.model.destinaton = new Point(x,y);
            this.model.moving = true;
         }
      }
      
      public function create(member:AstralMember) : void
      {
         this.view.create(member);
      }
      
      public function remove(memberId:String) : void
      {
         this.view.remove(memberId);
      }
      
      public function onEntrance(value:Boolean) : void
      {
         this.model.entrance = value;
      }
      
      public function changeCircleProperty(id:String, property:String, value:Object) : void
      {
         this.model.changeCircleProperty(id,property,value);
         this.view.drawCircles();
      }
      
      private function requestEstimate(e:AstralEvent) : void
      {
         this.lastDestination = new Point(e.x,e.y);
         ServerLayer.call(service,"estimate",this.estimateResult,null,e.x,e.y);
      }
      
      private function estimateResult(r:int) : void
      {
         trace("estimateResult",r);
         this.model.estimation = r;
         this.model.destinaton = this.lastDestination;
      }
      
      private function requestMoveTo(e:AstralEvent) : void
      {
         ServerLayer.call(service,"moveTo",null,null,e.x,e.y);
      }
      
      private function requestStop(e:AstralEvent) : void
      {
         ServerLayer.call(service,"estimate",null,null,0,0);
         this.model.destinaton = null;
         this.model.estimation = 0;
      }
      
      private function requestEnter(e:AstralEvent) : void
      {
         ServerLayer.call(service,"enter",null,null);
      }
      
      public function show() : void
      {
         ServerLayer.call(service,ComponentLocator.READY);
      }
      
      public function hide() : void
      {
         this.view.visible = false;
         this.model.enabled = false;
      }
   }
}

