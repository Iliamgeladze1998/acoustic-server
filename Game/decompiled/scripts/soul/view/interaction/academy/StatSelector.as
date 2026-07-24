package soul.view.interaction.academy
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.location.academy.AcademyResetType;
   import soul.view.assets.Assets;
   import soul.view.common.OptionRenderer;
   import soul.view.ui.Box;
   
   public class StatSelector extends Box
   {
      
      private static const sortedList:Array = [AcademyResetType.STATS,AcademyResetType.SCHOOLS,AcademyResetType.TALENTS,AcademyResetType.PROFESSIONS];
      
      private static const imageList:Object = {};
      
      imageList[AcademyResetType.STATS] = Assets.params;
      imageList[AcademyResetType.SCHOOLS] = Assets.school;
      imageList[AcademyResetType.TALENTS] = Assets.talents;
      imageList[AcademyResetType.PROFESSIONS] = Assets.profession;
      
      private var _selectedType:String;
      
      public function StatSelector()
      {
         var type:String = null;
         var child:OptionRenderer = null;
         super();
         for each(type in sortedList)
         {
            child = new OptionRenderer();
            child.source = imageList[type];
            child.value = type;
            child.label = this.getString(type).toUpperCase();
            child.addEventListener(MouseEvent.CLICK,this.childClick);
            addChild(child);
         }
      }
      
      private function childClick(e:MouseEvent) : void
      {
         this.selectedType = String(OptionRenderer(e.currentTarget).value);
      }
      
      [Bindable("selectedTypeChanged")]
      public function set selectedType(value:String) : void
      {
         var child:OptionRenderer = null;
         this._selectedType = value;
         for(var i:int = 0; i < numChildren; i++)
         {
            child = getChildAt(i) as OptionRenderer;
            child.selected = child.value == value;
         }
         dispatchEvent(new Event("selectedTypeChanged"));
      }
      
      public function get selectedType() : String
      {
         return this._selectedType;
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
   }
}

