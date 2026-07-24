package soul.view.interaction.character.parts
{
   import soul.model.character.Reputation;
   import soul.view.ui.HBox;
   
   public class ReputationBox extends HBox
   {
      
      public function ReputationBox()
      {
         super();
         gap = -4;
      }
      
      public function set dataProvider(value:Array) : void
      {
         var reputation:Reputation = null;
         var child:ReputationRenderer = null;
         removeAllChildren();
         for each(reputation in value)
         {
            child = new ReputationRenderer();
            child.reputation = reputation;
            addChild(child);
         }
      }
   }
}

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.EventDispatcher;
import soul.controller.locale.BundleName;
import soul.controller.locale.LocaleManager;
import soul.model.character.Reputation;
import soul.model.system.Configuration;
import soul.view.ui.Component;

class ReputationRenderer extends CharacterRoundIcon
{
   
   public function ReputationRenderer()
   {
      super();
   }
   
   public function set reputation(value:Reputation) : void
   {
      source = Configuration.getReputationUrl(value.type);
      var txt:String = "<font color=\'#00FF00\'>" + LocaleManager.getString(BundleName.REPUTATION,value.type) + "</font>";
      txt += "<br>" + this.getString("level") + ": " + value.level;
      txt += "<br>" + this.getString("XP") + ": " + value.xp + "%";
      toolTip = txt;
   }
   
   private function getString(key:String) : String
   {
      return LocaleManager.getString(BundleName.INTERFACE,key);
   }
}
