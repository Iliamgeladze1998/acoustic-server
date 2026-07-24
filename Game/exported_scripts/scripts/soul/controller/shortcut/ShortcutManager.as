package soul.controller.shortcut
{
   import flash.display.Stage;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   
   public class ShortcutManager
   {
      
      public static var shiftPressed:Boolean;
      
      public static var ctrlPressed:Boolean;
      
      private static var stage:Stage;
      
      public static var enabled:Boolean = true;
      
      private static var downShortcuts:Dictionary = new Dictionary();
      
      private static var upShortcuts:Dictionary = new Dictionary();
      
      public function ShortcutManager()
      {
         super();
      }
      
      public static function init(stage:Stage) : void
      {
         if(!stage)
         {
            return;
         }
         ShortcutManager.stage = stage;
         stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
      }
      
      public static function reset() : void
      {
         downShortcuts = new Dictionary();
         upShortcuts = new Dictionary();
         if(!stage)
         {
            return;
         }
         stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
      }
      
      public static function addShortcutListener(shortcut:Shortcut, listener:Function, priority:int = 0, down:Boolean = true) : void
      {
         var found:Boolean = false;
         var fs:FunctionShortcut = null;
         var v:Vector.<FunctionShortcut> = getListeners(shortcut,down) || new Vector.<FunctionShortcut>();
         var newShortcut:FunctionShortcut = new FunctionShortcut(listener,priority);
         for each(fs in v)
         {
            if(fs.method == listener)
            {
               found = true;
               break;
            }
         }
         if(!found)
         {
            v.push(newShortcut);
         }
         v.sort(sorter);
         if(down)
         {
            downShortcuts[shortcut] = v;
         }
         else
         {
            upShortcuts[shortcut] = v;
         }
      }
      
      private static function sorter(a:FunctionShortcut, b:FunctionShortcut) : int
      {
         return a.priority < b.priority ? 1 : (a.priority > b.priority ? -1 : 0);
      }
      
      public static function removeShortcutListener(shortcut:Shortcut, listener:Function, down:Boolean = true) : void
      {
         var fs:FunctionShortcut = null;
         var s:Object = null;
         var v:Vector.<FunctionShortcut> = getListeners(shortcut,down);
         if(v == null)
         {
            return;
         }
         var index:int = -1;
         for(var i:uint = 0; i < v.length; i++)
         {
            fs = v[i];
            if(fs.method == listener)
            {
               v.splice(i,1);
               break;
            }
         }
         var shortcuts:Dictionary = down ? downShortcuts : upShortcuts;
         if(v.length < 1)
         {
            for(s in shortcuts)
            {
               if(shortcut.equals(s as Shortcut))
               {
                  delete shortcuts[s];
               }
            }
         }
      }
      
      private static function onKeyDown(e:KeyboardEvent) : void
      {
         if(!enabled)
         {
            return;
         }
         if(e.keyCode == Keyboard.ESCAPE || e.keyCode == Keyboard.BACK)
         {
            e.preventDefault();
         }
         if(e.keyCode == Keyboard.SHIFT)
         {
            shiftPressed = true;
         }
         if(e.keyCode == Keyboard.CONTROL)
         {
            ctrlPressed = true;
         }
         checkKeyboardEvent(e,true);
      }
      
      private static function onKeyUp(e:KeyboardEvent) : void
      {
         if(!enabled)
         {
            return;
         }
         if(e.keyCode == Keyboard.SHIFT)
         {
            shiftPressed = false;
         }
         if(e.keyCode == Keyboard.CONTROL)
         {
            ctrlPressed = false;
         }
         checkKeyboardEvent(e,false);
      }
      
      private static function checkKeyboardEvent(e:KeyboardEvent, down:Boolean = true) : void
      {
         var prevent:Boolean = false;
         var fs:FunctionShortcut = null;
         var f:Function = null;
         var stageFocus:Object = stage.focus;
         if(stageFocus is TextField && !e.ctrlKey && !e.altKey)
         {
            return;
         }
         var s:Shortcut = new Shortcut(e.keyCode,e.ctrlKey,e.altKey,e.shiftKey);
         var v:Vector.<FunctionShortcut> = getListeners(s,down);
         for each(fs in v)
         {
            if(prevent)
            {
               break;
            }
            f = fs.method;
            try
            {
               prevent = f(e);
            }
            catch(e:Error)
            {
            }
         }
      }
      
      private static function getListeners(shortcut:Shortcut, down:Boolean = true) : Vector.<FunctionShortcut>
      {
         var s:Object = null;
         var shortcuts:Dictionary = down ? downShortcuts : upShortcuts;
         for(s in shortcuts)
         {
            if(shortcut.equals(s as Shortcut))
            {
               return shortcuts[s];
            }
         }
         return null;
      }
   }
}

class FunctionShortcut
{
   
   public var priority:int;
   
   public var method:Function;
   
   public function FunctionShortcut(method:Function, priority:int)
   {
      super();
      this.method = method;
      this.priority = priority;
   }
}
