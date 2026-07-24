package soul.view.common
{
   import com.gskinner.motion.GTween;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.text.AntiAliasType;
   import flash.text.GridFitType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import mx.utils.StringUtil;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.chat.MessageType;
   import soul.model.condition.Condition;
   
   public class BigMessage
   {
      
      private static var stage:Stage;
      
      private static const format:TextFormat = new TextFormat("Verdana",20,16777215);
      
      private static const filters:Array = [new GlowFilter(0,1,1.5,1.5,10),new DropShadowFilter(4,45,0,1,4,4,0.7)];
      
      private static const messages:Array = [];
      
      private static const messagePadding:int = 50;
      
      private static const messageGap:int = -5;
      
      private static const MESSAGE_TYPES:Array = [MessageType.CHAR_NOT_FOUND,MessageType.LEVEL_UP,MessageType.SHUTDOWN,MessageType.RESTART,MessageType.NEXT_DAY_REWARD,MessageType.VICTORY,MessageType.DEFEAT,MessageType.BATTLE_COMING,MessageType.HOLIDAY,MessageType.REQUIRE_QUEST,MessageType.ALREADY_LOOTED,MessageType.MUST_BE_OFFICER,MessageType.NOT_IN_CLAN,MessageType.CITADEL_OPEN,MessageType.CITADEL_OWNED,MessageType.CITADEL_NOT_OWNED,MessageType.CITADEL_OPENED,MessageType.CITADEL_ASSAULT,MessageType.NOT_ENOUGH_LOAD,MessageType.NOT_ENOUGH_MONEY,MessageType.NOT_ENOUGH_RUBIES,MessageType.NOT_ENOUGH_STATS,MessageType.SUBSCRIPTION_FINISHED,MessageType.NEW_LOTS_FORBIDDEN,MessageType.ITEM_IS_BROKEN];
      
      public function BigMessage()
      {
         super();
      }
      
      public static function init(stage:Stage) : void
      {
         BigMessage.stage = stage;
      }
      
      public static function showMessage(txt:String, color:uint = 16777215) : void
      {
         var s:Sprite = null;
         var t:TextField = null;
         var lastTween:GTween = null;
         var lastSprite:Sprite = null;
         if(!stage)
         {
            return;
         }
         s = new Sprite();
         s.mouseEnabled = false;
         t = new TextField();
         t.selectable = false;
         t.mouseEnabled = false;
         t.autoSize = "left";
         t.defaultTextFormat = format;
         t.textColor = color;
         t.antiAliasType = AntiAliasType.ADVANCED;
         t.gridFitType = GridFitType.PIXEL;
         t.thickness = 200;
         t.htmlText = txt;
         t.filters = filters;
         s.addChild(t);
         var startY:int = stage.stageHeight * 0.2;
         if(messages.length > 0)
         {
            lastTween = messages[messages.length - 1];
            lastSprite = lastTween.target as Sprite;
            startY = lastSprite.y + lastSprite.height + messageGap;
            if(startY > stage.stageHeight - messagePadding)
            {
               startY = messagePadding;
            }
         }
         s.y = startY;
         s.x = stage.stageWidth / 2 - s.width / 2;
         stage.addChild(s);
         var tween:GTween = new GTween(s,1,{
            "y":startY - 30,
            "alpha":0
         },{
            "delay":2,
            "onComplete":messageTweenComplete
         });
         messages.push(tween);
         tween.addEventListener(Event.COMPLETE,messageTweenComplete);
      }
      
      private static function messageTweenComplete(tween:GTween) : void
      {
         var s:Sprite = tween.target as Sprite;
         stage.removeChild(s);
         messages.splice(messages.indexOf(tween),1);
      }
      
      public static function showQuestConditionChange(qc:Condition) : void
      {
         var txt:String = LocaleManager.getString(BundleName.CONDITIONS,qc.type) + ": " + LocaleManager.getCondition(qc.type,qc.id) + " " + qc.current + "/" + qc.count;
         showMessage(txt,16776960);
      }
      
      public static function showAchievementConditionChange(qc:Condition) : void
      {
         var txt:String = LocaleManager.getString(BundleName.CONDITIONS,qc.type) + ": " + LocaleManager.getCondition(qc.type,qc.id) + " " + qc.current + "/" + qc.count;
         showMessage(txt,52224);
      }
      
      public static function showQuestComplete(questId:String) : void
      {
         var txt:String = StringUtil.substitute(LocaleManager.getString(BundleName.INTERFACE,"quest.complete"),LocaleManager.getQuestName(questId));
         showMessage(txt,16776960);
      }
      
      public static function showQuestFailed(questId:String) : void
      {
         var txt:String = StringUtil.substitute(LocaleManager.getString(BundleName.INTERFACE,"quest.failed"),LocaleManager.getQuestName(questId));
         showMessage(txt,16733525);
      }
      
      public static function messageTypeSupported(type:String) : Boolean
      {
         return MESSAGE_TYPES.indexOf(type) != -1;
      }
   }
}

