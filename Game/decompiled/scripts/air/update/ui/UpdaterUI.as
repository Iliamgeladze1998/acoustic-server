package air.update.ui
{
   import air.update.ApplicationUpdater;
   import air.update.events.UpdateEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.filesystem.File;
   
   [ExcludeClass]
   public class UpdaterUI extends ApplicationUpdater
   {
      
      private var uiLoader:EmbeddedUILoader;
      
      public function UpdaterUI()
      {
         super();
      }
      
      override public function installFromAIRFile(file:File) : void
      {
         this.showUI();
         super.installFromAIRFile(file);
      }
      
      public function get isFileUpdateVisible() : Boolean
      {
         return configuration.isFileUpdateVisible;
      }
      
      public function addResources(lang:String, res:Object) : void
      {
         if(Boolean(this.uiLoader) && this.uiLoader.initialized)
         {
            this.uiLoader.addResources(lang,res);
         }
      }
      
      public function get isUnexpectedErrorVisible() : Boolean
      {
         return configuration.isUnexpectedErrorVisible;
      }
      
      public function set isFileUpdateVisible(value:Boolean) : void
      {
         configuration.isFileUpdateVisible = value;
      }
      
      public function set isUnexpectedErrorVisible(value:Boolean) : void
      {
         configuration.isUnexpectedErrorVisible = value;
      }
      
      override public function installUpdate() : void
      {
         this.hideUI();
         super.installUpdate();
      }
      
      override public function checkForUpdate() : void
      {
         this.hideUI();
         super.checkForUpdate();
      }
      
      private function onUILoadComplete(event:Event) : void
      {
         dispatch(new UpdateEvent(UpdateEvent.INITIALIZED));
      }
      
      public function get isDownloadProgressVisible() : Boolean
      {
         return configuration.isDownloadProgressVisible;
      }
      
      public function set localeChain(value:Array) : void
      {
         if(Boolean(this.uiLoader) && this.uiLoader.initialized)
         {
            this.uiLoader.setLocaleChain(value);
         }
      }
      
      public function get localeChain() : Array
      {
         if(Boolean(this.uiLoader) && this.uiLoader.initialized)
         {
            return this.uiLoader.getLocaleChain();
         }
         return [];
      }
      
      public function get isInstallUpdateVisible() : Boolean
      {
         return configuration.isInstallUpdateVisible;
      }
      
      private function hideUI() : void
      {
         if(Boolean(this.uiLoader) && this.uiLoader.initialized)
         {
            this.uiLoader.hideWindow();
         }
      }
      
      private function showUI() : void
      {
         if(Boolean(this.uiLoader) && this.uiLoader.initialized)
         {
            this.uiLoader.showWindow();
         }
      }
      
      override public function cancelUpdate() : void
      {
         this.hideUI();
         super.cancelUpdate();
      }
      
      public function set isDownloadProgressVisible(value:Boolean) : void
      {
         configuration.isDownloadProgressVisible = value;
      }
      
      public function set isDownloadUpdateVisible(value:Boolean) : void
      {
         configuration.isDownloadUpdateVisible = value;
      }
      
      public function set isInstallUpdateVisible(value:Boolean) : void
      {
         configuration.isInstallUpdateVisible = value;
      }
      
      override public function downloadUpdate() : void
      {
         this.hideUI();
         super.downloadUpdate();
      }
      
      override public function checkNow() : void
      {
         this.showUI();
         super.checkNow();
      }
      
      public function get isDownloadUpdateVisible() : Boolean
      {
         return configuration.isDownloadUpdateVisible;
      }
      
      override protected function onInitializationComplete() : void
      {
         this.uiLoader = new EmbeddedUILoader();
         this.uiLoader.applicationUpdater = this;
         this.uiLoader.addEventListener(IOErrorEvent.IO_ERROR,function(e:Event):void
         {
            throw new Error("Cannot load UI");
         });
         this.uiLoader.addEventListener(Event.COMPLETE,this.onUILoadComplete);
         this.uiLoader.load();
      }
      
      public function set isCheckForUpdateVisible(value:Boolean) : void
      {
         configuration.isCheckForUpdateVisible = value;
      }
      
      public function get isCheckForUpdateVisible() : Boolean
      {
         return configuration.isCheckForUpdateVisible;
      }
   }
}

