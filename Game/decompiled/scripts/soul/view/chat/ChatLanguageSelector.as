package soul.view.chat
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.event.MenuEvent;
   import soul.view.ui.Label;
   import soul.view.ui.controls.menu.Menu;
   
   [Event(name="change",type="flash.events.Event")]
   public class ChatLanguageSelector extends Label
   {
      
      public var locales:Array;
      
      private var _locale:String;
      
      public function ChatLanguageSelector()
      {
         super();
         addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(e:MouseEvent) : void
      {
         var locale:String = null;
         var menu:Menu = null;
         var menuData:Array = [];
         for each(locale in this.locales)
         {
            menuData.push({
               "type":"radio",
               "data":locale,
               "label":this.getString(locale),
               "toggled":locale == this._locale
            });
         }
         menu = Menu.createMenu(stage,menuData);
         menu.addEventListener(MenuEvent.ITEM_CLICK,this.menuClick);
         menu.show(stage.mouseX,stage.mouseY);
      }
      
      private function getString(locale:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,"language." + locale);
      }
      
      private function menuClick(e:MenuEvent) : void
      {
         this._locale = e.item.data;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function set locale(value:String) : void
      {
         this._locale = value;
         text = "[" + value.toUpperCase() + "]";
      }
      
      public function get locale() : String
      {
         return this._locale;
      }
   }
}

