package soul.view.popups
{
   import flash.display.DisplayObjectContainer;
   import flash.utils.clearTimeout;
   import flash.utils.getTimer;
   import mx.events.ItemClickEvent;
   import soul.model.GameModel;
   import soul.model.common.ShortMessage;
   import soul.net.ServerLayer;
   import soul.view.ui.controls.PopupManager;
   
   public class MessageManager
   {
      
      private static var container:DisplayObjectContainer;
      
      private static var model:GameModel;
      
      private static var dialogs:Object = {};
      
      public function MessageManager()
      {
         super();
      }
      
      public static function init(container:DisplayObjectContainer, model:GameModel) : void
      {
         MessageManager.container = container;
         MessageManager.model = model;
      }
      
      public static function reset() : void
      {
         container = null;
         model = null;
      }
      
      public static function showMessage(msg:ShortMessage) : void
      {
         if(!msg)
         {
            return;
         }
         var dia:DialogWindow = new DialogWindow();
         if(Boolean(msg.timer))
         {
            clearTimeout(msg.timer);
            msg.timeOut -= getTimer() - msg.started;
         }
         dia.init(msg);
         dia.addEventListener(ItemClickEvent.ITEM_CLICK,messageResponse);
         PopupManager.addPopup(dia,null);
         PopupManager.centerPopup(dia);
         dialogs[msg.id] = dia;
      }
      
      public static function addMessage(msg:ShortMessage) : void
      {
         if(!msg)
         {
            return;
         }
         showMessage(msg);
      }
      
      public static function closeMessage(messageId:String) : void
      {
         var dia:DialogWindow = dialogs[messageId];
         dialogs[messageId] = dia;
         if(!dia)
         {
            return;
         }
         dia.reset();
         PopupManager.removePopup(dia);
      }
      
      private static function messageResponse(e:ItemClickEvent) : void
      {
         var index:int = e.index;
         var messageId:String = e.item as String;
         closeMessage(messageId);
         ServerLayer.call("gameService","respondMessage",null,null,messageId,index);
      }
   }
}

