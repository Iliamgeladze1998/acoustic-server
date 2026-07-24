package soul.view.rtm
{
   import soul.model.buff.Effect;
   import soul.view.ui.HBox;
   import soul.view.ui.VerticalAlign;
   
   public class Effects extends HBox
   {
      
      private var _textPosition:String = "bottom";
      
      public function Effects()
      {
         super();
         gap = 1;
         verticalAlign = VerticalAlign.BOTTOM;
      }
      
      public function set effects(value:Array) : void
      {
         var effect:Effect = null;
         var child:EffectRenderer = null;
         removeAllChildren();
         for each(effect in value)
         {
            child = new EffectRenderer();
            child.effect = effect;
            child.textPosition = this._textPosition;
            addChild(child);
         }
      }
      
      [Inspectable(category="General",enumeration="top,bottom",defaultValue="bottom")]
      public function set textPosition(value:String) : void
      {
         var icon:EffectRenderer = null;
         if(this._textPosition == value)
         {
            return;
         }
         this._textPosition = value;
         for(var i:uint = 0; i < numChildren; i++)
         {
            icon = getChildAt(i) as EffectRenderer;
            if(Boolean(icon))
            {
               icon.textPosition = value;
            }
         }
      }
   }
}

