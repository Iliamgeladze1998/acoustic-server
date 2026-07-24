package soul.view.ui.controls.menu
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import soul.event.MenuEvent;
   import soul.view.ui.Component;
   import soul.view.ui.controls.PopupManager;
   import soul.view.ui.soul_internal;
   
   use namespace soul_internal;
   
   public class Menu extends Component
   {
      
      public var typeField:String = "type";
      
      public var labelField:String = "label";
      
      public var childrenField:String = "children";
      
      public var toggledField:String = "toggled";
      
      public var enabledField:String = "enabled";
      
      public var subMenuStyle:String;
      
      private var data:Object;
      
      private var container:DisplayObjectContainer;
      
      private var child:SubMenu;
      
      public function Menu()
      {
         super();
         cacheAsBitmap = true;
      }
      
      public static function createMenu(container:DisplayObjectContainer, data:Object) : Menu
      {
         if(!container || !data)
         {
            return null;
         }
         var menu:Menu = new Menu();
         menu.container = container;
         menu.data = data;
         return menu;
      }
      
      public function show(x:int, y:int) : void
      {
         this.child = this.createSubMenu(this.data);
         addChild(this.child);
         this.x = x;
         this.y = y;
         PopupManager.addPopup(this,this.container);
         this.container.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
      }
      
      private function createSubMenu(data:Object) : SubMenu
      {
         var sm:SubMenu = new SubMenu();
         sm.owner = this;
         sm.labelField = this.labelField;
         sm.typeField = this.typeField;
         sm.childrenField = this.childrenField;
         sm.toggledField = this.toggledField;
         sm.enabledField = this.enabledField;
         sm.styleName = this.subMenuStyle;
         sm.data = data;
         return sm;
      }
      
      soul_internal function createChildMenu(child:Sprite, data:Object) : SubMenu
      {
         var p:Point = child.localToGlobal(new Point(child.width,0));
         var p2:Point = globalToLocal(p);
         var sm:SubMenu = this.createSubMenu(data);
         sm.x = p2.x;
         sm.y = p2.y;
         addChild(sm);
         return sm;
      }
      
      soul_internal function triggerClick(data:Object) : void
      {
         var ne:MenuEvent = new MenuEvent(MenuEvent.ITEM_CLICK);
         ne.item = data;
         dispatchEvent(ne);
         this.hide();
      }
      
      private function onMouseDown(e:MouseEvent) : void
      {
         var target:DisplayObject = e.target as DisplayObject;
         var inside:Boolean = false;
         while(Boolean(target))
         {
            if(target is Menu)
            {
               inside = true;
               return;
            }
            target = target.parent;
         }
         if(!inside)
         {
            this.hide();
         }
      }
      
      private function hide() : void
      {
         this.container.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         PopupManager.removePopup(this);
      }
   }
}

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.geom.Point;
import soul.event.SimpleUIEvent;
import soul.view.ui.BorderedContainer;
import soul.view.ui.Box;
import soul.view.ui.BoxDirection;
import soul.view.ui.Component;
import soul.view.ui.Container;
import soul.view.ui.Label;
import soul.view.ui.soul_internal;

use namespace soul_internal;

class SubMenu extends BorderedContainer
{
   
   public var owner:Menu;
   
   public var typeField:String;
   
   public var labelField:String;
   
   public var childrenField:String;
   
   public var toggledField:String;
   
   public var enabledField:String;
   
   public var menuItemRendererStyle:String;
   
   private var child:SubMenu;
   
   private var _data:Object;
   
   private var maxChildSize:int = 0;
   
   public function SubMenu()
   {
      super();
      direction = BoxDirection.VERTICAL;
      addEventListener(SimpleUIEvent.CREATION_COMPLETE,this.creationComplete);
   }
   
   private function creationComplete(e:SimpleUIEvent) : void
   {
      this.createMenus();
   }
   
   public function set data(value:Object) : void
   {
      this._data = value;
      if(initialized)
      {
         this.createMenus();
      }
   }
   
   private function createMenus() : void
   {
      var item:Object = null;
      var child:MenuItem = null;
      removeAllChildren();
      if(!this._data)
      {
         return;
      }
      for each(item in this._data)
      {
         child = new MenuItem();
         child.owner = this;
         child.styleName = this.menuItemRendererStyle;
         child.labelField = this.labelField;
         child.typeField = this.typeField;
         child.childrenField = this.childrenField;
         child.toggledField = this.toggledField;
         child.enabledField = this.enabledField;
         child.addEventListener(MouseEvent.MOUSE_OVER,this.onChildOver,false,0,true);
         child.addEventListener(MouseEvent.CLICK,this.onChildClick,false,0,true);
         child.data = item;
         addChild(child);
      }
   }
   
