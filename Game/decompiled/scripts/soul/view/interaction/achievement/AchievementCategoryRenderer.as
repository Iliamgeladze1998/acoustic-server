package soul.view.interaction.achievement
{
   import soul.view.assets.Assets;
   import soul.view.assets.GradientBox;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Canvas;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   
   public class AchievementCategoryRenderer extends Canvas
   {
      
      private static const GRADIENT:Array = [[4289299279,200],[11109199,255]];
      
      protected var box:HBox = new HBox();
      
      protected var gradient:GradientBox = new GradientBox();
      
      protected var iconBox:BorderedContainer = new BorderedContainer();
      
      protected var icon:CachedImage = new CachedImage();
      
      protected var label:Label = new Label();
      
      private var _selected:Boolean;
      
      public function AchievementCategoryRenderer()
      {
         super();
         width = 260;
         height = 30;
         this.box.percentWidth = 100;
         this.box.height = 26;
         this.iconBox.width = 26;
         this.iconBox.percentHeight = 100;
         this.iconBox.padding = 2;
         this.iconBox.borderSkin = Assets.simpleBorderRound;
         this.gradient.percentWidth = 100;
         this.gradient.percentHeight = 100;
         this.gradient.height = 26;
         this.icon.percentHeight = this.icon.percentWidth = 100;
         this.iconBox.addChild(this.icon);
         this.label.left = 10;
         this.label.color = 3219484;
         this.label.percentWidth = 100;
         this.label.height = 16;
         this.label.verticalCenter = 0;
         this.gradient.addChild(this.label);
         this.box.addChild(this.iconBox);
         this.box.addChild(this.gradient);
         addChild(this.box);
         this.selected = false;
      }
      
      public function set selected(value:Boolean) : void
      {
         this._selected = value;
         this.label.bold = value;
         this.gradient.gradient = value ? GRADIENT : [0];
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
   }
}

