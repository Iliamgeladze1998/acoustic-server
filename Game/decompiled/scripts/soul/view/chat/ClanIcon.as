package soul.view.chat
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import soul.net.ServerLayer;
   import soul.view.ui.Component;
   
   public class ClanIcon extends Component
   {
      
      public static const size:uint = 15;
      
      private static const cache:Object = {};
      
      private var icon:Bitmap = new Bitmap();
      
      private var _clanId:Number;
      
      private var _bitmapData:BitmapData;
      
      public function ClanIcon()
      {
         super();
         addChild(this.icon);
      }
      
      public function set clanId(value:Number) : void
      {
         this._clanId = value;
         if(Boolean(cache[this._clanId]))
         {
            this.draw();
         }
         else
         {
            ServerLayer.call("clanService","getIcon",this.setIcon,null,value);
         }
      }
      
      private function setIcon(value:ByteArray = null) : void
      {
         var bd:BitmapData = null;
         if(Boolean(value))
         {
            bd = new BitmapData(size,size,true,0);
            bd.setPixels(new Rectangle(0,0,size,size),value);
            cache[this._clanId] = bd;
            this.draw();
         }
      }
      
      [Bindable("bitmapDataChanged")]
      public function set bitmapData(value:BitmapData) : void
      {
         this._bitmapData = this.icon.bitmapData = value;
         dispatchEvent(new Event("bitmapDataChanged"));
      }
      
      public function get bitmapData() : BitmapData
      {
         return this._bitmapData;
      }
      
      override public function get width() : Number
      {
         return size;
      }
      
      override public function get height() : Number
      {
         return size;
      }
      
      private function draw() : void
      {
         this.bitmapData = cache[this._clanId];
      }
   }
}

