package soul.model.ability
{
   import flash.events.EventDispatcher;
   import flash.utils.describeType;
   
   [Event(name="change",type="flash.events.Event")]
   public class Ability extends EventDispatcher
   {
      
      public var id:String;
      
      public var locId:String;
      
      public var imagePath:String;
      
      public var school:String;
      
      public var target:String;
      
      public var sign:String;
      
      public var distance:int;
      
      public var radius:int;
      
      public var level:int;
      
      public var costs:Object;
      
      public var itemCosts:Object;
      
      public var castTime:int;
      
      public var coolDown:int;
      
      public var groupCD:String;
      
      public var availableInFight:Boolean;
      
      public var actions:Array;
      
      public var casterActions:Array;
      
      public var loading:Boolean;
      
      public function Ability()
      {
         super();
      }
      
      public function load(ability:Ability) : void
      {
         var key:String = null;
         var xx:XML = describeType(this);
         var props:XMLList = describeType(this).variable.@name;
         for each(key in props)
         {
            this[key] = ability[key];
         }
      }
   }
}

