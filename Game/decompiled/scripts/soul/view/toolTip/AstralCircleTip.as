package soul.view.toolTip
{
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.astral.AstralCircle;
   import soul.model.field.mapconfig.PvpState;
   import soul.view.ui.BoxDirection;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Component;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   
   public class AstralCircleTip extends SoulToolTipBase
   {
      
      public function AstralCircleTip()
      {
         super();
         direction = BoxDirection.VERTICAL;
         minWidth = 250;
         padding = 5;
         gap = 1;
      }
      
      override public function prepare() : void
      {
         var value:AstralCircle = null;
         var splitter:Component = null;
         var hbox:HBox = null;
         var image:CachedImage = null;
         var key:String = null;
         var label:Label = null;
         if(prepared)
         {
            return;
         }
         prepared = true;
         value = data as AstralCircle;
         if(!value)
         {
            return;
         }
         direction = BoxDirection.VERTICAL;
         label = new Label();
         label.fontSize = 12;
         label.text = this.getAstralString(value.id + ".name");
         addChild(label);
         splitter = new TipSplitter();
         splitter.percentWidth = 100;
         splitter.height = 1;
         addChild(splitter);
         if(Boolean(value.levels))
         {
            hbox = new HBox();
            label = new Label();
            label.color = 16777215;
            label.text = getString("levels") + ": ";
            hbox.addChild(label);
            label = new Label();
            label.color = value.accessible ? 52224 : 13369344;
            label.text = value.levels;
            hbox.addChild(label);
            addChild(hbox);
         }
         if(Boolean(value.side))
         {
            hbox = new HBox();
            label = new Label();
            label.color = 16777215;
            label.text = getString("side") + ": ";
            hbox.addChild(label);
            label = new Label();
            label.color = value.accessible ? 52224 : 13369344;
            label.text = getString(value.side);
            hbox.addChild(label);
            addChild(hbox);
         }
         if(Boolean(value.pvpState))
         {
            hbox = new HBox();
            label = new Label();
            label.color = 16777215;
            label.text = getString("pvpState") + ": ";
            hbox.addChild(label);
            label = new Label();
            label.color = PvpState.getTextColor(value.pvpState);
            label.text = getString(value.pvpState);
            hbox.addChild(label);
            addChild(hbox);
         }
         if(Boolean(value.citadelInfo))
         {
            label = new Label();
            label.color = 16777215;
            label.percentWidth = 100;
            label.wordWrap = true;
            label.multiline = true;
            label.htmlText = value.citadelInfo.getDescription();
            addChild(label);
         }
         splitter = new TipSplitter();
         splitter.percentWidth = 100;
         splitter.height = 1;
         addChild(splitter);
         label = new Label();
         label.color = 16777215;
         label.percentWidth = 100;
         label.wordWrap = true;
         label.multiline = true;
         label.htmlText = this.getAstralString(value.id + ".description");
         addChild(label);
      }
      
      private function getAstralString(key:String) : String
      {
         return LocaleManager.getString(BundleName.ASTRAL,key);
      }
   }
}

