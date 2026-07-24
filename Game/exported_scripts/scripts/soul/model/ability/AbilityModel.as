package soul.model.ability
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import soul.model.character.CharacterData;
   import soul.net.ServerLayer;
   
   public class AbilityModel extends EventDispatcher
   {
      
      public var abilityCache:Object = {};
      
      public var abilityBook:Array;
      
      public function AbilityModel()
      {
         super();
      }
      
      public function load(data:CharacterData) : void
      {
         this.updateCache(data.abilityCache);
         this.updateAbilityBook(data.abilityBook);
      }
      
      public function updateAbilityBook(abilities:Array) : void
      {
         this.abilityBook = abilities;
         dispatchEvent(new Event("abilitiesChanged"));
      }
      
      public function updateCache(cache:Array) : void
      {
         var a:Ability = null;
         for each(a in cache)
         {
            this.setAbility(a);
         }
      }
      
      [Bindable("abilitiesChanged")]
      public function getAbilitiesBySchool(school:String) : Array
      {
         var abilityId:String = null;
         var ability:Ability = null;
         var arr:Array = [];
         for each(abilityId in this.abilityBook)
         {
            ability = this.getAbilityById(abilityId);
            if(Boolean(ability) && (ability.school == school || school == AbilitySchool.OTHER))
            {
               arr.push(ability);
            }
         }
         return arr;
      }
      
      [Bindable("abilitiesChanged")]
      public function getOtherAbilities(schools:Array) : Array
      {
         var abilityId:String = null;
         var ability:Ability = null;
         var arr:Array = [];
         for each(abilityId in this.abilityBook)
         {
            ability = this.getAbilityById(abilityId);
            if(Boolean(ability) && schools.indexOf(ability.school) == -1)
            {
               arr.push(ability);
            }
         }
         return arr;
      }
      
      public function getAbilityById(id:String) : Ability
      {
         if(!id || id == "" || id == "null")
         {
            return null;
         }
         var ability:Ability = this.abilityCache[id];
         if(!ability)
         {
            ability = new Ability();
            ability.id = id;
            ability.loading = true;
            this.abilityCache[id] = ability;
            ServerLayer.call("characterService","getAbility",this.setAbility,null,id);
         }
         return ability;
      }
      
      private function setAbility(ability:Ability) : void
      {
         var currentAbility:Ability = this.abilityCache[ability.id];
         if(Boolean(currentAbility))
         {
            currentAbility.load(ability);
            currentAbility.dispatchEvent(new Event(Event.CHANGE));
         }
         else
         {
            this.abilityCache[ability.id] = ability;
         }
      }
   }
}

