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
   import mx.containers.VBox;
   import mx.controls.Label;
   import mx.core.IFlexModuleFactory;
   import mx.core.UIComponent;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.system.Configuration;
   import soulex.CharacterInfo;
   import soulex.controller.AirLocale;
   import spark.components.Image;
   
   use namespace mx_internal;
   
   public class CharacterInfoRenderer extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _CharacterInfoRenderer_Image1:Image;
      
      public var _CharacterInfoRenderer_Label1:Label;
      
      public var _CharacterInfoRenderer_Label2:Label;
      
      public var _CharacterInfoRenderer_Label3:Label;
      
      public var _CharacterInfoRenderer_Label4:Label;
      
      public var _CharacterInfoRenderer_VBox1:VBox;
      
      private var _1435216111charIcon:Image;
      
      private var _1191572447selector:UIComponent;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _3237038info:CharacterInfo;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function CharacterInfoRenderer()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":Image,
                  "id":"_CharacterInfoRenderer_Image1"
               }),new UIComponentDescriptor({
                  "type":Image,
                  "id":"charIcon",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "x":24,
                        "y":20,
                        "width":60,
                        "height":60
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":VBox,
                  "id":"_CharacterInfoRenderer_VBox1",
                  "stylesFactory":function():void
                  {
                     this.verticalGap = 0;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "x":110,
                        "y":10,
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":Label,
                           "id":"_CharacterInfoRenderer_Label1",
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "styleName":"form",
                                 "maxWidth":136
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Label,
                           "id":"_CharacterInfoRenderer_Label2",
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "styleName":"form",
                                 "maxWidth":136
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Label,
                           "id":"_CharacterInfoRenderer_Label3",
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "styleName":"form",
                                 "maxWidth":136
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Label,
                           "id":"_CharacterInfoRenderer_Label4",
                           "propertiesFactory":function():Object
                           {
                              return {"styleName":"form"};
                           }
                        })]
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":UIComponent,
                  "id":"selector"
               })]};
            }
         });
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         bindings = this._CharacterInfoRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soulex_view_CharacterInfoRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return CharacterInfoRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         CharacterInfoRenderer._watcherSetupUtil = param1;
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
      
      private function getAvatarImage(info:CharacterInfo) : String
      {
         return Configuration.staticServerURL + "/images/avatar/small/" + info.avatar;
      }
      
      public function set selected(value:Boolean) : void
      {
         this.selector.graphics.clear();
         if(value)
         {
            this.selector.graphics.lineStyle(3,65280,0.5);
            this.selector.graphics.drawRect(21,17,66,66);
         }
      }
      
      private function getClass(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key.toUpperCase());
      }
      
      private function getPlace(key:String) : String
      {
         return LocaleManager.getString(BundleName.SECTOR,key);
      }
      
      private function _CharacterInfoRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return AirAssets.frame;
         },null,"_CharacterInfoRenderer_Image1.source");
         result[1] = new Binding(this,function():Object
         {
            return getAvatarImage(info);
         },null,"charIcon.source");
         result[2] = new Binding(this,null,null,"_CharacterInfoRenderer_VBox1.visible","info");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = info.name;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_CharacterInfoRenderer_Label1.text");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = getPlace(info.location);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_CharacterInfoRenderer_Label2.text");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = getClass(info.disposition);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_CharacterInfoRenderer_Label3.text");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = AirLocale.getString("level") + ": " + info.level;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_CharacterInfoRenderer_Label4.text");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get charIcon() : Image
      {
         return this._1435216111charIcon;
      }
      
      public function set charIcon(param1:Image) : void
      {
         var _loc2_:Object = this._1435216111charIcon;
         if(_loc2_ !== param1)
         {
            this._1435216111charIcon = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"charIcon",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selector() : UIComponent
      {
         return this._1191572447selector;
      }
      
      public function set selector(param1:UIComponent) : void
      {
         var _loc2_:Object = this._1191572447selector;
         if(_loc2_ !== param1)
         {
            this._1191572447selector = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selector",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get info() : CharacterInfo
      {
         return this._3237038info;
      }
      
      public function set info(param1:CharacterInfo) : void
      {
         var _loc2_:Object = this._3237038info;
         if(_loc2_ !== param1)
         {
            this._3237038info = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"info",_loc2_,param1));
            }
         }
      }
   }
}

