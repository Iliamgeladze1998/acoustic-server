package spark.components.supportClasses
{
   import mx.core.ContainerGlobals;
   import mx.core.IFlexDisplayObject;
   import mx.core.mx_internal;
   import mx.managers.IFocusManagerContainer;
   
   use namespace mx_internal;
   
   [Exclude(name="focusThickness",kind="style")]
   [Exclude(name="focusBlendMode",kind="style")]
   [SkinState("disabled")]
   [SkinState("normal")]
   public class SkinnableContainerBase extends SkinnableComponent implements IFocusManagerContainer
   {
      
      mx_internal static const VERSION:String = "4.5.1.21328";
      
      private var _defaultButton:IFlexDisplayObject;
      
      public function SkinnableContainerBase()
      {
         super();
      }
      
      [Inspectable(category="General")]
      public function get defaultButton() : IFlexDisplayObject
      {
         return this._defaultButton;
      }
      
      public function set defaultButton(value:IFlexDisplayObject) : void
      {
         this._defaultButton = value;
         ContainerGlobals.focusedContainer = null;
      }
      
      override protected function getCurrentSkinState() : String
      {
         return enabled ? "normal" : "disabled";
      }
   }
}

