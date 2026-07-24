package air.update.states
{
   import flash.errors.IllegalOperationError;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   [ExcludeClass]
   public class HSM extends EventDispatcher
   {
      
      private var asyncTimer:Timer;
      
      private var _hsmState:Function;
      
      public function HSM(initialState:Function)
      {
         super();
         this._hsmState = initialState;
      }
      
      public function init() : void
      {
         try
         {
            this._hsmState(new HSMEvent(HSMEvent.ENTER));
         }
         catch(e:Error)
         {
            _hsmState(new ErrorEvent(ErrorEvent.ERROR,false,false,e.message,e.errorID));
         }
      }
      
      protected function get stateHSM() : Function
      {
         return this._hsmState;
      }
      
      protected function transition(state:Function) : void
      {
         this.asyncTimer = null;
         try
         {
            this._hsmState(new HSMEvent(HSMEvent.EXIT));
            this._hsmState = state;
            this._hsmState(new HSMEvent(HSMEvent.ENTER));
         }
         catch(e:Error)
         {
            _hsmState(new ErrorEvent(ErrorEvent.ERROR,false,false,"Unhandled exception " + e.name + ": " + e.message,e.errorID));
         }
      }
      
      protected function transitionAsync(state:Function) : void
      {
         if(Boolean(this.asyncTimer))
         {
            throw new IllegalOperationError("async transition already queued");
         }
         this.asyncTimer = new Timer(0,1);
         this.asyncTimer.addEventListener(TimerEvent.TIMER,function(event:Event):void
         {
            transition(state);
         });
         this.asyncTimer.start();
      }
      
      public function dispatch(event:Event) : void
      {
         try
         {
            this._hsmState(event);
         }
         catch(e:Error)
         {
            _hsmState(new ErrorEvent(ErrorEvent.ERROR,false,false,e.message,e.errorID));
         }
      }
   }
}

