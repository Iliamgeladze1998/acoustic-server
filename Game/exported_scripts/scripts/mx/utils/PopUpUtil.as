package mx.utils
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.managers.ISystemManager;
   
   [ExcludeClass]
   public class PopUpUtil
   {
      
      public function PopUpUtil()
      {
         super();
      }
      
      public static function positionOverComponent(component:DisplayObject, systemManager:ISystemManager, popUpWidth:Number, popUpHeight:Number, verticalCenter:Number = NaN, popUpPosition:Point = null, regPoint:Point = null, ensureOnScreen:Boolean = true) : Point
      {
         var position:Point = null;
         var vc:Number = NaN;
         var screen:Rectangle = null;
         var topLeft:Point = null;
         var bottomRight:Point = null;
         var sm:ISystemManager = systemManager.topLevelSystemManager;
         var sbRoot:DisplayObject = sm.getSandboxRoot();
         var x:Number = 0;
         var y:Number = 0;
         if(Boolean(popUpPosition))
         {
            x = popUpPosition.x;
            y = popUpPosition.y;
         }
         else
         {
            if(!regPoint)
            {
               regPoint = new Point(0,0);
            }
            position = sbRoot.globalToLocal(component.localToGlobal(regPoint));
            x = position.x;
            y = position.y;
         }
         if(!isNaN(verticalCenter))
         {
            vc = sbRoot.globalToLocal(component.localToGlobal(new Point(0,verticalCenter))).y;
            y = vc - popUpHeight / 2;
         }
         if(ensureOnScreen)
         {
            screen = sm.getVisibleApplicationRect(null,true);
            topLeft = sbRoot.globalToLocal(screen.topLeft);
            bottomRight = sbRoot.globalToLocal(screen.bottomRight);
            x = Math.max(topLeft.x,Math.min(bottomRight.x - popUpWidth,x));
            y = Math.max(topLeft.y,Math.min(bottomRight.y - popUpHeight,y));
         }
         return new Point(x,y);
      }
   }
}

