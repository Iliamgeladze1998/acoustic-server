package soul.view.interaction.quest
{
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import mx.binding.utils.BindingUtils;
   import mx.binding.utils.ChangeWatcher;
   import soul.controller.locale.LocaleManager;
   import soul.model.interaction.quest.QuestEntry;
   import soul.model.interaction.quest.QuestState;
   import soul.view.assets.Assets;
   import soul.view.common.Icons;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   
   public class QuestListItem extends Component
   {
      
      private static const stateIcons:Object = {};
      
      private static const plusFilters:Array = [new GlowFilter(0,1,1.1,1.1,20,4)];
      
      stateIcons[QuestState.COMPLETE] = Icons.questDone;
      stateIcons[QuestState.FAILED] = Icons.questFailed;
      stateIcons[QuestState.FINISHED] = Icons.questDone;
      stateIcons[QuestState.NONE] = Icons.questProgress;
      stateIcons[QuestState.TAKEN] = Icons.questProgress;
      
      public var subQuests:Array = [];
      
      private var gap:int;
      
      private var cursor:CachedImage = new CachedImage();
      
      private var image:CachedImage = new CachedImage();
      
      private var text:Label = new Label(Label.MONEY_LABEL);
      
      private var plus:Label = new Label(Label.MONEY_LABEL);
      
      private var _expanded:Boolean;
      
      private var cw:ChangeWatcher;
      
      private var _questEntry:QuestEntry;
      
      public function QuestListItem(subquest:Boolean = false)
      {
         super();
         this.gap = subquest ? 25 : 18;
         width = 282;
         height = 22;
         this.cursor.source = Assets.trackCursor;
         this.cursor.visible = false;
         this.cursor.x = 8;
         this.cursor.y = 2;
         this.plus.x = this.gap - 2;
         this.plus.width = 15;
         this.plus.height = 16;
         this.plus.color = 12623221;
         this.plus.align = "center";
         this.plus.filters = plusFilters;
         this.plus.text = "+";
         this.image.x = 12 + this.gap;
         this.image.y = 2;
         this.text.x = 35 + this.gap;
         this.text.width = width - this.text.x;
         this.text.height = 16;
         this.text.color = 0;
         addChild(this.plus);
         addChild(this.image);
         addChild(this.text);
         addChild(this.cursor);
         addEventListener(MouseEvent.CLICK,this.plusClicked);
      }
      
      private function plusClicked(e:MouseEvent) : void
      {
         this.expanded = !this.expanded;
      }
      
      public function get expanded() : Boolean
      {
         return this._expanded;
      }
      
      public function set expanded(value:Boolean) : void
      {
         var qli:QuestListItem = null;
         if(this._expanded == value)
         {
            return;
         }
         this._expanded = value;
         for each(qli in this.subQuests)
         {
            qli.scaleY = value ? 1 : 0;
         }
         this.plus.text = value ? "-" : "+";
      }
      
      public function set questEntry(value:QuestEntry) : void
      {
         if(Boolean(this.cw))
         {
            this.cw.unwatch();
         }
         this._questEntry = value;
         this.image.source = stateIcons[value.state];
         this.text.text = LocaleManager.getQuestName(value.questId);
         this.plus.visible = Boolean(value.subquests) && value.subquests.length > 0;
         if(Boolean(value))
         {
            this.cw = BindingUtils.bindSetter(this.trackedChanged,value,"tracked",false,true);
         }
      }
      
      public function get questEntry() : QuestEntry
      {
         return this._questEntry;
      }
      
      public function trackedChanged(value:Boolean) : void
      {
         this.cursor.visible = value;
      }
      
      public function set selected(value:Boolean) : void
      {
         graphics.clear();
         graphics.beginFill(13603176,value ? 1 : 0);
         graphics.drawRect(this.gap,0,width - this.gap,height);
         graphics.endFill();
      }
   }
}

