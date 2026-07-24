package soul.controller.shortcut
{
   import flash.ui.Keyboard;
   
   public class Shortcut
   {
      
      public static const KEY_Q:Shortcut = new Shortcut(81);
      
      public static const KEY_W:Shortcut = new Shortcut(87);
      
      public static const KEY_E:Shortcut = new Shortcut(69);
      
      public static const KEY_R:Shortcut = new Shortcut(82);
      
      public static const KEY_T:Shortcut = new Shortcut(84);
      
      public static const KEY_Y:Shortcut = new Shortcut(89);
      
      public static const KEY_U:Shortcut = new Shortcut(85);
      
      public static const KEY_I:Shortcut = new Shortcut(73);
      
      public static const CTRL_ALT_F:Shortcut = new Shortcut(70,true);
      
      public static const CTRL_ALT_I:Shortcut = new Shortcut(73,true,true);
      
      public static const CTRL_ALT_R:Shortcut = new Shortcut(82,true,true);
      
      public static const CTRL_ALT_S:Shortcut = new Shortcut(83,true,true);
      
      public static const CTRL_ALT_L:Shortcut = new Shortcut(76,true,true);
      
      public static const CTRL_ALT_G:Shortcut = new Shortcut(71,true,true);
      
      public static const BACKPACK:Shortcut = new Shortcut(66);
      
      public static const CHARACTER:Shortcut = new Shortcut(67);
      
      public static const FRIENDS:Shortcut = new Shortcut(79);
      
      public static const MAP:Shortcut = new Shortcut(77);
      
      public static const STATS:Shortcut = new Shortcut(78);
      
      public static const QUEST:Shortcut = new Shortcut(76);
      
      public static const TALENTS:Shortcut = new Shortcut(80);
      
      public static const SPELLBOOK:Shortcut = new Shortcut(80,false,false,true);
      
      public static const SWITCH_WEAPON:Shortcut = new Shortcut(83);
      
      public static const SWITCH_AUTOATTACK:Shortcut = new Shortcut(85,true);
      
      public static const SWITCH_CRAFT:Shortcut = new Shortcut(220,true);
      
      public static const ENTER:Shortcut = new Shortcut(Keyboard.ENTER);
      
      public static const ALT_ENTER:Shortcut = new Shortcut(Keyboard.ENTER,false,true);
      
      public static const CANCEL:Shortcut = new Shortcut(Keyboard.ESCAPE);
      
      public static const TAB:Shortcut = new Shortcut(Keyboard.TAB);
      
      public static const SELECT_NEXT_ENEMY2:Shortcut = new Shortcut(192);
      
      public var key:uint;
      
      public var ctrl:Boolean;
      
      public var alt:Boolean;
      
      public var shift:Boolean;
      
      public function Shortcut(key:uint, ctrl:Boolean = false, alt:Boolean = false, shift:Boolean = false)
      {
         super();
         this.key = key;
         this.ctrl = ctrl;
         this.alt = alt;
         this.shift = shift;
      }
      
      public function equals(s:Shortcut) : Boolean
      {
         return s.key == this.key && s.ctrl == this.ctrl && s.alt == this.alt && s.shift == this.shift;
      }
      
      public function toString() : String
      {
         return "ctrl:" + this.ctrl + " alt:" + this.alt + " shift:" + this.shift + "code:" + this.key;
      }
   }
}

