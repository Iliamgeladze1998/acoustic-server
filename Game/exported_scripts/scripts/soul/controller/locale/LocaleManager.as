package soul.controller.locale
{
   import mx.utils.StringUtil;
   import soul.model.LocalizationParamType;
   import soul.model.condition.ConditionType;
   import soul.resources.ResourceManager;
   import soul.utils.DateUtils;
   import soul.view.console.Console;
   
   public class LocaleManager
   {
      
      private static var itemWithSuffixTemplate:String;
      
      private static var goldTemplate:String;
      
      private static var silverTemplate:String;
      
      private static var copperTemplate:String;
      
      private static var rubyTemplate:String;
      
      private static var pvpTemplate:String;
      
      private static var arenaTemplate:String;
      
      private static var tips:Vector.<String> = new Vector.<String>();
      
      public function LocaleManager()
      {
         super();
      }
      
      public static function setBundle(fileName:String, xml:XML) : void
      {
         var x:XML = null;
         Console.trace("LocaleManager.setBundle()",fileName,xml is XML);
         var bundleName:String = fileName.substring(0,fileName.lastIndexOf("."));
         var bundle:Object = {};
         for each(x in xml.entry)
         {
            bundle[String(x.@key)] = x.toString();
         }
         ResourceManager.setBundle(bundleName,bundle);
      }
      
      public static function setTips(xml:XML) : void
      {
         var x:XML = null;
         Console.trace("LocaleManager.setTips()",xml);
         if(!xml)
         {
            return;
         }
         for each(x in xml.entry)
         {
            tips.push(x.toString());
         }
      }
      
      public static function getRandomTip() : String
      {
         var l:uint = tips.length;
         return l > 0 ? tips[uint(Math.random() * l)] : "";
      }
      
      public static function getString(bundleName:String, key:String) : String
      {
         return ResourceManager.getString(bundleName,key);
      }
      
      public static function getTypedParam(type:String, value:String) : String
      {
         var str:String = null;
         var itemName:Array = null;
         if(!type)
         {
            return value;
         }
         switch(type)
         {
            case LocalizationParamType.ITEMS:
               itemName = value.split(".");
               str = getItemName(itemName[0],itemName[1]);
               break;
            case LocalizationParamType.COPPER:
               str = getMoney(int(value));
               break;
            case LocalizationParamType.RUBIES:
               str = getRubies(int(value));
               break;
            case LocalizationParamType.PVP:
               str = getPvp(int(value));
               break;
            case LocalizationParamType.ARENA:
               str = getArena(int(value));
               break;
            case LocalizationParamType.INTERVAL:
               str = DateUtils.getTimeLeft(Number(value));
               break;
            default:
               str = getString(type,value);
         }
         return str;
      }
      
      public static function getAbilityName(abilityId:String) : String
      {
         return getString(BundleName.ABILITIES,abilityId);
      }
      
      public static function getAbilitySchool(school:String) : String
      {
         return getString(BundleName.ABILITIES,school);
      }
      
      public static function getAbilityDescription(abilityId:String) : String
      {
         return getString(BundleName.ABILITIES,abilityId + ".description");
      }
      
      public static function getTalentDescription(talentId:String) : String
      {
         return getString(BundleName.TALENTS,talentId + ".description");
      }
      
      public static function getBuffEffectName(id:String) : String
      {
         return getString(BundleName.BUFF,id);
      }
      
      public static function getBuffEffectDescription(id:String) : String
      {
         return getString(BundleName.BUFF,id + ".description");
      }
      
      public static function getAbilityOrBuffName(id:String) : String
      {
         var ret:String = getBuffEffectName(id);
         return ret == id ? getAbilityName(id) : ret;
      }
      
      public static function getAchievementName(id:String) : String
      {
         return getString(BundleName.ACHIEVEMENT,id);
      }
      
      public static function getAchievementDescription(id:String) : String
      {
         return getString(BundleName.ACHIEVEMENT,id + ".description");
      }
      
      public static function getItemName(templateId:String, suffixId:String = null, localeId:String = null) : String
      {
         var suffix:String = null;
         if(Boolean(localeId))
         {
            templateId = localeId;
         }
         if(!itemWithSuffixTemplate)
         {
            itemWithSuffixTemplate = getString(BundleName.ITEMS,"ITEM_WITH_SUFFIX");
         }
         var name:String = getString(BundleName.ITEMS,templateId);
         if(Boolean(suffixId))
         {
            suffix = getString(BundleName.ITEMS,suffixId);
         }
         if(Boolean(suffix))
         {
            return StringUtil.substitute(itemWithSuffixTemplate,name,suffix);
         }
         return name;
      }
      
      public static function getItemDescription(templateId:String, descId:String = null) : String
      {
         var templateKey:String = templateId + ".description";
         var ret:String = getString(BundleName.ITEMS,Boolean(descId) ? descId : templateKey);
         return ret == templateKey || ret == descId ? null : ret;
      }
      
      public static function getMoney(coppers:int) : String
      {
         if(!goldTemplate)
         {
            goldTemplate = getString(BundleName.ITEMS,"GOLD_RECEIVED");
         }
         if(!silverTemplate)
         {
            silverTemplate = getString(BundleName.ITEMS,"SILVER_RECEIVED");
         }
         if(!copperTemplate)
         {
            copperTemplate = getString(BundleName.ITEMS,"COPPER_RECEIVED");
         }
         var coins:Array = [];
         var golds:int = coppers / 10000;
         coppers -= golds * 10000;
         var silvers:int = coppers / 100;
         coppers -= silvers * 100;
         if(golds > 0)
         {
            coins.push(StringUtil.substitute(goldTemplate,golds));
         }
         if(silvers > 0)
         {
            coins.push(StringUtil.substitute(silverTemplate,silvers));
         }
         if(coppers > 0)
         {
            coins.push(StringUtil.substitute(copperTemplate,coppers));
         }
         return coins.join(", ");
      }
      
      public static function getRubies(count:int) : String
      {
         if(!rubyTemplate)
         {
            rubyTemplate = getString(BundleName.ITEMS,"RUBIES_RECEIVED");
         }
         return StringUtil.substitute(rubyTemplate,count);
      }
      
      public static function getPvp(count:int) : String
      {
         if(!pvpTemplate)
         {
            pvpTemplate = getString(BundleName.ITEMS,"PVP_RECEIVED");
         }
         return StringUtil.substitute(pvpTemplate,count);
      }
      
      public static function getArena(count:int) : String
      {
         if(!arenaTemplate)
         {
            arenaTemplate = getString(BundleName.ITEMS,"ARENA_RECEIVED");
         }
         return StringUtil.substitute(arenaTemplate,count);
      }
      
      public static function getClanRole(key:String) : String
      {
         return getString(BundleName.INTERFACE,"CLAN_ROLE." + key);
      }
      
      public static function getClanRoleDescription(key:String) : String
      {
         return getString(BundleName.INTERFACE,"CLAN_ROLE." + key + ".description");
      }
      
      public static function getCondition(type:String, id:String) : String
      {
         switch(type)
         {
            case ConditionType.ITEM:
            case ConditionType.DELIVERY:
               return getItemName(id);
            case ConditionType.QUEST:
               return getString(BundleName.QUESTS,id);
            case ConditionType.KILL:
            case ConditionType.PVE_KILL:
            case ConditionType.TALK:
            case ConditionType.FOLLOWER:
            case ConditionType.OBJECT:
               return getString(BundleName.NPC,id);
            case ConditionType.EXPLORE:
               return getString(BundleName.MAPS,id);
            default:
               return getString(BundleName.CONDITIONS,id);
         }
      }
      
      public static function getQuestName(questId:String) : String
      {
         return getString(BundleName.QUESTS,questId);
      }
      
      public static function getMapName(sectorId:String, mapId:String) : String
      {
         var mapKey:String = sectorId + "." + mapId;
         var mapName:String = getString(BundleName.MAPS,mapKey);
         if(mapName == mapKey)
         {
            mapName = getString(BundleName.MAPS,mapId);
            if(mapName == mapId)
            {
               mapName = mapKey;
            }
         }
         return mapName;
      }
      
      public static function getSubscriptionName(type:String) : String
      {
         return getString(BundleName.INTERFACE,"subscription." + type);
      }
   }
}

