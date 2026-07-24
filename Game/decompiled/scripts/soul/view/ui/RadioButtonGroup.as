package soul.view.ui
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   [Event(name="change",type="flash.events.Event")]
   public class RadioButtonGroup extends EventDispatcher
   {
      
      private var children:Vector.<RadioButton> = new Vector.<RadioButton>();
      
      private var selectedChild:RadioButton;
      
      public function RadioButtonGroup()
      {
         super();
      }
      
      public function addChild(child:RadioButton) : void
      {
         if(this.children.indexOf(child) == -1)
         {
            this.children.push(child);
         }
      }
      
      [Bindable(event="selectedValueChanged")]
      public function get selectedValue() : Object
      {
         return Boolean(this.selectedChild) ? this.selectedChild.value : null;
      }
      
      public function set selectedValue(value:Object) : void
      {
         var child:RadioButton = null;
         for each(child in this.children)
         {
            if(child.value == value)
            {
               this.selectedChild = child;
               child.selected = true;
            }
            else
            {
               child.selected = false;
            }
         }
         if(hasEventListener("selectedValueChanged"))
         {
            dispatchEvent(new Event("selectedValueChanged"));
         }
         if(hasEventListener(Event.CHANGE))
         {
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
   }
}

