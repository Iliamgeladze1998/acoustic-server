package air.update.core
{
   import air.update.descriptors.StateDescriptor;
   import air.update.logging.Logger;
   import air.update.utils.Constants;
   import air.update.utils.FileUtils;
   import flash.filesystem.File;
   
   [ExcludeClass]
   public class UpdaterState
   {
      
      private static var logger:Logger = Logger.getLogger("air.update.core.UpdaterState");
      
      private var _descriptor:StateDescriptor;
      
      public function UpdaterState()
      {
         super();
      }
      
      public function removeAllFailedUpdates() : void
      {
         this.descriptor.removeAllFailedUpdates();
      }
      
      public function resetUpdateData() : void
      {
         this.descriptor.currentVersion = "";
         this.descriptor.previousVersion = "";
         this.descriptor.storage = null;
         FileUtils.deleteFile(FileUtils.getLocalUpdateFile());
         FileUtils.deleteFile(FileUtils.getLocalDescriptorFile());
         this.descriptor.updaterLaunched = false;
      }
      
      public function load() : void
      {
         var updateFile:File;
         var xml:XML = null;
         var storageFile:File = FileUtils.getStorageStateFile();
         var documentsFile:File = FileUtils.getDocumentsStateFile();
         if(!storageFile.exists)
         {
            if(!documentsFile.exists)
            {
               this._descriptor = StateDescriptor.defaultState();
               this.saveToStorage();
            }
            else
            {
               try
               {
                  xml = FileUtils.readXMLFromFile(documentsFile);
                  this._descriptor = new StateDescriptor(xml);
                  this._descriptor.validate();
                  this.saveToStorage();
               }
               catch(e:Error)
               {
                  logger.fine("Invalid state: " + e);
                  _descriptor = StateDescriptor.defaultState();
                  saveToStorage();
               }
            }
         }
         else
         {
            try
            {
               xml = FileUtils.readXMLFromFile(storageFile);
               this._descriptor = new StateDescriptor(xml);
               this._descriptor.validate();
            }
            catch(e:Error)
            {
               logger.fine("Invalid state: " + e);
               _descriptor = StateDescriptor.defaultState();
               saveToStorage();
            }
         }
         updateFile = FileUtils.getLocalUpdateFile();
         if(Boolean(this.descriptor.currentVersion) && Boolean(!updateFile.exists) && !this.descriptor.updaterLaunched)
         {
            logger.fine("Missing update file");
            this._descriptor = StateDescriptor.defaultState();
            this.saveToStorage();
         }
         FileUtils.deleteFile(documentsFile);
      }
      
      public function addFailedUpdate(version:String) : void
      {
         this.descriptor.addFailedUpdate(version);
      }
      
      public function saveToDocuments() : void
      {
         var documentsFile:File = FileUtils.getDocumentsStateFile();
         FileUtils.saveXMLToFile(this._descriptor.getXML(),documentsFile);
      }
      
      public function removePreviousStorageData(previousStorage:File) : void
      {
         if(!previousStorage || !previousStorage.exists)
         {
            return;
         }
         var file:File = previousStorage.resolvePath(Constants.UPDATER_FOLDER + "/" + Constants.STATE_FILE);
         FileUtils.deleteFile(file);
         file = previousStorage.resolvePath(Constants.UPDATER_FOLDER + "/" + Constants.UPDATE_LOCAL_FILE);
         FileUtils.deleteFile(file);
         file = previousStorage.resolvePath(Constants.UPDATER_FOLDER + "/" + Constants.DESCRIPTOR_LOCAL_FILE);
         FileUtils.deleteFile(file);
         file = previousStorage.resolvePath(Constants.UPDATER_FOLDER);
         FileUtils.deleteFolder(file);
      }
      
      public function saveToStorage() : void
      {
         var storageFile:File = FileUtils.getStorageStateFile();
         FileUtils.saveXMLToFile(this._descriptor.getXML(),storageFile);
      }
      
      public function get descriptor() : StateDescriptor
      {
         return this._descriptor;
      }
   }
}

