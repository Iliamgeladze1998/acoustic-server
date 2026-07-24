package soul.model
{
   public class LabelTab
   {
      
      public var key:String;
      
      public var label:String;
      
      public var enabled:Boolean;
      
      public function LabelTab(key:String, label:String, enabled:Boolean = true)
      {
         super();
         this.key = key;
         this.label = label;
         this.enabled = enabled;
      }
   }
}

