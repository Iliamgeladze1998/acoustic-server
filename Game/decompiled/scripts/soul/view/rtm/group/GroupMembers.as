package soul.view.rtm.group
{
   import mx.binding.utils.BindingUtils;
   import soul.model.group.GroupMember;
   import soul.model.group.GroupModel;
   import soul.model.rtm.RTMModel;
   import soul.view.ui.VBox;
   
   public class GroupMembers extends VBox
   {
      
      public var rtmModel:RTMModel;
      
      private var _myId:String;
      
      private var _groupModel:GroupModel;
      
      public function GroupMembers()
      {
         super();
      }
      
      public function set myId(value:String) : void
      {
         this._myId = value;
         if(Boolean(this._groupModel) && Boolean(this._groupModel.members))
         {
            this.drawMembers();
         }
      }
      
      public function set groupModel(value:GroupModel) : void
      {
         this._groupModel = value;
         BindingUtils.bindSetter(this.setMembers,this._groupModel,"members",false,false);
      }
      
      private function setMembers(value:Array) : void
      {
         if(Boolean(this._myId) && Boolean(value) && value.length > 0)
         {
            this.drawMembers();
         }
      }
      
      private function drawMembers() : void
      {
         var frame:GroupMemberRenderer = null;
         var frameOffline:GroupMemberOfflineRenderer = null;
         var member:GroupMember = null;
         removeAllChildren();
         for each(member in this._groupModel.members)
         {
            if(member.id != this._myId)
            {
               if(member.online)
               {
                  frame = new GroupMemberRenderer();
                  frame.unit = member;
                  frame.rtmModel = this.rtmModel;
                  addChild(frame);
               }
               else
               {
                  frameOffline = new GroupMemberOfflineRenderer();
                  frameOffline.unit = member;
                  frameOffline.rtmModel = this.rtmModel;
                  addChild(frameOffline);
               }
            }
         }
      }
   }
}

