package
{
   import mx.binding.ArrayElementWatcher;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.inventory.Doll;
   
   [ExcludeClass]
   public class _soul_view_interaction_inventory_DollWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_inventory_DollWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         Doll.watcherSetupUtil = new _soul_view_interaction_inventory_DollWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var staticPropertyGetter:Function = param3;
         var bindings:Array = param4;
         var watchers:Array = param5;
         watchers[18] = new PropertyWatcher("alternativeIndex",{"propertyChange":true},[bindings[27]],propertyGetter);
         watchers[32] = new PropertyWatcher("slots",{"propertyChange":true},[bindings[52],bindings[54],bindings[56]],propertyGetter);
         watchers[35] = new ArrayElementWatcher(target,function():*
         {
            return 1;
         },[bindings[54]]);
         watchers[33] = new ArrayElementWatcher(target,function():*
         {
            return 0;
         },[bindings[52]]);
         watchers[37] = new ArrayElementWatcher(target,function():*
         {
            return 2;
         },[bindings[56]]);
         watchers[1] = new PropertyWatcher("bodyModel",{"propertyChange":true},[bindings[1],bindings[4],bindings[7],bindings[10],bindings[13],bindings[16],bindings[20],bindings[24],bindings[30],bindings[34],bindings[37],bindings[40],bindings[43],bindings[46],bindings[49]],propertyGetter);
         watchers[2] = new PropertyWatcher("earClips",{"propertyChange":true},[bindings[1]],null);
         watchers[7] = new PropertyWatcher("amulet",{"propertyChange":true},[bindings[7]],null);
         watchers[21] = new PropertyWatcher("shield2",{"propertyChange":true},[bindings[34]],null);
         watchers[20] = new PropertyWatcher("shield1",{"propertyChange":true},[bindings[30]],null);
         watchers[27] = new PropertyWatcher("waist",{"propertyChange":true},[bindings[43]],null);
         watchers[23] = new PropertyWatcher("gloves",{"propertyChange":true},[bindings[37]],null);
         watchers[5] = new PropertyWatcher("helmet",{"propertyChange":true},[bindings[4]],null);
         watchers[31] = new PropertyWatcher("tatoo",{"propertyChange":true},[bindings[49]],null);
         watchers[25] = new PropertyWatcher("armour",{"propertyChange":true},[bindings[40]],null);
         watchers[9] = new PropertyWatcher("ring1",{"propertyChange":true},[bindings[10]],null);
         watchers[16] = new PropertyWatcher("weapon2",{"propertyChange":true},[bindings[24]],null);
         watchers[29] = new PropertyWatcher("boots",{"propertyChange":true},[bindings[46]],null);
         watchers[11] = new PropertyWatcher("ring3",{"propertyChange":true},[bindings[16]],null);
         watchers[10] = new PropertyWatcher("ring2",{"propertyChange":true},[bindings[13]],null);
         watchers[15] = new PropertyWatcher("weapon1",{"propertyChange":true},[bindings[20]],null);
         watchers[13] = new PropertyWatcher("altMode",{"propertyChange":true},[bindings[19],bindings[23],bindings[29],bindings[33]],propertyGetter);
         watchers[14] = new PropertyWatcher("selectedIndex",{"selectedIndexChanged":true},[bindings[19],bindings[23],bindings[29],bindings[33]],null);
         watchers[3] = new PropertyWatcher("locked",{"propertyChange":true},[bindings[2],bindings[5],bindings[8],bindings[11],bindings[14],bindings[17],bindings[21],bindings[25],bindings[31],bindings[35],bindings[38],bindings[41],bindings[44],bindings[47],bindings[50],bindings[51],bindings[53],bindings[55]],propertyGetter);
         watchers[18].updateParent(target);
         watchers[32].updateParent(target);
         watchers[35].arrayWatcher = watchers[32];
         watchers[32].addChild(watchers[35]);
         watchers[33].arrayWatcher = watchers[32];
         watchers[32].addChild(watchers[33]);
         watchers[37].arrayWatcher = watchers[32];
         watchers[32].addChild(watchers[37]);
         watchers[1].updateParent(target);
         watchers[1].addChild(watchers[2]);
         watchers[1].addChild(watchers[7]);
         watchers[1].addChild(watchers[21]);
         watchers[1].addChild(watchers[20]);
         watchers[1].addChild(watchers[27]);
         watchers[1].addChild(watchers[23]);
         watchers[1].addChild(watchers[5]);
         watchers[1].addChild(watchers[31]);
         watchers[1].addChild(watchers[25]);
         watchers[1].addChild(watchers[9]);
         watchers[1].addChild(watchers[16]);
         watchers[1].addChild(watchers[29]);
         watchers[1].addChild(watchers[11]);
         watchers[1].addChild(watchers[10]);
         watchers[1].addChild(watchers[15]);
         watchers[13].updateParent(target);
         watchers[13].addChild(watchers[14]);
         watchers[3].updateParent(target);
      }
   }
}

