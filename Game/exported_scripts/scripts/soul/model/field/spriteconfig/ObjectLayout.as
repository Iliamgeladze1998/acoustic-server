package soul.model.field.spriteconfig
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   import soul.SoulNamespace;
   import soul.model.field.mapconfig.AspectRatio;
   
   public class ObjectLayout implements IEventDispatcher
   {
      
      public static const TAG:String = "objectLayout";
      
      private var _3355id:String;
      
      private var _3575610type:String;
      
      private var _989452712phases:Array;
      
      private var _3521p1:SpritePoint;
      
      private var _3522p2:SpritePoint;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function ObjectLayout()
      {
         super();
         this.phases = [new SpritePhase("0")];
         this.type = SpriteType.RAISED;
         this.p1 = new SpritePoint(0,0);
         this.p2 = new SpritePoint(10,0);
      }
      
      public static function fromXML(xml:XML) : ObjectLayout
      {
         var phaseX:XML = null;
         default xml namespace = SoulNamespace.nameSpace;
         var layout:ObjectLayout = new ObjectLayout();
         layout.id = xml.@id;
         layout.type = xml.@type == SpriteType.RAISED ? SpriteType.RAISED : SpriteType.GROUND;
         if(layout.type == SpriteType.RAISED)
         {
            layout.p1 = new SpritePoint(xml.p1.@x,xml.p1.@y);
            layout.p2 = new SpritePoint(xml.p2.@x,xml.p2.@y);
         }
         else
         {
            layout.p1 = null;
            layout.p2 = null;
         }
         layout.phases = [];
         for each(phaseX in xml[SpritePhase.TAG])
         {
            layout.phases.push(SpritePhase.fromXML(phaseX));
         }
         layout.applyAspectRatio();
         return layout;
      }
      
      public function toXML() : XML
      {
         var phase:SpritePhase = null;
         var p1:XML = null;
         var p2:XML = null;
         default xml namespace = SoulNamespace.nameSpace;
         this.removeAspectRatio();
         var xml:XML = new XML("<" + TAG + "/>");
         xml.@id = this.id;
         xml.@type = this.type;
         if(!this.phases || this.phases.length < 1)
         {
            throw new Error("Can\'t save object with zero phases");
         }
         for each(phase in this.phases)
         {
            xml.appendChild(phase.toXML());
         }
         if(this.type == SpriteType.RAISED)
         {
            p1 = new XML("<p1 x=\"" + this.p1.x + "\" y=\"" + this.p1.y + "\" />");
            xml.appendChild(p1);
            p2 = new XML("<p2 x=\"" + this.p2.x + "\" y=\"" + this.p2.y + "\" />");
            xml.appendChild(p2);
         }
         this.applyAspectRatio();
         return xml;
      }
      
      public function applyAspectRatio() : void
      {
         var phase:SpritePhase = null;
         default xml namespace = SoulNamespace.nameSpace;
         for each(phase in this.phases)
         {
            phase.applyAspectRatio();
         }
         if(Boolean(this.p1))
         {
            this.p1.y /= AspectRatio.y;
         }
         if(Boolean(this.p2))
         {
            this.p2.y /= AspectRatio.y;
         }
      }
      
      public function removeAspectRatio() : void
      {
         var phase:SpritePhase = null;
         default xml namespace = SoulNamespace.nameSpace;
         for each(phase in this.phases)
         {
            phase.removeAspectRatio();
         }
         if(Boolean(this.p1))
         {
            this.p1.y *= AspectRatio.y;
         }
         if(Boolean(this.p2))
         {
            this.p2.y *= AspectRatio.y;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get id() : String
      {
         return this._3355id;
      }
      
      public function set id(param1:String) : void
      {
         var _loc2_:Object = this._3355id;
         if(_loc2_ !== param1)
         {
            this._3355id = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"id",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get type() : String
      {
         return this._3575610type;
      }
      
      public function set type(param1:String) : void
      {
         var _loc2_:Object = this._3575610type;
         if(_loc2_ !== param1)
         {
            this._3575610type = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"type",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get phases() : Array
      {
         return this._989452712phases;
      }
      
      public function set phases(param1:Array) : void
      {
         var _loc2_:Object = this._989452712phases;
         if(_loc2_ !== param1)
         {
            this._989452712phases = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"phases",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get p1() : SpritePoint
      {
         return this._3521p1;
      }
      
      public function set p1(param1:SpritePoint) : void
      {
         var _loc2_:Object = this._3521p1;
         if(_loc2_ !== param1)
         {
            this._3521p1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"p1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get p2() : SpritePoint
      {
         return this._3522p2;
      }
      
      public function set p2(param1:SpritePoint) : void
      {
         var _loc2_:Object = this._3522p2;
         if(_loc2_ !== param1)
         {
            this._3522p2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"p2",_loc2_,param1));
            }
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}

