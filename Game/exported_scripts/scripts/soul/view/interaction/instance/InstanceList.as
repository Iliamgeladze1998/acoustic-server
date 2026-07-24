package soul.view.interaction.instance
{
   import soul.model.character.InstanceRecord;
   import soul.view.ui.VBox;
   
   public class InstanceList extends VBox
   {
      
      public function InstanceList()
      {
         super();
      }
      
      public function set instances(value:Array) : void
      {
         var record:InstanceRecord = null;
         var child:InstanceRenderer = null;
         removeAllChildren();
         for each(record in value)
         {
            if(record.timeLeft > 0)
            {
               child = new InstanceRenderer();
               child.record = record;
               addChild(child);
            }
         }
      }
   }
}

