package soul.controller.dialog
{
   import mx.events.ItemClickEvent;
   import soul.controller.IManager;
   import soul.controller.Interaction;
   import soul.model.common.InteractionType;
   import soul.model.interaction.dialog.DialogBranch;
   import soul.net.ServerLayer;
   import soul.view.interaction.quest.QuestDialog;
   
   public class DialogManager implements IManager
   {
      
      private var view:QuestDialog;
      
      public function DialogManager(view:QuestDialog)
      {
         super();
         this.view = view;
         view.addEventListener(ItemClickEvent.ITEM_CLICK,this.itemClicked);
         ServerLayer.call("dialogService","getDialog",this.setDialog);
      }
      
      public function reset() : void
      {
      }
      
      public function setDialog(d:DialogBranch) : void
      {
         if(!d)
         {
            Interaction.hide(InteractionType.DIALOG);
         }
         else
         {
            this.view.init(d);
         }
      }
      
      public function itemClicked(e:ItemClickEvent) : void
      {
         var id:String = e.label;
         var dialog:DialogBranch = e.item as DialogBranch;
         ServerLayer.call("dialogService","answerOnDialog",null,this.onFault,dialog.id,id);
      }
      
      private function onFault(r:* = null) : void
      {
         if(Boolean(this.view))
         {
            this.view.unlock();
         }
      }
   }
}

