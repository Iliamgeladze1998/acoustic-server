package soul.view.interaction.character
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
   import soul.controller.Interaction;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.event.CharacterEvent;
   import soul.event.InventoryEvent;
   import soul.event.SimpleUIEvent;
   import soul.model.achievement.AchievementModel;
   import soul.model.character.CharPropertyType;
   import soul.model.character.CharacterModel;
   import soul.model.character.ParamType;
   import soul.model.common.InteractionType;
   import soul.model.interaction.clan.ClanModel;
   import soul.model.interaction.ruby.SubscriptionType;
   import soul.model.inventory.BodyModel;
   import soul.model.inventory.InventoryModel;
   import soul.model.item.Item;
   import soul.model.rtm.RTMModel;
   import soul.model.system.Configuration;
   import soul.view.assets.Assets;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientLabel;
   import soul.view.assets.RoundImage;
   import soul.view.chat.ClanIcon;
   import soul.view.interaction.achievement.AchievementPointsInfo;
   import soul.view.interaction.character.parts.ReputationBox;
   import soul.view.interaction.character.parts.ResistRenderer;
   import soul.view.interaction.character.parts.StatControls;
   import soul.view.interaction.inventory.Doll;
   import soul.view.interaction.inventory.ItemRenderer;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Canvas;
   import soul.view.ui.Component;
   import soul.view.ui.Container;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   import soul.view.ui.controls.PopupManager;
   
   use namespace mx_internal;
   
   public class InternalInfo extends Container implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const MAX_GIFTS:uint = 6;
      
      public var _InternalInfo_AchievementPointsInfo1:AchievementPointsInfo;
      
      public var _InternalInfo_CachedImage1:CachedImage;
      
      public var _InternalInfo_CachedImage2:CachedImage;
      
      public var _InternalInfo_CachedImage3:CachedImage;
      
      public var _InternalInfo_CachedImage4:CachedImage;
      
      public var _InternalInfo_CachedImage5:CachedImage;
      
      public var _InternalInfo_CachedImage6:CachedImage;
      
      public var _InternalInfo_CachedImage7:CachedImage;
      
      public var _InternalInfo_ClanIcon1:ClanIcon;
      
      public var _InternalInfo_Doll1:Doll;
      
      public var _InternalInfo_GradientLabel1:GradientLabel;
      
      public var _InternalInfo_GradientLabel2:GradientLabel;
      
      public var _InternalInfo_HBox2:HBox;
      
      public var _InternalInfo_Label1:Label;
      
      public var _InternalInfo_Label2:Label;
      
      public var _InternalInfo_Label3:Label;
      
      public var _InternalInfo_Label4:Label;
      
      public var _InternalInfo_Label5:Label;
      
      public var _InternalInfo_ReputationBox1:ReputationBox;
      
      public var _InternalInfo_ResistRenderer1:ResistRenderer;
      
      public var _InternalInfo_ResistRenderer2:ResistRenderer;
      
      public var _InternalInfo_ResistRenderer3:ResistRenderer;
      
      public var _InternalInfo_ResistRenderer4:ResistRenderer;
      
      public var _InternalInfo_ResistRenderer5:ResistRenderer;
      
      public var _InternalInfo_ResistRenderer6:ResistRenderer;
      
      public var _InternalInfo_ResistRenderer7:ResistRenderer;
      
      public var _InternalInfo_RoundImage1:RoundImage;
      
      private var _27381371giftBox:HBox;
      
      private var _1923867350statControls:StatControls;
      
      private var _109757599stats:Canvas;
      
      private var _104069929model:InventoryModel;
      
      private var _340320640characterModel:CharacterModel;
      
      private var _116778114rtmModel:RTMModel;
      
      private var _187142541clanModel:ClanModel;
      
      private var _2075894074achievementModel:AchievementModel;
      
      private var _1925822394showGifts:Boolean = false;
      
      private var _626994798characterWeapons:Array;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function InternalInfo()
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
         bindings = this._InternalInfo_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_character_InternalInfoWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return InternalInfo[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 390;
         this.height = 480;
         this.children = [this._InternalInfo_Container2_c(),this._InternalInfo_CachedImage5_i(),this._InternalInfo_Canvas1_i()];
         this.addEventListener("creationComplete",this.___InternalInfo_Container1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         InternalInfo._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         addEventListener(Event.REMOVED,this.removed);
         addEventListener(InventoryEvent.TAKEOFF,this.delegate,false,0,true);
         addEventListener(InventoryEvent.CHANGE_BODY_SLOT,this.delegate,false,0,true);
         addEventListener(InventoryEvent.EQUIP_TO_SLOT,this.delegate,false,0,true);
         addEventListener(InventoryEvent.EQUIP,this.delegate,false,0,true);
         addEventListener(InventoryEvent.DROP,this.delegate,false,0,true);
         addEventListener(InventoryEvent.CREATE_AUTO_RUNE_SHORTCUT,this.delegateToCharacter,false,0,true);
         addEventListener(InventoryEvent.REMOVE_AUTO_RUNE_SHORTCUT,this.delegateToCharacter,false,0,true);
         this.level = 0;
      }
      
      private function removed(e:Event) : void
      {
         if(e.target != this)
         {
            return;
         }
         removeEventListener(InventoryEvent.TAKEOFF,this.delegate,false);
         removeEventListener(InventoryEvent.CHANGE_BODY_SLOT,this.delegate,false);
         removeEventListener(InventoryEvent.EQUIP_TO_SLOT,this.delegate,false);
         removeEventListener(InventoryEvent.EQUIP,this.delegate,false);
         removeEventListener(InventoryEvent.DROP,this.delegate,false);
         removeEventListener(InventoryEvent.CREATE_AUTO_RUNE_SHORTCUT,this.delegateToCharacter,false);
         removeEventListener(InventoryEvent.REMOVE_AUTO_RUNE_SHORTCUT,this.delegateToCharacter,false);
      }
      
      private function set sixGifts(value:Array) : void
      {
         var item:Item = null;
         var itemRenderer:ItemRenderer = null;
         this.giftBox.removeAllChildren();
         for each(item in value)
         {
            itemRenderer = new ItemRenderer();
            itemRenderer.item = item;
            itemRenderer.width = itemRenderer.height = 51;
            this.giftBox.addChild(itemRenderer);
         }
      }
      
      private function getSixGifts(awards:Array, gifts:Array, trophies:Array) : Array
      {
         var i:uint = 0;
         var arr:Array = [];
         var count:uint = 0;
         i = 0;
         while(count < MAX_GIFTS && i < awards.length)
         {
            arr.push(awards[i]);
            count++;
            i++;
         }
         i = 0;
         while(count < MAX_GIFTS && i < gifts.length)
         {
            arr.push(gifts[i]);
            count++;
            i++;
         }
         i = 0;
         while(count < MAX_GIFTS && i < trophies.length)
         {
            arr.push(trophies[i]);
            count++;
            i++;
         }
         while(count < MAX_GIFTS)
         {
            arr.unshift(null);
            count++;
         }
         return arr;
      }
      
      private function openGifts() : void
      {
         var giftPopup:GiftPopup = new GiftPopup();
         giftPopup.body = this.model.body;
         PopupManager.addPopup(giftPopup,null,true);
         PopupManager.centerPopup(giftPopup);
      }
      
      private function openClan() : void
      {
         Interaction.toggle(InteractionType.CLAN);
      }
      
      private function openAchievements() : void
      {
         Interaction.toggle(InteractionType.ACHIEVEMENT);
      }
      
      private function set level(value:uint) : void
      {
         var title:String = this.characterModel.name + " [" + this.characterModel.properties[CharPropertyType.LEVEL] + "]";
         InteractionWindow.findInteractionParent(this).label = title;
      }
      
      private function onChange() : void
      {
         var ne:CharacterEvent = new CharacterEvent(CharacterEvent.PREVIEW);
         ne.previewObject = this.statControls.collectStats();
         this.characterModel.dispatchEvent(ne);
      }
      
      private function onComplete() : void
      {
         var ne:CharacterEvent = new CharacterEvent(CharacterEvent.ACCEPT);
         ne.previewObject = this.statControls.collectStats();
         this.statControls.reset();
         this.characterModel.dispatchEvent(ne);
      }
      
      private function delegate(e:InventoryEvent) : void
      {
         e.stopPropagation();
         this.model.dispatchEvent(e.clone());
      }
      
      private function delegateToCharacter(e:InventoryEvent) : void
      {
         e.stopPropagation();
         this.characterModel.dispatchEvent(e.clone());
      }
      
      private function openSubscription() : void
      {
         Interaction.show(InteractionType.RUBY,false,1);
      }
      
      private function openAvatar() : void
      {
         Interaction.show(InteractionType.AVATARS,false,1);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function getSubscription(type:String) : String
      {
         return Boolean(type) ? LocaleManager.getSubscriptionName(type) : this.getString("subscription.noSubscription");
      }
      
      private function _InternalInfo_Container2_c() : Container
      {
         var _loc1_:Container = null;
         _loc1_ = new Container();
         _loc1_.x = -3;
         _loc1_.y = -1;
         _loc1_.children = [this._InternalInfo_CachedImage1_i(),this._InternalInfo_HBox1_c(),this._InternalInfo_Container3_c(),this._InternalInfo_Doll1_i(),this._InternalInfo_CachedImage3_i(),this._InternalInfo_AchievementPointsInfo1_i(),this._InternalInfo_HBox3_i(),this._InternalInfo_CachedImage4_i()];
         return _loc1_;
      }
      
      private function _InternalInfo_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._InternalInfo_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_InternalInfo_CachedImage1",this._InternalInfo_CachedImage1);
         return _loc1_;
      }
      
      private function _InternalInfo_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.x = 75;
         _loc1_.y = 12;
         _loc1_.width = 300;
         _loc1_.height = 40;
         _loc1_.verticalAlign = "bottom";
         _loc1_.children = [this._InternalInfo_VBox1_c(),this._InternalInfo_Component1_c(),this._InternalInfo_VBox2_c()];
         return _loc1_;
      }
      
      private function _InternalInfo_VBox1_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.children = [this._InternalInfo_Label1_i(),this._InternalInfo_Label2_i()];
         return _loc1_;
      }
      
      private function _InternalInfo_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.color = 0;
         _loc1_.fontSize = 12;
         this._InternalInfo_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_InternalInfo_Label1",this._InternalInfo_Label1);
         return _loc1_;
      }
      
      private function _InternalInfo_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.color = 0;
         _loc1_.fontSize = 12;
         _loc1_.width = 120;
         _loc1_.truncateToFit = true;
         this._InternalInfo_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_InternalInfo_Label2",this._InternalInfo_Label2);
         return _loc1_;
      }
      
      private function _InternalInfo_Component1_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.percentWidth = 100;
         return _loc1_;
      }
      
      private function _InternalInfo_VBox2_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.horizontalAlign = "right";
         _loc1_.children = [this._InternalInfo_HBox2_i(),this._InternalInfo_Label4_i()];
         return _loc1_;
      }
      
      private function _InternalInfo_HBox2_i() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.useHandCursor = true;
         _loc1_.children = [this._InternalInfo_ClanIcon1_i(),this._InternalInfo_Label3_i()];
         _loc1_.addEventListener("click",this.___InternalInfo_HBox2_click);
         this._InternalInfo_HBox2 = _loc1_;
         BindingManager.executeBindings(this,"_InternalInfo_HBox2",this._InternalInfo_HBox2);
         return _loc1_;
      }
      
      private function _InternalInfo_ClanIcon1_i() : ClanIcon
      {
         var _loc1_:ClanIcon = new ClanIcon();
         this._InternalInfo_ClanIcon1 = _loc1_;
         BindingManager.executeBindings(this,"_InternalInfo_ClanIcon1",this._InternalInfo_ClanIcon1);
         return _loc1_;
      }
      
      private function _InternalInfo_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.color = 0;
         _loc1_.fontSize = 12;
         this._InternalInfo_Label3 = _loc1_;
         BindingManager.executeBindings(this,"_InternalInfo_Label3",this._InternalInfo_Label3);
         return _loc1_;
      }
      
      public function ___InternalInfo_HBox2_click(event:MouseEvent) : void
      {
         this.openClan();
      }
      
      private function _InternalInfo_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.color = 0;
         _loc1_.fontSize = 12;
         _loc1_.width = 170;
         _loc1_.truncateToFit = true;
         this._InternalInfo_Label4 = _loc1_;
         BindingManager.executeBindings(this,"_InternalInfo_Label4",this._InternalInfo_Label4);
         return _loc1_;
      }
      
      private function _InternalInfo_Container3_c() : Container
      {
         var _loc1_:Container = new Container();
         _loc1_.y = -28;
         _loc1_.children = [this._InternalInfo_RoundImage1_i(),this._InternalInfo_CachedImage2_i()];
         return _loc1_;
      }
      
      private function _InternalInfo_RoundImage1_i() : RoundImage
      {
         var _loc1_:RoundImage = new RoundImage();
         _loc1_.x = 6;
         _loc1_.y = 5;
         _loc1_.width = 60;
         _loc1_.height = 60;
         this._InternalInfo_RoundImage1 = _loc1_;
         BindingManager.executeBindings(this,"_InternalInfo_RoundImage1",this._InternalInfo_RoundImage1);
         return _loc1_;
      }
      
      private function _InternalInfo_CachedImage2_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.addEventListener("click",this.___InternalInfo_CachedImage2_click);
         this._InternalInfo_CachedImage2 = _loc1_;
         BindingManager.executeBindings(this,"_InternalInfo_CachedImage2",this._InternalInfo_CachedImage2);
         return _loc1_;
      }
      
      public function ___InternalInfo_CachedImage2_click(event:MouseEvent) : void
      {
         this.openAvatar();
      }
      
      private function _InternalInfo_Doll1_i() : Doll
      {
         var _loc1_:Doll = new Doll();
         _loc1_.y = 55;
         this._InternalInfo_Doll1 = _loc1_;
         BindingManager.executeBindings(this,"_InternalInfo_Doll1",this._InternalInfo_Doll1);
         return _loc1_;
      }
      
      private function _InternalInfo_CachedImage3_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.x = 16;
         _loc1_.y = 80;
         _loc1_.addEventListener("click",this.___InternalInfo_CachedImage3_click);
         this._InternalInfo_CachedImage3 = _loc1_;
         BindingManager.executeBindings(this,"_InternalInfo_CachedImage3",this._InternalInfo_CachedImage3);
         return _loc1_;
      }
      
      public function ___InternalInfo_CachedImage3_click(event:MouseEvent) : void
      {
         this.openSubscription();
      }
      
      private function _InternalInfo_AchievementPointsInfo1_i() : AchievementPointsInfo
      {
         var _loc1_:AchievementPointsInfo = new AchievementPointsInfo();
         _loc1_.x = 325;
         _loc1_.y = 80;
         _loc1_.addEventListener("click",this.___InternalInfo_AchievementPointsInfo1_click);
         this._InternalInfo_AchievementPointsInfo1 = _loc1_;
         BindingManager.executeBindings(this,"_InternalInfo_AchievementPointsInfo1",this._InternalInfo_AchievementPointsInfo1);
         return _loc1_;
      }
      
      public function ___InternalInfo_AchievementPointsInfo1_click(event:MouseEvent) : void
      {
         this.openAchievements();
      }
      
      private function _InternalInfo_HBox3_i() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.x = 20;
         _loc1_.y = 418;
         _loc1_.width = 328;
         _loc1_.horizontalAlign = "right";
         _loc1_.gap = 5;
         this.giftBox = _loc1_;
         BindingManager.executeBindings(this,"giftBox",this.giftBox);
         return _loc1_;
      }
      
      private function _InternalInfo_CachedImage4_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.x = 350;
         _loc1_.y = 418;
         _loc1_.addEventListener("click",this.___InternalInfo_CachedImage4_click);
         this._InternalInfo_CachedImage4 = _loc1_;
         BindingManager.executeBindings(this,"_InternalInfo_CachedImage4",this._InternalInfo_CachedImage4);
         return _loc1_;
      }
      
      public function ___InternalInfo_CachedImage4_click(event:MouseEvent) : void
      {
         this.openGifts();
      }
      
      private function _InternalInfo_CachedImage5_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.x = 393;
         _loc1_.y = 200;
         _loc1_.addEventListener("click",this.___InternalInfo_CachedImage5_click);
         this._InternalInfo_CachedImage5 = _loc1_;
         BindingManager.executeBindings(this,"_InternalInfo_CachedImage5",this._InternalInfo_CachedImage5);
         return _loc1_;
      }
      
      public function ___InternalInfo_CachedImage5_click(event:MouseEvent) : void
      {
         this.stats.visible = true;
      }
      
      private function _InternalInfo_Canvas1_i() : Canvas
      {
         var _loc1_:Canvas = new Canvas();
         _loc1_.x = 393;
         _loc1_.y = -29;
         _loc1_.width = 318;
         _loc1_.height = 512;
         _loc1_.children = [this._InternalInfo_CachedImage6_i(),this._InternalInfo_CachedImage7_i(),this._InternalInfo_VBox3_c(),this._InternalInfo_VBox4_c()];
         this.stats = _loc1_;
         BindingManager.executeBindings(this,"stats",this.stats);
         return _loc1_;
      }
      
      private function _InternalInfo_CachedImage6_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._InternalInfo_CachedImage6 = _loc1_;
         BindingManager.executeBindings(this,"_InternalInfo_CachedImage6",this._InternalInfo_CachedImage6);
         return _loc1_;
      }
      
      private function _InternalInfo_CachedImage7_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.x = 344;
         _loc1_.y = 230;
         _loc1_.addEventListener("click",this.___InternalInfo_CachedImage7_click);
         this._InternalInfo_CachedImage7 = _loc1_;
         BindingManager.executeBindings(this,"_InternalInfo_CachedImage7",this._InternalInfo_CachedImage7);
         return _loc1_;
      }
      
      public function ___InternalInfo_CachedImage7_click(event:MouseEvent) : void
      {
         this.stats.visible = false;
      }
      
      private function _InternalInfo_VBox3_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.x = 8;
         _loc1_.y = 8;
         _loc1_.width = 330;
         _loc1_.children = [this._InternalInfo_GradientLabel1_i(),this._InternalInfo_ReputationBox1_i(),this._InternalInfo_GradientLabel2_i(),this._InternalInfo_HBox4_c()];
         return _loc1_;
      }
      
      private function _InternalInfo_GradientLabel1_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.fontSize = 11;
         _loc1_.percentWidth = 100;
         _loc1_.height = 22;
         this._InternalInfo_GradientLabel1 = _loc1_;
         BindingManager.executeBindings(this,"_InternalInfo_GradientLabel1",this._InternalInfo_GradientLabel1);
         return _loc1_;
      }
      
      private function _InternalInfo_ReputationBox1_i() : ReputationBox
      {
         var _loc1_:ReputationBox = new ReputationBox();
         this._InternalInfo_ReputationBox1 = _loc1_;
         BindingManager.executeBindings(this,"_InternalInfo_ReputationBox1",this._InternalInfo_ReputationBox1);
         return _loc1_;
      }
      
      private function _InternalInfo_GradientLabel2_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.fontSize = 11;
         _loc1_.percentWidth = 100;
         _loc1_.height = 22;
         this._InternalInfo_GradientLabel2 = _loc1_;
         BindingManager.executeBindings(this,"_InternalInfo_GradientLabel2",this._InternalInfo_GradientLabel2);
         return _loc1_;
      }
      
      private function _InternalInfo_HBox4_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = -4;
         _loc1_.children = [this._InternalInfo_ResistRenderer1_i(),this._InternalInfo_ResistRenderer2_i(),this._InternalInfo_ResistRenderer3_i(),this._InternalInfo_ResistRenderer4_i(),this._InternalInfo_ResistRenderer5_i(),this._InternalInfo_ResistRenderer6_i(),this._InternalInfo_ResistRenderer7_i()];
         return _loc1_;
      }
      
      private function _InternalInfo_ResistRenderer1_i() : ResistRenderer
      {
         var _loc1_:ResistRenderer = new ResistRenderer();
         this._InternalInfo_ResistRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_InternalInfo_ResistRenderer1",this._InternalInfo_ResistRenderer1);
         return _loc1_;
      }
      
      private function _InternalInfo_ResistRenderer2_i() : ResistRenderer
      {
         var _loc1_:ResistRenderer = new ResistRenderer();
         this._InternalInfo_ResistRenderer2 = _loc1_;
         BindingManager.executeBindings(this,"_InternalInfo_ResistRenderer2",this._InternalInfo_ResistRenderer2);
         return _loc1_;
      }
      
      private function _InternalInfo_ResistRenderer3_i() : ResistRenderer
      {
         var _loc1_:ResistRenderer = new ResistRenderer();
         this._InternalInfo_ResistRenderer3 = _loc1_;
         BindingManager.executeBindings(this,"_InternalInfo_ResistRenderer3",this._InternalInfo_ResistRenderer3);
         return _loc1_;
      }
      
      private function _InternalInfo_ResistRenderer4_i() : ResistRenderer
      {
         var _loc1_:ResistRenderer = new ResistRenderer();
         this._InternalInfo_ResistRenderer4 = _loc1_;
         BindingManager.executeBindings(this,"_InternalInfo_ResistRenderer4",this._InternalInfo_ResistRenderer4);
         return _loc1_;
      }
      
      private function _InternalInfo_ResistRenderer5_i() : ResistRenderer
      {
         var _loc1_:ResistRenderer = new ResistRenderer();
         this._InternalInfo_ResistRenderer5 = _loc1_;
         BindingManager.executeBindings(this,"_InternalInfo_ResistRenderer5",this._InternalInfo_ResistRenderer5);
         return _loc1_;
      }
      
      private function _InternalInfo_ResistRenderer6_i() : ResistRenderer
      {
         var _loc1_:ResistRenderer = new ResistRenderer();
         this._InternalInfo_ResistRenderer6 = _loc1_;
         BindingManager.executeBindings(this,"_InternalInfo_ResistRenderer6",this._InternalInfo_ResistRenderer6);
         return _loc1_;
      }
      
      private function _InternalInfo_ResistRenderer7_i() : ResistRenderer
      {
         var _loc1_:ResistRenderer = new ResistRenderer();
         this._InternalInfo_ResistRenderer7 = _loc1_;
         BindingManager.executeBindings(this,"_InternalInfo_ResistRenderer7",this._InternalInfo_ResistRenderer7);
         return _loc1_;
      }
      
      private function _InternalInfo_VBox4_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.horizontalAlign = "center";
         _loc1_.x = 22;
         _loc1_.y = 175;
         _loc1_.width = 300;
         _loc1_.height = 435;
         _loc1_.children = [this._InternalInfo_Label5_i(),this._InternalInfo_StatControls1_i()];
         return _loc1_;
      }
      
      private function _InternalInfo_Label5_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.horizontalCenter = 0;
         _loc1_.color = 0;
         _loc1_.bold = true;
         _loc1_.fontSize = 12;
         this._InternalInfo_Label5 = _loc1_;
         BindingManager.executeBindings(this,"_InternalInfo_Label5",this._InternalInfo_Label5);
         return _loc1_;
      }
      
      private function _InternalInfo_StatControls1_i() : StatControls
      {
         var _loc1_:StatControls = new StatControls();
         _loc1_.addEventListener("change",this.__statControls_change);
         _loc1_.addEventListener("complete",this.__statControls_complete);
         this.statControls = _loc1_;
         BindingManager.executeBindings(this,"statControls",this.statControls);
         return _loc1_;
      }
      
      public function __statControls_change(event:Event) : void
      {
         this.onChange();
      }
      
      public function __statControls_complete(event:Event) : void
      {
         this.onComplete();
      }
      
      public function ___InternalInfo_Container1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _InternalInfo_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():*
         {
            return characterModel.properties.LEVEL;
         },function(param1:*):void
         {
            level = param1;
         },"level");
         result[1] = new Binding(this,function():*
         {
            return getSixGifts(model.body.awards,model.body.gifts,model.body.trophies);
         },function(param1:*):void
         {
            sixGifts = param1;
         },"sixGifts");
         result[2] = new Binding(this,function():Object
         {
            return Assets.doll;
         },null,"_InternalInfo_CachedImage1.source");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = getString(characterModel.disposition);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InternalInfo_Label1.text");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = getString(characterModel.side);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InternalInfo_Label2.text");
         result[5] = new Binding(this,function():Boolean
         {
            return clanModel.id > 0;
         },null,"_InternalInfo_HBox2.visible");
         result[6] = new Binding(this,function():Number
         {
            return clanModel.id;
         },null,"_InternalInfo_ClanIcon1.clanId");
         result[7] = new Binding(this,function():String
         {
            var _loc1_:* = clanModel.name;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InternalInfo_Label3.text");
         result[8] = new Binding(this,function():String
         {
            var _loc1_:* = rtmModel.mapName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InternalInfo_Label4.text");
         result[9] = new Binding(this,function():Object
         {
            return Configuration.getSmallAvatarUrl(characterModel.avatarImagePath);
         },null,"_InternalInfo_RoundImage1.source");
         result[10] = new Binding(this,function():Object
         {
            return Assets.roundFrameBig;
         },null,"_InternalInfo_CachedImage2.source");
         result[11] = new Binding(this,function():BodyModel
         {
            return model.body;
         },null,"_InternalInfo_Doll1.bodyModel");
         result[12] = new Binding(this,function():Array
         {
            var _loc1_:* = characterModel.autoSlots;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_InternalInfo_Doll1.slots");
         result[13] = new Binding(this,function():Boolean
         {
            return !showGifts;
         },null,"_InternalInfo_Doll1.visible");
         result[14] = new Binding(this,function():uint
         {
            return characterModel.alternativeIndex;
         },null,"_InternalInfo_Doll1.alternativeIndex");
         result[15] = new Binding(this,function():Object
         {
            return SubscriptionType.getMedIcon(characterModel.subscriptionType);
         },null,"_InternalInfo_CachedImage3.source");
         result[16] = new Binding(this,function():String
         {
            var _loc1_:* = getSubscription(characterModel.subscriptionType);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InternalInfo_CachedImage3.toolTip");
         result[17] = new Binding(this,function():uint
         {
            return achievementModel.pointsCollected;
         },null,"_InternalInfo_AchievementPointsInfo1.points");
         result[18] = new Binding(this,function():String
         {
            var _loc1_:* = getString("achievements.title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InternalInfo_AchievementPointsInfo1.toolTip");
         result[19] = new Binding(this,function():Object
         {
            return Assets.gifts;
         },null,"_InternalInfo_CachedImage4.source");
         result[20] = new Binding(this,function():String
         {
            var _loc1_:* = getString("charInfo.button.gifts");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InternalInfo_CachedImage4.toolTip");
         result[21] = new Binding(this,function():Object
         {
            return Assets.showStats;
         },null,"_InternalInfo_CachedImage5.source");
         result[22] = new Binding(this,function():Object
         {
            return Assets.charInfoStatsBg;
         },null,"_InternalInfo_CachedImage6.source");
         result[23] = new Binding(this,function():Object
         {
            return Assets.hideStats;
         },null,"_InternalInfo_CachedImage7.source");
         result[24] = new Binding(this,function():String
         {
            var _loc1_:* = getString("character.reputation") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InternalInfo_GradientLabel1.text");
         result[25] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_InternalInfo_GradientLabel1.color");
         result[26] = new Binding(this,function():Array
         {
            var _loc1_:* = characterModel.reputations;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_InternalInfo_ReputationBox1.dataProvider");
         result[27] = new Binding(this,function():String
         {
            var _loc1_:* = getString("character.resistance");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InternalInfo_GradientLabel2.text");
         result[28] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_InternalInfo_GradientLabel2.color");
         result[29] = new Binding(this,function():Object
         {
            return ParamType.getBigIcon(ParamType.AC);
         },null,"_InternalInfo_ResistRenderer1.source");
         result[30] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.AC);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InternalInfo_ResistRenderer1.toolTip");
         result[31] = new Binding(this,function():String
         {
            var _loc1_:* = characterModel.params.AC;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InternalInfo_ResistRenderer1.label");
         result[32] = new Binding(this,function():Object
         {
            return ParamType.getBigIcon(ParamType.RESISTANCE_NATURE);
         },null,"_InternalInfo_ResistRenderer2.source");
         result[33] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.RESISTANCE_NATURE);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InternalInfo_ResistRenderer2.toolTip");
         result[34] = new Binding(this,function():String
         {
            var _loc1_:* = characterModel.params.RESISTANCE_NATURE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InternalInfo_ResistRenderer2.label");
         result[35] = new Binding(this,function():Object
         {
            return ParamType.getBigIcon(ParamType.RESISTANCE_HOLY);
         },null,"_InternalInfo_ResistRenderer3.source");
         result[36] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.RESISTANCE_HOLY);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InternalInfo_ResistRenderer3.toolTip");
         result[37] = new Binding(this,function():String
         {
            var _loc1_:* = characterModel.params.RESISTANCE_HOLY;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InternalInfo_ResistRenderer3.label");
         result[38] = new Binding(this,function():Object
         {
            return ParamType.getBigIcon(ParamType.RESISTANCE_DARK);
         },null,"_InternalInfo_ResistRenderer4.source");
         result[39] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.RESISTANCE_DARK);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InternalInfo_ResistRenderer4.toolTip");
         result[40] = new Binding(this,function():String
         {
            var _loc1_:* = characterModel.params.RESISTANCE_DARK;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InternalInfo_ResistRenderer4.label");
         result[41] = new Binding(this,function():Object
         {
            return ParamType.getBigIcon(ParamType.RESISTANCE_FIRE);
         },null,"_InternalInfo_ResistRenderer5.source");
         result[42] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.RESISTANCE_FIRE);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InternalInfo_ResistRenderer5.toolTip");
         result[43] = new Binding(this,function():String
         {
            var _loc1_:* = characterModel.params.RESISTANCE_FIRE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InternalInfo_ResistRenderer5.label");
         result[44] = new Binding(this,function():Object
         {
            return ParamType.getBigIcon(ParamType.RESISTANCE_FROST);
         },null,"_InternalInfo_ResistRenderer6.source");
         result[45] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.RESISTANCE_FROST);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InternalInfo_ResistRenderer6.toolTip");
         result[46] = new Binding(this,function():String
         {
            var _loc1_:* = characterModel.params.RESISTANCE_FROST;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InternalInfo_ResistRenderer6.label");
         result[47] = new Binding(this,function():Object
         {
            return ParamType.getBigIcon(ParamType.RESISTANCE_ARCANE);
         },null,"_InternalInfo_ResistRenderer7.source");
         result[48] = new Binding(this,function():String
         {
            var _loc1_:* = getString(ParamType.RESISTANCE_ARCANE);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InternalInfo_ResistRenderer7.toolTip");
         result[49] = new Binding(this,function():String
         {
            var _loc1_:* = characterModel.params.RESISTANCE_ARCANE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InternalInfo_ResistRenderer7.label");
         result[50] = new Binding(this,function():String
         {
            var _loc1_:* = getString("character.baseParams");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InternalInfo_Label5.text");
         result[51] = new Binding(this,null,null,"statControls.characterModel","characterModel");
         result[52] = new Binding(this,function():int
         {
            return characterModel.additionalPoints.STATS;
         },null,"statControls.points");
         return result;
      }
      
      private function _InternalInfo_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         this.level = this.characterModel.properties.LEVEL;
         this.sixGifts = this.getSixGifts(this.model.body.awards,this.model.body.gifts,this.model.body.trophies);
      }
      
      [Bindable(event="propertyChange")]
      public function get giftBox() : HBox
      {
         return this._27381371giftBox;
      }
      
      public function set giftBox(param1:HBox) : void
      {
         var _loc2_:Object = this._27381371giftBox;
         if(_loc2_ !== param1)
         {
            this._27381371giftBox = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"giftBox",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get statControls() : StatControls
      {
         return this._1923867350statControls;
      }
      
      public function set statControls(param1:StatControls) : void
      {
         var _loc2_:Object = this._1923867350statControls;
         if(_loc2_ !== param1)
         {
            this._1923867350statControls = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statControls",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get stats() : Canvas
      {
         return this._109757599stats;
      }
      
      public function set stats(param1:Canvas) : void
      {
         var _loc2_:Object = this._109757599stats;
         if(_loc2_ !== param1)
         {
            this._109757599stats = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"stats",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get model() : InventoryModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:InventoryModel) : void
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
      public function get characterModel() : CharacterModel
      {
         return this._340320640characterModel;
      }
      
      public function set characterModel(param1:CharacterModel) : void
      {
         var _loc2_:Object = this._340320640characterModel;
         if(_loc2_ !== param1)
         {
            this._340320640characterModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"characterModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rtmModel() : RTMModel
      {
         return this._116778114rtmModel;
      }
      
      public function set rtmModel(param1:RTMModel) : void
      {
         var _loc2_:Object = this._116778114rtmModel;
         if(_loc2_ !== param1)
         {
            this._116778114rtmModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rtmModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get clanModel() : ClanModel
      {
         return this._187142541clanModel;
      }
      
      public function set clanModel(param1:ClanModel) : void
      {
         var _loc2_:Object = this._187142541clanModel;
         if(_loc2_ !== param1)
         {
            this._187142541clanModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clanModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get achievementModel() : AchievementModel
      {
         return this._2075894074achievementModel;
      }
      
      public function set achievementModel(param1:AchievementModel) : void
      {
         var _loc2_:Object = this._2075894074achievementModel;
         if(_loc2_ !== param1)
         {
            this._2075894074achievementModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"achievementModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get showGifts() : Boolean
      {
         return this._1925822394showGifts;
      }
      
      private function set showGifts(param1:Boolean) : void
      {
         var _loc2_:Object = this._1925822394showGifts;
         if(_loc2_ !== param1)
         {
            this._1925822394showGifts = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showGifts",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get characterWeapons() : Array
      {
         return this._626994798characterWeapons;
      }
      
      private function set characterWeapons(param1:Array) : void
      {
         var _loc2_:Object = this._626994798characterWeapons;
         if(_loc2_ !== param1)
         {
            this._626994798characterWeapons = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"characterWeapons",_loc2_,param1));
            }
         }
      }
   }
}

