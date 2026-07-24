package soul.view.interaction.map
{
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.GlowFilter;
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
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.event.SimpleUIEvent;
   import soul.model.character.CharacterModel;
   import soul.model.group.GroupMember;
   import soul.model.group.GroupModel;
   import soul.model.interaction.map.SectorData;
   import soul.model.rtm.RTMModel;
   import soul.model.system.Configuration;
   import soul.net.ServerLayer;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.Box;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   import soul.view.ui.controls.PopupManager;
   
   public class Map extends Box
   {
      
      private static const labelFilters:Array = [new GlowFilter(0,1,7,7,2)];
      
      private static const labelFormat:TextFormat = new TextFormat("_serif",14,13675637,false,true);
      
      private var _97739box:Component;
      
      public var model:RTMModel;
      
      public var groupModel:GroupModel;
      
      public var characterModel:CharacterModel;
      
      private const image:CachedImage = new CachedImage();
      
      private var timer:Timer = new Timer(1000);
      
      private var dataLoaded:Boolean;
      
      private var rows:uint;
      
      private var cols:uint;
      
      private var mapCoordinates:Object = {};
      
      private var mapFragmentWidth:uint;
      
      private var mapFragmentHeight:uint;
      
      private var mapCharacters:Object = {};
      
      public function Map()
      {
         super();
         this.minHeight = 100;
         this.minWidth = 100;
         this.children = [this._Map_Component1_i()];
         this.addEventListener("creationComplete",this.___Map_Box1_creationComplete);
      }
      
      private function creationComplete() : void
      {
         addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.image.addEventListener(Event.CHANGE,this.onImageLoaded);
         ServerLayer.call("rtmService","getSectorData",this.setSectorData);
      }
      
      private function removed(e:Event) : void
      {
         if(e.target != this)
         {
            return;
         }
         if(this.timer.running)
         {
            this.timer.stop();
         }
      }
      
      private function setSectorData(data:SectorData = null) : void
      {
         if(Boolean(data))
         {
            this.dataLoaded = true;
            this.model.sectorId = data.sectorId;
            this.model.sectorCache[data.sectorId] = data.mapTable;
            this.image.source = Configuration.getMapUrl(data.sectorId);
         }
      }
      
      private function onImageLoaded(e:Event) : void
      {
         this.image.removeEventListener(Event.CHANGE,this.onImageLoaded);
         this.draw();
      }
      
      private function draw() : void
      {
         var mapTable:Array = null;
         var label:Label = null;
         var y:String = null;
         var parent:InteractionWindow = null;
         var row:Array = null;
         var x:String = null;
         var mapId:String = null;
         var key:String = null;
         if(!this.dataLoaded || this.image.width < 1)
         {
            return;
         }
         mapTable = this.model.sectorCache[this.model.sectorId];
         this.box.addChild(this.image);
         this.rows = mapTable.length;
         this.cols = mapTable[0].length;
         this.mapFragmentWidth = this.image.width / this.cols;
         this.mapFragmentHeight = this.image.height / this.rows;
         this.box.width = this.image.width;
         this.box.height = this.image.height;
         for(y in mapTable)
         {
            row = mapTable[y];
            for(x in row)
            {
               mapId = row[x];
               key = this.model.sectorId + "." + mapId;
               this.mapCoordinates[key] = [int(x),int(y)];
               label = new Label(labelFormat);
               label.text = LocaleManager.getString(BundleName.MAPS,key);
               label.y = this.mapFragmentHeight * int(y);
               label.x = this.mapFragmentWidth * (int(x) + 1) - label.width / 2 - this.mapFragmentWidth / 2;
               label.filters = labelFilters;
               this.box.addChild(label);
            }
         }
         parent = InteractionWindow.findInteractionParent(this);
         if(Boolean(parent))
         {
            PopupManager.centerPopup(parent);
            parent.label = LocaleManager.getString(BundleName.INTERFACE,"map.title") + " - " + LocaleManager.getString(BundleName.SECTOR,this.model.sectorId);
         }
         this.timer.start();
         this.onTimer(null);
      }
      
      private function onTimer(e:Event) : void
      {
         ServerLayer.call("groupService","getUnitCoordinates",this.setUnitCoordinates);
      }
      
      private function setUnitCoordinates(value:Object) : void
      {
         var mapCharacter:MapCharacter = null;
         var mapTable:Array = null;
         var characterId:String = null;
         var gm:GroupMember = null;
         var itsMe:Boolean = false;
         var key:String = null;
         var mapCoords:Array = null;
         var dx:int = 0;
         var dy:int = 0;
         var characterX:int = 0;
         var characterY:int = 0;
         var charCoords:Array = null;
         for each(mapCharacter in this.mapCharacters)
         {
            if(this.box.contains(mapCharacter))
            {
               this.box.removeChild(mapCharacter);
            }
         }
         this.mapCharacters = {};
         mapTable = this.model.sectorCache[this.model.sectorId];
         for(characterId in value)
         {
            gm = this.getGroupMemberById(characterId);
            if(gm)
            {
               itsMe = this.characterModel.id == characterId;
               key = itsMe ? this.model.sectorId + "." + this.model.mapId : gm.sectorId + "." + gm.mapId;
               mapCoords = this.mapCoordinates[key];
               if(mapCoords)
               {
                  dx = int(mapCoords[0]);
                  dy = int(mapCoords[1]);
                  mapCharacter = new MapCharacter(itsMe);
                  mapCharacter.characterName = gm.name;
                  if(itsMe)
                  {
                     characterX = this.model.myUnit.x;
                     characterY = this.model.myUnit.y << 1;
                  }
                  else
                  {
                     charCoords = value[characterId];
                     characterX = int(charCoords[0]);
                     characterY = int(charCoords[1]);
                  }
                  mapCharacter.x = dx * this.mapFragmentWidth + characterX / this.model.mapWidth * this.mapFragmentWidth;
                  mapCharacter.y = dy * this.mapFragmentHeight + characterY / this.model.mapHeight * this.mapFragmentHeight;
                  this.box.addChild(mapCharacter);
                  this.mapCharacters[characterId] = mapCharacter;
               }
            }
         }
      }
      
      private function getGroupMemberById(characterId:String) : GroupMember
      {
         var gm:GroupMember = null;
         for each(gm in this.groupModel.members)
         {
            if(gm.id == characterId)
            {
               return gm;
            }
         }
         return null;
      }
      
      private function _Map_Component1_i() : Component
      {
         var _loc1_:Component = new Component();
         this.box = _loc1_;
         BindingManager.executeBindings(this,"box",this.box);
         return _loc1_;
      }
      
      public function ___Map_Box1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      [Bindable(event="propertyChange")]
      public function get box() : Component
      {
         return this._97739box;
      }
      
      public function set box(param1:Component) : void
      {
         var _loc2_:Object = this._97739box;
         if(_loc2_ !== param1)
         {
            this._97739box = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"box",_loc2_,param1));
            }
         }
      }
   }
}

