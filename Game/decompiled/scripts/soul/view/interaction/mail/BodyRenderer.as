package soul.view.interaction.mail
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
   import mx.events.ItemClickEvent;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.interaction.mail.Mail;
   import soul.model.item.Item;
   import soul.view.interaction.inventory.ItemRenderer;
   import soul.view.ui.Component;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.ScrollBase;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   [Event(name="itemClick",type="mx.events.ItemClickEvent")]
   public class BodyRenderer extends VBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _BodyRenderer_Label1:Label;
      
      public var _BodyRenderer_Label2:Label;
      
      public var _BodyRenderer_Label3:Label;
      
      public var _BodyRenderer_Label4:Label;
      
      public var _BodyRenderer_Label5:Label;
      
      public var _BodyRenderer_Label6:Label;
      
      private var _1506871896attachmentBox:HBox;
      
      private var _50959185attachmentHolder:VBox;
      
      private var _3343799mail:Mail;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function BodyRenderer()
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
         bindings = this._BodyRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_mail_BodyRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return BodyRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.padding = 20;
         this.gap = 2;
         this.children = [this._BodyRenderer_HBox1_c(),this._BodyRenderer_HBox2_c(),this._BodyRenderer_Component1_c(),this._BodyRenderer_ScrollBase1_c(),this._BodyRenderer_VBox2_i()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         BodyRenderer._watcherSetupUtil = param1;
      }
      
      private function set attachments(value:Array) : void
      {
         var item:Item = null;
         var child:ItemRenderer = null;
         this.attachmentHolder.visible = Boolean(value) && value.length > 0;
         this.attachmentBox.removeAllChildren();
         for each(item in value)
         {
            child = new ItemRenderer();
            child.addEventListener(MouseEvent.CLICK,this.attachClick);
            child.width = child.height = 51;
            child.item = item;
            this.attachmentBox.addChild(child);
         }
      }
      
      private function attachClick(e:MouseEvent) : void
      {
         var child:ItemRenderer = e.currentTarget as ItemRenderer;
         var ne:ItemClickEvent = new ItemClickEvent(ItemClickEvent.ITEM_CLICK);
         ne.index = this.attachmentBox.getChildIndex(child);
         dispatchEvent(ne);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _BodyRenderer_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.gap = 5;
         _loc1_.children = [this._BodyRenderer_Label1_i(),this._BodyRenderer_Label2_i()];
         return _loc1_;
      }
      
      private function _BodyRenderer_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.color = 0;
         _loc1_.bold = true;
         this._BodyRenderer_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_BodyRenderer_Label1",this._BodyRenderer_Label1);
         return _loc1_;
      }
      
      private function _BodyRenderer_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.color = 0;
         this._BodyRenderer_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_BodyRenderer_Label2",this._BodyRenderer_Label2);
         return _loc1_;
      }
      
      private function _BodyRenderer_HBox2_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.gap = 5;
         _loc1_.children = [this._BodyRenderer_Label3_i(),this._BodyRenderer_Label4_i()];
         return _loc1_;
      }
      
      private function _BodyRenderer_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.color = 0;
         _loc1_.bold = true;
         this._BodyRenderer_Label3 = _loc1_;
         BindingManager.executeBindings(this,"_BodyRenderer_Label3",this._BodyRenderer_Label3);
         return _loc1_;
      }
      
      private function _BodyRenderer_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.color = 0;
         this._BodyRenderer_Label4 = _loc1_;
         BindingManager.executeBindings(this,"_BodyRenderer_Label4",this._BodyRenderer_Label4);
         return _loc1_;
      }
      
      private function _BodyRenderer_Component1_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.percentWidth = 100;
         _loc1_.height = 1;
         _loc1_.backgroundColor = 0;
         return _loc1_;
      }
      
      private function _BodyRenderer_ScrollBase1_c() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.verticalScrollPolicy = "auto";
         _loc1_.children = [this._BodyRenderer_Label5_i()];
         return _loc1_;
      }
      
      private function _BodyRenderer_Label5_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.width = 255;
         _loc1_.multiline = true;
         _loc1_.wordWrap = true;
         _loc1_.color = 0;
         _loc1_.linkEnabled = true;
         this._BodyRenderer_Label5 = _loc1_;
         BindingManager.executeBindings(this,"_BodyRenderer_Label5",this._BodyRenderer_Label5);
         return _loc1_;
      }
      
      private function _BodyRenderer_VBox2_i() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.children = [this._BodyRenderer_Label6_i(),this._BodyRenderer_HBox3_i()];
         this.attachmentHolder = _loc1_;
         BindingManager.executeBindings(this,"attachmentHolder",this.attachmentHolder);
         return _loc1_;
      }
      
      private function _BodyRenderer_Label6_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.color = 0;
         this._BodyRenderer_Label6 = _loc1_;
         BindingManager.executeBindings(this,"_BodyRenderer_Label6",this._BodyRenderer_Label6);
         return _loc1_;
      }
      
      private function _BodyRenderer_HBox3_i() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 5;
         this.attachmentBox = _loc1_;
         BindingManager.executeBindings(this,"attachmentBox",this.attachmentBox);
         return _loc1_;
      }
      
      private function _BodyRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():*
         {
            return mail.attachments;
         },function(param1:*):void
         {
            attachments = param1;
         },"attachments");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = getString("mail.from");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BodyRenderer_Label1.text");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = mail.localizedFrom;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BodyRenderer_Label2.text");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = getString("mail.subject");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BodyRenderer_Label3.text");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = mail.localizedSubject;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BodyRenderer_Label4.text");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = mail.localizedBody;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BodyRenderer_Label5.htmlText");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = getString("mail.attachment") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BodyRenderer_Label6.text");
         return result;
      }
      
      private function _BodyRenderer_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         this.attachments = this.mail.attachments;
      }
      
      [Bindable(event="propertyChange")]
      public function get attachmentBox() : HBox
      {
         return this._1506871896attachmentBox;
      }
      
      public function set attachmentBox(param1:HBox) : void
      {
         var _loc2_:Object = this._1506871896attachmentBox;
         if(_loc2_ !== param1)
         {
            this._1506871896attachmentBox = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"attachmentBox",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get attachmentHolder() : VBox
      {
         return this._50959185attachmentHolder;
      }
      
      public function set attachmentHolder(param1:VBox) : void
      {
         var _loc2_:Object = this._50959185attachmentHolder;
         if(_loc2_ !== param1)
         {
            this._50959185attachmentHolder = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"attachmentHolder",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mail() : Mail
      {
         return this._3343799mail;
      }
      
      public function set mail(param1:Mail) : void
      {
         var _loc2_:Object = this._3343799mail;
         if(_loc2_ !== param1)
         {
            this._3343799mail = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mail",_loc2_,param1));
            }
         }
      }
   }
}

