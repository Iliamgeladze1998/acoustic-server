package soul.controller.interaction
{
   import soul.controller.IManager;
   import soul.controller.Interaction;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.event.ArenaEvent;
   import soul.model.common.InteractionType;
   import soul.model.interaction.arena.ArenaData;
   import soul.model.interaction.arena.ArenaInfo;
   import soul.model.interaction.arena.ArenaModel;
   import soul.model.interaction.arena.ArenaState;
   import soul.model.interaction.arena.ArenaStateData;
   import soul.model.interaction.arena.FightTypeModel;
   import soul.net.ComponentLocator;
   import soul.net.ServerLayer;
   
   public class ArenaManager implements IManager
   {
      
      private static const SERVICE:String = "arenaService";
      
      private static const bundles:Array = [BundleName.INTERFACE,BundleName.ARENAS];
      
      private var model:ArenaModel;
      
      public function ArenaManager(m:ArenaModel)
      {
         super();
         this.model = m;
         ServerLayer.call(SERVICE,"getArenas",this.initArenas);
         ComponentLocator.setComponent(ComponentLocator.ARENA,this);
         ServerLayer.call(SERVICE,ComponentLocator.READY);
         this.model.addEventListener(ArenaEvent.CREATE_FIGHT_TYPE_CLAIM,this.createArenaClaim);
         this.model.addEventListener(ArenaEvent.CREATE_ARENA_CLAIM,this.createArenaClaim);
         this.model.addEventListener(ArenaEvent.CANCEL,this.cancelArena);
      }
      
      public function reset() : void
      {
         this.model.removeEventListener(ArenaEvent.CREATE_FIGHT_TYPE_CLAIM,this.createArenaClaim);
         this.model.removeEventListener(ArenaEvent.CREATE_ARENA_CLAIM,this.createArenaClaim);
         this.model.removeEventListener(ArenaEvent.CANCEL,this.cancelArena);
      }
      
      public function init(value:ArenaStateData, losingCooldown:uint = 0) : void
      {
         this.model.losingCooldown = losingCooldown;
         this.updateArenaState(value);
      }
      
      private function initArenas(value:Array) : void
      {
         var arena:ArenaData = null;
         var arr:Array = null;
         var key:String = null;
         var arenaInfo:ArenaInfo = null;
         var randomArena:ArenaInfo = null;
         var ft:FightTypeModel = null;
         var tmp:Object = {};
         for each(arena in value)
         {
            arenaInfo = new ArenaInfo();
            arenaInfo.load(arena);
            if(tmp[arena.fightType] == null)
            {
               tmp[arena.fightType] = [];
               randomArena = new ArenaInfo();
               randomArena.fightType = arena.fightType;
               randomArena.mapName = this.getString("arena.arenas");
               tmp[arena.fightType].push(randomArena);
            }
            arenaInfo.mapName = this.getString(arena.sectorId + "." + arena.mapId + "." + arena.layerId + ".name");
            arenaInfo.description = this.getString(arena.sectorId + "." + arena.mapId + "." + arena.layerId + ".desc");
            tmp[arena.fightType].push(arenaInfo);
         }
         this.model.arenas = tmp;
         arr = [];
         for(key in this.model.arenas)
         {
            ft = new FightTypeModel();
            ft.fightType = key;
            ft.label = this.getString(key);
            ft.description = this.getString(ft.fightType);
            arr.push(ft);
         }
         this.model.fightTypes = arr;
      }
      
      public function updateArenaState(value:ArenaStateData) : void
      {
         if(value != null)
         {
            switch(value.arenaState)
            {
               case ArenaState.BATTLE:
               case ArenaState.ASSEMBLY:
                  Interaction.hide(InteractionType.ARENA);
                  break;
               case ArenaState.CLEANUP:
                  Interaction.show(InteractionType.ARENA);
                  break;
               case ArenaState.NONE:
                  value = null;
            }
         }
         this.model.state = value;
         this.model.dispatchEvent(new ArenaEvent(ArenaEvent.STATE_CHANGED));
         this.model.cooldown = Boolean(value) && !value.cancelable ? value.cooldown : 0;
      }
      
      private function setFightTypeDesc(value:String, index:int) : void
      {
         this.model.fightTypes[index].description = value;
      }
      
      private function createArenaClaim(e:ArenaEvent) : void
      {
         switch(e.type)
         {
            case ArenaEvent.CREATE_FIGHT_TYPE_CLAIM:
               ServerLayer.call(SERVICE,"createFightTypeClaim",null,null,e.data);
               break;
            case ArenaEvent.CREATE_ARENA_CLAIM:
               ServerLayer.call(SERVICE,"createArenaClaim",null,null,e.data);
         }
      }
      
      private function cancelArena(e:ArenaEvent) : void
      {
         ServerLayer.call(SERVICE,"cancel");
      }
      
      private function getString(key:String) : String
      {
         var bundle:String = null;
         var str:String = null;
         for each(bundle in bundles)
         {
            str = LocaleManager.getString(bundle,key);
            if(str != key)
            {
               return str;
            }
         }
         return key;
      }
   }
}

