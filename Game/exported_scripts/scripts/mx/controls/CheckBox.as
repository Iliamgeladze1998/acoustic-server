package mx.controls
{
   import flash.text.TextLineMetrics;
   import flash.utils.getQualifiedClassName;
   import mx.core.FlexVersion;
   import mx.core.IToggleButton;
   import mx.core.UITextField;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [Alternative(replacement="spark.components.CheckBox",since="4.0")]
   [IconFile("CheckBox.png")]
   [DefaultTriggerEvent("click")]
   [DefaultBindingProperty(source="selected",destination="selected")]
   [AccessibilityClass(implementation="mx.accessibility.CheckBoxAccImpl")]
   [Exclude(name="toggle",kind="property")]
   [Exclude(name="emphasized",kind="property")]
   [Style(name="symbolColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="disabledIconColor",type="uint",format="Color",inherit="yes",theme="halo")]
   [Style(name="iconColor",type="uint",format="Color",inherit="yes",theme="halo")]
   public class CheckBox extends Button implements IToggleButton
   {
      
      mx_internal static var createAccessibilityImplementation:Function;
      
      mx_internal static const VERSION:String = "4.5.1.21328";
      
      public function CheckBox()
      {
         super();
         mx_internal::_toggle = true;
         mx_internal::centerContent = false;
         mx_internal::extraSpacing = 8;
      }
      
      [Inspectable(environment="none")]
      override public function set emphasized(value:Boolean) : void
      {
      }
      
      [Inspectable(environment="none")]
      override public function set toggle(value:Boolean) : void
      {
      }
      
      override protected function initializeAccessibility() : void
      {
         if(CheckBox.mx_internal::createAccessibilityImplementation != null)
         {
            CheckBox.mx_internal::createAccessibilityImplementation(this);
         }
      }
      
      override protected function measure() : void
      {
         var lineMetrics:TextLineMetrics = null;
         var textH:Number = NaN;
         super.measure();
         if(!label && FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_0 && getQualifiedClassName(currentIcon).indexOf(".spark") >= 0)
         {
            lineMetrics = measureText(label);
            textH = lineMetrics.height + UITextField.TEXT_HEIGHT_PADDING;
            textH += getStyle("paddingTop") + getStyle("paddingBottom");
            measuredMinHeight = measuredHeight = Math.max(textH,measuredMinHeight);
         }
      }
   }
}

