package soul.view.interaction.lfg
{
   import flash.events.MouseEvent;
   import soul.controller.Interaction;
   import soul.model.common.InteractionType;
   import soul.model.interaction.lfg.GroupApplication;
   import soul.view.common.Icons;
   import soul.view.ui.CachedImage;
   
   public class LFGIcon extends CachedImage
   {
      
      public function LFGIcon()
      {
         super();
         source = Icons.lfg;
         addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(e:MouseEvent) : void
      {
         Interaction.show(InteractionType.LFG);
      }
      
      public function set application(value:GroupApplication) : void
      {
         toolTip = Boolean(value) ? value.getTooltip() : null;
         visible = value != null;
      }
   }
}

