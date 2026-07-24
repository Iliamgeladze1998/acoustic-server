package soul.view.console
{
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   
   public class Console
   {
      
      private static var initialized:Boolean;
      
      private static var stage:Stage;
      
      private static var events:Vector.<ConsoleEvent>;
      
      private static const LINE_LIMIT:int = 1000;
      
      private static var container:Sprite = new Sprite();
      
      private static var text:TextField = new TextField();
      
      private static var input:TextField = new TextField();
      
      public function Console()
      {
         super();
      }
      
      public static function init(stage:Stage) : void
      {
         Console.stage = stage;
         stage.addEventListener(KeyboardEvent.KEY_DOWN,onKey,false,100);
         var tf:TextFormat = new TextFormat("tahoma",12,16777215);
         events = new Vector.<ConsoleEvent>();
         text.defaultTextFormat = tf;
         text.width = 500;
         text.height = 300;
         text.type = TextFieldType.DYNAMIC;
         text.border = true;
         text.borderColor = 0;
         text.textColor = 16777215;
         input.defaultTextFormat = tf;
         input.width = 500;
         input.height = 30;
         input.type = TextFieldType.INPUT;
         input.border = true;
         input.borderColor = 0;
         input.textColor = 16777215;
         input.y = 300;
         container.addChild(text);
         container.addChild(input);
         container.graphics.beginFill(3355647,0.3);
         container.graphics.drawRect(0,0,500,330);
         container.graphics.endFill();
         stage.addChild(container);
         container.visible = false;
         initialized = true;
      }
      
      private static function onKey(e:KeyboardEvent) : void
      {
         if(e.keyCode == 192 && e.ctrlKey)
         {
            if(input.length > 0)
            {
               return;
            }
            container.visible = !container.visible;
            e.stopImmediatePropagation();
            e.stopPropagation();
            if(container.visible)
            {
               stage.setChildIndex(container,stage.numChildren - 1);
               stage.focus = input;
            }
         }
         else if(e.keyCode == Keyboard.ENTER)
         {
            if(input.length > 0)
            {
               parseConsole();
            }
         }
      }
      
      private static function parseConsole() : void
      {
         var subcmd:String = null;
         var event:ConsoleEvent = null;
         var args:Array = input.text.split(" ");
         var cmd:String = args.shift();
         if(cmd.charAt(0) == "/")
         {
            subcmd = cmd.substring(1);
            for each(event in events)
            {
               if(event.command == subcmd)
               {
                  try
                  {
                     event.method(args);
                  }
                  catch(e:Error)
                  {
                     trace("handler for \'" + subcmd + "\' has error: ",e);
                  }
               }
            }
         }
         else if(cmd == "clear")
         {
            text.text = "";
         }
         input.text = "";
      }
      
      public static function trace(... args) : void
      {
         var _loc4_:Array = null;
      }
      
      public static function addListener(command:String, method:Function) : void
      {
         var e:ConsoleEvent = null;
         for each(e in events)
         {
            if(e.command == command && e.method == method)
            {
               return;
            }
         }
         events.push(new ConsoleEvent(command,method));
      }
      
      public static function removeListener(command:String, method:Function) : void
      {
         var e:ConsoleEvent = null;
         for(var i:uint = 0; i < events.length; i++)
         {
            e = events[i];
            if(e.command == command && e.method == method)
            {
               events.splice(i,1);
               return;
            }
         }
      }
   }
}

class ConsoleEvent
{
   
   public var command:String;
   
   public var method:Function;
   
   public function ConsoleEvent(command:String, method:Function)
   {
      super();
      this.command = command;
      this.method = method;
   }
}
