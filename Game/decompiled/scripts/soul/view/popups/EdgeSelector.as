package soul.view.popups
{
   import flash.events.MouseEvent;
   import soul.model.rtm.RTMModel;
   import soul.net.ServerLayer;
   import soul.view.assets.Assets;
   import soul.view.ui.BorderedContainer;
   
   public class EdgeSelector extends BorderedContainer
   {
      
      public var model:RTMModel;
      
      public function EdgeSelector()
      {
         super();
         direction = "vertical";
         padding = 5;
         borderSkin = Assets.tooltipBorder;
         visible = false;
      }
      
      public function show() : void
      {
         ServerLayer.call("rtmService","getEdges",this.setEdges);
      }
      
      private function setEdges(value:Array) : void
      {
         var load:int = 0;
         var child:EdgeInfoRenderer = null;
         var enabled:Boolean = false;
         if(!value)
         {
            return;
         }
         removeAllChildren();
         for(var i:int = 0; i < value.length; i++)
         {
            load = int(value[i]);
            child = new EdgeInfoRenderer();
            enabled = i != this.model.mapEdge;
            child.init(i,load,enabled);
            if(enabled)
            {
               child.addEventListener(MouseEvent.CLICK,this.onChildClick);
            }
            addChild(child);
         }
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         visible = true;
      }
      
      private function onChildClick(e:MouseEvent) : void
      {
         ServerLayer.call("rtmService","changeEdge",null,null,getChildIndex(e.currentTarget as EdgeInfoRenderer));
      }
      
      private function onMouseUp(e:MouseEvent) : void
      {
         visible = false;
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
      }
   }
}

