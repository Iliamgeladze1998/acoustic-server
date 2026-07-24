package soul.model.item
{
   public class ItemShortcut
   {
      
      public var templateId:String;
      
      public var abilityId:String;
      
      public var imagePath:String;
      
      public var itemClass:String;
      
      public var level:int;
      
      public function ItemShortcut()
      {
         super();
      }
      
      public function toItem() : Item
      {
         var item:Item = new Item();
         item.templateId = this.templateId;
         item.abilityId = this.abilityId;
         item.imagePath = this.imagePath;
         item.itemClass = this.itemClass;
         item.level = this.level;
         return item;
      }
   }
}

