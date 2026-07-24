package air.update.core
{
   import air.update.states.HSM;
   import air.update.states.HSMEvent;
   import air.update.utils.Constants;
   import flash.events.*;
   import flash.filesystem.*;
   import flash.net.*;
   import flash.utils.*;
   
   [ExcludeClass]
   [Event(name="securityError",type="flash.events.SecurityErrorEvent")]
   [Event(name="httpStatus",type="flash.events.HTTPStatusEvent")]
   [Event(name="ioError",type="flash.events.IOErrorEvent")]
   [Event(name="error",type="flash.events.ErrorEvent")]
   [Event(name="complete",type="flash.events.Event")]
   [Event(name="progress",type="flash.events.ProgressEvent")]
   public class UCFUnpackager extends HSM
   {
      
      protected static const AT_START:uint = 0;
      
      protected static const AT_HEADER:uint = 1;
      
      protected static const AT_FILENAME:uint = 2;
      
      protected static const AT_EXTRA_FIELD:uint = 3;
      
      protected static const AT_DATA:uint = 4;
      
      protected static const AT_END:uint = 5;
      
      protected static const AT_ERROR:uint = 6;
      
      protected static const AT_COMPLETE:uint = 12;
      
      protected static const AT_ABORTED:uint = 13;
      
      protected static const AT_CDHEADER:uint = 7;
      
      protected static const AT_CDHEADERMAGIC:uint = 8;
      
      protected static const AT_CDFILENAME:uint = 9;
      
      protected static const AT_CDEXTRA_FIELD:uint = 10;
      
      protected static const AT_CDCOMMENT:uint = 11;
      
      private var m_validator:Object = new Object();
      
      private var m_ucfParseState:uint = 0;
      
      private var _data:ByteArray;
      
      private var _path:String;
      
      private var _fileCommentLength:uint;
      
      private var m_isComplete:Boolean = false;
      
      private var source:URLStream;
      
      private var m_fileCount:uint = 0;
      
      private var _currentLFH:ByteArray;
      
      private var _extraFieldLength:uint;
      
      private var identifier:String;
      
      private var _fileRelativeOffset:uint;
      
      private var m_dir:File;
      
      private var _root:Object = new Object();
      
      private var _compressedSize:uint;
      
      private var _generalPurposeBitFlags:uint;
      
      private var _uncompressedSize:uint;
      
      private var isDirectory:Boolean;
      
      private var _compressionMethod:uint;
      
      private var _filenameLength:uint;
      
      private var m_enableSignatureValidation:Boolean = false;
      
      public function UCFUnpackager()
      {
         super(this.initialized);
      }
      
      protected function onDone() : void
      {
      }
      
      public function get isComplete() : Boolean
      {
         return this.m_isComplete;
      }
      
      private function unpackaging(event:Event) : void
      {
         switch(event.type)
         {
            case HSMEvent.ENTER:
               this.source = new URLStream();
               this.source.endian = Endian.LITTLE_ENDIAN;
               this.source.addEventListener(ProgressEvent.PROGRESS,dispatch);
               this.source.addEventListener(HTTPStatusEvent.HTTP_STATUS,dispatch);
               this.source.addEventListener(IOErrorEvent.IO_ERROR,dispatch);
               this.source.addEventListener(SecurityErrorEvent.SECURITY_ERROR,dispatch);
               this.source.addEventListener(Event.COMPLETE,dispatch);
               this.source.load(new URLRequest(this.identifier));
               break;
            case ProgressEvent.PROGRESS:
               this.onData(event as ProgressEvent);
               break;
            case HTTPStatusEvent.HTTP_STATUS:
               dispatchEvent(event.clone());
               break;
            case IOErrorEvent.IO_ERROR:
            case SecurityErrorEvent.SECURITY_ERROR:
               this.m_ucfParseState = AT_ERROR;
               dispatchEvent(event.clone());
               break;
            case Event.COMPLETE:
               this.onComplete(event);
         }
      }
      
      public function set enableSignatureValidation(enable:Boolean) : void
      {
         this.m_enableSignatureValidation = enable;
      }
      
      private function errored(event:Event) : void
      {
      }
      
      private function onData(event:ProgressEvent) : void
      {
         var HEADER_SIZE_BYTES:uint = 0;
         var ZIP_LFH_MAGIC:uint = 0;
         var CDHEADER_SIZE_BYTES:uint = 0;
         var ZIP_CDH_MAGIC:uint = 0;
         var ZIP_CDSIG_MAGIC:uint = 0;
         var magic:uint = 0;
         var filename:ByteArray = null;
         var versionNeededToExtract:uint = 0;
         var lastModTime:uint = 0;
         var lastModDate:uint = 0;
         var crc32:uint = 0;
         var DATA_DESCRIPTOR_FLAG:uint = 0;
         var COMPRESSION_NONE:uint = 0;
         var COMPRESSION_DEFLATE:uint = 0;
         var elements:Array = null;
         var numParentDirs:int = 0;
         var parent:Object = null;
         var currentPath:Array = null;
         var sizeToRead:uint = 0;
         var i:uint = 0;
         var element:String = null;
         var shouldContinue:Boolean = false;
         var fs:FileStream = null;
         dispatchEvent(event.clone());
         try
         {
            HEADER_SIZE_BYTES = 30;
            ZIP_LFH_MAGIC = 67324752;
            CDHEADER_SIZE_BYTES = 46;
            ZIP_CDH_MAGIC = 33639248;
            ZIP_CDSIG_MAGIC = 101010256;
            while(true)
            {
               switch(this.m_ucfParseState)
               {
                  case AT_START:
                  case AT_HEADER:
                     if(this.source.bytesAvailable < HEADER_SIZE_BYTES)
                     {
                        return;
                     }
                     this._currentLFH = new ByteArray();
                     this._currentLFH.endian = Endian.LITTLE_ENDIAN;
                     this.source.readBytes(this._currentLFH,0,4);
                     magic = this._currentLFH.readUnsignedInt();
                     if(ZIP_LFH_MAGIC != magic)
                     {
                        if(this.m_ucfParseState == AT_START)
                        {
                           throw new Error("not an AIR file",Constants.ERROR_UCF_INVALID_AIR_FILE);
                        }
                        if(ZIP_CDH_MAGIC != magic)
                        {
                           this.m_ucfParseState = AT_END;
                           return;
                        }
                        this.m_ucfParseState = AT_CDHEADERMAGIC;
                        continue;
                     }
                     this.source.readBytes(this._currentLFH,this._currentLFH.length,HEADER_SIZE_BYTES - 4);
                     versionNeededToExtract = this._currentLFH.readUnsignedShort();
                     this._generalPurposeBitFlags = this._currentLFH.readUnsignedShort();
                     if((this._generalPurposeBitFlags & 0xFFF9) != 0)
                     {
                        throw new Error("file uses unsupported encryption or streaming features",Constants.ERROR_UCF_INVALID_FLAGS);
                     }
                     this._compressionMethod = this._currentLFH.readUnsignedShort();
                     lastModTime = this._currentLFH.readUnsignedShort();
                     lastModDate = this._currentLFH.readUnsignedShort();
                     crc32 = this._currentLFH.readUnsignedInt();
                     this._compressedSize = this._currentLFH.readUnsignedInt();
                     this._uncompressedSize = this._currentLFH.readUnsignedInt();
                     this._filenameLength = this._currentLFH.readUnsignedShort();
                     this._extraFieldLength = this._currentLFH.readUnsignedShort();
                     if(this._filenameLength == 0)
                     {
                        throw new Error("one of the files has an empty (zero-length) name",Constants.ERROR_UCF_INVALID_FILENAME);
                     }
                     this.m_ucfParseState = AT_FILENAME;
                  case AT_FILENAME:
                     if(this.source.bytesAvailable < this._filenameLength)
                     {
                        return;
                     }
                     this.source.readBytes(this._currentLFH,this._currentLFH.length,this._filenameLength);
                     filename = new ByteArray();
                     this._currentLFH.readBytes(filename,0,this._filenameLength);
                     this._path = filename.toString();
                     if(this.m_fileCount == 0 && this._path != "mimetype")
                     {
                        throw new Error("mimetype must be the first file",Constants.ERROR_UCF_NO_MIMETYPE);
                     }
                     DATA_DESCRIPTOR_FLAG = 128;
                     if(Boolean(this._generalPurposeBitFlags & DATA_DESCRIPTOR_FLAG))
                     {
                        throw new Error("file " + this._path + " uses a data descriptor field",Constants.ERROR_UCF_INVALID_FLAGS);
                     }
                     COMPRESSION_NONE = 0;
                     COMPRESSION_DEFLATE = 8;
                     if(this._compressionMethod != COMPRESSION_DEFLATE && this._compressionMethod != COMPRESSION_NONE)
                     {
                        throw new Error("file " + this._path + " uses an illegal compression method " + this._compressionMethod,Constants.ERROR_UCF_UNKNOWN_COMPRESSION);
                     }
                     this.isDirectory = this._path.charAt(this._path.length - 1) == "/";
                     if(this.isDirectory)
                     {
                        this._path = this._path.slice(0,this._path.length - 1);
                     }
                     elements = this._path.split("/");
                     if(elements.length == 0)
                     {
                        throw new Error("it contains a file with an empty name",Constants.ERROR_UCF_INVALID_FILENAME);
                     }
                     elements.filter(function(item:*, index:int, array:Array):Boolean
                     {
                        if(item == ".")
                        {
                           throw new Error("filename " + _path + " contains a component of \'.\'",Constants.ERROR_UCF_INVALID_FILENAME);
                        }
                        if(item == "..")
                        {
                           throw new Error("filename " + _path + " contains a component of \'..\'",Constants.ERROR_UCF_INVALID_FILENAME);
                        }
                        if(item == "")
                        {
                           throw new Error("filename " + _path + " contains an empty component",Constants.ERROR_UCF_INVALID_FILENAME);
                        }
                        return true;
                     });
                     numParentDirs = this.isDirectory ? int(elements.length) : int(elements.length - 1);
                     parent = this._root;
                     currentPath = new Array();
                     for(i = 0; i < numParentDirs; i++)
                     {
                        element = elements[i];
                        currentPath.push(element);
                        if(parent[element] == null)
                        {
                           parent[element] = new Object();
                           this.onDirectory(currentPath.join("/"));
                        }
                        parent = parent[element];
                     }
                     this.m_ucfParseState = AT_EXTRA_FIELD;
                  case AT_EXTRA_FIELD:
                     if(this.source.bytesAvailable < this._extraFieldLength)
                     {
                        return;
                     }
                     if(this._extraFieldLength > 0)
                     {
                        this.source.readBytes(this._currentLFH,this._currentLFH.length,this._extraFieldLength);
                     }
                     this.m_ucfParseState = AT_DATA;
                  case AT_DATA:
                     sizeToRead = this._compressionMethod == 8 ? this._compressedSize : this._uncompressedSize;
                     if(this.source.bytesAvailable < sizeToRead)
                     {
                        return;
                     }
                     if(this.isDirectory)
                     {
                        if(this._uncompressedSize != 0)
                        {
                           throw new Error("directory entry " + this._path + " has associated data",Constants.ERROR_UCF_INVALID_FILENAME);
                        }
                        if(Boolean(this.m_dir))
                        {
                           this.m_dir.resolvePath(this._path).createDirectory();
                        }
                     }
                     else
                     {
                        this._data = new ByteArray();
                        if(sizeToRead > 0)
                        {
                           this.source.readBytes(this._data,0,sizeToRead);
                           if(this._compressionMethod == 8)
                           {
                              this._data.uncompress(CompressionAlgorithm.DEFLATE);
                           }
                        }
                        if(Boolean(this.m_dir))
                        {
                           this._data.position = 0;
                           fs = new FileStream();
                           fs.open(this.m_dir.resolvePath(this._path),FileMode.WRITE);
                           fs.writeBytes(this._data);
                           fs.close();
                        }
                        if(this.m_enableSignatureValidation)
                        {
                           if(this._path == "META-INF/signatures.xml")
                           {
                              this.m_validator.signatures = this._data;
                           }
                           else
                           {
                              this.m_validator.addFile(this._path,this._data);
                           }
                        }
                        shouldContinue = this.onFile(this.m_fileCount,this._path,this._data);
                        if(!shouldContinue)
                        {
                           this.m_ucfParseState = AT_ABORTED;
                           continue;
                        }
                     }
                     ++this.m_fileCount;
                     this.m_ucfParseState = AT_HEADER;
                     break;
                  case AT_CDHEADER:
                     if(this.source.bytesAvailable < 4)
                     {
                        return;
                     }
                     this._currentLFH = new ByteArray();
                     this._currentLFH.endian = Endian.LITTLE_ENDIAN;
                     this.source.readBytes(this._currentLFH,0,4);
                     magic = this._currentLFH.readUnsignedInt();
                     if(ZIP_CDH_MAGIC != magic)
                     {
                        this.m_ucfParseState = AT_END;
                        return;
                     }
                     this.m_ucfParseState = AT_CDHEADERMAGIC;
                  case AT_CDHEADERMAGIC:
                     if(this.source.bytesAvailable < CDHEADER_SIZE_BYTES - 4)
                     {
                        return;
                     }
                     this.source.readBytes(this._currentLFH,this._currentLFH.length,CDHEADER_SIZE_BYTES - 4);
                     this._currentLFH.position += 24;
                     this._filenameLength = this._currentLFH.readUnsignedShort();
                     this._extraFieldLength = this._currentLFH.readUnsignedShort();
                     this._fileCommentLength = this._currentLFH.readUnsignedShort();
                     this._currentLFH.position += 8;
                     this._fileRelativeOffset = this._currentLFH.readUnsignedInt();
                     this.m_ucfParseState = AT_CDFILENAME;
                  case AT_CDFILENAME:
                     if(this.source.bytesAvailable < this._filenameLength)
                     {
                        return;
                     }
                     this.source.readBytes(this._currentLFH,this._currentLFH.length,this._filenameLength);
                     filename = new ByteArray();
                     this._currentLFH.readBytes(filename,0,this._filenameLength);
                     this._path = filename.toString();
                     this.m_ucfParseState = AT_CDEXTRA_FIELD;
                  case AT_CDEXTRA_FIELD:
                     if(this.source.bytesAvailable < this._extraFieldLength)
                     {
                        return;
                     }
                     if(this._extraFieldLength > 0)
                     {
                        this.source.readBytes(this._currentLFH,this._currentLFH.length,this._extraFieldLength);
                     }
                     this.m_ucfParseState = AT_CDCOMMENT;
                  case AT_CDCOMMENT:
                     if(this.source.bytesAvailable < this._fileCommentLength)
                     {
                        return;
                     }
                     if(this._fileCommentLength > 0)
                     {
                        this.source.readBytes(this._currentLFH,this._currentLFH.length,this._fileCommentLength);
                     }
                     break;
                  case AT_END:
                     return;
                  case AT_ABORTED:
                     return;
                  case AT_ERROR:
                     return;
               }
               this.m_ucfParseState = AT_CDHEADER;
            }
         }
         catch(e:Error)
         {
            dispatchError(e);
         }
      }
      
      private function dispatchError(error:Error) : void
      {
         this.m_ucfParseState = AT_ERROR;
         dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,error.message,error.errorID));
      }
      
      private function onComplete(event:Event) : void
      {
         try
         {
            switch(this.m_ucfParseState)
            {
               case AT_END:
                  this.onDone();
                  this.m_ucfParseState = AT_COMPLETE;
                  if(this.m_enableSignatureValidation && this.m_validator.packageSignatureStatus != 0)
                  {
                     dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"signature is not valid"));
                     transition(this.errored);
                  }
                  else
                  {
                     transition(this.complete);
                  }
                  break;
               case AT_ABORTED:
                  this.m_isComplete = true;
                  dispatchEvent(new Event(Event.COMPLETE));
                  break;
               case AT_ERROR:
                  break;
               default:
                  throw new Error("truncated or corrupt",Constants.ERROR_UCF_CORRUPT_AIR);
            }
         }
         catch(e:Error)
         {
            dispatchError(e);
         }
      }
      
      private function complete(event:Event) : void
      {
         switch(event.type)
         {
            case HSMEvent.ENTER:
               this.m_isComplete = true;
               dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      protected function onDirectory(path:String) : void
      {
      }
      
      private function initialized(event:Event) : void
      {
      }
      
      protected function get ucfParseState() : uint
      {
         return this.m_ucfParseState;
      }
      
      public function set outputDirectory(dir:File) : void
      {
         this.m_dir = dir;
      }
      
      public function get outputDirectory() : File
      {
         return this.m_dir;
      }
      
      public function unpackageAsync(url:String) : void
      {
         this.identifier = url;
         transitionAsync(this.unpackaging);
      }
      
      public function cancel() : void
      {
         if(Boolean(this.source) && this.source.connected)
         {
            this.source.close();
            this.m_ucfParseState = AT_ABORTED;
         }
      }
      
      protected function onFile(fileNumber:uint, path:String, data:ByteArray) : Boolean
      {
         return true;
      }
   }
}

