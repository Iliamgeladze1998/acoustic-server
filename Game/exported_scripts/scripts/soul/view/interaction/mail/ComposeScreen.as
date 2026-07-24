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
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.event.MailEvent;
   import soul.event.MenuEvent;
   import soul.event.SimpleUIEvent;
   import soul.model.interaction.mail.MailModel;
   import soul.model.interaction.mail.NewMailData;
   import soul.model.item.InvKey;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.assets.GradientBox;
   import soul.view.common.Icons;
   import soul.view.common.MoneyRenderer;
   import soul.view.interaction.auction.MoneyEnter;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Canvas;
   import soul.view.ui.Component;
   import soul.view.ui.HBox;
   import soul.view.ui.Input;
   import soul.view.ui.Label;
   import soul.view.ui.TextArea;
   import soul.view.ui.VBox;
   import soul.view.ui.controls.menu.Menu;
   
   use namespace mx_internal;
   
   public class ComposeScreen extends BorderedContainer implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const GRADIENT:Array = [0,2566914048,2566914048,2566914048,2566914048];
      
      public var _ComposeScreen_Button11:Button1;
      
      public var _ComposeScreen_Button12:Button1;
      
      public var _ComposeScreen_CachedImage1:CachedImage;
      
      public var _ComposeScreen_CachedImage2:CachedImage;
      
      public var _ComposeScreen_GradientBox1:GradientBox;
      
      public var _ComposeScreen_Label1:Label;
      
      public var _ComposeScreen_Label2:Label;
      
      public var _ComposeScreen_Label3:Label;
      
      public var _ComposeScreen_Label4:Label;
      
      public var _ComposeScreen_MoneyRenderer1:MoneyRenderer;
      
      private var _3029410body:TextArea;
      
      private var _953258618coppers:MoneyEnter;
      
      private var _3242771item:MailItemContainer;
      
      private var _820081177recipient:Input;
      
      private var _1867885268subject:Input;
      
      private var _104069929model:MailModel;
      
      private var _1790120620characterName:String;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ComposeScreen()
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
         bindings = this._ComposeScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_mail_ComposeScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return ComposeScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.direction = "vertical";
         this.width = 329;
         this.height = 416;
         this.padding = 10;
         this.gap = 10;
         this.children = [this._ComposeScreen_Canvas1_c(),this._ComposeScreen_HBox4_c()];
         this.addEventListener("creationComplete",this.___ComposeScreen_BorderedContainer1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ComposeScreen._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         this.model.addEventListener(MailEvent.SEND_SUCCESS,this.sendSuccess,false,0,true);
      }
      
      private function send() : void
      {
         var data:NewMailData = new NewMailData();
         data.to = this.recipient.text;
         data.subject = this.subject.text;
         data.body = this.body.text;
         data.item = Boolean(this.item.item) ? this.item.item.key : null;
         data.copper = this.coppers.value;
         var ne:MailEvent = new MailEvent(MailEvent.SEND);
         ne.newMailData = data;
         this.model.dispatchEvent(ne);
      }
      
      private function sendSuccess(e:MailEvent) : void
      {
         this.clean();
      }
      
      public function clean() : void
      {
         this.recipient.text = "";
         this.subject.text = "";
         this.body.text = "";
         this.item.item = null;
         this.coppers.value = 0;
      }
      
      private function close() : void
      {
         this.clean();
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      private function showMenu() : void
      {
         var data:Array = [{
            "data":"%CLAN%",
            "label":this.getString("mail.list.clan")
         },{
            "data":"%FRIENDS%",
            "label":this.getString("mail.list.friends")
         },{
            "data":"%SUPPORT%",
            "label":this.getString("mail.list.support")
         }];
         var menu:Menu = Menu.createMenu(stage,data);
         menu.addEventListener(MenuEvent.ITEM_CLICK,this.menuClick);
         menu.show(stage.mouseX,stage.mouseY);
      }
      
      private function menuClick(e:MenuEvent) : void
      {
         var data:String = e.item.data;
         this.recipient.text = data;
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _ComposeScreen_Canvas1_c() : Canvas
      {
         var _loc1_:Canvas = new Canvas();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.children = [this._ComposeScreen_CachedImage1_i(),this._ComposeScreen_VBox1_c()];
         return _loc1_;
      }
      
      private function _ComposeScreen_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.top = 0;
         _loc1_.horizontalCenter = 0;
         this._ComposeScreen_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_ComposeScreen_CachedImage1",this._ComposeScreen_CachedImage1);
         return _loc1_;
      }
      
      private function _ComposeScreen_VBox1_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.padding = 25;
         _loc1_.gap = 5;
         _loc1_.children = [this._ComposeScreen_HBox1_c(),this._ComposeScreen_HBox2_c(),this._ComposeScreen_TextArea1_i(),this._ComposeScreen_Label3_i(),this._ComposeScreen_HBox3_c()];
         return _loc1_;
      }
      
      private function _ComposeScreen_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.gap = 1;
         _loc1_.children = [this._ComposeScreen_Label1_i(),this._ComposeScreen_Component1_c(),this._ComposeScreen_Input1_i(),this._ComposeScreen_CachedImage2_i()];
         return _loc1_;
      }
      
      private function _ComposeScreen_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.color = 0;
         _loc1_.bold = true;
         this._ComposeScreen_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_ComposeScreen_Label1",this._ComposeScreen_Label1);
         return _loc1_;
      }
      
      private function _ComposeScreen_Component1_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.width = 8;
         return _loc1_;
      }
      
      private function _ComposeScreen_Input1_i() : Input
      {
         var _loc1_:Input = new Input();
         _loc1_.percentWidth = 100;
         _loc1_.color = 0;
         _loc1_.fontSize = 12;
         _loc1_.padding = 5;
         _loc1_.tabIndex = 0;
         this.recipient = _loc1_;
         BindingManager.executeBindings(this,"recipient",this.recipient);
         return _loc1_;
      }
      
      private function _ComposeScreen_CachedImage2_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.addEventListener("click",this.___ComposeScreen_CachedImage2_click);
         this._ComposeScreen_CachedImage2 = _loc1_;
         BindingManager.executeBindings(this,"_ComposeScreen_CachedImage2",this._ComposeScreen_CachedImage2);
         return _loc1_;
      }
      
      public function ___ComposeScreen_CachedImage2_click(event:MouseEvent) : void
      {
         this.showMenu();
      }
      
      private function _ComposeScreen_HBox2_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.children = [this._ComposeScreen_Label2_i(),this._ComposeScreen_Component2_c(),this._ComposeScreen_Input2_i(),this._ComposeScreen_Component3_c()];
         return _loc1_;
      }
      
      private function _ComposeScreen_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.color = 0;
         _loc1_.bold = true;
         this._ComposeScreen_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_ComposeScreen_Label2",this._ComposeScreen_Label2);
         return _loc1_;
      }
      
      private function _ComposeScreen_Component2_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.width = 10;
         return _loc1_;
      }
      
      private function _ComposeScreen_Input2_i() : Input
      {
         var _loc1_:Input = new Input();
         _loc1_.percentWidth = 100;
         _loc1_.color = 0;
         _loc1_.fontSize = 12;
         _loc1_.padding = 5;
         _loc1_.tabIndex = 1;
         this.subject = _loc1_;
         BindingManager.executeBindings(this,"subject",this.subject);
         return _loc1_;
      }
      
      private function _ComposeScreen_Component3_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.width = 15;
         return _loc1_;
      }
      
      private function _ComposeScreen_TextArea1_i() : TextArea
      {
         var _loc1_:TextArea = new TextArea();
         _loc1_.multiline = true;
         _loc1_.wordWrap = true;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.color = 0;
         _loc1_.tabIndex = 2;
         _loc1_.editable = true;
         this.body = _loc1_;
         BindingManager.executeBindings(this,"body",this.body);
         return _loc1_;
      }
      
      private function _ComposeScreen_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.color = 0;
         _loc1_.bold = true;
         this._ComposeScreen_Label3 = _loc1_;
         BindingManager.executeBindings(this,"_ComposeScreen_Label3",this._ComposeScreen_Label3);
         return _loc1_;
      }
      
      private function _ComposeScreen_HBox3_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 5;
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._ComposeScreen_MailItemContainer1_i(),this._ComposeScreen_MoneyEnter1_i()];
         return _loc1_;
      }
      
      private function _ComposeScreen_MailItemContainer1_i() : MailItemContainer
      {
         var _loc1_:MailItemContainer = new MailItemContainer();
         this.item = _loc1_;
         BindingManager.executeBindings(this,"item",this.item);
         return _loc1_;
      }
      
      private function _ComposeScreen_MoneyEnter1_i() : MoneyEnter
      {
         var _loc1_:MoneyEnter = new MoneyEnter();
         this.coppers = _loc1_;
         BindingManager.executeBindings(this,"coppers",this.coppers);
         return _loc1_;
      }
      
      private function _ComposeScreen_HBox4_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.children = [this._ComposeScreen_GradientBox1_i(),this._ComposeScreen_Button11_i(),this._ComposeScreen_Component4_c(),this._ComposeScreen_Button12_i()];
         return _loc1_;
      }
      
      private function _ComposeScreen_GradientBox1_i() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 24;
         _loc1_.children = [this._ComposeScreen_HBox5_c()];
         this._ComposeScreen_GradientBox1 = _loc1_;
         BindingManager.executeBindings(this,"_ComposeScreen_GradientBox1",this._ComposeScreen_GradientBox1);
         return _loc1_;
      }
      
      private function _ComposeScreen_HBox5_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.left = 20;
         _loc1_.verticalCenter = 0;
         _loc1_.children = [this._ComposeScreen_Label4_i(),this._ComposeScreen_MoneyRenderer1_i()];
         return _loc1_;
      }
      
      private function _ComposeScreen_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         this._ComposeScreen_Label4 = _loc1_;
         BindingManager.executeBindings(this,"_ComposeScreen_Label4",this._ComposeScreen_Label4);
         return _loc1_;
      }
      
      private function _ComposeScreen_MoneyRenderer1_i() : MoneyRenderer
      {
         var _loc1_:MoneyRenderer = new MoneyRenderer();
         this._ComposeScreen_MoneyRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_ComposeScreen_MoneyRenderer1",this._ComposeScreen_MoneyRenderer1);
         return _loc1_;
      }
      
      private function _ComposeScreen_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 27;
         _loc1_.addEventListener("click",this.___ComposeScreen_Button11_click);
         this._ComposeScreen_Button11 = _loc1_;
         BindingManager.executeBindings(this,"_ComposeScreen_Button11",this._ComposeScreen_Button11);
         return _loc1_;
      }
      
      public function ___ComposeScreen_Button11_click(event:MouseEvent) : void
      {
         this.send();
      }
      
      private function _ComposeScreen_Component4_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.width = 5;
         return _loc1_;
      }
      
      private function _ComposeScreen_Button12_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 27;
         _loc1_.addEventListener("click",this.___ComposeScreen_Button12_click);
         this._ComposeScreen_Button12 = _loc1_;
         BindingManager.executeBindings(this,"_ComposeScreen_Button12",this._ComposeScreen_Button12);
         return _loc1_;
      }
      
      public function ___ComposeScreen_Button12_click(event:MouseEvent) : void
      {
         this.close();
      }
      
      public function ___ComposeScreen_BorderedContainer1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _ComposeScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return Assets.shadedBorderRound;
         },null,"this.borderSkin");
         result[1] = new Binding(this,function():Object
         {
            return Assets.pattern_06;
         },null,"this.backgroundImage");
         result[2] = new Binding(this,function():Object
         {
            return Assets.mailBackground;
         },null,"_ComposeScreen_CachedImage1.source");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = getString("mail.recipient");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ComposeScreen_Label1.text");
         result[4] = new Binding(this,function():Object
         {
            return Assets.mailBorder;
         },null,"recipient.borderSkin");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = getString("mail.lists");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ComposeScreen_CachedImage2.toolTip");
         result[6] = new Binding(this,function():Object
         {
            return Icons.mailArrow;
         },null,"_ComposeScreen_CachedImage2.source");
         result[7] = new Binding(this,function():String
         {
            var _loc1_:* = getString("mail.subject");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ComposeScreen_Label2.text");
         result[8] = new Binding(this,function():Object
         {
            return Assets.mailBorder;
         },null,"subject.borderSkin");
         result[9] = new Binding(this,function():Object
         {
            return Assets.mailBorder;
         },null,"body.borderSkin");
         result[10] = new Binding(this,function():String
         {
            var _loc1_:* = getString("mail.attachment") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ComposeScreen_Label3.text");
         result[11] = new Binding(this,function():Array
         {
            var _loc1_:* = GRADIENT;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_ComposeScreen_GradientBox1.gradient");
         result[12] = new Binding(this,function():String
         {
            var _loc1_:* = getString("cost") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ComposeScreen_Label4.text");
         result[13] = new Binding(this,function():uint
         {
            return model.mailCost;
         },null,"_ComposeScreen_MoneyRenderer1.value");
         result[14] = new Binding(this,function():Object
         {
            return Icons.accept;
         },null,"_ComposeScreen_Button11.icon");
         result[15] = new Binding(this,function():String
         {
            var _loc1_:* = getString("mail.compose");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ComposeScreen_Button11.toolTip");
         result[16] = new Binding(this,function():Boolean
         {
            return recipient.text.length > 0 && subject.text.length > 0 && recipient.text != characterName;
         },null,"_ComposeScreen_Button11.enabled");
         result[17] = new Binding(this,function():Object
         {
            return Icons.cancel;
         },null,"_ComposeScreen_Button12.icon");
         result[18] = new Binding(this,function():String
         {
            var _loc1_:* = getString("close");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ComposeScreen_Button12.toolTip");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get body() : TextArea
      {
         return this._3029410body;
      }
      
      public function set body(param1:TextArea) : void
      {
         var _loc2_:Object = this._3029410body;
         if(_loc2_ !== param1)
         {
            this._3029410body = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"body",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get coppers() : MoneyEnter
      {
         return this._953258618coppers;
      }
      
      public function set coppers(param1:MoneyEnter) : void
      {
         var _loc2_:Object = this._953258618coppers;
         if(_loc2_ !== param1)
         {
            this._953258618coppers = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"coppers",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get item() : MailItemContainer
      {
         return this._3242771item;
      }
      
      public function set item(param1:MailItemContainer) : void
      {
         var _loc2_:Object = this._3242771item;
         if(_loc2_ !== param1)
         {
            this._3242771item = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"item",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get recipient() : Input
      {
         return this._820081177recipient;
      }
      
      public function set recipient(param1:Input) : void
      {
         var _loc2_:Object = this._820081177recipient;
         if(_loc2_ !== param1)
         {
            this._820081177recipient = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"recipient",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get subject() : Input
      {
         return this._1867885268subject;
      }
      
      public function set subject(param1:Input) : void
      {
         var _loc2_:Object = this._1867885268subject;
         if(_loc2_ !== param1)
         {
            this._1867885268subject = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"subject",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get model() : MailModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:MailModel) : void
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
      
      [Bindable(event="propertyChange")]
      public function get characterName() : String
      {
         return this._1790120620characterName;
      }
      
      public function set characterName(param1:String) : void
      {
         var _loc2_:Object = this._1790120620characterName;
         if(_loc2_ !== param1)
         {
            this._1790120620characterName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"characterName",_loc2_,param1));
            }
         }
      }
   }
}

