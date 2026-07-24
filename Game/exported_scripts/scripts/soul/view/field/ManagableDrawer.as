package soul.view.field
{
   import mx.events.PropertyChangeEvent;
   
   public class ManagableDrawer extends FieldDrawer
   {
      
      protected var _sortingEnabled:Boolean = true;
      
      public function ManagableDrawer()
      {
         super();
      }
      
      private function set _215356525bgVisible(value:Boolean) : void
      {
         mcBg.visible = value;
      }
      
      public function get bgVisible() : Boolean
      {
         return mcBg.visible;
      }
      
      private function set _2123134118raisedVisible(value:Boolean) : void
      {
         mcRaised.visible = value;
      }
      
      public function get raisedVisible() : Boolean
      {
         return mcRaised.visible;
      }
      
      private function set _1626683627groundVisible(value:Boolean) : void
      {
         mcGround.visible = value;
      }
      
      public function get groundVisible() : Boolean
      {
         return mcGround.visible;
      }
      
      private function set _2090225949sortingEnabled(value:Boolean) : void
      {
         this._sortingEnabled = value;
      }
      
      public function get sortingEnabled() : Boolean
      {
         return this._sortingEnabled;
      }
      
      [Bindable(event="propertyChange")]
      public function set sortingEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this.sortingEnabled;
         if(_loc2_ !== param1)
         {
            this._2090225949sortingEnabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sortingEnabled",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set raisedVisible(param1:Boolean) : void
      {
         var _loc2_:Object = this.raisedVisible;
         if(_loc2_ !== param1)
         {
            this._2123134118raisedVisible = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"raisedVisible",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set bgVisible(param1:Boolean) : void
      {
         var _loc2_:Object = this.bgVisible;
         if(_loc2_ !== param1)
         {
            this._215356525bgVisible = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bgVisible",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set groundVisible(param1:Boolean) : void
      {
         var _loc2_:Object = this.groundVisible;
         if(_loc2_ !== param1)
         {
            this._1626683627groundVisible = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"groundVisible",_loc2_,param1));
            }
         }
      }
   }
}

