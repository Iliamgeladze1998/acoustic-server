package soul.controller.character
{
   import soul.controller.IManager;
   import soul.event.CharacterEvent;
   import soul.event.InventoryEvent;
   import soul.model.character.CharacterData;
   import soul.model.character.CharacterModel;
   import soul.model.character.InstanceRecord;
   import soul.model.character.Reputation;
   import soul.net.ComponentLocator;
   import soul.net.ServerLayer;
   
   public class CharacterManager implements IManager
   {
      
      private static const SERVICE:String = "characterService";
      
      private var model:CharacterModel;
      
      public function CharacterManager(model:CharacterModel)
      {
         super();
         this.model = model;
         ComponentLocator.setComponent(ComponentLocator.CHARACTER,this);
         model.addEventListener(CharacterEvent.PREVIEW,this.previewChanges);
         model.addEventListener(CharacterEvent.ACCEPT,this.acceptChanges);
         model.addEventListener(InventoryEvent.CREATE_AUTO_RUNE_SHORTCUT,this.createAutoRune);
         model.addEventListener(InventoryEvent.REMOVE_AUTO_RUNE_SHORTCUT,this.removeAutoRune);
         ServerLayer.call(SERVICE,ComponentLocator.READY);
      }
      
      public function reset() : void
      {
         this.model.removeEventListener(CharacterEvent.PREVIEW,this.previewChanges);
         this.model.removeEventListener(CharacterEvent.ACCEPT,this.acceptChanges);
         this.model.removeEventListener(InventoryEvent.CREATE_AUTO_RUNE_SHORTCUT,this.createAutoRune);
         this.model.removeEventListener(InventoryEvent.REMOVE_AUTO_RUNE_SHORTCUT,this.removeAutoRune);
      }
      
      private function previewChanges(e:CharacterEvent) : void
      {
         ServerLayer.call(SERVICE,"previewPoints",this.setPreview,null,e.previewObject);
      }
      
      private function setPreview(value:Object) : void
      {
         this.model.previewParams = value;
      }
      
      private function acceptChanges(e:CharacterEvent) : void
      {
         ServerLayer.call(SERVICE,"changePoints",this.confirm,null,e.previewObject);
      }
      
      private function confirm(value:CharacterData) : void
      {
         this.model.load(value);
      }
      
      private function createAutoRune(e:InventoryEvent) : void
      {
         ServerLayer.call(SERVICE,"addAutoRune",null,null,e.itemId,e.slotIndex);
      }
      
      private function removeAutoRune(e:InventoryEvent) : void
      {
         ServerLayer.call(SERVICE,"addAutoRune",null,null,null,e.slotIndex);
      }
      
      public function init(r:* = null) : void
      {
      }
      
      public function changeMoney(currency:String, value:int) : void
      {
         this.model.currencies[currency] = value;
      }
      
      public function changeParam(paramType:String, value:Object) : void
      {
         this.model.params[paramType] = value;
      }
      
      public function changeCharProperty(propertyType:String, value:Object) : void
      {
         this.model.properties[propertyType] = value;
      }
      
      public function updateAvatar(path:String) : void
      {
         this.model.avatarImagePath = path;
      }
      
      public function changeReputation(type:String, level:int, xp:Number) : void
      {
         var rep:Reputation = null;
         trace("CharacterManager.changeReputation()",arguments);
         for each(rep in this.model.reputations)
         {
            if(rep.type == type)
            {
               rep.level = level;
               rep.xp = xp;
               break;
            }
            rep = null;
         }
         if(!rep)
         {
            rep = new Reputation();
            rep.type = type;
            rep.level = level;
            rep.xp = xp;
            this.model.reputations.push(rep);
         }
      }
      
      public function initAutoSlots(slots:Array) : void
      {
         this.model.autoSlots = slots;
      }
      
      public function addInstanceRecord(record:InstanceRecord) : void
      {
         if(!this.model.instances)
         {
            this.model.instances = [];
         }
         this.removeInstanceRecord(record.sectorId);
         this.model.instances.push(record);
         this.model.instances.sortOn("time");
      }
      
      public function removeInstanceRecord(sectorId:String) : void
      {
         var record:InstanceRecord = null;
         for each(record in this.model.instances)
         {
            if(record.sectorId == sectorId)
            {
               this.model.instances.splice(this.model.instances.indexOf(record),1);
            }
         }
      }
   }
}

