package soul.view.field
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import soul.sorting.ISpriteContainer;
   
   public class SpriteContainer implements ISpriteContainer
   {
      
      private var container:DisplayObjectContainer;
      
      public function SpriteContainer(container:DisplayObjectContainer)
      {
         super();
         this.container = container;
      }
      
      public function spriteCount() : int
      {
         return this.container.numChildren;
      }
      
      public function getSpriteAt(i:int) : Object
      {
         return this.container.getChildAt(i);
      }
      
      public function getSpriteIndex(sprite:Object) : int
      {
         return this.container.getChildIndex(sprite as DisplayObject);
      }
      
      public function setSpriteIndex(sprite:Object, index:int) : void
      {
         this.container.setChildIndex(sprite as DisplayObject,index);
      }
      
      public function swapSpritesAt(index1:int, index2:int) : void
      {
         this.container.swapChildrenAt(index1,index2);
      }
      
      public function swapSprites(sprite1:Object, sprite2:Object) : void
      {
         this.container.swapChildren(sprite1 as DisplayObject,sprite2 as DisplayObject);
      }
   }
}

