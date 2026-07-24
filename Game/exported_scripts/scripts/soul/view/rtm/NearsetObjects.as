package soul.view.rtm
{
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import soul.controller.shortcut.InteractShortcut;
   import soul.controller.shortcut.ShortcutManager;
   import soul.event.FieldEvent;
   import soul.model.rtm.RTMModel;
   import soul.view.field.visual.FieldObject;
   import soul.view.ui.HBox;
   
   public class NearsetObjects extends HBox
   {
      
      public var model:RTMModel;
      
      private var childs:Vector.<ShortcutRenderer>;
      
      public function NearsetObjects()
      {
         var child:ShortcutRenderer = null;
         this.childs = new Vector.<ShortcutRenderer>();
         super();
         gap = 1;
         addEventListener(Event.ADDED_TO_STAGE,this.added);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
         for(var i:uint = 0; i < 4; i++)
         {
            child = new ShortcutRenderer();
            child.addEventListener(MouseEvent.CLICK,this.onChildClick);
            this.childs.push(child);
         }
      }
      
      private function added(e:Event) : void
      {
         ShortcutManager.addShortcutListener(InteractShortcut.instance,this.interact,InteractShortcut.USE_INTERACTIVE,false);
      }
      
      private function removed(e:Event) : void
      {
         ShortcutManager.removeShortcutListener(InteractShortcut.instance,this.interact,false);
      }
      
      public function set dataProvider(value:Array) : void
      {
         var fo:FieldObject = null;
         var child:ShortcutRenderer = null;
         removeAllChildren(false);
         if(!value)
         {
            return;
         }
         for(var index:uint = 0; index < value.length; index++)
         {
            fo = value[index];
            child = this.childs[index];
            child.object = fo;
            addChild(child);
         }
         updateNow();
      }
      
      private function onChildClick(e:MouseEvent) : void
      {
         var fo:FieldObject = ShortcutRenderer(e.currentTarget).object;
         this.activateObject(fo);
      }
      
      private function interact(e:KeyboardEvent) : void
      {
         var sr:ShortcutRenderer = getChildAt(0) as ShortcutRenderer;
         if(Boolean(sr) && Boolean(sr.object))
         {
            this.activateObject(sr.object);
         }
      }
      
      private function activateObject(fo:FieldObject) : void
      {
         if(!fo || !this.model)
         {
            return;
         }
         var ne:FieldEvent = new FieldEvent(FieldEvent.CS_USE_OBJECT);
         ne.data = fo.id;
         this.model.dispatchEvent(ne);
      }
   }
}

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.EventDispatcher;
import flash.filters.DropShadowFilter;
import soul.controller.locale.BundleName;
import soul.controller.locale.LocaleManager;
import soul.view.common.Icons;
import soul.view.field.visual.FieldObject;
import soul.view.ui.CachedImage;
import soul.view.ui.Component;
import soul.view.ui.Label;

class ShortcutRenderer extends Component
{
   
   private static const LABEL_FILTERS:Array = [new DropShadowFilter(0,0,0,1,3,3,8,2)];
   
   private const icon:CachedImage = new CachedImage();
   
   private const key:Label = new Label();
   
   private var _object:FieldObject;
   
   public function ShortcutRenderer()
   {
      super();
      mouseChildren = false;
      width = height = 40;
      this.icon.source = Icons.shortcut;
      this.key.x = 25;
      this.key.y = 22;
      this.key.filters = LABEL_FILTERS;
      addChild(this.icon);
      addChild(this.key);
   }
   
   public function get object() : FieldObject
   {
      return this._object;
   }
   
   public function set object(value:FieldObject) : void
   {
      this._object = value;
      toolTip = LocaleManager.getString(BundleName.HINT,value.tooltipId);
   }
}
