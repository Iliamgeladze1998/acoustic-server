package soulex.view
{
   import flash.accessibility.*;
   import flash.data.*;
   import flash.debugger.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filesystem.*;
   import flash.geom.*;
   import flash.html.*;
   import flash.html.script.*;
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
   import mx.containers.Canvas;
   import mx.containers.HBox;
   import mx.containers.VBox;
   import mx.controls.Button;
   import mx.controls.CheckBox;
   import mx.controls.ComboBox;
   import mx.controls.Label;
   import mx.controls.TextInput;
   import mx.core.IFlexModuleFactory;
   import mx.core.UIComponent;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.ListEvent;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import soulex.GameConfig;
   import soulex.controller.AirLocale;
   import soulex.event.LoginEvent;
   
   use namespace mx_internal;
   
   public class LoginScreen extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _LoginScreen_Button1:Button;
      
      public var _LoginScreen_Button2:Button;
      
      public var _LoginScreen_Button3:Button;
      
      public var _LoginScreen_Label1:Label;
      
      public var _LoginScreen_Label2:Label;
      
      public var _LoginScreen_Label3:Label;
      
      public var _LoginScreen_Label4:Label;
      
      public var _LoginScreen_Label5:Label;
      
      public var _LoginScreen_Label6:Label;
      
      public var _LoginScreen_Label7:Label;
      
      public var _LoginScreen_Label8:Label;
      
      private var _241734567localeSelector:ComboBox;
      
      private var _389158383passwordInput:TextInput;
      
      private var _522328435remember:CheckBox;
      
      private var _319038143userInput:TextInput;
      
      private var _3613077vbox:VBox;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _1397862439setLogin:String;
      
      private var _1088661219setPassword:String;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function LoginScreen()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "events":{"creationComplete":"___LoginScreen_Canvas1_creationComplete"},
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":VBox,
                  "id":"vbox",
                  "stylesFactory":function():void
                  {
                     this.paddingTop = 190;
                     this.horizontalAlign = "center";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "horizontalCenter":0,
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":Label,
                           "id":"_LoginScreen_Label1",
                           "stylesFactory":function():void
                           {
                              this.fontSize = 13;
                           },
                           "propertiesFactory":function():Object
                           {
                              return {"styleName":"form"};
                           }
                        }),new UIComponentDescriptor({
                           "type":UIComponent,
                           "propertiesFactory":function():Object
                           {
                              return {"height":20};
                           }
                        }),new UIComponentDescriptor({
                           "type":Label,
                           "id":"_LoginScreen_Label2",
                           "propertiesFactory":function():Object
                           {
                              return {"styleName":"form"};
                           }
                        }),new UIComponentDescriptor({
                           "type":TextInput,
                           "id":"userInput",
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "styleName":"form",
                                 "width":200
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":UIComponent,
                           "propertiesFactory":function():Object
                           {
                              return {"height":5};
                           }
                        }),new UIComponentDescriptor({
                           "type":Label,
                           "id":"_LoginScreen_Label3",
                           "propertiesFactory":function():Object
                           {
                              return {"styleName":"form"};
                           }
                        }),new UIComponentDescriptor({
                           "type":TextInput,
                           "id":"passwordInput",
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "displayAsPassword":true,
                                 "styleName":"form",
                                 "width":200
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":CheckBox,
                           "id":"remember"
                        }),new UIComponentDescriptor({
                           "type":UIComponent,
                           "propertiesFactory":function():Object
                           {
                              return {"height":5};
                           }
                        }),new UIComponentDescriptor({
                           "type":Button,
                           "id":"_LoginScreen_Button1",
                           "events":{"click":"___LoginScreen_Button1_click"},
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "styleName":"form",
                                 "width":192,
                                 "height":41
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Button,
                           "id":"_LoginScreen_Button2",
                           "events":{"click":"___LoginScreen_Button2_click"},
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "styleName":"form",
                                 "width":192,
                                 "height":41,
                                 "enabled":false
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Button,
                           "id":"_LoginScreen_Button3",
                           "events":{"click":"___LoginScreen_Button3_click"},
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "styleName":"form",
                                 "width":192,
                                 "height":41
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":HBox,
                           "propertiesFactory":function():Object
                           {
                              return {"childDescriptors":[new UIComponentDescriptor({
                                 "type":Label,
                                 "id":"_LoginScreen_Label4",
                                 "events":{"click":"___LoginScreen_Label4_click"},
                                 "propertiesFactory":function():Object
                                 {
                                    return {"styleName":"form"};
                                 }
                              }),new UIComponentDescriptor({
                                 "type":Canvas,
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "percentHeight":100,
                                       "width":1,
                                       "styleName":"splitter"
                                    };
                                 }
                              }),new UIComponentDescriptor({
                                 "type":Label,
                                 "id":"_LoginScreen_Label5",
                                 "events":{"click":"___LoginScreen_Label5_click"},
                                 "propertiesFactory":function():Object
                                 {
                                    return {"styleName":"form"};
                                 }
                              }),new UIComponentDescriptor({
                                 "type":Canvas,
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "percentHeight":100,
                                       "width":1,
                                       "styleName":"splitter"
                                    };
                                 }
                              }),new UIComponentDescriptor({
                                 "type":Label,
                                 "id":"_LoginScreen_Label6",
                                 "events":{"click":"___LoginScreen_Label6_click"},
                                 "propertiesFactory":function():Object
                                 {
                                    return {"styleName":"form"};
                                 }
                              }),new UIComponentDescriptor({
                                 "type":Canvas,
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "percentHeight":100,
                                       "width":1,
                                       "styleName":"splitter"
                                    };
                                 }
                              }),new UIComponentDescriptor({
                                 "type":Label,
                                 "id":"_LoginScreen_Label7",
                                 "events":{"click":"___LoginScreen_Label7_click"},
                                 "propertiesFactory":function():Object
                                 {
                                    return {"styleName":"form"};
                                 }
                              })]};
                           }
                        }),new UIComponentDescriptor({
                           "type":Label,
                           "id":"_LoginScreen_Label8",
                           "events":{"click":"___LoginScreen_Label8_click"},
                           "propertiesFactory":function():Object
                           {
                              return {"styleName":"form"};
                           }
                        })]
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":ComboBox,
                  "id":"localeSelector",
                  "events":{"change":"__localeSelector_change"},
                  "propertiesFactory":function():Object
                  {
                     return {
                        "x":890,
                        "y":326,
                        "styleName":"form",
                        "width":182,
                        "height":22
                     };
                  }
               })]};
            }
         });
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         bindings = this._LoginScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soulex_view_LoginScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return LoginScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.percentWidth = 100;
         this.percentHeight = 100;
         this.addEventListener("creationComplete",this.___LoginScreen_Canvas1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         LoginScreen._watcherSetupUtil = param1;
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         super.moduleFactory = param1;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
      }
      
      override public function initialize() : void
      {
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         super.initialize();
      }
      
      private function creationComplete() : void
      {
         if(Boolean(this.setLogin) && this.setLogin.length > 0)
         {
            this.passwordInput.setFocus();
         }
         var locales:Array = GameConfig.localeList;
         this.localeSelector.dataProvider = locales;
         for(var i:int = 0; i < locales.length; i++)
         {
            if(locales[i].value == GameConfig.locale)
            {
               this.localeSelector.selectedIndex = i;
               break;
            }
         }
         addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
      }
      
      private function onKeyUp(e:KeyboardEvent) : void
      {
         if(e.keyCode == Keyboard.ENTER)
         {
            if(stage.focus == this.userInput || stage.focus == this.passwordInput)
            {
               this.onEnter();
            }
         }
      }
      
      private function onEnter() : void
      {
         var ne:LoginEvent = new LoginEvent(LoginEvent.CONFIRM);
         ne.user = this.userInput.text;
         ne.password = this.passwordInput.text;
         dispatchEvent(ne);
      }
      
      private function onLocaleChange() : void
      {
         var ne:LoginEvent = new LoginEvent(LoginEvent.LOCALE_CHANGED);
         ne.locale = this.localeSelector.selectedItem.value;
         dispatchEvent(ne);
      }
      
      private function exit() : void
      {
         var ne:LoginEvent = new LoginEvent(LoginEvent.EXIT);
         dispatchEvent(ne);
      }
      
      public function set login(value:String) : void
      {
         this.setLogin = value;
      }
      
      public function set password(value:String) : void
      {
         this.setPassword = value;
      }
      
      private function goto(url:String) : void
      {
         GameConfig.goto(url);
      }
      
      override public function set enabled(value:Boolean) : void
      {
         if(!this.vbox)
         {
            super.enabled = value;
            return;
         }
         this.vbox.alpha = value ? 1 : 0.5;
         this.vbox.mouseEnabled = value;
         this.vbox.mouseChildren = value;
      }
      
      public function ___LoginScreen_Canvas1_creationComplete(event:FlexEvent) : void
      {
         this.creationComplete();
      }
      
      public function ___LoginScreen_Button1_click(event:MouseEvent) : void
      {
         this.onEnter();
      }
      
      public function ___LoginScreen_Button2_click(event:MouseEvent) : void
      {
         this.goto("register");
      }
      
      public function ___LoginScreen_Button3_click(event:MouseEvent) : void
      {
         this.exit();
      }
      
      public function ___LoginScreen_Label4_click(event:MouseEvent) : void
      {
         this.goto("partners");
      }
      
      public function ___LoginScreen_Label5_click(event:MouseEvent) : void
      {
         this.goto("support");
      }
      
      public function ___LoginScreen_Label6_click(event:MouseEvent) : void
      {
         this.goto("forum");
      }
      
      public function ___LoginScreen_Label7_click(event:MouseEvent) : void
      {
         this.goto("help");
      }
      
      public function ___LoginScreen_Label8_click(event:MouseEvent) : void
      {
         this.goto("copyrights");
      }
      
      public function __localeSelector_change(event:ListEvent) : void
      {
         this.onLocaleChange();
      }
      
      private function _LoginScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = AirLocale.getString("login.title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LoginScreen_Label1.text");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = AirLocale.getString("login.login");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LoginScreen_Label2.text");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = setLogin;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"userInput.text");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = AirLocale.getString("login.password");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LoginScreen_Label3.text");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = setPassword;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"passwordInput.text");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = AirLocale.getString("login.remember");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"remember.label");
         result[6] = new Binding(this,function():Boolean
         {
            return setPassword != null;
         },null,"remember.selected");
         result[7] = new Binding(this,function():String
         {
            var _loc1_:* = AirLocale.getString("enterGame");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LoginScreen_Button1.label");
         result[8] = new Binding(this,function():Boolean
         {
            return userInput.text.length > 0 && passwordInput.text.length > 0;
         },null,"_LoginScreen_Button1.enabled");
         result[9] = new Binding(this,function():String
         {
            var _loc1_:* = AirLocale.getString("login.register");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LoginScreen_Button2.label");
         result[10] = new Binding(this,function():String
         {
            var _loc1_:* = AirLocale.getString("exit");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LoginScreen_Button3.label");
         result[11] = new Binding(this,function():String
         {
            var _loc1_:* = AirLocale.getString("login.partners");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LoginScreen_Label4.text");
         result[12] = new Binding(this,function():String
         {
            var _loc1_:* = AirLocale.getString("login.support");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LoginScreen_Label5.text");
         result[13] = new Binding(this,function():String
         {
            var _loc1_:* = AirLocale.getString("login.forum");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LoginScreen_Label6.text");
         result[14] = new Binding(this,function():String
         {
            var _loc1_:* = AirLocale.getString("login.help");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LoginScreen_Label7.text");
         result[15] = new Binding(this,function():String
         {
            var _loc1_:* = AirLocale.getString("login.copyrights");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LoginScreen_Label8.text");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get localeSelector() : ComboBox
      {
         return this._241734567localeSelector;
      }
      
      public function set localeSelector(param1:ComboBox) : void
      {
         var _loc2_:Object = this._241734567localeSelector;
         if(_loc2_ !== param1)
         {
            this._241734567localeSelector = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"localeSelector",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get passwordInput() : TextInput
      {
         return this._389158383passwordInput;
      }
      
      public function set passwordInput(param1:TextInput) : void
      {
         var _loc2_:Object = this._389158383passwordInput;
         if(_loc2_ !== param1)
         {
            this._389158383passwordInput = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"passwordInput",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get remember() : CheckBox
      {
         return this._522328435remember;
      }
      
      public function set remember(param1:CheckBox) : void
      {
         var _loc2_:Object = this._522328435remember;
         if(_loc2_ !== param1)
         {
            this._522328435remember = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"remember",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get userInput() : TextInput
      {
         return this._319038143userInput;
      }
      
      public function set userInput(param1:TextInput) : void
      {
         var _loc2_:Object = this._319038143userInput;
         if(_loc2_ !== param1)
         {
            this._319038143userInput = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"userInput",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get vbox() : VBox
      {
         return this._3613077vbox;
      }
      
      public function set vbox(param1:VBox) : void
      {
         var _loc2_:Object = this._3613077vbox;
         if(_loc2_ !== param1)
         {
            this._3613077vbox = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"vbox",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get setLogin() : String
      {
         return this._1397862439setLogin;
      }
      
      private function set setLogin(param1:String) : void
      {
         var _loc2_:Object = this._1397862439setLogin;
         if(_loc2_ !== param1)
         {
            this._1397862439setLogin = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"setLogin",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get setPassword() : String
      {
         return this._1088661219setPassword;
      }
      
      private function set setPassword(param1:String) : void
      {
         var _loc2_:Object = this._1088661219setPassword;
         if(_loc2_ !== param1)
         {
            this._1088661219setPassword = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"setPassword",_loc2_,param1));
            }
         }
      }
   }
}

