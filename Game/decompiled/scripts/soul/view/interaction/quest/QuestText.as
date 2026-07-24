package soul.view.interaction.quest
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.utils.getDefinitionByName;
   import soul.model.system.Configuration;
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   
   public class QuestText extends Component
   {
      
      private static const textColor:String = "#000000";
      
      private var label:Label;
      
      private var htmlLoader:Object;
      
      private var _htmlText:String;
      
      public function QuestText()
      {
         var htmlClass:Class = null;
         super();
         try
         {
            htmlClass = getDefinitionByName("flash.html::HTMLLoader") as Class;
         }
         catch(e:Error)
         {
         }
         if(Boolean(htmlClass))
         {
            this.htmlLoader = new htmlClass();
            this.htmlLoader.width = width;
            this.htmlLoader.placeLoadStringContentInApplicationSandbox = true;
            this.htmlLoader.paintsDefaultBackground = false;
            this.htmlLoader.mouseEnabled = false;
            this.htmlLoader.mouseChildren = false;
            this.htmlLoader.addEventListener("htmlBoundsChange",this.onChange,false,0,true);
            addChild(this.htmlLoader as DisplayObject);
         }
         else
         {
            this.label = new Label(Label.QUEST_TEXT);
            this.label.wordWrap = true;
            this.label.addEventListener("heightChanged",this.onChange,false,0,true);
            addChild(this.label);
         }
      }
      
      private function onChange(e:Event) : void
      {
         callLater(this.measure);
      }
      
      protected function measure() : void
      {
         if(Boolean(this.label))
         {
            this.label.width = width;
            actualHeight = this.label.height + 10;
         }
         else
         {
            this.htmlLoader.width = width;
            this.htmlLoader.height = this.htmlLoader.contentHeight;
            actualHeight = this.htmlLoader.contentHeight;
         }
      }
      
      override protected function redraw() : void
      {
         this.measure();
         super.redraw();
      }
      
      public function set htmlText(value:String) : void
      {
         if(!value)
         {
            value = "";
         }
         if(this._htmlText == value)
         {
            return;
         }
         this._htmlText = value;
         if(Boolean(this.label))
         {
            value = value.replace(/src="/g,"src=\"" + Configuration.staticServerURL);
            this.label.htmlText = value + "\n<br>";
            callLater(this.measure);
         }
         else
         {
            value = value.replace(/src="/g,"align=\"left\" src=\"" + Configuration.staticServerURL);
            value = value.replace(/<br\/?>\n/g,"\n");
            value = value.replace(/\n/g,"<br>\n");
            value = "<font color=\"" + textColor + "\" size=2>" + value + "</font>";
            this.htmlLoader.height = 0;
            this.htmlLoader.loadString(value);
            this.onChange(null);
         }
      }
   }
}

