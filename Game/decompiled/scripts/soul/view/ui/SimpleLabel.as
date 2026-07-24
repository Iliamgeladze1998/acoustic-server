package soul.view.ui
{
   import flash.text.AntiAliasType;
   import flash.text.Font;
   import flash.text.FontType;
   import flash.text.GridFitType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class SimpleLabel extends TextField
   {
      
      public static const DEFAULT_FORMAT:TextFormat = new TextFormat("Verdana, Tahoma, _sans",11,12618080);
      
      public var minWidth:int;
      
      public var minHeight:int;
      
      public function SimpleLabel(tf:TextFormat = null)
      {
         super();
         multiline = false;
         selectable = false;
         autoSize = TextFieldAutoSize.LEFT;
         if(!tf)
         {
            tf = DEFAULT_FORMAT;
         }
         defaultTextFormat = tf;
         var font:Font = getFontByName(tf.font);
         if(Boolean(font) && font.fontType == FontType.EMBEDDED)
         {
            embedFonts = true;
            antiAliasType = AntiAliasType.ADVANCED;
            sharpness = 400;
            gridFitType = GridFitType.PIXEL;
         }
      }
      
      public static function getFontByName(name:String, deviceFonts:Boolean = true) : Font
      {
         var font:Font = null;
         var arr:Array = Font.enumerateFonts(deviceFonts);
         for each(font in arr)
         {
            if(font.fontName == name)
            {
               return font;
            }
         }
         return null;
      }
      
      public function set align(value:String) : void
      {
         autoSize = TextFieldAutoSize.NONE;
         var tf:TextFormat = defaultTextFormat;
         tf.align = value;
         defaultTextFormat = tf;
      }
      
      public function set fontSize(value:Number) : void
      {
         var tf:TextFormat = defaultTextFormat;
         tf.size = value;
         defaultTextFormat = tf;
      }
      
      override public function set width(value:Number) : void
      {
         if(autoSize != TextFieldAutoSize.NONE)
         {
            autoSize = TextFieldAutoSize.NONE;
         }
         super.width = value;
      }
      
      override public function get width() : Number
      {
         return Math.max(super.width,this.minWidth);
      }
      
      override public function set height(value:Number) : void
      {
         if(autoSize != TextFieldAutoSize.NONE)
         {
            autoSize = TextFieldAutoSize.NONE;
         }
         super.height = value;
      }
      
      override public function get height() : Number
      {
         return Math.max(super.height,this.minHeight);
      }
   }
}

