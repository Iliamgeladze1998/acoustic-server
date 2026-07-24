package soul.view.rtm
{
   import flash.events.MouseEvent;
   import soul.controller.MenuManager;
   import soul.event.FieldEvent;
   import soul.model.common.MenuType;
   import soul.model.field.FieldUnit;
   import soul.view.assets.Colors;
   import soul.view.rtm.targetFrame.TargetFrame;
   
   public class Sticker extends TargetFrame
   {
      
      private var _id:String;
      
      public function Sticker()
      {
         super();
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
      }
      
      private function onMouseDown(e:MouseEvent) : void
      {
         parent.setChildIndex(this,parent.numChildren - 1);
         startDrag(false);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
      }
      
      private function onMouseUp(e:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         stopDrag();
      }
      
      public function set id(value:String) : void
      {
         if(this._id == value)
         {
            return;
         }
         this._id = value;
         if(Boolean(value))
         {
            model.addEventListener(FieldEvent.UNIT_CHANGED,this.unitChanged);
            unit = model.units[this.id];
         }
         else
         {
            model.removeEventListener(FieldEvent.UNIT_CHANGED,this.unitChanged);
            unit = null;
         }
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get isPlayer() : Boolean
      {
         return Boolean(unit) ? unit.character : false;
      }
      
      private function unitChanged(e:FieldEvent) : void
      {
         var newUnit:FieldUnit = null;
         var id:String = e.data;
         if(id != this._id && id != "*")
         {
            return;
         }
         var currentUnit:FieldUnit = unit;
         newUnit = model.units[id];
         if(Boolean(newUnit))
         {
            filters = [];
            unit = newUnit;
            alpha = 1;
         }
         else if(Boolean(currentUnit) && currentUnit.character)
         {
            filters = Colors.DISABLED_FILTER;
            alpha = 0.7;
         }
         else
         {
            close();
         }
      }
      
      override protected function avatarClick() : void
      {
         var e:FieldEvent = null;
         if(Boolean(model.activeAbility))
         {
            if(Boolean(unit) && unit.accepts(model.activeAbility))
            {
               model.activeUnit = unit;
               model.dispatchEvent(new FieldEvent(FieldEvent.ACCEPT_ABILITY));
            }
         }
         else if(model.targetUnit == unit)
         {
            model.dispatchEvent(new FieldEvent(FieldEvent.CS_INTERACT));
         }
         else
         {
            e = new FieldEvent(FieldEvent.CS_SELECT_TARGET);
            e.data = unit.id;
            model.dispatchEvent(e);
         }
      }
      
      override protected function menuClick() : void
      {
         if(!unit.character)
         {
            close();
            return;
         }
         MenuManager.create(MenuType.CHARACTER_MENU,unit.id,false,true);
      }
   }
}

