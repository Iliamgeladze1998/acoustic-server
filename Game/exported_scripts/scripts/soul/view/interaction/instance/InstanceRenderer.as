package soul.view.interaction.instance
{
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.character.InstanceRecord;
   import soul.utils.DateUtils;
   import soul.view.ui.Component;
   import soul.view.ui.SimpleLabel;
   
   public class InstanceRenderer extends Component
   {
      
      private var instanceName:TextField = new SimpleLabel();
      
      private var instanceTime:TextField = new SimpleLabel();
      
      public function InstanceRenderer()
      {
         super();
         this.instanceName.autoSize = TextFieldAutoSize.NONE;
         this.instanceName.width = 200;
         this.instanceTime.autoSize = TextFieldAutoSize.NONE;
         this.instanceTime.width = 120;
         this.instanceTime.x = 200;
         var tf:TextFormat = this.instanceTime.defaultTextFormat;
         tf.align = "center";
         this.instanceTime.defaultTextFormat = tf;
         this.instanceTime.textColor = 16711680;
         addChild(this.instanceName);
         addChild(this.instanceTime);
      }
      
      public function set record(value:InstanceRecord) : void
      {
         this.instanceName.text = LocaleManager.getString(BundleName.SECTOR,value.sectorId);
         this.instanceTime.text = DateUtils.getTimeLeft(value.timeLeft);
      }
   }
}

