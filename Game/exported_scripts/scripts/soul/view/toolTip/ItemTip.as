package soul.view.toolTip
{
   import soul.controller.locale.LocaleManager;
   import soul.model.character.ParamBonus;
   import soul.model.character.ParamType;
   import soul.model.item.Item;
   import soul.model.item.ItemAutoAbility;
   import soul.model.item.ItemBindingType;
   import soul.model.item.ItemClass;
   import soul.model.item.ItemInfoData;
   import soul.model.item.ItemInfoManager;
   import soul.model.item.ItemType;
   import soul.model.location.shop.ShopModel;
   import soul.model.system.Configuration;
   import soul.sorting.Pair;
   import soul.utils.DateUtils;
   import soul.view.common.MoneyRenderer;
   import soul.view.ui.Component;
   import soul.view.ui.Container;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   
   public class ItemTip extends SoulToolTipBase
   {
      
      private static const MIN_WIDTH:uint = 200;
      
      private var addSplitter:Boolean = false;
      
      private var value:ItemInfoData;
      
      protected var mainInfo:VBox;
      
      public function ItemTip()
      {
         super();
         padding = 5;
         gap = 1;
         visible = false;
      }
      
      override public function prepare() : void
      {
         if(prepared)
         {
            return;
         }
         var item:Item = data as Item;
         if(!item)
         {
            return;
         }
         var id:String = item.id != null && item.id != "0" ? SoulToolTipBase.PREFIX_ITEM + SoulToolTipBase.DELIMITER + item.id : SoulToolTipBase.PREFIX_TEMPLATE + SoulToolTipBase.DELIMITER + item.templateId;
         if(ItemInfoManager.hasInfo(id))
         {
            this.setInfo(ItemInfoManager.getItemInfo(id));
         }
         else
         {
            ItemInfoManager.requestInfo(id,this.setInfo);
         }
      }
      
      private function setInfo(ii:ItemInfoData) : void
      {
         this.value = ii;
         if(!this.value)
         {
            return;
         }
         visible = true;
         removeAllChildren();
         this.draw();
      }
      
      protected function draw() : void
      {
         var hbox:HBox = null;
         var money:MoneyRenderer = null;
         var pair:Pair = null;
         var sortedPairs:Vector.<Pair> = null;
         var splitter:Component = null;
         var label:Label = null;
         var currency:String = null;
         var priceValue:int = 0;
         var realDate:Date = null;
         var timeLeft:Number = NaN;
         var expiresString:String = null;
         var autoAbility:ItemAutoAbility = null;
         var container:HBox = null;
         var setInfo:VBox = null;
         var item:String = null;
         var count:String = null;
         var countBonuses:ParamBonus = null;
         this.mainInfo = new VBox();
         this.mainInfo.minWidth = MIN_WIDTH;
         label = new Label();
         label.color = ItemClass.getItemColor(this.value.itemClass);
         label.text = LocaleManager.getItemName(this.value.templateId,this.value.suffixId,this.value.locId);
         this.mainInfo.addChild(label);
         label = new Label();
         label.color = 16777215;
         label.text = getString(this.value.type) + (this.value.type == ItemType.JEWEL ? " (" + getString(this.value.subType) + ")" : "") + (this.value.usable ? " (" + getString("usable") + ")" : "");
         this.mainInfo.addChild(label);
         if(this.value.capacity > 0)
         {
            label = new Label();
            label.color = 16777215;
            label.text = getString("CAPACITY") + reqBonSuffix + this.value.capacity;
            this.mainInfo.addChild(label);
         }
         this.addSplitter = true;
         this.drawSplitter(this.mainInfo);
         if(Boolean(this.value.binding) && this.value.binding != ItemBindingType.NONE)
         {
            this.addSplitter = true;
            label = new Label();
            label.color = 16777215;
            label.text = getString(this.value.bound ? "binding.BOUND" : "binding." + this.value.binding);
            this.mainInfo.addChild(label);
         }
         if(Boolean(this.value.expires) && int(this.value.id) > 0)
         {
            this.addSplitter = true;
            label = new Label();
            label.color = 16777215;
            realDate = Configuration.serverDateToLocal(this.value.expires);
            timeLeft = Math.max(0,realDate.time - new Date().time);
            expiresString = DateUtils.getTimeLeft(timeLeft);
            label.text = getString("EXPIRES") + ": " + expiresString;
            this.mainInfo.addChild(label);
         }
         else if(this.value.ttl > 0 && int(this.value.id) <= 0)
         {
            this.addSplitter = true;
            label = new Label();
            label.color = 16777215;
            label.text = getString("EXPIRES") + ": " + DateUtils.getTimeLeft(this.value.ttl);
            this.mainInfo.addChild(label);
         }
         this.drawSplitter(this.mainInfo);
         if(this.value.durabilityMaximum != 0)
         {
            label = new Label();
            label.color = this.value.durability > 0 ? 16304748 : 16733525;
            label.text = getString("DURABILITY") + ": " + this.value.durability + "/" + (this.value.durabilityMaximum > 0 ? this.value.durabilityMaximum : "-");
            this.mainInfo.addChild(label);
            this.addSplitter = true;
            if(this.value.repairsLeft > -1)
            {
               label = new Label();
               label.color = 16304748;
               label.text = getString("REPAIRS_LEFT") + ": " + this.value.repairsLeft;
               this.mainInfo.addChild(label);
            }
         }
         if(Boolean(this.value.bonus.add) || Boolean(this.value.bonus.mult))
         {
            this.drawSplitter(this.mainInfo);
            label = new Label();
            label.color = 1441542;
            label.text = getString("PROPERTIES") + ":";
            this.mainInfo.addChild(label);
            sortedPairs = ParamType.sortParams(this.value.bonus.add);
            for each(pair in sortedPairs)
            {
               label = new Label();
               label.color = 16777215;
               label.text = "- " + getString(String(pair.first)) + ": " + (pair.second > 0 ? "+" : "") + pair.second;
               this.mainInfo.addChild(label);
            }
            sortedPairs = ParamType.sortParams(this.value.bonus.mult);
            for each(pair in sortedPairs)
            {
               label = new Label();
               label.color = 16777215;
               label.text = "- " + getString(String(pair.first)) + ": " + int(Number(pair.second) * 100) + "%";
               this.mainInfo.addChild(label);
            }
            this.addSplitter = true;
         }
         if(this.value.sockets > 0)
         {
            label = new Label();
            label.color = 16777215;
            label.text = getString("SOCKETS") + reqBonSuffix + this.value.jewels + "/" + this.value.sockets;
            this.mainInfo.addChild(label);
            if(Boolean(this.value.jewelBonus))
            {
               sortedPairs = ParamType.sortParams(this.value.jewelBonus.add);
               for each(pair in sortedPairs)
               {
                  label = new Label();
                  label.color = 16777215;
                  label.text = "- " + getString(String(pair.first)) + ": " + (pair.second > 0 ? "+" : "") + pair.second;
                  this.mainInfo.addChild(label);
               }
               sortedPairs = ParamType.sortParams(this.value.jewelBonus.mult);
               for each(pair in sortedPairs)
               {
                  label = new Label();
                  label.color = 16777215;
                  label.text = "- " + getString(String(pair.first)) + ": " + (pair.second > 0 ? "+" : "") + pair.second;
                  this.mainInfo.addChild(label);
               }
            }
            this.addSplitter = true;
         }
         if(Boolean(this.value.autoAbilities) && this.value.autoAbilities.length > 0)
         {
            for each(autoAbility in this.value.autoAbilities)
            {
               this.mainInfo.addChild(createSplitter());
               this.mainInfo.addChild(new ItemAutoAbilityRenderer(autoAbility));
            }
         }
         if(Boolean(this.value.requirements || this.value.dispositionGroup || this.value.disposition || this.value.race || this.value.side) || Boolean(this.value.clan) || Boolean(this.value.level))
         {
            this.drawSplitter(this.mainInfo);
            label = new Label();
            label.color = 16730455;
            label.text = getString("REQUIREMENTS") + ":";
            this.mainInfo.addChild(label);
            if(Boolean(this.value.level))
            {
               label = new Label();
               label.color = 16777215;
               label.text = reqBonPrefix + getString("character.level") + reqBonSuffix + this.value.level;
               this.mainInfo.addChild(label);
            }
            if(Boolean(this.value.dispositionGroup))
            {
               label = new Label();
               label.color = 16777215;
               label.text = reqBonPrefix + getString("character.dispositionGroup") + reqBonSuffix + this.getArray(this.value.dispositionGroup);
               this.mainInfo.addChild(label);
            }
            if(Boolean(this.value.disposition))
            {
               label = new Label();
               label.color = 16777215;
               label.text = reqBonPrefix + getString("character.disposition") + reqBonSuffix + this.getArray(this.value.disposition);
               this.mainInfo.addChild(label);
            }
            if(Boolean(this.value.side))
            {
               label = new Label();
               label.color = 16777215;
               label.text = reqBonPrefix + getString("side") + reqBonSuffix + getString(this.value.side);
               this.mainInfo.addChild(label);
            }
            if(Boolean(this.value.clan))
            {
               label = new Label();
               label.color = 16777215;
               label.text = reqBonPrefix + getString("clan") + reqBonSuffix + this.value.clan;
               this.mainInfo.addChild(label);
            }
            sortedPairs = ParamType.sortParams(this.value.requirements);
            for each(pair in sortedPairs)
            {
               label = new Label();
               label.color = 16777215;
               label.text = reqBonPrefix + getString(String(pair.first)) + ": " + pair.second;
               this.mainInfo.addChild(label);
            }
            this.addSplitter = true;
         }
         var description:String = LocaleManager.getItemDescription(this.value.templateId,this.value.descId);
         if(Boolean(description))
         {
            this.drawSplitter(this.mainInfo);
            label = new Label();
            label.color = 16777215;
            label.percentWidth = 100;
            label.wordWrap = true;
            label.multiline = true;
            label.htmlText = description;
            this.mainInfo.addChild(label);
            this.addSplitter = true;
         }
         var priceContent:HBox = new HBox();
         priceContent.verticalAlign = "middle";
         label = new Label();
         label.color = 16304748;
         label.text = getString("COST") + ": ";
         priceContent.addChild(label);
         for(currency in this.value.price)
         {
            priceValue = int(this.value.price[currency]);
            money = new MoneyRenderer();
            money.type = currency;
            money.value = priceValue;
            splitter = new Component();
            splitter.width = 20;
            priceContent.addChild(money);
            priceContent.addChild(splitter);
         }
         if(priceContent.numChildren > 1)
         {
            this.drawSplitter(this.mainInfo);
            this.mainInfo.addChild(priceContent);
         }
         var shopPrice:Object = Boolean(ShopModel.sellDatas) ? ShopModel.sellDatas[this.value.id] : null;
         if(Boolean(shopPrice))
         {
            priceContent = new HBox();
            priceContent.verticalAlign = "middle";
            label = new Label();
            label.color = 16304748;
            label.text = getString("SHOP_COST") + ": ";
            priceContent.addChild(label);
            for(currency in shopPrice)
            {
               priceValue = int(shopPrice[currency]);
               money = new MoneyRenderer();
               money.type = currency;
               money.value = priceValue;
               splitter = new Component();
               splitter.width = 20;
               priceContent.addChild(money);
               priceContent.addChild(splitter);
            }
            if(priceContent.numChildren > 1)
            {
               this.mainInfo.addChild(priceContent);
            }
         }
         else if(Boolean(ShopModel.sellDatas) && int(this.value.id) > 0)
         {
            label = new Label();
            label.color = 16304748;
            label.text = getString("SHOP_NOT_ACCEPTS");
            this.mainInfo.addChild(label);
         }
         if(Boolean(this.value.setInfo))
         {
            container = new HBox();
            container.addChild(this.mainInfo);
            splitter = new TipSplitter();
            splitter.width = 1;
            splitter.percentHeight = 100;
            container.addChild(splitter);
            setInfo = new VBox();
            label = new Label();
            label.color = 5598446;
            label.text = LocaleManager.getItemName(this.value.setInfo.name);
            setInfo.addChild(label);
            for each(item in this.value.setInfo.items)
            {
               label = new Label();
               label.color = 16777215;
               label.text = "- " + LocaleManager.getItemName(item);
               setInfo.addChild(label);
            }
            splitter = new Component();
            splitter.height = 10;
            setInfo.addChild(splitter);
            for(count in this.value.setInfo.countBonuses)
            {
               label = new Label();
               label.color = 10661108;
               label.text = getString("BONUSES") + ": " + count;
               setInfo.addChild(label);
               countBonuses = this.value.setInfo.countBonuses[count];
               sortedPairs = ParamType.sortParams(countBonuses.add);
               for each(pair in sortedPairs)
               {
                  label = new Label();
                  label.color = 10661108;
                  label.text = "- " + getString(String(pair.first)) + ": " + (int(pair.second) > 0 ? "+" : "") + pair.second;
                  setInfo.addChild(label);
               }
               sortedPairs = ParamType.sortParams(countBonuses.mult);
               for each(pair in sortedPairs)
               {
                  label = new Label();
                  label.color = 10661108;
                  label.text = "- " + getString(String(pair.first)) + ": " + (pair.second > 0 ? "+" : "") + Math.round(Number(pair.second) * 100) + "%";
                  setInfo.addChild(label);
               }
               splitter = new Component();
               splitter.height = 5;
               setInfo.addChild(splitter);
            }
            container.addChild(setInfo);
            addChild(container);
         }
         else
         {
            addChild(this.mainInfo);
         }
         if(int(this.value.id) <= 0)
         {
            prepared = true;
         }
      }
      
      private function drawSplitter(container:Container) : void
      {
         if(!this.addSplitter)
         {
            return;
         }
         container.addChild(createSplitter());
         this.addSplitter = false;
      }
      
      private function getArray(src:Array) : Array
      {
         var str:String = null;
         var arr:Array = [];
         for each(str in src)
         {
            arr.push(getString(str));
         }
         return arr;
      }
   }
}

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import soul.controller.locale.BundleName;
import soul.controller.locale.LocaleManager;
import soul.model.GameModel;
import soul.model.ability.Ability;
import soul.model.ability.AbilityModel;
import soul.model.item.ItemAutoAbility;
import soul.view.ui.Box;
import soul.view.ui.Component;
import soul.view.ui.Container;
import soul.view.ui.Label;
import soul.view.ui.VBox;

