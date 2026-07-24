package soul.view.interaction.academy
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.character.DispositionGroup;
   import soul.view.assets.Assets;
   import soul.view.common.OptionRenderer;
   import soul.view.ui.Box;
   
   public class ClassSelector extends Box
   {
      
      private static const imageList:Object = {};
      
      imageList[DispositionGroup.WARRIOR] = Assets.warrior;
      imageList[DispositionGroup.THIEF] = Assets.thief;
      imageList[DispositionGroup.PRIEST] = Assets.cleric;
      imageList[DispositionGroup.MAGICIAN] = Assets.mage;
      
      private var _selectedClass:String;
      
      public function ClassSelector()
      {
         var klass:String = null;
         var child:OptionRenderer = null;
         super();
         for each(klass in DispositionGroup.SORTED_LIST)
         {
            child = new OptionRenderer();
            child.source = imageList[klass];
            child.value = klass;
            child.label = this.getString(klass).toUpperCase();
            child.addEventListener(MouseEvent.CLICK,this.childClick);
            addChild(child);
         }
      }
      
      private function childClick(e:MouseEvent) : void
      {
         this.selectedClass = String(OptionRenderer(e.currentTarget).value);
      }
      
      [Bindable("selectedClassChanged")]
      public function set selectedClass(value:String) : void
      {
         var child:OptionRenderer = null;
         this._selectedClass = value;
         for(var i:int = 0; i < numChildren; i++)
         {
            child = getChildAt(i) as OptionRenderer;
            child.selected = child.value == value;
         }
         dispatchEvent(new Event("selectedClassChanged"));
      }
      
      public function get selectedClass() : String
      {
         return this._selectedClass;
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.DISPOSITION_INFO,key);
      }
   }
}

