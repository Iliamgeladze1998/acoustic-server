package soul.view.astral
{
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import mx.binding.*;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import soul.model.astral.AstralMember;
   import soul.model.astral.AstralModel;
   import soul.view.ui.HBox;
   
   use namespace mx_internal;
   
   public class AstralScreen extends HBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private var _107868map:AstralMap;
      
      private var _106433028panel:AstralPanel;
      
      private var _104069929model:AstralModel;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function AstralScreen()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         bindings = this._AstralScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_astral_AstralScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return AstralScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.minHeight = 512;
         this.children = [this._AstralScreen_AstralMap1_i(),this._AstralScreen_AstralPanel1_i()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         AstralScreen._watcherSetupUtil = param1;
      }
      
      public function stopAt(id:String, x:int, y:int) : void
      {
         this.map.stopAt(id,x,y);
      }
      
      public function moveTo(id:String, x:int, y:int, duration:int) : void
      {
         this.map.moveTo(id,x,y,duration);
      }
      
      public function create(member:AstralMember) : void
      {
         this.map.create(member);
      }
      
      public function remove(memberId:String) : void
      {
         this.map.remove(memberId);
      }
      
      public function drawCircles() : void
      {
         this.map.drawCircles();
      }
      
      private function _AstralScreen_AstralMap1_i() : AstralMap
      {
         var _loc1_:AstralMap = new AstralMap();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         this.map = _loc1_;
         BindingManager.executeBindings(this,"map",this.map);
         return _loc1_;
      }
      
      private function _AstralScreen_AstralPanel1_i() : AstralPanel
      {
         var _loc1_:AstralPanel = new AstralPanel();
         _loc1_.percentHeight = 100;
         this.panel = _loc1_;
         BindingManager.executeBindings(this,"panel",this.panel);
         return _loc1_;
      }
      
      private function _AstralScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,null,null,"map.model","model");
         result[1] = new Binding(this,function():Point
         {
            return model.destinaton;
         },null,"map.destination");
         result[2] = new Binding(this,function():Boolean
         {
            return model.enabled;
         },null,"map.enabled");
         result[3] = new Binding(this,null,null,"panel.model","model");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get map() : AstralMap
      {
         return this._107868map;
      }
      
      public function set map(param1:AstralMap) : void
      {
         var _loc2_:Object = this._107868map;
         if(_loc2_ !== param1)
         {
            this._107868map = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"map",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get panel() : AstralPanel
      {
         return this._106433028panel;
      }
      
      public function set panel(param1:AstralPanel) : void
      {
         var _loc2_:Object = this._106433028panel;
         if(_loc2_ !== param1)
         {
            this._106433028panel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"panel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get model() : AstralModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:AstralModel) : void
      {
         var _loc2_:Object = this._104069929model;
         if(_loc2_ !== param1)
         {
            this._104069929model = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"model",_loc2_,param1));
            }
         }
      }
   }
}