   private function onChildOver(e:MouseEvent) : void
   {
      if(Boolean(this.child))
      {
         this.child.parent.removeChild(this.child);
         this.child = null;
      }
      var sm:MenuItem = e.currentTarget as MenuItem;
      if(Boolean(sm.data[this.childrenField]))
      {
         this.child = this.owner.soul_internal::createChildMenu(sm,sm.data[this.childrenField]);
      }
   }
   
   private function onChildClick(e:MouseEvent) : void
   {
      var sm:MenuItem = e.currentTarget as MenuItem;
      if(!sm.data[this.childrenField])
      {
         this.owner.soul_internal::triggerClick(sm.data);
      }
   }
   
   public function set childSize(value:int) : void
   {
      if(value > this.maxChildSize)
      {
         this.maxChildSize = value;
         callLater(this.applyMaxChildSize);
      }
   }
   
   private function applyMaxChildSize() : void
   {
      var child:MenuItem = null;
      if(!stage)
      {
         return;
      }
      for(var i:uint = 0; i < numChildren; i++)
      {
         child = getChildAt(i) as MenuItem;
         child.maxSize = this.maxChildSize;
      }
      var p:Point = localToGlobal(new Point(width,height));
      var dx:int = stage.stageWidth - p.x;
      var dy:int = stage.stageHeight - p.y;
      if(dx < 0)
      {
         x += dx;
      }
      if(dy < 0)
      {
         y += dy;
      }
      visible = true;
   }
}

class MenuItem extends Component
{
   
   public var typeField:String;
   
   public var labelField:String;
   
   public var childrenField:String;
   
   public var toggledField:String;
   
   public var enabledField:String;
   
   public var paddingLeft:int = 20;
   
   public var paddingRight:int = 20;
   
   public var owner:SubMenu;
   
   public var radioIcon:Class = RadioIcon;
   
   public var branchIcon:Class = BranchIcon;
   
   private var leftIcon:Sprite;
   
   private var label:Label = new Label();
   
   private var rightIcon:Sprite;
   
   private var initialized:Boolean = true;
   
   private var _data:Object;
   
   private var _maxSize:int;
   
   public function MenuItem()
   {
      super();
      mouseChildren = false;
   }
   
   public function set data(value:Object) : void
   {
      this._data = value;
      if(this.initialized)
      {
         this.redraw();
      }
   }
   
   public function get data() : Object
   {
      return this._data;
   }
   
   public function set color(value:uint) : void
   {
      this.label.color = value;
   }
   
   public function set maxSize(value:int) : void
   {
      this._maxSize = value;
      if(value > width)
      {
         this.redraw();
      }
   }
   
   override protected function applySize() : void
   {
   }
   
   override protected function redraw() : void
   {
      while(numChildren > 0)
      {
         removeChildAt(0);
      }
      if(!this._data)
      {
         return;
      }
      this.label.text = this._data[this.labelField];
      switch(this._data[this.typeField])
      {
         case "radio":
            if(Boolean(this._data[this.toggledField]) && Boolean(this.radioIcon))
            {
               this.leftIcon = new this.radioIcon();
            }
      }
      if(Boolean(this._data[this.childrenField]) && Boolean(this.branchIcon))
      {
         this.rightIcon = new this.branchIcon();
      }
      enabled = !(this._data[this.enabledField] === false || this._data[this.enabledField] == "false");
      addChild(this.label);
      if(Boolean(this.leftIcon))
      {
         addChild(this.leftIcon);
      }
      if(Boolean(this.rightIcon))
      {
         addChild(this.rightIcon);
      }
      height = this.label.height;
      width = Math.max(this._maxSize,this.paddingLeft + this.label.width + this.paddingRight);
      graphics.clear();
      graphics.beginFill(0,0);
      graphics.drawRect(0,0,width,height);
      graphics.endFill();
      this.label.x = this.paddingLeft;
      if(Boolean(this.leftIcon))
      {
         this.leftIcon.x = (this.paddingLeft - this.leftIcon.width) / 2;
         this.leftIcon.y = (height - this.leftIcon.height) / 2;
      }
      if(Boolean(this.rightIcon))
      {
         this.rightIcon.x = width - this.rightIcon.width - 2;
         this.rightIcon.y = (height - this.rightIcon.height) / 2;
      }
      if(width > this._maxSize && Boolean(this.owner))
      {
         this.owner.childSize = width;
      }
   }
}

class BranchIcon extends Label
{
   
   public function BranchIcon()
   {
      super();
      color = 16777215;
      text = ">";
   }
}

class RadioIcon extends Label
{
   
   public function RadioIcon()
   {
      super();
      color = 16777215;
      text = "v";
   }
}
