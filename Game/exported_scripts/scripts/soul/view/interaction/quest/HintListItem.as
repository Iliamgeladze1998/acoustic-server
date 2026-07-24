package soul.view.interaction.quest
{
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.interaction.quest.HintEntry;
   import soul.view.common.Icons;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   
   public class HintListItem extends Component
   {
      
      private var image:CachedImage = new CachedImage();
      
      private var text:Label = new Label();
      
      public function HintListItem()
      {
         super();
         width = 255;
         height = 22;
         this.image.x = 2;
         this.image.y = 2;
         this.image.source = Icons.hint;
         this.text.width = 230;
         this.text.x = 25;
         this.text.color = 0;
         addChild(this.image);
         addChild(this.text);
      }
      
      public function set entry(value:HintEntry) : void
      {
         this.text.text = LocaleManager.getString(BundleName.HELPER,value.id + ".name");
      }
      
      public function set selected(value:Boolean) : void
      {
         graphics.clear();
         graphics.beginFill(13603176,value ? 1 : 0);
         graphics.drawRect(0,0,width,height);
         graphics.endFill();
      }
   }
}

