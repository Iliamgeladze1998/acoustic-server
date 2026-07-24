package soul.sorting
{
   public interface ISpriteContainer
   {
      
      function spriteCount() : int;
      
      function getSpriteAt(param1:int) : Object;
      
      function getSpriteIndex(param1:Object) : int;
      
      function setSpriteIndex(param1:Object, param2:int) : void;
      
      function swapSprites(param1:Object, param2:Object) : void;
      
      function swapSpritesAt(param1:int, param2:int) : void;
   }
}

