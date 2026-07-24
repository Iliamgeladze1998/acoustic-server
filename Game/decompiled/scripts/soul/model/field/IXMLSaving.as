package soul.model.field
{
   public interface IXMLSaving
   {
      
      function toXML() : XML;
      
      function applyAspectRatio() : void;
      
      function removeAspectRatio() : void;
   }
}

