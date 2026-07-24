package soul.view.interaction.clan
{
   import flash.events.MouseEvent;
   import mx.events.PropertyChangeEvent;
   import soul.controller.MenuManager;
   import soul.controller.locale.LocaleManager;
   import soul.model.common.MenuType;
   import soul.model.interaction.clan.ClanMember;
   import soul.view.assets.GradientBox;
   import soul.view.common.Icons;
   import soul.view.ui.Box;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   import spark.layouts.VerticalAlign;
   
   public class ClanMemberRenderer extends Component
   {
      
      private static const ONLINE_COLOR:uint = 65280;
      
      private static const OFFLINE_COLOR:uint = 7829367;
      
      private var bg:GradientBox = new GradientBox();
      
      private var box:Box = new Box();
      
      private var icon:CachedImage = new CachedImage();
      
      private var nameLabel:Label = new Label();
      
      private var statusLabel:Label = new Label();
      
      private var _member:ClanMember;
      
      private var _selected:Boolean;
      
      public function ClanMemberRenderer()
      {
         super();
         this.icon.source = Icons.infoIcon;
         this.icon.addEventListener(MouseEvent.CLICK,this.showInfo,false,0,true);
         backgroundColor = 0;
         backgroundAlpha = 0;
         width = 400;
         height = 20;
         this.nameLabel.width = 205;
         this.nameLabel.height = 17;
         this.statusLabel.width = 150;
         this.statusLabel.height = 17;
         this.bg.width = 400;
         this.bg.height = 20;
         this.bg.visible = false;
         this.box.verticalAlign = VerticalAlign.MIDDLE;
         this.box.padding = 3;
         this.box.addChild(this.icon);
         this.box.addChild(this.nameLabel);
         this.box.addChild(this.statusLabel);
         addChild(this.bg);
         addChild(this.box);
      }
      
      private function draw() : void
      {
         this.nameLabel.color = this._member.online ? ONLINE_COLOR : OFFLINE_COLOR;
         this.nameLabel.text = "[" + this._member.level + "] " + this._member.name;
         this.statusLabel.text = LocaleManager.getClanRole(this._member.role);
      }
      
      private function propertyChanged(e:PropertyChangeEvent) : void
      {
         this.draw();
      }
      
      private function showInfo(e:MouseEvent) : void
      {
         e.stopPropagation();
         if(!this._member)
         {
            return;
         }
         MenuManager.create(MenuType.CHARACTER_MENU,this._member.id);
      }
      
      public function set member(value:ClanMember) : void
      {
         if(this._member == value)
         {
            return;
         }
         if(Boolean(this._member))
         {
            this._member.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.propertyChanged);
         }
         this._member = value;
         this._member.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.propertyChanged);
         this.draw();
      }
      
      public function get member() : ClanMember
      {
         return this._member;
      }
      
      public function set selected(value:Boolean) : void
      {
         if(this._selected == value)
         {
            return;
         }
         this._selected = value;
         this.bg.visible = value;
      }
   }
}

