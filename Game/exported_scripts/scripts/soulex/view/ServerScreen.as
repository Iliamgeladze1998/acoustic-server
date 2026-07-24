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
   import mx.controls.ComboBox;
   import mx.controls.Label;
   import mx.core.IFlexModuleFactory;
   import mx.core.UIComponent;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.ListEvent;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import soul.view.AlertStyleProxy;
   import soul.view.common.Icons;
   import soulex.GameConfig;
   import soulex.ServerInfo;
   import soulex.controller.AirLocale;
   import soulex.event.CharacterEvent;
   import soulex.event.ServerEvent;
   import spark.components.Image;
   
   use namespace mx_internal;
   
   public class ServerScreen extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _ServerScreen_Button1:Button;
      
      public var _ServerScreen_Button2:Button;
      
      public var _ServerScreen_Image1:Image;
      
      public var _ServerScreen_Label1:Label;
      
      public var _ServerScreen_Label2:Label;
      
      public var _ServerScreen_Label3:Label;
      
      public var _ServerScreen_Label4:Label;
      
      private var _1826162047serverList:ComboBox;
      
      private var _3560110tile:CharacterSelector;
      
      private var _3613077vbox:VBox;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ServerScreen()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "events":{"creationComplete":"___ServerScreen_Canvas1_creationComplete"},
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
                           "id":"_ServerScreen_Label1",
                           "stylesFactory":function():void
                           {
                              this.fontSize = 13;
                           },
                           "propertiesFactory":function():Object
                           {
                              return {"styleName":"form"};
                           }
                        }),new UIComponentDescriptor({
                           "type":HBox,
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "percentWidth":100,
                                 "childDescriptors":[new UIComponentDescriptor({
                                    "type":UIComponent,
                                    "propertiesFactory":function():Object
                                    {
                                       return {"width":25};
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":Label,
                                    "id":"_ServerScreen_Label2",
                                    "propertiesFactory":function():Object
                                    {
                                       return {"styleName":"form"};
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":Label,
                                    "id":"_ServerScreen_Label3",
                                    "stylesFactory":function():void
                                    {
                                       this.textAlign = "center";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "styleName":"form",
                                          "percentWidth":100
                                       };
                                    }
                                 })]
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":HBox,
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "percentWidth":100,
                                 "childDescriptors":[new UIComponentDescriptor({
                                    "type":UIComponent,
                                    "propertiesFactory":function():Object
                                    {
                                       return {"width":25};
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":Label,
                                    "id":"_ServerScreen_Label4",
                                    "propertiesFactory":function():Object
                                    {
                                       return {"styleName":"form"};
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":ComboBox,
                                    "id":"serverList",
                                    "events":{"change":"__serverList_change"},
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "enabled":false,
                                          "styleName":"form",
                                          "width":320,
                                          "height":24
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":UIComponent,
                                    "propertiesFactory":function():Object
                                    {
                                       return {"percentWidth":100};
                                    }
                                 })]
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":CharacterSelector,
                           "id":"tile",
                           "events":{"select":"__tile_select"},
                           "stylesFactory":function():void
                           {
                              this.horizontalGap = 0;
                              this.verticalGap = 10;
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "percentWidth":100,
                                 "percentHeight":100
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":HBox,
                           "stylesFactory":function():void
                           {
                              this.horizontalGap = 50;
                           },
                           "propertiesFactory":function():Object
                           {
                              return {"childDescriptors":[new UIComponentDescriptor({
                                 "type":Button,
                                 "id":"_ServerScreen_Button1",
                                 "events":{"click":"___ServerScreen_Button1_click"},
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
                                 "id":"_ServerScreen_Button2",
                                 "events":{"click":"___ServerScreen_Button2_click"},
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "styleName":"form",
                                       "width":192,
                                       "height":41
                                    };
                                 }
                              })]};
                           }
                        })]
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Image,
                  "id":"_ServerScreen_Image1",
                  "events":{"click":"___ServerScreen_Image1_click"},
                  "propertiesFactory":function():Object
                  {
                     return {
                        "x":1000,
                        "y":30
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
         bindings = this._ServerScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soulex_view_ServerScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return ServerScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.percentWidth = 100;
         this.percentHeight = 100;
         this.addEventListener("creationComplete",this.___ServerScreen_Canvas1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ServerScreen._watcherSetupUtil = param1;
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
         var info:ServerInfo = null;
         var servers:Array = GameConfig.servers;
         this.serverList.enabled = true;
         this.serverList.dataProvider = servers;
         var selectedIndex:int = 0;
         for(var i:int = 0; i < servers.length; i++)
         {
            info = servers[i];
            if(info.id == GameConfig.lastServer)
            {
               selectedIndex = i;
               break;
            }
         }
         this.serverList.selectedIndex = selectedIndex;
         this.serverSelected();
      }
      
      private function serverSelected() : void
      {
         trace("serverSelected");
         var ne:ServerEvent = new ServerEvent(ServerEvent.SERVER_SELECTED);
         ne.index = this.serverList.selectedIndex;
         dispatchEvent(ne);
      }
      
      private function onCancel() : void
      {
         var ne:Event = new Event(Event.CLOSE);
         dispatchEvent(ne);
      }
      
      private function onCreate() : void
      {
         AlertStyleProxy.show(AirLocale.getString("login.register.unavailable"),AirLocale.getString("warning"));
      }
      
      private function onSelect() : void
      {
         var ne:CharacterEvent = new CharacterEvent(CharacterEvent.CHARACTER_SELECTED);
         ne.id = this.tile.selectedCharacterIndex;
         dispatchEvent(ne);
      }
      
      public function set characters(value:Array) : void
      {
         this.tile.characters = value;
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
      
      public function ___ServerScreen_Canvas1_creationComplete(event:FlexEvent) : void
      {
         this.creationComplete();
      }
      
      public function __serverList_change(event:ListEvent) : void
      {
         this.serverSelected();
      }
      
      public function __tile_select(event:Event) : void
      {
         this.onSelect();
      }
      
      public function ___ServerScreen_Button1_click(event:MouseEvent) : void
      {
         this.onSelect();
      }
      
      public function ___ServerScreen_Button2_click(event:MouseEvent) : void
      {
         this.onCreate();
      }
      
      public function ___ServerScreen_Image1_click(event:MouseEvent) : void
      {
         this.onCancel();
      }
      
      private function _ServerScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = AirLocale.getString("server.title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ServerScreen_Label1.text");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = AirLocale.getString("server.account") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ServerScreen_Label2.text");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = GameConfig.lastLogin;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ServerScreen_Label3.text");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = AirLocale.getString("server.server") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ServerScreen_Label4.text");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = AirLocale.getString("enterGame");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ServerScreen_Button1.label");
         result[5] = new Binding(this,function():Boolean
         {
            return tile.selectedCharacterIndex > -1;
         },null,"_ServerScreen_Button1.enabled");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = AirLocale.getString("server.create");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ServerScreen_Button2.label");
         result[7] = new Binding(this,function():Object
         {
            return Icons.close;
         },null,"_ServerScreen_Image1.source");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get serverList() : ComboBox
      {
         return this._1826162047serverList;
      }
      
      public function set serverList(param1:ComboBox) : void
      {
         var _loc2_:Object = this._1826162047serverList;
         if(_loc2_ !== param1)
         {
            this._1826162047serverList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"serverList",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get tile() : CharacterSelector
      {
         return this._3560110tile;
      }
      
      public function set tile(param1:CharacterSelector) : void
      {
         var _loc2_:Object = this._3560110tile;
         if(_loc2_ !== param1)
         {
            this._3560110tile = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tile",_loc2_,param1));
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
   }
}

