package soul.view.field.visual.players.effect
{
   import flash.display.Sprite;
   import flash.events.Event;
   import soul.model.field.LibraryManager;
   import soul.view.ui.CachedMovieClip;
   
   public class EffectPlayer extends Sprite
   {
      
      private var child:CachedMovieClip;
      
      public function EffectPlayer()
      {
         super();
         mouseEnabled = false;
      }
      
      public function play(effectId:String) : void
      {
         this.stop();
         this.child = LibraryManager.getObject(effectId,LibraryManager.mainLibrary) as CachedMovieClip;
         if(!this.child)
         {
            return;
         }
         addChild(this.child);
         this.startListener();
      }
      
      public function stop() : void
      {
         if(!this.child)
         {
            return;
         }
         this.child.stop();
         removeChild(this.child);
         this.stopListener();
         this.child = null;
      }
      
      private function startListener() : void
      {
         this.child.addEventListener(Event.EXIT_FRAME,this.exitFrame);
      }
      
      private function stopListener() : void
      {
         this.child.removeEventListener(Event.EXIT_FRAME,this.exitFrame);
      }
      
      private function exitFrame(e:Event) : void
      {
         if(this.child.currentFrame == this.child.totalFrames)
         {
            this.stop();
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
   }
}

