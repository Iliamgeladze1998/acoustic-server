package soul.model.buff
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.clearInterval;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   
   public class Effect extends EventDispatcher
   {
      
      private static const updateFrequency:int = 500;
      
      public var id:String;
      
      public var localeId:String;
      
      public var group:String;
      
      public var imagePath:String;
      
      public var effects:Array;
      
      public var aura:Aura;
      
      [Bindable("hpChanged")]
      public var hp:int;
      
      public var maxHp:int;
      
      private var timeout:int;
      
      private var timeToDie:int;
      
      private var _ttl:int;
      
      public function Effect()
      {
         super();
      }
      
      [Bindable(event="tllChanged")]
      public function set ttl(value:int) : void
      {
         this.reset();
         if(value > 0)
         {
            this.timeout = setInterval(this.tick,updateFrequency);
            this.timeToDie = getTimer() + value;
         }
         this.tick();
      }
      
      public function get ttl() : int
      {
         return this._ttl;
      }
      
      private function tick() : void
      {
         var now:int = getTimer();
         if(now >= this.timeToDie)
         {
            this._ttl = 0;
            this.reset();
         }
         else
         {
            this._ttl = this.timeToDie - now;
         }
         dispatchEvent(new Event("ttlChanged"));
      }
      
      public function reset() : void
      {
         clearInterval(this.timeout);
      }
      
      public function updateHp(value:int) : void
      {
         this.hp = value;
         dispatchEvent(new Event("hpChanged"));
      }
   }
}

