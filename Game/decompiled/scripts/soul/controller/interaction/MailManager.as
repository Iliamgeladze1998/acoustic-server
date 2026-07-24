package soul.controller.interaction
{
   import soul.controller.IManager;
   import soul.event.MailEvent;
   import soul.model.interaction.mail.Mail;
   import soul.model.interaction.mail.MailData;
   import soul.model.interaction.mail.MailModel;
   import soul.model.interaction.mail.NewMailData;
   import soul.net.ComponentLocator;
   import soul.net.ServerLayer;
   
   public class MailManager implements IManager
   {
      
      private var model:MailModel;
      
      private var currentMailId:String;
      
      private var currentItemIndex:int = -1;
      
      public function MailManager(model:MailModel)
      {
         super();
         ComponentLocator.setComponent(ComponentLocator.MAIL,this);
         this.model = model;
         model.addEventListener(MailEvent.READ,this.onRead);
         model.addEventListener(MailEvent.TAKE,this.onTake);
         model.addEventListener(MailEvent.DELETE,this.onDelete);
         model.addEventListener(MailEvent.SEND,this.onSend);
         ServerLayer.call("mailService",ComponentLocator.READY);
      }
      
      public function reset() : void
      {
      }
      
      private function onRead(e:MailEvent) : void
      {
         ServerLayer.call("mailService","markRead",null,null,e.mailId);
         this.checkNewMail();
      }
      
      private function onTake(e:MailEvent) : void
      {
         this.currentMailId = e.mailId;
         this.currentItemIndex = e.itemIndex;
         ServerLayer.call("mailService","takeAttachment",this.takeAttachmentResult,null,this.currentMailId,this.currentItemIndex);
      }
      
      private function takeAttachmentResult() : void
      {
         var mail:Mail = null;
         var arr:Array = null;
         if(Boolean(this.currentMailId))
         {
            for each(mail in this.model.inbox)
            {
               if(mail.id == this.currentMailId)
               {
                  if(Boolean(mail.attachments) && this.currentItemIndex != -1)
                  {
                     arr = mail.attachments.slice();
                     arr[this.currentItemIndex] = null;
                     mail.attachments = arr;
                     this.currentItemIndex = -1;
                  }
                  break;
               }
            }
            this.currentMailId = null;
         }
      }
      
      private function onDelete(e:MailEvent) : void
      {
         ServerLayer.call("mailService","deleteMail",null,null,e.mailId);
      }
      
      private function onSend(e:MailEvent) : void
      {
         var d:NewMailData = e.newMailData;
         ServerLayer.call("mailService","sendMail",this.sendSuccess,null,d.to,d.subject,d.body,d.item,d.copper);
      }
      
      private function sendSuccess() : void
      {
         this.model.dispatchEvent(new MailEvent(MailEvent.SEND_SUCCESS));
      }
      
      public function init(mailData:MailData) : void
      {
         this.model.mailCost = mailData.mailCost;
         this.model.inbox = mailData.inbox;
         this.checkNewMail();
      }
      
      public function addMail(mail:Mail) : void
      {
         var arr:Array = this.model.inbox;
         arr.unshift(mail);
         this.model.inbox = null;
         this.model.inbox = arr;
         this.model.hasNewMail = true;
      }
      
      public function deleteMail(id:String) : void
      {
         var mail:Mail = null;
         var arr:Array = this.model.inbox;
         for each(mail in arr)
         {
            if(mail.id == id)
            {
               arr.splice(arr.indexOf(mail),1);
               break;
            }
         }
         this.model.inbox = null;
         this.model.inbox = arr;
         this.checkNewMail();
      }
      
      private function checkNewMail() : void
      {
         var mail:Mail = null;
         for each(mail in this.model.inbox)
         {
            if(!mail.read)
            {
               this.model.hasNewMail = true;
               return;
            }
         }
         this.model.hasNewMail = false;
      }
   }
}