class ItemAutoAbilityRenderer extends VBox
{
   
   private var description:Component;
   
   private var model:AbilityModel = GameModel.getInstance().abilityModel;
   
   private var abilityId:String;
   
   private var _ability:Ability;
   
   public function ItemAutoAbilityRenderer(value:ItemAutoAbility)
   {
      super();
      this.abilityId = value.abilityId;
      var label:Label = new Label();
      label.text = LocaleManager.getString(BundleName.TOOLTIP,value.condition) + " " + Math.round(value.chance * 100) + "%:";
      addChild(label);
      var ability:Ability = this.model.getAbilityById(value.abilityId);
      ability.addEventListener(Event.CHANGE,this.abilityChanged);
      this.ability = ability;
   }
   
   private function abilityChanged(e:Event) : void
   {
      this.ability = e.target as Ability;
   }
   
   public function set ability(value:Ability) : void
   {
      this._ability = value;
      this.drawDescription();
   }
   
   private function drawDescription() : void
   {
      var label:Label = null;
      var description:VBox = null;
      if(Boolean(this.description))
      {
         removeChild(this.description);
         this.description = null;
      }
      if(!this._ability || Boolean(this._ability.loading))
      {
         label = new Label();
         label.text = "Loading... " + this.abilityId;
         this.description = label;
      }
      else
      {
         description = AbilityTip.createDesription(this._ability) as VBox;
         description.padding = 0;
         this.description = description;
      }
      addChild(this.description);
   }
}
