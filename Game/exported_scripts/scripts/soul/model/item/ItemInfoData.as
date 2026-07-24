package soul.model.item
{
   import soul.model.character.ParamBonus;
   
   public class ItemInfoData extends Item
   {
      
      public var range:int;
      
      public var quest:Boolean;
      
      public var artefact:Boolean;
      
      public var action:Boolean;
      
      public var challenge:Boolean;
      
      public var expires:Date;
      
      public var ttl:Number;
      
      public var price:Object;
      
      public var priceSell:Object;
      
      public var repairsLeft:int;
      
      public var jewels:uint;
      
      public var jewelBonus:ParamBonus;
      
      public var capacity:uint;
      
      public var bonus:ParamBonus;
      
      public var spells:Array;
      
      public var abilityPatches:Array;
      
      public var race:Array;
      
      public var dispositionGroup:Array;
      
      public var disposition:Array;
      
      public var side:String;
      
      public var clan:String;
      
      public var requirements:Object;
      
      public var setInfo:SetInfo;
      
      public var useHp:int;
      
      public var useMinTime:int;
      
      public var useTime:int;
      
      public var useStamina:int;
      
      public var useMana:int;
      
      public var regMana:int;
      
      public var regHp:int;
      
      public var regStamina:int;
      
      public var regEffects:Array;
      
      public function ItemInfoData()
      {
         super();
      }
   }
}

