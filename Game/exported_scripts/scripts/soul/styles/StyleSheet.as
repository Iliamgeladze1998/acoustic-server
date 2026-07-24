package soul.styles
{
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import mx.utils.StringUtil;
   import soul.view.ui.Component;
   
   public class StyleSheet
   {
      
      private static const CLASS_REFERENCE:String = "ClassReference";
      
      private var data:Object;
      
      public function StyleSheet(css:String)
      {
         var part:String = null;
         var parsedPart:Array = null;
         this.data = {};
         super();
         css = css.replace(/\t/g,"");
         css = css.replace(/\r/g,"");
         css = css.replace(/\/\/.*\n/g,"");
         css = css.replace(/\n/g,"");
         css = css.replace(/\/\*.*\*\//g,"");
         var parts:Array = css.split("}");
         for each(part in parts)
         {
            parsedPart = this.parsePart(part);
            if(Boolean(parsedPart))
            {
               this.data[parsedPart[0]] = parsedPart[1];
            }
         }
      }
      
      private function parsePart(part:String) : Array
      {
         var param:String = null;
         var arr:Array = part.split("{");
         if(arr.length < 2)
         {
            return null;
         }
         var klass:String = StringUtil.trim(arr[0]);
         var params:Array = arr[1].split(";");
         var data:Object = {};
         for each(param in params)
         {
            arr = param.split(":");
            if(arr.length >= 2)
            {
               data[StringUtil.trim(arr[0])] = this.parseVariable(arr[1]);
            }
         }
         return [klass,data];
      }
      
      private function parseVariable(str:String) : *
      {
         var reference:String = null;
         var arr:Array = null;
         var symbol:String = null;
         var klass:Object = null;
         var value:Object = null;
         str = StringUtil.trim(str);
         if(str.charAt(0) == "#")
         {
            return Number("0x" + str.substr(1));
         }
         if(str.indexOf(CLASS_REFERENCE) == 0)
         {
            reference = str.substring(CLASS_REFERENCE.length + 1,str.length - 1);
            arr = reference.split("#");
            if(arr.length < 2)
            {
               return getDefinitionByName(reference);
            }
            reference = arr[0];
            symbol = arr[1];
            try
            {
               klass = getDefinitionByName(reference);
            }
            catch(e:Error)
            {
            }
            if(!klass)
            {
               return null;
            }
            try
            {
               value = klass[symbol];
            }
            catch(e:Error)
            {
            }
            return value;
         }
         return str;
      }
      
      public function getStyleForClass(target:Component) : Object
      {
         var prop:String = null;
         var bundle:Object = null;
         var className:String = getQualifiedClassName(target).replace("::",".");
         var styleName:String = target.styleName;
         var obj:Object = {};
         bundle = this.data[className];
         for(prop in bundle)
         {
            obj[prop] = bundle[prop];
         }
         if(!styleName)
         {
            return obj;
         }
         bundle = this.data["." + styleName];
         for(prop in bundle)
         {
            obj[prop] = bundle[prop];
         }
         bundle = this.data[className + "." + styleName];
         for(prop in bundle)
         {
            obj[prop] = bundle[prop];
         }
         return obj;
      }
   }
}

