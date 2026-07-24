package soul.view.interaction.quest
{
   import flash.display.GradientType;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.field.QuestGiverStatus;
   import soul.model.interaction.dialog.DialogAnswer;
   import soul.view.assets.Assets;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   
   public class AnswerRenderer extends Component
   {
      
      private static var questColor:uint = 155138;
      
      private static var dialogColor:uint = 9393410;
      
      private var frame:CachedImage = new CachedImage();
      
      private var icon:CachedImage = new CachedImage();
      
      private var label:Label = new Label(Label.QUEST_ANSWER);
      
      private var over:Boolean = false;
      
      private var iconColor:uint = 0;
      
      private var _answer:DialogAnswer;
      
      public function AnswerRenderer()
      {
         super();
         this.frame.source = Assets.answerFrame;
         addChild(this.frame);
         addChild(this.icon);
         addChild(this.label);
         this.frame.x = this.frame.y = 1;
         this.icon.x = 6;
         this.icon.y = 6;
         this.label.x = 32;
         this.label.y = 5;
         this.label.width = 430;
         width = 430;
         height = 30;
         addEventListener(MouseEvent.MOUSE_OVER,this.onRollOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onRollOut);
      }
      
      private function onRollOver(e:MouseEvent) : void
      {
         this.over = true;
         this.drawBg();
      }
      
      private function onRollOut(e:MouseEvent) : void
      {
         this.over = false;
         this.drawBg();
      }
      
      private function drawBg() : void
      {
         var m:Matrix = new Matrix();
         m.createGradientBox(width,height);
         var color:uint = this.over ? 16707033 : 13873286;
         var colors:Array = [color,color];
         var alphas:Array = [1,0];
         var ratios:Array = [200,255];
         graphics.clear();
         graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,m);
         graphics.drawRect(15,0,width - 30,height - 2);
         graphics.endFill();
         graphics.beginFill(this.iconColor);
         graphics.drawCircle(15,15,12);
         graphics.endFill();
      }
      
      public function set answer(value:DialogAnswer) : void
      {
         this._answer = value;
         switch(value.icon)
         {
            case QuestGiverStatus.AVAILABLE:
               this.iconColor = questColor;
               break;
            case QuestGiverStatus.TAKEN:
               this.iconColor = questColor;
               break;
            case QuestGiverStatus.READY:
               this.iconColor = questColor;
               break;
            default:
               this.iconColor = dialogColor;
         }
         this.icon.source = QuestGiverStatus.getSmallIcon(value.icon);
         this.label.text = LocaleManager.getString(BundleName.QUESTS,Boolean(value.locId) ? value.locId : value.id);
         this.drawBg();
      }
      
      public function get answer() : DialogAnswer
      {
         return this._answer;
      }
   }
}

