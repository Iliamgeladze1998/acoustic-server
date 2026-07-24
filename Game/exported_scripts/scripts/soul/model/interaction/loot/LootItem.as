package soul.model.interaction.loot
{
   import soul.model.item.Item;
   
   public class LootItem
   {
      
      public var id:String;
      
      public var templateId:String;
      
      public var itemClass:String;
      
      public var imagePath:String;
      
      public var count:int;
      
      public var confirmBinding:Boolean;
      
      public var binding:String;
      
      public function LootItem()
      {
         super();
      }
      
      public static function toItem(loot:LootItem) : Item
      {
         if(!loot)
         {
            return null;
         }
         var i:Item = new Item();
         i.id = loot.id;
         i.itemClass = loot.itemClass;
         i.templateId = loot.templateId;
         i.imagePath = loot.imagePath;
         i.count = loot.count;
         i.binding = loot.binding;
         i.confirmBinding = loot.confirmBinding;
         return i;
      }
   }
}

