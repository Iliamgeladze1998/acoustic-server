package air.update.core
{
   import air.update.descriptors.ConfigurationDescriptor;
   import air.update.logging.Logger;
   import air.update.utils.Constants;
   import air.update.utils.FileUtils;
   import air.update.utils.VersionUtils;
   import flash.filesystem.File;
   
   [ExcludeClass]
   public class UpdaterConfiguration
   {
      
      private static var logger:Logger = Logger.getLogger("air.update.core.UpdaterConfiguration");
      
      private var _delay:Number;
      
      private var configurationDescriptor:ConfigurationDescriptor;
      
      private var _isFileUpdateVisible:int;
      
      private var _configurationFile:File;
      
      private var _isDownloadProgressVisible:int;
      
      private var _isUnexpectedErrorVisible:int;
      
      private var _updateURL:String;
      
      private var _isNewerVersionFunction:Function;
      
      private var _isInstallUpdateVisible:int;
      
      private var _isDownloadUpdateVisible:int;
      
      private var _isCheckForUpdateVisible:int;
      
      public function UpdaterConfiguration()
      {
         super();
         this._delay = -1;
         this._isCheckForUpdateVisible = -1;
         this._isDownloadUpdateVisible = -1;
         this._isDownloadProgressVisible = -1;
         this._isInstallUpdateVisible = -1;
         this._isFileUpdateVisible = -1;
         this._isUnexpectedErrorVisible = -1;
         this._isNewerVersionFunction = VersionUtils.isNewerVersion;
      }
      
      public function get delay() : Number
      {
         if(this._delay < 0)
         {
            if(Boolean(this.configurationDescriptor) && this.configurationDescriptor.checkInterval >= 0)
            {
               return this.configurationDescriptor.checkInterval;
            }
            return 0;
         }
         return this._delay;
      }
      
      public function set delay(value:Number) : void
      {
         this._delay = value;
      }
      
      public function get delayAsMilliseconds() : Number
      {
         return this.delay * Constants.DAY_IN_MILLISECONDS;
      }
      
      public function set updateURL(value:String) : void
      {
         this._updateURL = value;
      }
      
      public function get isNewerVersionFunction() : Function
      {
         return this._isNewerVersionFunction;
      }
      
      public function set isUnexpectedErrorVisible(value:Boolean) : void
      {
         this._isUnexpectedErrorVisible = value ? 1 : 0;
      }
      
      public function get configurationFile() : File
      {
         return this._configurationFile;
      }
      
      public function set isFileUpdateVisible(value:Boolean) : void
      {
         this._isFileUpdateVisible = value ? 1 : 0;
      }
      
      public function get isCheckForUpdateVisible() : Boolean
      {
         if(this._isCheckForUpdateVisible >= 0)
         {
            return this._isCheckForUpdateVisible == 1;
         }
         var config:int = this.dialogVisibilityInConfiguration(ConfigurationDescriptor.DIALOG_CHECK_FOR_UPDATE);
         if(config >= 0)
         {
            return config == 1;
         }
         return true;
      }
      
      public function get isDownloadUpdateVisible() : Boolean
      {
         if(this._isDownloadUpdateVisible >= 0)
         {
            return this._isDownloadUpdateVisible == 1;
         }
         var config:int = this.dialogVisibilityInConfiguration(ConfigurationDescriptor.DIALOG_DOWNLOAD_UPDATE);
         if(config >= 0)
         {
            return config == 1;
         }
         return true;
      }
      
      public function set isNewerVersionFunction(value:Function) : void
      {
         this._isNewerVersionFunction = value;
      }
      
      public function get isFileUpdateVisible() : Boolean
      {
         if(this._isFileUpdateVisible >= 0)
         {
            return this._isFileUpdateVisible == 1;
         }
         var config:int = this.dialogVisibilityInConfiguration(ConfigurationDescriptor.DIALOG_FILE_UPDATE);
         if(config >= 0)
         {
            return config == 1;
         }
         return true;
      }
      
      public function set isInstallUpdateVisible(value:Boolean) : void
      {
         this._isInstallUpdateVisible = value ? 1 : 0;
      }
      
      public function set isDownloadProgressVisible(value:Boolean) : void
      {
         this._isDownloadProgressVisible = value ? 1 : 0;
      }
      
      public function get isDownloadProgressVisible() : Boolean
      {
         if(this._isDownloadProgressVisible >= 0)
         {
            return this._isDownloadProgressVisible == 1;
         }
         var config:int = this.dialogVisibilityInConfiguration(ConfigurationDescriptor.DIALOG_DOWNLOAD_PROGRESS);
         if(config >= 0)
         {
            return config == 1;
         }
         return true;
      }
      
      public function validate() : void
      {
         var xml:XML = null;
         if(Boolean(this.configurationFile))
         {
            if(!this.configurationFile.exists)
            {
               throw new Error("Configuration file \"" + this.configurationFile.nativePath + "\" does not exists on disk",Constants.ERROR_CONFIGURATION_FILE_MISSING);
            }
            xml = FileUtils.readXMLFromFile(this.configurationFile);
            this.configurationDescriptor = new ConfigurationDescriptor(xml);
            this.configurationDescriptor.validate();
         }
         if(!this._updateURL && !this.configurationDescriptor)
         {
            throw new Error("Update URL not set",Constants.ERROR_UPDATE_URL_MISSING);
         }
      }
      
      public function set configurationFile(value:File) : void
      {
         this._configurationFile = value;
      }
      
      public function get updateURL() : String
      {
         return Boolean(this._updateURL) ? this._updateURL : this.configurationDescriptor.url;
      }
      
      public function get isUnexpectedErrorVisible() : Boolean
      {
         if(this._isUnexpectedErrorVisible >= 0)
         {
            return this._isUnexpectedErrorVisible == 1;
         }
         var config:int = this.dialogVisibilityInConfiguration(ConfigurationDescriptor.DIALOG_UNEXPECTED_ERROR);
         if(config >= 0)
         {
            return config == 1;
         }
         return true;
      }
      
      public function set isDownloadUpdateVisible(value:Boolean) : void
      {
         this._isDownloadUpdateVisible = value ? 1 : 0;
      }
      
      public function get isInstallUpdateVisible() : Boolean
      {
         if(this._isInstallUpdateVisible >= 0)
         {
            return this._isInstallUpdateVisible == 1;
         }
         var config:int = this.dialogVisibilityInConfiguration(ConfigurationDescriptor.DIALOG_INSTALL_UPDATE);
         if(config >= 0)
         {
            return config == 1;
         }
         return true;
      }
      
      public function set isCheckForUpdateVisible(value:Boolean) : void
      {
         this._isCheckForUpdateVisible = value ? 1 : 0;
      }
      
      private function dialogVisibilityInConfiguration(name:String) : int
      {
         var dlg:Object = null;
         if(!this.configurationDescriptor)
         {
            return -1;
         }
         var dialogs:Array = this.configurationDescriptor.defaultUI;
         for(var i:int = 0; i < dialogs.length; i++)
         {
            dlg = dialogs[i];
            if(name.toLowerCase() == dlg.name.toLowerCase())
            {
               return Boolean(dlg.visible) ? 1 : 0;
            }
         }
         return -1;
      }
   }
}

