package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.character.parts.StatViewer;
   
   [ExcludeClass]
   public class _soul_view_interaction_character_parts_StatViewerWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_character_parts_StatViewerWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         StatViewer.watcherSetupUtil = new _soul_view_interaction_character_parts_StatViewerWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[4] = new PropertyWatcher("charData",{"propertyChange":true},[param4[3],param4[7],param4[11],param4[15],param4[17],param4[19],param4[21],param4[23],param4[25],param4[27],param4[29],param4[31]],param2);
         param5[5] = new PropertyWatcher("params",null,[param4[3],param4[7],param4[11],param4[15],param4[17],param4[19],param4[21],param4[23],param4[25],param4[27],param4[29],param4[31]],null);
         param5[33] = new PropertyWatcher("HIT_MELEE",null,[param4[25]],null);
         param5[42] = new PropertyWatcher("ANTICRIT",null,[param4[31]],null);
         param5[36] = new PropertyWatcher("CRIT",null,[param4[27]],null);
         param5[39] = new PropertyWatcher("DODGE",null,[param4[29]],null);
         param5[16] = new PropertyWatcher("ACCURACY",null,[param4[11]],null);
         param5[6] = new PropertyWatcher("STRENGTH",null,[param4[3]],null);
         param5[26] = new PropertyWatcher("MAX_HP",null,[param4[19]],null);
         param5[28] = new PropertyWatcher("MAX_MP",null,[param4[21]],null);
         param5[21] = new PropertyWatcher("INTELLECT",null,[param4[15]],null);
         param5[11] = new PropertyWatcher("CONSTITUTION",null,[param4[7]],null);
         param5[24] = new PropertyWatcher("DAMAGE_PHYSICAL_MAX",null,[param4[17]],null);
         param5[23] = new PropertyWatcher("DAMAGE_PHYSICAL_MIN",null,[param4[17]],null);
         param5[30] = new PropertyWatcher("MAX_STAMINA",null,[param4[23]],null);
         param5[4].updateParent(param1);
         param5[4].addChild(param5[5]);
         param5[5].addChild(param5[33]);
         param5[5].addChild(param5[42]);
         param5[5].addChild(param5[36]);
         param5[5].addChild(param5[39]);
         param5[5].addChild(param5[16]);
         param5[5].addChild(param5[6]);
         param5[5].addChild(param5[26]);
         param5[5].addChild(param5[28]);
         param5[5].addChild(param5[21]);
         param5[5].addChild(param5[11]);
         param5[5].addChild(param5[24]);
         param5[5].addChild(param5[23]);
         param5[5].addChild(param5[30]);
      }
   }
}

