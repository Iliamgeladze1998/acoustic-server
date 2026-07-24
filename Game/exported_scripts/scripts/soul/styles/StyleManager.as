package soul.styles
{
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import soul.view.ui.Component;
   
   public class StyleManager
   {
      
      public static const defaultManager:StyleManager = new StyleManager();
      
      private const styleCache:Dictionary = new Dictionary(true);
      
      private const localCache:Dictionary = new Dictionary(true);
      
      private var style:StyleSheet;
      
      public function StyleManager(data:Object = null)
      {
         super();
         this.load(data);
      }
      
      public function load(data:Object = null) : void
      {
         var css:String = null;
         if(data is Class)
         {
            data = new data();
         }
         if(data is ByteArray)
         {
            css = data.toString();
         }
         if(!css)
         {
            return;
         }
         this.style = new StyleSheet(css);
      }
      
      public function getStyle(target:Component, prop:String) : *
      {
         if(Boolean(this.localCache[target]))
         {
            return this.localCache[target][prop];
         }
         if(!this.style)
         {
            return null;
         }
         if(this.styleCache[target] == null)
         {
            this.styleCache[target] = this.style.getStyleForClass(target);
         }
         var style:Object = this.styleCache[target];
         return Boolean(style) ? style[prop] : null;
      }
      
      public function setStyle(target:Component, prop:String, value:*) : void
      {
         if(!this.localCache[target])
         {
            this.localCache[target] = {};
         }
         this.localCache[target][prop] = value;
      }
      
      public function applyStyle(target:Component) : void
      {
         var key:String = null;
         if(!this.style)
         {
            return;
         }
         var style:Object = this.style.getStyleForClass(target);
         for(key in style)
         {
            if(target.hasOwnProperty(key))
            {
               try
               {
                  target[key] = style[key];
               }
               catch(e:Error)
               {
               }
            }
         }
      }
   }
}

