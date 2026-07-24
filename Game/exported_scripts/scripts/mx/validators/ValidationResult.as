package mx.validators
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class ValidationResult
   {
      
      mx_internal static const VERSION:String = "4.5.1.21328";
      
      public var errorCode:String;
      
      public var errorMessage:String;
      
      public var isError:Boolean;
      
      public var subField:String;
      
      public function ValidationResult(isError:Boolean, subField:String = "", errorCode:String = "", errorMessage:String = "")
      {
         super();
         this.isError = isError;
         this.subField = subField;
         this.errorMessage = errorMessage;
         this.errorCode = errorCode;
      }
   }
}

