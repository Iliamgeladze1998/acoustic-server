package
{
   import mx.binding.ArrayElementWatcher;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.common.CurrencyType;
   import soul.view.interaction.clan.ClanScreen;
   
   [ExcludeClass]
   public class _soul_view_interaction_clan_ClanScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_clan_ClanScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ClanScreen.watcherSetupUtil = new _soul_view_interaction_clan_ClanScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var staticPropertyGetter:Function = param3;
         var bindings:Array = param4;
         var watchers:Array = param5;
         watchers[1] = new PropertyWatcher("model",{"propertyChange":true},[bindings[1],bindings[4],bindings[6],bindings[8],bindings[9],bindings[17],bindings[18],bindings[20],bindings[23],bindings[26],bindings[30],bindings[37],bindings[43],bindings[48],bindings[59],bindings[60]],propertyGetter);
         watchers[32] = new PropertyWatcher("memberBonuses",{"propertyChange":true},[bindings[26]],null);
         watchers[4] = new PropertyWatcher("maxMembers",{"propertyChange":true},[bindings[1],bindings[18]],null);
         watchers[14] = new PropertyWatcher("name",{"propertyChange":true},[bindings[8]],null);
         watchers[35] = new PropertyWatcher("rubies",{"propertyChange":true},[bindings[30],bindings[37],bindings[48]],null);
         watchers[9] = new PropertyWatcher("myMember",{"propertyChange":true},[bindings[4],bindings[6],bindings[9],bindings[20],bindings[37]],null);
         watchers[28] = new PropertyWatcher("clanRole",{"clanRoleChanged":true},[bindings[20],bindings[37]],null);
         watchers[47] = new PropertyWatcher("log",{"propertyChange":true},[bindings[43]],null);
         watchers[2] = new PropertyWatcher("members",{"propertyChange":true},[bindings[1],bindings[17],bindings[18]],null);
         watchers[30] = new PropertyWatcher("clanBonuses",{"propertyChange":true},[bindings[23]],null);
         watchers[58] = new PropertyWatcher("characterModel",{"propertyChange":true},[bindings[55],bindings[61]],propertyGetter);
         watchers[59] = new PropertyWatcher("currencies",{"propertyChange":true},[bindings[55]],null);
         watchers[60] = new ArrayElementWatcher(target,function():*
         {
            return CurrencyType.RUBIES;
         },[bindings[55]]);
         watchers[7] = new PropertyWatcher("memberSelector",{"propertyChange":true},[bindings[4],bindings[6]],propertyGetter);
         watchers[8] = new PropertyWatcher("selectedMember",{"selectedMemberChanged":true},[bindings[4],bindings[6]],null);
         watchers[37] = new PropertyWatcher("selectedBonus",{"propertyChange":true},[bindings[34],bindings[37],bindings[40]],propertyGetter);
         watchers[38] = new PropertyWatcher("cost",{"propertyChange":true},[bindings[34],bindings[37]],null);
         watchers[48] = new PropertyWatcher("filterBox",{"propertyChange":true},[bindings[44]],propertyGetter);
         watchers[49] = new PropertyWatcher("selectedItem",{"selectedItemChanged":true},[bindings[44]],null);
         watchers[50] = new PropertyWatcher("data",null,[bindings[44]],null);
         watchers[56] = new PropertyWatcher("depositAmount",{"propertyChange":true},[bindings[55],bindings[58]],propertyGetter);
         watchers[57] = new PropertyWatcher("text",{"textChanged":true},[bindings[55],bindings[58]],null);
         watchers[22] = new PropertyWatcher("bar",{"propertyChange":true},[bindings[12]],propertyGetter);
         watchers[23] = new PropertyWatcher("selectedIndex",{"selectedIndexChanged":true},[bindings[12]],null);
         watchers[1].updateParent(target);
         watchers[1].addChild(watchers[32]);
         watchers[1].addChild(watchers[4]);
         watchers[1].addChild(watchers[14]);
         watchers[1].addChild(watchers[35]);
         watchers[1].addChild(watchers[9]);
         watchers[9].addChild(watchers[28]);
         watchers[1].addChild(watchers[47]);
         watchers[1].addChild(watchers[2]);
         watchers[1].addChild(watchers[30]);
         watchers[58].updateParent(target);
         watchers[58].addChild(watchers[59]);
         watchers[60].arrayWatcher = watchers[59];
         watchers[59].addChild(watchers[60]);
         watchers[7].updateParent(target);
         watchers[7].addChild(watchers[8]);
         watchers[37].updateParent(target);
         watchers[37].addChild(watchers[38]);
         watchers[48].updateParent(target);
         watchers[48].addChild(watchers[49]);
         watchers[49].addChild(watchers[50]);
         watchers[56].updateParent(target);
         watchers[56].addChild(watchers[57]);
         watchers[22].updateParent(target);
         watchers[22].addChild(watchers[23]);
      }
   }
}

