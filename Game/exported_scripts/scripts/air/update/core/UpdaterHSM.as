package air.update.core
{
   import air.update.descriptors.ApplicationDescriptor;
   import air.update.descriptors.UpdateDescriptor;
   import air.update.events.DownloadErrorEvent;
   import air.update.events.StatusFileUpdateErrorEvent;
   import air.update.events.StatusFileUpdateEvent;
   import air.update.events.StatusUpdateErrorEvent;
   import air.update.events.StatusUpdateEvent;
   import air.update.events.UpdateEvent;
   import air.update.logging.Logger;
   import air.update.net.FileDownloader;
   import air.update.states.HSM;
   import air.update.states.HSMEvent;
   import air.update.states.UpdateState;
   import air.update.utils.Constants;
   import air.update.utils.FileUtils;
   import air.update.utils.VersionUtils;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.filesystem.File;
   import flash.net.URLRequest;
   
   [ExcludeClass]
   [Event(name="beforeInstall",type="air.update.events.UpdateEvent")]
   [Event(name="downloadComplete",type="air.update.events.UpdateEvent")]
   [Event(name="downloadError",type="air.update.events.DownloadErrorEvent")]
   [Event(name="progress",type="flash.events.ProgressEvent")]
   [Event(name="downloadStart",type="air.update.events.UpdateEvent")]
   [Event(name="updateError",type="air.update.events.StatusUpdateErrorEvent")]
   [Event(name="updateStatus",type="air.update.events.StatusUpdateEvent")]
   [Event(name="checkForUpdate",type="air.update.events.UpdateEvent")]
   public class UpdaterHSM extends HSM
   {
      
      private static var logger:Logger = Logger.getLogger("air.update.core.UpdaterHSM");
      
      public static const EVENT_CHECK:String = "updater.check";
      
      public static const EVENT_DOWNLOAD:String = "updater.download";
      
      public static const EVENT_INSTALL:String = "updater.install";
      
      public static const EVENT_INSTALL_TRIGGER:String = "install.trigger";
      
      public static const EVENT_FILE_INSTALL_TRIGGER:String = "file_install.trigger";
      
      public static const EVENT_STATE_CLEAR_TRIGGER:String = "state_clear.trigger";
      
      public static const EVENT_ASYNC:String = "check.async";
      
      public static const EVENT_FILE:String = "check.file";
      
      public static const EVENT_VERIFIED:String = "check.verified";
      
      private var descriptorURL:URLRequest;
      
      private var unpackager:AIRUnpackager;
      
      private var descriptorFile:File;
      
      private var _descriptor:UpdateDescriptor;
      
      private var requestedFile:File;
      
      private var requestedURL:String;
      
      private var lastErrorEvent:ErrorEvent;
      
      private var downloader:FileDownloader;
      
      private var _applicationDescriptor:ApplicationDescriptor;
      
      private var updateFile:File;
      
      private var updateURL:URLRequest;
      
      private var _configuration:UpdaterConfiguration;
      
      public function UpdaterHSM()
      {
         super(this.stateReady);
      }
      
      protected function stateInitialized(event:Event) : void
      {
         logger.finest("stateInitialized: " + event.type);
         switch(event.type)
         {
            case HSMEvent.ENTER:
               transition(this.stateReady);
         }
      }
      
      protected function stateDownloading(event:Event) : void
      {
         if(event.type != ProgressEvent.PROGRESS)
         {
            logger.finest("stateDownloading: " + event.type);
         }
         switch(event.type)
         {
            case HSMEvent.ENTER:
               this.downloader = new FileDownloader(this.updateURL,this.updateFile);
               this.downloader.addEventListener(DownloadErrorEvent.DOWNLOAD_ERROR,dispatch);
               this.downloader.addEventListener(UpdateEvent.DOWNLOAD_START,dispatch);
               this.downloader.addEventListener(ProgressEvent.PROGRESS,dispatch);
               this.downloader.addEventListener(UpdateEvent.DOWNLOAD_COMPLETE,dispatch);
               this.downloader.download();
               break;
            case UpdateEvent.DOWNLOAD_START:
               dispatchEvent(event.clone());
               break;
            case ProgressEvent.PROGRESS:
               dispatchEvent(event.clone());
               break;
            case DownloadErrorEvent.DOWNLOAD_ERROR:
               this.lastErrorEvent = ErrorEvent(event.clone());
               transition(this.stateErrored);
               break;
            case UpdateEvent.DOWNLOAD_COMPLETE:
               this.downloader = null;
               transition(this.stateDownloaded);
         }
      }
      
      public function getUpdateState() : int
      {
         var updateState:int = -1;
         switch(stateHSM)
         {
            case this.stateInitialized:
               updateState = UpdateState.READY;
               break;
            case this.stateBeforeChecking:
               updateState = UpdateState.BEFORE_CHECKING;
               break;
            case this.stateChecking:
               updateState = UpdateState.CHECKING;
               break;
            case this.stateAvailable:
            case this.stateAvailableFile:
               updateState = UpdateState.AVAILABLE;
               break;
            case this.stateDownloading:
               updateState = UpdateState.DOWNLOADING;
               break;
            case this.stateDownloaded:
               updateState = UpdateState.DOWNLOADED;
               break;
            case this.stateInstalling:
               updateState = UpdateState.INSTALLING;
               break;
            case this.statePendingInstall:
               updateState = UpdateState.PENDING_INSTALLING;
               break;
            case this.stateReady:
               updateState = UpdateState.READY;
         }
         return updateState;
      }
      
      private function fileUnpackaged() : void
      {
         var xml:XML = null;
         logger.finer("Parsing file descriptor");
         try
         {
            xml = this.unpackager.descriptorXML;
            this._applicationDescriptor = new ApplicationDescriptor(xml);
            this._applicationDescriptor.validate();
            if(VersionUtils.getApplicationID() != this._applicationDescriptor.id)
            {
               throw new Error("Different applicationID",Constants.ERROR_DIFFERENT_APPLICATION_ID);
            }
            if(!this.isNewerVersion(VersionUtils.getApplicationVersion(),this._applicationDescriptor.version))
            {
               if(dispatchEvent(new StatusFileUpdateEvent(StatusFileUpdateEvent.FILE_UPDATE_STATUS,false,true,false,this._applicationDescriptor.version,this.requestedFile.nativePath,this._applicationDescriptor.versionLabel)))
               {
                  transition(this.stateReady);
               }
               return;
            }
            transition(this.stateAvailableFile);
         }
         catch(e:Error)
         {
            logger.fine("Error validating file descriptor: " + e);
            lastErrorEvent = new StatusFileUpdateErrorEvent(StatusFileUpdateErrorEvent.FILE_UPDATE_ERROR,false,true,e.message,e.errorID);
            transition(stateErrored);
         }
      }
      
      private function isNewerVersion(oldVersion:String, newVersion:String) : Boolean
      {
         if(Boolean(this.configuration))
         {
            return this.configuration.isNewerVersionFunction(oldVersion,newVersion);
         }
         return VersionUtils.isNewerVersion(oldVersion,newVersion);
      }
      
      protected function stateDownloaded(event:Event) : void
      {
         var descriptor:ApplicationDescriptor = null;
         logger.finest("stateDownloaded: " + event.type);
         switch(event.type)
         {
            case HSMEvent.ENTER:
               this.unpackager = new AIRUnpackager();
               this.unpackager.addEventListener(Event.COMPLETE,dispatch);
               this.unpackager.addEventListener(ErrorEvent.ERROR,dispatch);
               this.unpackager.addEventListener(IOErrorEvent.IO_ERROR,dispatch);
               this.unpackager.unpackageAsync(this.updateFile.url);
               break;
            case ErrorEvent.ERROR:
            case IOErrorEvent.IO_ERROR:
               this.unpackager.cancel();
               this.unpackager = null;
               this.lastErrorEvent = new DownloadErrorEvent(DownloadErrorEvent.DOWNLOAD_ERROR,false,true,"",Constants.ERROR_AIR_UNPACKAGING,ErrorEvent(event).errorID);
               transition(this.stateErrored);
               break;
            case Event.COMPLETE:
               this.unpackager.cancel();
               descriptor = new ApplicationDescriptor(this.unpackager.descriptorXML);
               try
               {
                  descriptor.validate();
               }
               catch(e:Error)
               {
                  unpackager = null;
                  lastErrorEvent = new DownloadErrorEvent(DownloadErrorEvent.DOWNLOAD_ERROR,false,true,e.message,Constants.ERROR_VALIDATE,e.errorID);
                  transition(stateErrored);
                  return;
               }
               if(descriptor.id != VersionUtils.getApplicationID())
               {
                  this.lastErrorEvent = new DownloadErrorEvent(DownloadErrorEvent.DOWNLOAD_ERROR,false,true,"Different applicationID",Constants.ERROR_VALIDATE,Constants.ERROR_DIFFERENT_APPLICATION_ID);
                  transition(this.stateErrored);
                  return;
               }
               if(this._descriptor.version != descriptor.version)
               {
                  this.lastErrorEvent = new DownloadErrorEvent(DownloadErrorEvent.DOWNLOAD_ERROR,false,true,"Version mismatch",Constants.ERROR_VALIDATE,Constants.ERROR_VERSION_MISMATCH);
                  transition(this.stateErrored);
                  return;
               }
               if(!this.isNewerVersion(VersionUtils.getApplicationVersion(),descriptor.version))
               {
                  this.lastErrorEvent = new DownloadErrorEvent(DownloadErrorEvent.DOWNLOAD_ERROR,false,true,"Not a newer version",Constants.ERROR_VALIDATE,Constants.ERROR_NOT_NEW_VERSION);
                  transition(this.stateErrored);
                  return;
               }
               dispatch(new Event(EVENT_VERIFIED));
               break;
            case EVENT_VERIFIED:
               if(dispatchEvent(new UpdateEvent(UpdateEvent.DOWNLOAD_COMPLETE,false,true)))
               {
                  transition(this.stateInstalling);
                  return;
               }
               break;
            case EVENT_INSTALL:
               transition(this.stateInstalling);
         }
      }
      
      protected function stateReady(event:Event) : void
      {
         logger.finest("stateReady: " + event.type);
         switch(event.type)
         {
            case HSMEvent.ENTER:
               break;
            case EVENT_ASYNC:
               this.updateURL = new URLRequest(this.requestedURL);
               this.updateFile = FileUtils.getLocalDescriptorFile();
               transitionAsync(this.stateBeforeChecking);
               break;
            case EVENT_FILE:
               transitionAsync(this.stateUnpackaging);
         }
      }
      
      protected function stateChecking(event:Event) : void
      {
         logger.finest("stateChecking: " + event.type);
         switch(event.type)
         {
            case HSMEvent.ENTER:
               this.downloader = new FileDownloader(this.updateURL,this.updateFile);
               this.downloader.addEventListener(DownloadErrorEvent.DOWNLOAD_ERROR,dispatch);
               this.downloader.addEventListener(ProgressEvent.PROGRESS,dispatch);
               this.downloader.addEventListener(UpdateEvent.DOWNLOAD_COMPLETE,dispatch);
               this.downloader.download();
               break;
            case UpdateEvent.DOWNLOAD_START:
            case ProgressEvent.PROGRESS:
               break;
            case DownloadErrorEvent.DOWNLOAD_ERROR:
               this.lastErrorEvent = new StatusUpdateErrorEvent(StatusUpdateErrorEvent.UPDATE_ERROR,false,true,DownloadErrorEvent(event).text,DownloadErrorEvent(event).errorID,DownloadErrorEvent(event).subErrorID);
               transition(this.stateErrored);
               break;
            case UpdateEvent.DOWNLOAD_COMPLETE:
               this.downloader = null;
               this.descriptorDownloaded();
         }
      }
      
      private function startTimer(delay:Number = -1) : void
      {
      }
      
      public function installFile(file:File) : void
      {
         this.requestedFile = file;
         dispatch(new Event(EVENT_FILE));
      }
      
      protected function stateAvailable(event:Event) : void
      {
         logger.finest("stateAvailable: " + event.type);
         switch(event.type)
         {
            case HSMEvent.ENTER:
               if(dispatchEvent(new StatusUpdateEvent(StatusUpdateEvent.UPDATE_STATUS,false,true,true,this.descriptor.version,this.descriptor.description,this.descriptor.versionLabel)))
               {
                  transition(this.stateDownloading);
                  return;
               }
               break;
            case EVENT_DOWNLOAD:
               transition(this.stateDownloading);
         }
      }
      
      protected function stateUnpackaging(event:Event) : void
      {
         logger.finest("stateUnpackaging: " + event.type);
         switch(event.type)
         {
            case HSMEvent.ENTER:
               this.unpackager = new AIRUnpackager();
               this.unpackager.addEventListener(Event.COMPLETE,dispatch);
               this.unpackager.addEventListener(ErrorEvent.ERROR,dispatch);
               this.unpackager.addEventListener(IOErrorEvent.IO_ERROR,dispatch);
               this.unpackager.unpackageAsync(this.requestedFile.url);
               break;
            case Event.COMPLETE:
               this.unpackager.cancel();
               this.fileUnpackaged();
               this.unpackager = null;
               break;
            case ErrorEvent.ERROR:
            case IOErrorEvent.IO_ERROR:
               this.unpackager.cancel();
               this.unpackager = null;
               this.lastErrorEvent = new StatusFileUpdateErrorEvent(StatusFileUpdateErrorEvent.FILE_UPDATE_ERROR,false,true,"",ErrorEvent(event).errorID);
               transition(this.stateErrored);
         }
      }
      
      private function installUpdate() : void
      {
         logger.finest("Installing update");
         dispatchEvent(new Event(EVENT_INSTALL_TRIGGER));
      }
      
      protected function stateCancelled(event:Event) : void
      {
         logger.finest("stateCancelled: " + event.type);
         switch(event.type)
         {
            case HSMEvent.ENTER:
               dispatchEvent(new Event(EVENT_STATE_CLEAR_TRIGGER));
               if(Boolean(this.downloader))
               {
                  this.downloader.cancel();
                  this.downloader = null;
               }
               transition(this.stateReady);
         }
      }
      
      public function checkAsync(url:String) : void
      {
         this.requestedURL = url;
         dispatch(new Event(EVENT_ASYNC));
      }
      
      protected function stateErrored(event:Event) : void
      {
         var isDialogHidden:Boolean = false;
         logger.finest("stateErrored: " + event.type + " lastErrorEvent: " + this.lastErrorEvent);
         switch(event.type)
         {
            case HSMEvent.ENTER:
               isDialogHidden = false;
               if(Boolean(this.lastErrorEvent))
               {
                  isDialogHidden = dispatchEvent(this.lastErrorEvent);
                  this.lastErrorEvent = null;
               }
               dispatchEvent(new Event(EVENT_STATE_CLEAR_TRIGGER));
               if(Boolean(this.downloader))
               {
                  this.downloader.cancel();
                  this.downloader = null;
               }
               if(isDialogHidden)
               {
                  transition(this.stateReady);
               }
         }
      }
      
      protected function stateInstalling(event:Event) : void
      {
         logger.finest("stateInstalling: " + event.type);
         switch(event.type)
         {
            case HSMEvent.ENTER:
               if(!dispatchEvent(new UpdateEvent(UpdateEvent.BEFORE_INSTALL,false,true)))
               {
                  transition(this.statePendingInstall);
                  return;
               }
               this.installUpdate();
         }
      }
      
      protected function stateAvailableFile(event:Event) : void
      {
         logger.finest("stateAvailableFile: " + event.type + " file: " + this.requestedFile.url);
         switch(event.type)
         {
            case HSMEvent.ENTER:
               if(dispatchEvent(new StatusFileUpdateEvent(StatusFileUpdateEvent.FILE_UPDATE_STATUS,false,true,true,this._applicationDescriptor.version,this.requestedFile.nativePath,this._applicationDescriptor.versionLabel)))
               {
                  transition(this.stateInstallingFile);
                  return;
               }
               break;
            case EVENT_INSTALL:
               transition(this.stateInstallingFile);
         }
      }
      
      public function get applicationDescriptor() : ApplicationDescriptor
      {
         return this._applicationDescriptor;
      }
      
      private function installFileUpdate() : void
      {
         logger.finest("Installing file update");
         dispatchEvent(new Event(EVENT_FILE_INSTALL_TRIGGER));
      }
      
      public function set configuration(value:UpdaterConfiguration) : void
      {
         this._configuration = value;
      }
      
      public function get airFile() : File
      {
         return this.requestedFile;
      }
      
      public function get descriptor() : UpdateDescriptor
      {
         return this._descriptor;
      }
      
      protected function stateBeforeChecking(event:Event) : void
      {
         var e:UpdateEvent = null;
         logger.finest("stateBeforeChecking: " + event.type);
         switch(event.type)
         {
            case HSMEvent.ENTER:
               e = new UpdateEvent(UpdateEvent.CHECK_FOR_UPDATE,false,true);
               dispatchEvent(e);
               if(!e.isDefaultPrevented())
               {
                  transition(this.stateChecking);
                  return;
               }
               logger.finer("CheckForUpdate cancelled");
               break;
            case EVENT_CHECK:
               transition(this.stateChecking);
         }
      }
      
      protected function stateInstallingFile(event:Event) : void
      {
         logger.finest("stateInstallingFile: " + event.type);
         switch(event.type)
         {
            case HSMEvent.ENTER:
               this.installFileUpdate();
         }
      }
      
      protected function statePendingInstall(event:Event) : void
      {
         logger.finest("statePendingInstall: " + event.type);
         switch(event.type)
         {
            case HSMEvent.ENTER:
               return;
            default:
               return;
         }
      }
      
      public function get configuration() : UpdaterConfiguration
      {
         return this._configuration;
      }
      
      public function cancel() : void
      {
         transition(this.stateCancelled);
      }
      
      private function descriptorDownloaded() : void
      {
         var xml:XML = null;
         logger.finer("Parsing descriptor");
         try
         {
            xml = FileUtils.readXMLFromFile(this.updateFile);
            this._descriptor = new UpdateDescriptor(xml);
            this._descriptor.validate();
            if(!this._descriptor.isCompatibleWithApplicationDescriptor(VersionUtils.applicationHasVersionNumber()))
            {
               throw new Error("Application namespace and update descriptor namespace are not compatible",Constants.ERROR_INCOMPATIBLE_NAMESPACE);
            }
            if(!this.isNewerVersion(VersionUtils.getApplicationVersion(),this._descriptor.version))
            {
               if(dispatchEvent(new StatusUpdateEvent(StatusUpdateEvent.UPDATE_STATUS,false,true)))
               {
                  transition(this.stateReady);
               }
               return;
            }
            this.updateFile = FileUtils.getLocalUpdateFile();
            this.updateURL = new URLRequest(this.descriptor.url);
            transition(this.stateAvailable);
         }
         catch(e:Error)
         {
            logger.fine("Error loading/validating downloaded descriptor: " + e);
            lastErrorEvent = new StatusUpdateErrorEvent(StatusUpdateErrorEvent.UPDATE_ERROR,false,false,e.message,e.errorID);
            transition(stateErrored);
         }
      }
   }
}

