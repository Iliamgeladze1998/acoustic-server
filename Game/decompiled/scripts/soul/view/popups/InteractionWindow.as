package soul.view.popups
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import soul.controller.Interaction;
   import soul.view.ui.controls.Window;
   
   public class InteractionWindow extends Window
   {
      
      public var type:String;
      
      public var modal:Boolean;
      
      public function InteractionWindow()
      {
         super();
      }
      
      public static function findInteractionParent(o:DisplayObject) : InteractionWindow
      {
         o = o.parent;
         while(o != null)
         {
            if(o is InteractionWindow)
            {
               break;
            }
            o = o.parent;
         }
         return o as InteractionWindow;
      }
      
      public static function setLabelToInteractionParent(o:DisplayObject, label:String) : void
      {
         var parent:InteractionWindow = findInteractionParent(o);
         if(Boolean(parent))
         {
            parent.label = label;
         }
      }
      
      override protected function childAdded(child:DisplayObject) : void
      {
         super.childAdded(child);
         updateNow();
      }
      
      override public function tryToConfirm(e:Event) : void
      {
         var child:DisplayObject = null;
         for(var i:uint = 0; i < numChildren; i++)
         {
            child = getChildAt(i);
            if(child.hasEventListener(Event.COMPLETE))
            {
               child.dispatchEvent(new Event(Event.COMPLETE));
               e.stopPropagation();
               e.stopImmediatePropagation();
            }
         }
      }
      
      override protected function exit(e:Event) : void
      {
         Interaction.hide(this.type);
      }
   }
}

