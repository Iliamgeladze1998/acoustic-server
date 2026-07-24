package air.update.net
{
   import air.update.events.DownloadErrorEvent;
   import air.update.events.UpdateEvent;
   import air.update.logging.Logger;
   import air.update.utils.Constants;
   import air.update.utils.NetUtils;
   import flash.errors.EOFError;
   import flash.errors.IOError;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.net.URLRequest;
   import flash.net.URLStream;
   import flash.utils.ByteArray;
   
   [ExcludeClass]
   [Event(name="downloadStart",type="air.update.events.UpdateEvent")]
   [Event(name="downloadComplete",type="air.update.events.UpdateEvent")]
   [Event(name="progress",type="flash.events.ProgressEvent")]
   [Event(name="downloadError",type="air.update.events.DownloadErrorEvent")]
   public class FileDownloader extends EventDispatcher
   {
      
      private static var logger:Logger = Logger.getLogger("air.update.net.FileDownloader");
      
      private var downloadedFile:File;
      
      private var urlStream:URLStream;
      
      private var fileURL:URLRequest;
      
      private var isInError:Boolean;
      
      private var fileStream:FileStream;
      
      public function FileDownloader(url:URLRequest, file:File)
      {
         super();
         this.fileURL = url;
         this.fileURL.useCache = false;
         this.downloadedFile = file;
         logger.finer("url: " + url.url + " file: " + file.nativePath);
         this.urlStream = new URLStream();
         this.urlStream.addEventListener(IOErrorEvent.IO_ERROR,this.onDownloadError);
         this.urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onDownloadError);
         this.urlStream.addEventListener(ProgressEvent.PROGRESS,this.onDownloadProgress);
         this.urlStream.addEventListener(Event.OPEN,this.onDownloadOpen);
         this.urlStream.addEventListener(Event.COMPLETE,this.onDownloadComplete);
         this.urlStream.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,this.onDownloadResponseStatus);
      }
      
      private function onDownloadComplete(event:Event) : void
      {
         while(Boolean(this.urlStream) && Boolean(this.urlStream.bytesAvailable))
         {
            this.saveBytes();
         }
         if(Boolean(this.urlStream) && this.urlStream.connected)
         {
            this.urlStream.close();
            this.urlStream = null;
         }
         this.fileStream.close();
         this.fileStream = null;
         if(!this.isInError)
         {
            dispatchEvent(new UpdateEvent(UpdateEvent.DOWNLOAD_COMPLETE));
         }
      }
      
      public function cancel() : void
      {
         try
         {
            if(Boolean(this.urlStream) && this.urlStream.connected)
            {
               this.urlStream.close();
            }
            if(Boolean(this.fileStream))
            {
               this.fileStream.close();
               this.fileStream = null;
            }
            if(Boolean(this.downloadedFile) && Boolean(this.downloadedFile.exists))
            {
               this.downloadedFile.deleteFile();
            }
         }
         catch(e:Error)
         {
            logger.fine("Error during canceling the download: " + e);
         }
      }
      
      public function download() : void
      {
         this.urlStream.load(this.fileURL);
      }
      
      private function onDownloadResponseStatus(event:HTTPStatusEvent) : void
      {
         logger.fine("DownloadStatus: " + event.status);
         if(!NetUtils.isHTTPStatusAcceptable(event.status))
         {
            this.dispatchErrorEvent("Invalid HTTP status code: " + event.status,Constants.ERROR_INVALID_HTTP_STATUS,event.status);
         }
      }
      
      public function inProgress() : Boolean
      {
         return this.urlStream.connected;
      }
      
      private function dispatchErrorEvent(eventText:String, errorID:int = 0, subErrorID:int = 0) : void
      {
         this.isInError = true;
         if(Boolean(this.urlStream) && this.urlStream.connected)
         {
            this.urlStream.close();
            this.urlStream = null;
         }
         dispatchEvent(new DownloadErrorEvent(DownloadErrorEvent.DOWNLOAD_ERROR,false,true,eventText,errorID,subErrorID));
      }
      
      private function saveBytes() : void
      {
         var bytes:ByteArray = null;
         if(!this.fileStream || !this.urlStream || !this.urlStream.connected)
         {
            return;
         }
         try
         {
            bytes = new ByteArray();
            this.urlStream.readBytes(bytes,0,this.urlStream.bytesAvailable);
            this.fileStream.writeBytes(bytes);
         }
         catch(error:EOFError)
         {
            isInError = true;
            logger.fine("EOFError: " + error);
            dispatchErrorEvent(error.message,Constants.ERROR_EOF_DOWNLOAD,error.errorID);
         }
         catch(err:IOError)
         {
            isInError = true;
            logger.fine("IOError: " + err);
            dispatchErrorEvent(err.message,Constants.ERROR_IO_FILE,err.errorID);
         }
      }
      
      private function onDownloadError(event:ErrorEvent) : void
      {
         if(event is IOErrorEvent)
         {
            this.dispatchErrorEvent(event.text,Constants.ERROR_IO_DOWNLOAD,event.errorID);
         }
         else if(event is SecurityErrorEvent)
         {
            this.dispatchErrorEvent(event.text,Constants.ERROR_SECURITY,event.errorID);
         }
      }
      
      private function onDownloadOpen(event:Event) : void
      {
         this.fileStream = new FileStream();
         try
         {
            this.fileStream.open(this.downloadedFile,FileMode.WRITE);
         }
         catch(e:Error)
         {
            logger.fine("Error opening file on disk: " + e);
            isInError = true;
            dispatchErrorEvent(e.message,Constants.ERROR_IO_FILE,e.errorID);
            return;
         }
         dispatchEvent(new UpdateEvent(UpdateEvent.DOWNLOAD_START,false,false));
      }
      
      private function onDownloadProgress(event:ProgressEvent) : void
      {
         if(!this.isInError)
         {
            this.saveBytes();
            dispatchEvent(event);
         }
      }
   }
}

