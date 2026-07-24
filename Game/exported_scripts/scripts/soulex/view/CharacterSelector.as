package soulex.view
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.containers.Tile;
   import mx.events.PropertyChangeEvent;
   import soulex.CharacterInfo;
   
   [Event(name="select",type="flash.events.Event")]
   public class CharacterSelector extends Tile
   {
      
      private var _991518044selectedCharacterIndex:int = -1;
      
      public function CharacterSelector()
      {
         super();
      }
      
      public function set characters(value:Array) : void
      {
         var info:CharacterInfo = null;
         var child:CharacterInfoRenderer = null;
         this.selectedCharacterIndex = -1;
         removeAllElements();
         for each(info in value)
         {
            child = new CharacterInfoRenderer();
            child.info = info;
            child.doubleClickEnabled = true;
            child.addEventListener(MouseEvent.CLICK,this.onClick);
            child.addEventListener(MouseEvent.DOUBLE_CLICK,this.onDblClick);
            addElement(child);
         }
      }
      
      private function onClick(e:MouseEvent) : void
      {
         var child:CharacterInfoRenderer = null;
         for(var i:int = 0; i < numElements; i++)
         {
            child = getElementAt(i) as CharacterInfoRenderer;
            if(child == e.currentTarget && Boolean(child.info))
            {
               child.selected = true;
               this.selectedCharacterIndex = i;
            }
            else
            {
               child.selected = false;
            }
         }
      }
      
      private function onDblClick(e:MouseEvent) : void
      {
         dispatchEvent(new Event(Event.SELECT));
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedCharacterIndex() : int
      {
         return this._991518044selectedCharacterIndex;
      }
      
      public function set selectedCharacterIndex(param1:int) : void
      {
         var _loc2_:Object = this._991518044selectedCharacterIndex;
         if(_loc2_ !== param1)
         {
            this._991518044selectedCharacterIndex = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedCharacterIndex",_loc2_,param1));
            }
         }
      }
   }
}

