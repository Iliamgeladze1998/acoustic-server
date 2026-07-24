package
{
   import flash.net.getClassByAlias;
   import flash.net.registerClassAlias;
   import flash.system.*;
   import flash.utils.*;
   import mx.collections.ArrayCollection;
   import mx.collections.ArrayList;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.effects.EffectManager;
   import mx.managers.SystemManagerGlobals;
   import mx.managers.systemClasses.ChildManager;
   import mx.resources.ResourceManager;
   import mx.styles.IStyleManager2;
   import mx.styles.StyleManagerImpl;
   import mx.utils.ObjectProxy;
   
   [Mixin]
   public class _SoulAir_FlexInit
   {
      
      public function _SoulAir_FlexInit()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var styleNames:Array;
         var i:int;
         var styleManager:IStyleManager2 = null;
         var fbs:IFlexModuleFactory = param1;
         new ChildManager(fbs);
         styleManager = new StyleManagerImpl(fbs);
         EffectManager.mx_internal::registerEffectTrigger("addedEffect","added");
         EffectManager.mx_internal::registerEffectTrigger("closeEffect","windowClose");
         EffectManager.mx_internal::registerEffectTrigger("creationCompleteEffect","creationComplete");
         EffectManager.mx_internal::registerEffectTrigger("focusInEffect","focusIn");
         EffectManager.mx_internal::registerEffectTrigger("focusOutEffect","focusOut");
         EffectManager.mx_internal::registerEffectTrigger("hideEffect","hide");
         EffectManager.mx_internal::registerEffectTrigger("itemsChangeEffect","itemsChange");
         EffectManager.mx_internal::registerEffectTrigger("minimizeEffect","windowMinimize");
         EffectManager.mx_internal::registerEffectTrigger("mouseDownEffect","mouseDown");
         EffectManager.mx_internal::registerEffectTrigger("mouseUpEffect","mouseUp");
         EffectManager.mx_internal::registerEffectTrigger("moveEffect","move");
         EffectManager.mx_internal::registerEffectTrigger("removedEffect","removed");
         EffectManager.mx_internal::registerEffectTrigger("resizeEffect","resize");
         EffectManager.mx_internal::registerEffectTrigger("resizeEndEffect","resizeEnd");
         EffectManager.mx_internal::registerEffectTrigger("resizeStartEffect","resizeStart");
         EffectManager.mx_internal::registerEffectTrigger("rollOutEffect","rollOut");
         EffectManager.mx_internal::registerEffectTrigger("rollOverEffect","rollOver");
         EffectManager.mx_internal::registerEffectTrigger("showEffect","show");
         EffectManager.mx_internal::registerEffectTrigger("unminimizeEffect","windowUnminimize");
         try
         {
            if(getClassByAlias("flex.messaging.io.ArrayCollection") != ArrayCollection)
            {
               registerClassAlias("flex.messaging.io.ArrayCollection",ArrayCollection);
               if(fbs != SystemManagerGlobals.topLevelSystemManagers[0])
               {
                  trace(ResourceManager.getInstance().getString("core","remoteClassMemoryLeak",["mx.collections.ArrayCollection","SoulAir","_SoulAir_FlexInit"]));
               }
            }
         }
         catch(e:Error)
         {
            registerClassAlias("flex.messaging.io.ArrayCollection",ArrayCollection);
            if(fbs != SystemManagerGlobals.topLevelSystemManagers[0])
            {
               trace(ResourceManager.getInstance().getString("core","remoteClassMemoryLeak",["mx.collections.ArrayCollection","SoulAir","_SoulAir_FlexInit"]));
            }
         }
         try
         {
            if(getClassByAlias("flex.messaging.io.ArrayList") != ArrayList)
            {
               registerClassAlias("flex.messaging.io.ArrayList",ArrayList);
               if(fbs != SystemManagerGlobals.topLevelSystemManagers[0])
               {
                  trace(ResourceManager.getInstance().getString("core","remoteClassMemoryLeak",["mx.collections.ArrayList","SoulAir","_SoulAir_FlexInit"]));
               }
            }
         }
         catch(e:Error)
         {
            registerClassAlias("flex.messaging.io.ArrayList",ArrayList);
            if(fbs != SystemManagerGlobals.topLevelSystemManagers[0])
            {
               trace(ResourceManager.getInstance().getString("core","remoteClassMemoryLeak",["mx.collections.ArrayList","SoulAir","_SoulAir_FlexInit"]));
            }
         }
         try
         {
            if(getClassByAlias("flex.messaging.io.ObjectProxy") != ObjectProxy)
            {
               registerClassAlias("flex.messaging.io.ObjectProxy",ObjectProxy);
               if(fbs != SystemManagerGlobals.topLevelSystemManagers[0])
               {
                  trace(ResourceManager.getInstance().getString("core","remoteClassMemoryLeak",["mx.utils.ObjectProxy","SoulAir","_SoulAir_FlexInit"]));
               }
            }
         }
         catch(e:Error)
         {
            registerClassAlias("flex.messaging.io.ObjectProxy",ObjectProxy);
            if(fbs != SystemManagerGlobals.topLevelSystemManagers[0])
            {
               trace(ResourceManager.getInstance().getString("core","remoteClassMemoryLeak",["mx.utils.ObjectProxy","SoulAir","_SoulAir_FlexInit"]));
            }
         }
         styleNames = ["lineHeight","unfocusedTextSelectionColor","kerning","iconColor","textRollOverColor","showErrorSkin","digitCase","inactiveTextSelectionColor","listAutoPadding","showErrorTip","justificationRule","textDecoration","dominantBaseline","fontThickness","textShadowColor","trackingRight","blockProgression","leadingModel","selectionDisabledColor","listStylePosition","textAlignLast","textShadowAlpha","textAlpha","letterSpacing","chromeColor","rollOverColor","fontSize","baselineShift","focusedTextSelectionColor","paragraphEndIndent","fontWeight","breakOpportunity","leading","symbolColor","renderingMode","barColor","fontSharpness","modalTransparencyDuration","paragraphStartIndent","layoutDirection","justificationStyle","footerColors","wordSpacing","listStyleType","contentBackgroundColor","paragraphSpaceAfter","contentBackgroundAlpha","fontAntiAliasType","textRotation","errorColor","cffHinting","direction","locale","backgroundDisabledColor","digitWidth","modalTransparencyColor","touchDelay"
         ,"ligatureLevel","textIndent","firstBaselineOffset","themeColor","clearFloats","modalTransparency","fontLookup","tabStops","paragraphSpaceBefore","headerColors","textAlign","fontFamily","textSelectedColor","interactionMode","lineThrough","whiteSpaceCollapse","fontGridFitType","alignmentBaseline","trackingLeft","fontStyle","dropShadowColor","accentColor","selectionColor","disabledColor","dropdownBorderColor","disabledIconColor","modalTransparencyBlur","focusColor","downColor","textJustify","color","alternatingItemColors","typographicCase"];
         i = 0;
         while(i < styleNames.length)
         {
            styleManager.registerInheritingStyle(styleNames[i]);
            i++;
         }
      }
   }
}

import mx.core.TextFieldFactory;

TextFieldFactory;

