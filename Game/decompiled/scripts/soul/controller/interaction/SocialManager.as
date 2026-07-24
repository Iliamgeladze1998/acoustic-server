package soul.controller.interaction
{
   import soul.controller.IManager;
   import soul.event.SocialEvent;
   import soul.model.interaction.social.SocialElement;
   import soul.model.interaction.social.SocialModel;
   import soul.net.ComponentLocator;
   import soul.net.ServerLayer;
   
   public class SocialManager implements IManager
   {
      
      private static const SERVICE:String = "socialService";
      
      public var model:SocialModel;
      
      public function SocialManager(model:SocialModel)
      {
         super();
         this.model = model;
         ComponentLocator.setComponent(ComponentLocator.SOCIAL,this);
         model.addEventListener(SocialEvent.ADD,this.addElement);
         model.addEventListener(SocialEvent.REMOVE,this.removeElement);
         ServerLayer.call(SERVICE,ComponentLocator.READY);
      }
      
      public function reset() : void
      {
         this.model.removeEventListener(SocialEvent.ADD,this.addElement);
         this.model.removeEventListener(SocialEvent.REMOVE,this.removeElement);
      }
      
      public function init(data:Object) : void
      {
         var arr:Array = null;
         for each(arr in data)
         {
            arr.sortOn("name");
         }
         this.model.socialLists = data;
      }
      
      public function addElement(e:SocialEvent) : void
      {
         ServerLayer.call(SERVICE,"add",null,null,e.characterName,e.listType);
      }
      
      public function removeElement(e:SocialEvent) : void
      {
         ServerLayer.call(SERVICE,"remove",null,null,e.characterId,e.listType);
      }
      
      public function add(value:SocialElement, type:String) : void
      {
         trace("SocialManager.add()",arguments);
         var arr:Array = this.model.socialLists[type];
         arr.push(value);
         arr.sortOn("name");
         this.model.dispatchEvent(new SocialEvent(SocialEvent.LIST_CHANGED));
      }
      
      public function remove(id:String, type:String) : void
      {
         var element:SocialElement = null;
         trace("SocialManager.remove()",arguments);
         var arr:Array = this.model.socialLists[type];
         for each(element in arr)
         {
            if(element.id == id)
            {
               arr.splice(arr.indexOf(element),1);
            }
         }
         this.model.dispatchEvent(new SocialEvent(SocialEvent.LIST_CHANGED));
      }
      
      public function update(element:SocialElement, type:String) : void
      {
         var oldElement:SocialElement = null;
         trace("SocialManager.remove()",arguments);
         var arr:Array = this.model.socialLists[type];
         for each(oldElement in arr)
         {
            if(oldElement.id == element.id)
            {
               arr.splice(arr.indexOf(oldElement),1,element);
            }
         }
         this.model.dispatchEvent(new SocialEvent(SocialEvent.LIST_CHANGED));
      }
   }
}

