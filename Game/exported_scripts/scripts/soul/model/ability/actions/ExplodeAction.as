package soul.model.ability.actions
{
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   
   public class ExplodeAction extends AbilityAction
   {
      
      public var limit:uint;
      
      public var transport:String;
      
      public var excludeCaster:Boolean;
      
      public var actions:Array;
      
      public function ExplodeAction()
      {
         super();
      }
      
      override public function getDescription() : Component
      {
         var box:VBox = null;
         var label:Label = null;
         var action:UnitAbilityAction = null;
         box = new VBox();
         box.percentWidth = 100;
         label = new Label();
         label.percentWidth = 100;
         label.multiline = true;
         label.wordWrap = true;
         label.htmlText = getParam("area") + this.getAreaDescription();
         box.addChild(label);
         for each(action in this.actions)
         {
            box.addChild(action.getDescription());
         }
         return box;
      }
      
      protected function getAreaDescription() : String
      {
         var opts:Vector.<String> = new Vector.<String>(0);
         if(this.excludeCaster)
         {
            opts.push(getString("excludeCaster"));
         }
         if(this.limit > 0)
         {
            opts.push(getString("maxTargets") + " " + this.limit);
         }
         return opts.length > 0 ? "(" + opts.join(", ") + ")" : "";
      }
   }
}

