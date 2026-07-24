package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.character.parts.StatControls;
   
   [ExcludeClass]
   public class _soul_view_interaction_character_parts_StatControlsWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_character_parts_StatControlsWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         StatControls.watcherSetupUtil = new _soul_view_interaction_character_parts_StatControlsWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[6] = new PropertyWatcher("characterModel",{"propertyChange":true},[param4[4],param4[9],param4[14],param4[19],param4[23],param4[26],param4[29],param4[32],param4[35],param4[37],param4[39],param4[41]],param2);
         param5[9] = new PropertyWatcher("previewParams",{"propertyChange":true},[param4[4],param4[9],param4[14],param4[19],param4[23],param4[26],param4[29],param4[32],param4[35],param4[37],param4[39],param4[41]],null);
         param5[55] = new PropertyWatcher("HIT_MELEE",null,[param4[35]],null);
         param5[67] = new PropertyWatcher("ANTICRIT",null,[param4[41]],null);
         param5[59] = new PropertyWatcher("CRIT",null,[param4[37]],null);
         param5[63] = new PropertyWatcher("DODGE",null,[param4[39]],null);
         param5[23] = new PropertyWatcher("ACCURACY",null,[param4[14]],null);
         param5[10] = new PropertyWatcher("STRENGTH",null,[param4[4]],null);
         param5[41] = new PropertyWatcher("MAX_HP",null,[param4[26]],null);
         param5[46] = new PropertyWatcher("MAX_MP",null,[param4[29]],null);
         param5[29] = new PropertyWatcher("INTELLECT",null,[param4[19]],null);
         param5[17] = new PropertyWatcher("CONSTITUTION",null,[param4[9]],null);
         param5[36] = new PropertyWatcher("DAMAGE_PHYSICAL_MAX",null,[param4[23]],null);
         param5[34] = new PropertyWatcher("DAMAGE_PHYSICAL_MIN",null,[param4[23]],null);
         param5[49] = new PropertyWatcher("MAX_STAMINA",null,[param4[32]],null);
         param5[7] = new PropertyWatcher("params",{"propertyChange":true},[param4[4],param4[9],param4[14],param4[19],param4[23],param4[26],param4[29],param4[32],param4[35],param4[37],param4[39],param4[41]],null);
         param5[54] = new PropertyWatcher("HIT_MELEE",null,[param4[35]],null);
         param5[66] = new PropertyWatcher("ANTICRIT",null,[param4[41]],null);
         param5[58] = new PropertyWatcher("CRIT",null,[param4[37]],null);
         param5[62] = new PropertyWatcher("DODGE",null,[param4[39]],null);
         param5[22] = new PropertyWatcher("ACCURACY",null,[param4[14]],null);
         param5[8] = new PropertyWatcher("STRENGTH",null,[param4[4]],null);
         param5[40] = new PropertyWatcher("MAX_HP",null,[param4[26]],null);
         param5[45] = new PropertyWatcher("MAX_MP",null,[param4[29]],null);
         param5[28] = new PropertyWatcher("INTELLECT",null,[param4[19]],null);
         param5[16] = new PropertyWatcher("CONSTITUTION",null,[param4[9]],null);
         param5[35] = new PropertyWatcher("DAMAGE_PHYSICAL_MAX",null,[param4[23]],null);
         param5[33] = new PropertyWatcher("DAMAGE_PHYSICAL_MIN",null,[param4[23]],null);
         param5[48] = new PropertyWatcher("MAX_STAMINA",null,[param4[32]],null);
         param5[0] = new PropertyWatcher("points",{"propertyChange":true},[param4[0]],param2);
         param5[43] = new PropertyWatcher("intellect",{"propertyChange":true},[param4[28]],param2);
         param5[44] = new PropertyWatcher("modifier",{"propertyChange":true},[param4[28]],null);
         param5[31] = new PropertyWatcher("strength",{"propertyChange":true},[param4[22]],param2);
         param5[32] = new PropertyWatcher("modifier",{"propertyChange":true},[param4[22]],null);
         param5[1] = new PropertyWatcher("totalModifier",{"propertyChange":true},[param4[0],param4[46],param4[49]],param2);
         param5[11] = new PropertyWatcher("available",{"propertyChange":true},[param4[5],param4[10],param4[15],param4[20],param4[44]],param2);
         param5[52] = new PropertyWatcher("accuracy",{"propertyChange":true},[param4[34]],param2);
         param5[53] = new PropertyWatcher("modifier",{"propertyChange":true},[param4[34]],null);
         param5[38] = new PropertyWatcher("constitution",{"propertyChange":true},[param4[25],param4[31]],param2);
         param5[39] = new PropertyWatcher("modifier",{"propertyChange":true},[param4[25],param4[31]],null);
         param5[6].updateParent(param1);
         param5[6].addChild(param5[9]);
         param5[9].addChild(param5[55]);
         param5[9].addChild(param5[67]);
         param5[9].addChild(param5[59]);
         param5[9].addChild(param5[63]);
         param5[9].addChild(param5[23]);
         param5[9].addChild(param5[10]);
         param5[9].addChild(param5[41]);
         param5[9].addChild(param5[46]);
         param5[9].addChild(param5[29]);
         param5[9].addChild(param5[17]);
         param5[9].addChild(param5[36]);
         param5[9].addChild(param5[34]);
         param5[9].addChild(param5[49]);
         param5[6].addChild(param5[7]);
         param5[7].addChild(param5[54]);
         param5[7].addChild(param5[66]);
         param5[7].addChild(param5[58]);
         param5[7].addChild(param5[62]);
         param5[7].addChild(param5[22]);
         param5[7].addChild(param5[8]);
         param5[7].addChild(param5[40]);
         param5[7].addChild(param5[45]);
         param5[7].addChild(param5[28]);
         param5[7].addChild(param5[16]);
         param5[7].addChild(param5[35]);
         param5[7].addChild(param5[33]);
         param5[7].addChild(param5[48]);
         param5[0].updateParent(param1);
         param5[43].updateParent(param1);
         param5[43].addChild(param5[44]);
         param5[31].updateParent(param1);
         param5[31].addChild(param5[32]);
         param5[1].updateParent(param1);
         param5[11].updateParent(param1);
         param5[52].updateParent(param1);
         param5[52].addChild(param5[53]);
         param5[38].updateParent(param1);
         param5[38].addChild(param5[39]);
      }
   }
}

