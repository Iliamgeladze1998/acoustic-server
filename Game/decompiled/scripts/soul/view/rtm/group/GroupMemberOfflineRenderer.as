package soul.view.rtm.group
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
   import soul.controller.MenuManager;
   import soul.event.FieldEvent;
   import soul.event.SimpleUIEvent;
   import soul.model.character.Disposition;
   import soul.model.character.DispositionGroup;
   import soul.model.common.MenuType;
   import soul.model.field.FieldUnit;
   import soul.model.group.GroupMember;
   import soul.model.rtm.RTMModel;
   import soul.view.assets.Assets;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientLabel;
   import soul.view.toolTip.PartyToolTip;
   import soul.view.toolTip.ToolTipManager;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Container;
   
   use namespace mx_internal;
   
   public class GroupMemberOfflineRenderer extends Container implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _GroupMemberOfflineRenderer_CachedImage1:CachedImage;
      
      public var _GroupMemberOfflineRenderer_CachedImage2:CachedImage;
      
      public var _GroupMemberOfflineRenderer_GradientLabel1:GradientLabel;
      
      public var rtmModel:RTMModel;
      
      private var _3594628unit:GroupMember;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function GroupMemberOfflineRenderer()
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
         bindings = this._GroupMemberOfflineRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_rtm_group_GroupMemberOfflineRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return GroupMemberOfflineRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 200;
         this.height = 26;
         this.mouseEnabled = false;
         this.children = [this._GroupMemberOfflineRenderer_GradientLabel1_i(),this._GroupMemberOfflineRenderer_CachedImage1_i(),this._GroupMemberOfflineRenderer_CachedImage2_i()];
         this.addEventListener("creationComplete",this.___GroupMemberOfflineRenderer_Container1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         GroupMemberOfflineRenderer._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         addEventListener(Event.REMOVED,this.removed);
         addEventListener(MouseEvent.CLICK,this.mouseClick);
         ToolTipManager.register(this,this.unit,PartyToolTip);
      }
      
      private function removed(e:Event) : void
      {
         if(e.target != this)
         {
            return;
         }
         removeEventListener(Event.REMOVED,this.removed);
         removeEventListener(MouseEvent.CLICK,this.mouseClick);
         ToolTipManager.unregister(this);
      }
      
      private function mouseClick(e:MouseEvent) : void
      {
         var fu:FieldUnit = null;
         if(Boolean(this.rtmModel.activeAbility))
         {
            fu = new FieldUnit();
            fu.id = this.unit.id;
            fu.acceptsPositive = true;
            this.rtmModel.activeUnit = fu;
            this.rtmModel.dispatchEvent(new Event(FieldEvent.ACCEPT_ABILITY));
         }
         else
         {
            this.showMenu(e);
         }
      }
      
      private function showMenu(e:MouseEvent) : void
      {
         e.stopImmediatePropagation();
         MenuManager.create(MenuType.CHARACTER_MENU,this.unit.id);
      }
      
      private function _GroupMemberOfflineRenderer_GradientLabel1_i() : GradientLabel
      {
         var _loc1_:GradientLabel = null;
         _loc1_ = new GradientLabel();
         _loc1_.x = 26;
         _loc1_.y = 4;
         _loc1_.bold = true;
         _loc1_.fontSize = 10;
         _loc1_.width = 125;
         _loc1_.bgPaddingLeft = -10;
         _loc1_.mouseEnabled = false;
         _loc1_.mouseChildren = false;
         this._GroupMemberOfflineRenderer_GradientLabel1 = _loc1_;
         BindingManager.executeBindings(this,"_GroupMemberOfflineRenderer_GradientLabel1",this._GroupMemberOfflineRenderer_GradientLabel1);
         return _loc1_;
      }
      
      private function _GroupMemberOfflineRenderer_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._GroupMemberOfflineRenderer_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_GroupMemberOfflineRenderer_CachedImage1",this._GroupMemberOfflineRenderer_CachedImage1);
         return _loc1_;
      }
      
      private function _GroupMemberOfflineRenderer_CachedImage2_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.x = 4;
         _loc1_.y = 3;
         this._GroupMemberOfflineRenderer_CachedImage2 = _loc1_;
         BindingManager.executeBindings(this,"_GroupMemberOfflineRenderer_CachedImage2",this._GroupMemberOfflineRenderer_CachedImage2);
         return _loc1_;
      }
      
      public function ___GroupMemberOfflineRenderer_Container1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _GroupMemberOfflineRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = unit.name;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_GroupMemberOfflineRenderer_GradientLabel1.text");
         result[1] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_GroupMemberOfflineRenderer_GradientLabel1.color");
         result[2] = new Binding(this,function():Object
         {
            return Assets.partyMemberFrameOffline;
         },null,"_GroupMemberOfflineRenderer_CachedImage1.source");
         result[3] = new Binding(this,function():Object
         {
            return DispositionGroup.getPartyIcon(Disposition.getDispositionGroup(unit.disposition));
         },null,"_GroupMemberOfflineRenderer_CachedImage2.source");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get unit() : GroupMember
      {
         return this._3594628unit;
      }
      
      public function set unit(param1:GroupMember) : void
      {
         var _loc2_:Object = this._3594628unit;
         if(_loc2_ !== param1)
         {
            this._3594628unit = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"unit",_loc2_,param1));
            }
         }
      }
   }
}

