package soul.view.interaction.clan
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import soul.model.interaction.clan.ClanMember;
   import soul.view.ui.Box;
   import soul.view.ui.ScrollBase;
   
   public class ClanMembers extends ScrollBase
   {
      
      private var box:Box = new Box();
      
      [Bindable("selectedMemberChanged")]
      public var selectedMember:ClanMember;
      
      private var _dataProvider:Array;
      
      public function ClanMembers()
      {
         super();
         this.box.direction = "vertical";
         addChild(this.box);
      }
      
      public function set dataProvider(value:Array) : void
      {
         var member:ClanMember = null;
         var child:ClanMemberRenderer = null;
         this.box.removeAllChildren();
         for each(member in value)
         {
            child = new ClanMemberRenderer();
            child.member = member;
            child.addEventListener(MouseEvent.CLICK,this.childSelect);
            this.box.addChild(child);
         }
      }
      
      private function childSelect(e:MouseEvent) : void
      {
         var child:ClanMemberRenderer = null;
         for(var i:int = 0; i < this.box.numChildren; i++)
         {
            child = this.box.getChildAt(i) as ClanMemberRenderer;
            child.selected = child == e.currentTarget;
         }
         var selectedMember:ClanMember = ClanMemberRenderer(e.currentTarget).member;
         if(this.selectedMember != selectedMember)
         {
            this.selectedMember = selectedMember;
            dispatchEvent(new Event("selectedMemberChanged"));
         }
      }
   }
}

