package soul.view.astral
{
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.astral.AstralCircle;
   import soul.model.field.mapconfig.PvpState;
   import soul.view.assets.GradientLabel;
   import soul.view.common.Icons;
   import soul.view.toolTip.AstralCircleTip;
   import soul.view.toolTip.ToolTipManager;
   import soul.view.ui.CachedImage;
   import soul.view.ui.HBox;
   import soul.view.ui.IListItemRenderer;
   import soul.view.ui.VerticalAlign;
   
   public class AstralLocationRenderer extends HBox implements IListItemRenderer
   {
      
      private static const GRADIENT_SELECTED:Array = [[2583691263,127],16777215];
      
      private static const GRADIENT:Array = [16777215];
      
      private static const LABEL_COLOR:uint = 3219484;
      
      private static const QUEST_COLOR:uint = 229137;
      
      private const icon:CachedImage = new CachedImage();
      
      private const label:GradientLabel = new GradientLabel();
      
      private var _data:Object;
      
      public function AstralLocationRenderer()
      {
         super();
         mouseChildren = false;
         doubleClickEnabled = true;
         this.label.width = 173;
         this.label.fontSize = 12;
         this.label.truncateToFit = true;
         verticalAlign = VerticalAlign.MIDDLE;
         this.selected = false;
         addChild(this.icon);
         addChild(this.label);
      }
      
      public function set data(value:Object) : void
      {
         var circle:AstralCircle = null;
         if(this._data == value)
         {
            return;
         }
         this._data = value;
         circle = value as AstralCircle;
         if(!circle)
         {
            return;
         }
         this.icon.source = PvpState.getRoundIcon(circle.pvpState) || (Boolean(circle.citadelInfo) ? Icons.citadel : null);
         this.label.text = " " + LocaleManager.getString(BundleName.ASTRAL,circle.id + ".name");
         this.label.color = circle.objective ? QUEST_COLOR : LABEL_COLOR;
         ToolTipManager.register(this,circle,AstralCircleTip);
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set selected(value:Boolean) : void
      {
         this.label.gradient = value ? GRADIENT_SELECTED : GRADIENT;
      }
      
      public function get selected() : Boolean
      {
         return false;
      }
   }
}

