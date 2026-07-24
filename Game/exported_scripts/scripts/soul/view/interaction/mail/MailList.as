package soul.view.interaction.mail
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import soul.model.interaction.mail.Mail;
   import soul.view.ui.VBox;
   
   public class MailList extends VBox
   {
      
      public static const MAIL_SELECTED:String = "mailSelected";
      
      private var _selectedMail:Mail;
      
      public function MailList()
      {
         super();
      }
      
      public function set inbox(value:Array) : void
      {
         var mail:Mail = null;
         var renderer:MailRenderer = null;
         removeAllChildren();
         this.selectedMail = null;
         for each(mail in value)
         {
            renderer = new MailRenderer();
            renderer.mail = mail;
            renderer.selected = false;
            addChild(renderer);
            renderer.addEventListener(MouseEvent.CLICK,this.mailClick,false,0,true);
         }
      }
      
      private function mailClick(e:Event) : void
      {
         var mr:MailRenderer = null;
         var selectedRenderer:MailRenderer = MailRenderer(e.currentTarget);
         for(var i:int = 0; i < numChildren; i++)
         {
            mr = MailRenderer(getChildAt(i));
            if(Boolean(mr) && mr != selectedRenderer)
            {
               mr.selected = false;
            }
         }
         selectedRenderer.selected = true;
         this.selectedMail = selectedRenderer.mail;
      }
      
      [Bindable("mailSelected")]
      public function set selectedMail(value:Mail) : void
      {
         if(this._selectedMail == value)
         {
            return;
         }
         this._selectedMail = value;
         dispatchEvent(new Event(MAIL_SELECTED));
      }
      
      public function get selectedMail() : Mail
      {
         return this._selectedMail;
      }
   }
}

