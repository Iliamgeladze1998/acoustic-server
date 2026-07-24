package soul.view.sprite
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import flash.net.registerClassAlias;
   import flash.utils.ByteArray;
   
   public class SpriteEntry
   {
      
      registerClassAlias("SpriteEntry",SpriteEntry);
      
      public var x:int;
      
      public var y:int;
      
      public var bitmapData:BitmapData;
      
      public function SpriteEntry(bitmapData:BitmapData = null, x:int = 0, y:int = 0)
      {
         super();
         this.x = x;
         this.y = y;
         this.bitmapData = bitmapData;
      }
      
      public function setBytes(input:ByteArray) : void
      {
         var width:uint = 0;
         var height:uint = 0;
         var transparent:Boolean = false;
         var src:ByteArray = null;
         this.x = input.readInt();
         this.y = input.readInt();
         if(input.readBoolean())
         {
            width = input.readUnsignedInt();
            height = input.readUnsignedInt();
            transparent = input.readBoolean();
            src = new ByteArray();
            input.readBytes(src,0,width * height * 4);
            this.bitmapData = new BitmapData(width,height,transparent);
            this.bitmapData.setPixels(new Rectangle(0,0,width,height),src);
         }
      }
      
      public function getBytes() : ByteArray
      {
         var output:ByteArray = new ByteArray();
         output.writeInt(this.x);
         output.writeInt(this.y);
         if(Boolean(this.bitmapData))
         {
            output.writeBoolean(true);
            output.writeUnsignedInt(this.bitmapData.width);
            output.writeUnsignedInt(this.bitmapData.height);
            output.writeBoolean(this.bitmapData.transparent);
            output.writeBytes(this.bitmapData.getPixels(new Rectangle(0,0,this.bitmapData.width,this.bitmapData.height)));
         }
         return output;
      }
   }
}

