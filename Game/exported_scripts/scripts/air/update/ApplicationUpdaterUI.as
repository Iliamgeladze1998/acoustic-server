package air.update
{
   import air.update.events.DownloadErrorEvent;
   import air.update.events.StatusFileUpdateErrorEvent;
   import air.update.events.StatusFileUpdateEvent;
   import air.update.events.StatusUpdateErrorEvent;
   import air.update.events.StatusUpdateEvent;
   import air.update.events.UpdateEvent;
   import air.update.logging.Logger;
   import air.update.states.UpdateState;
   import air.update.ui.UpdaterUI;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.ProgressEvent;
   import flash.filesystem.File;
   
   [Event(name="error",type="flash.events.ErrorEvent")]
   [Event(name="progress",type="flash.events.ProgressEvent")]
   [Event(name="fileUpdateError",type="air.update.events.StatusFileUpdateErrorEvent")]
   [Event(name="fileUpdateStatus",type="air.update.events.StatusFileUpdateEvent")]
   [Event(name="downloadError",type="air.update.events.DownloadErrorEvent")]
   [Event(name="updateError",type="air.update.events.StatusUpdateErrorEvent")]
   [Event(name="updateStatus",type="air.update.events.StatusUpdateEvent")]
   [Event(name="beforeInstall",type="air.update.events.UpdateEvent")]
   [Event(name="downloadComplete",type="air.update.events.UpdateEvent")]
   [Event(name="downloadStart",type="air.update.events.UpdateEvent")]
   [Event(name="checkForUpdate",type="air.update.events.UpdateEvent")]
   [Event(name="initialized",type="air.update.events.UpdateEvent")]
   public class ApplicationUpdaterUI extends EventDispatcher
   {
      
      private static var logger:Logger = Logger.getLogger("air.update.ApplicationUpdaterUI");
      
      private var isUpdaterUIInitialized:Boolean;
      
      private var applicationUpdater:UpdaterUI;
      
      public function ApplicationUpdaterUI()
      {
         super();
         this.applicationUpdater = new UpdaterUI();
         this.applicationUpdater.addEventListener(UpdateEvent.INITIALIZED,this.dispatchProxy);
         this.applicationUpdater.addEventListener(ErrorEvent.ERROR,this.dispatchError);
         this.applicationUpdater.addEventListener(UpdateEvent.CHECK_FOR_UPDATE,this.dispatchProxy);
         this.applicationUpdater.addEventListener(StatusUpdateEvent.UPDATE_STATUS,this.dispatchProxy);
         this.applicationUpdater.addEventListener(UpdateEvent.DOWNLOAD_START,this.dispatchProxy);
         this.applicationUpdater.addEventListener(ProgressEvent.PROGRESS,this.dispatchProxy);
         this.applicationUpdater.addEventListener(UpdateEvent.DOWNLOAD_COMPLETE,this.dispatchProxy);
         this.applicationUpdater.addEventListener(UpdateEvent.BEFORE_INSTALL,this.dispatchProxy);
         this.applicationUpdater.addEventListener(StatusUpdateErrorEvent.UPDATE_ERROR,this.dispatchProxy);
         this.applicationUpdater.addEventListener(DownloadErrorEvent.DOWNLOAD_ERROR,this.dispatchProxy);
         this.applicationUpdater.addEventListener(StatusFileUpdateEvent.FILE_UPDATE_STATUS,this.dispatchProxy);
         this.applicationUpdater.addEventListener(StatusFileUpdateErrorEvent.FILE_UPDATE_ERROR,this.dispatchProxy);
      }
      
      public function get delay() : Number
      {
         return this.applicationUpdater.delay;
      }
      
      public function addResources(lang:String, res:Object) : void
      {
         this.applicationUpdater.addResources(lang,res);
      }
      
      public function get isFirstRun() : Boolean
      {
         return this.applicationUpdater.isFirstRun;
      }
      
      public function set delay(value:Number) : void
      {
         this.applicationUpdater.delay = value;
      }
      
      public function get localeChain() : Array
      {
         return this.applicationUpdater.localeChain;
      }
      
      public function installFromAIRFile(file:File) : void
      {
         this.applicationUpdater.installFromAIRFile(file);
      }
      
      public function get isFileUpdateVisible() : Boolean
      {
         return this.applicationUpdater.isFileUpdateVisible;
      }
      
      public function set updateURL(value:String) : void
      {
         this.applicationUpdater.updateURL = value;
      }
      
      public function get isNewerVersionFunction() : Function
      {
         return this.applicationUpdater.isNewerVersionFunction;
      }
      
      public function set localeChain(value:Array) : void
      {
         this.applicationUpdater.localeChain = value;
      }
      
      public function initialize() : void
      {
         this.applicationUpdater.initialize();
      }
      
      public function set isUnexpectedErrorVisible(value:Boolean) : void
      {
         this.applicationUpdater.isUnexpectedErrorVisible = value;
      }
      
      public function get configurationFile() : File
      {
         return this.applicationUpdater.configurationFile;
      }
      
      public function get isDownloadProgressVisible() : Boolean
      {
         return this.applicationUpdater.isDownloadProgressVisible;
      }
      
      protected function dispatchProxy(event:Event) : void
      {
         if(event.type == UpdateEvent.INITIALIZED)
         {
            this.isUpdaterUIInitialized = true;
         }
         if(event is ErrorEvent)
         {
            if(hasEventListener(event.type))
            {
               dispatchEvent(event);
            }
         }
         else
         {
            dispatchEvent(event);
         }
      }
      
      public function set isFileUpdateVisible(value:Boolean) : void
      {
         this.applicationUpdater.isFileUpdateVisible = value;
      }
      
      public function get wasPendingUpdate() : Boolean
      {
         return this.applicationUpdater.wasPendingUpdate;
      }
      
      public function get updateDescriptor() : XML
      {
         return this.applicationUpdater.updateDescriptor;
      }
      
      public function set isNewerVersionFunction(value:Function) : void
      {
         this.applicationUpdater.isNewerVersionFunction = value;
      }
      
      public function get isUnexpectedErrorVisible() : Boolean
      {
         return this.applicationUpdater.isUnexpectedErrorVisible;
      }
      
      public function get currentVersion() : String
      {
         return this.applicationUpdater.currentVersion;
      }
      
      public function get previousVersion() : String
      {
         return this.applicationUpdater.previousVersion;
      }
      
      public function cancelUpdate() : void
      {
         this.applicationUpdater.cancelUpdate();
      }
      
      public function set configurationFile(value:File) : void
      {
         this.applicationUpdater.configurationFile = value;
      }
      
      public function get isUpdateInProgress() : Boolean
      {
         return this.applicationUpdater.currentState != UpdateState.getStateName(UpdateState.READY);
      }
      
      public function get updateURL() : String
      {
         return this.applicationUpdater.updateURL;
      }
      
      public function get isInstallUpdateVisible() : Boolean
      {
         return this.applicationUpdater.isInstallUpdateVisible;
      }
      
      public function get previousApplicationStorageDirectory() : File
      {
         return this.applicationUpdater.previousApplicationStorageDirectory;
      }
      
      public function set isDownloadProgressVisible(value:Boolean) : void
      {
         this.applicationUpdater.isDownloadProgressVisible = value;
      }
      
      protected function dispatchError(event:ErrorEvent) : void
      {
         if(!this.isUpdaterUIInitialized)
         {
            dispatchEvent(event);
         }
      }
      
      public function set isInstallUpdateVisible(value:Boolean) : void
      {
         this.applicationUpdater.isInstallUpdateVisible = value;
      }
      
      public function set isDownloadUpdateVisible(value:Boolean) : void
      {
         this.applicationUpdater.isDownloadUpdateVisible = value;
      }
      
      public function get isDownloadUpdateVisible() : Boolean
      {
         return this.applicationUpdater.isDownloadUpdateVisible;
      }
      
      public function set isCheckForUpdateVisible(value:Boolean) : void
      {
         this.applicationUpdater.isCheckForUpdateVisible = value;
      }
      
      public function checkNow() : void
      {
         this.applicationUpdater.checkNow();
      }
      
      public function get isCheckForUpdateVisible() : Boolean
      {
         return this.applicationUpdater.isCheckForUpdateVisible;
      }
   }
}

