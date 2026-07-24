package soulex.controller
{
   import flash.errors.IOError;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import mx.events.FlexEvent;
   import soul.view.console.Console;
   import soulex.GameConfig;
   import soulex.event.ContentEvent;
   import soulex.view.UpdateScreen;
   
   public class GameContent extends EventDispatcher
   {
      
      private static const FILE_LIST:String = "file.list";
      
      private static const DATA_STORAGE:String = "data";
      
      private static const PATCH_OK:String = "ok";
      
      private var loader:URLLoader;
      
      private var version:String;
      
      private var dataStorage:File;
      
      private var versionStorage:File;
      
      private var patchOk:File;
      
      private var newFileList:String;
      
      private var multiLoader:MultiLoader;
      
      private var updatesToLoad:Array;
      
      private var currentVersion:String;
      
      private var currentUpdate:String;
      
      private var removeList:Array;
      
      private var remoteFileMap:Object;
      
      private var localFileMap:Object;
      
      private var unpacker:Unpacker;
      
      private var view:UpdateScreen;
      
      public function GameContent(version:String)
      {
         super();
         this.version = version;
         this.dataStorage = File.applicationStorageDirectory.resolvePath(DATA_STORAGE);
      }
      
      public function update(view:UpdateScreen) : void
      {
         this.view = view;
         view.addEventListener(FlexEvent.CREATION_COMPLETE,this.created);
      }
      
      private function created(e:FlexEvent) : void
      {
         this.versionStorage = this.dataStorage.resolvePath(this.version);
         this.patchOk = this.versionStorage.resolvePath(PATCH_OK);
         if(!this.patchOk.exists)
         {
            this.updateVersion();
            return;
         }
         this.loader = new URLLoader();
         this.loader.dataFormat = URLLoaderDataFormat.BINARY;
         this.loader.addEventListener(Event.COMPLETE,this.fileListLoaded);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.fileListError);
         this.loader.addEventListener(ProgressEvent.PROGRESS,this.fileListProgress);
         this.loader.load(new URLRequest(GameConfig.staticServer + "/" + this.version + "/" + FILE_LIST));
         this.view.action = "updates";
      }
      
      private function fileListProgress(e:Event) : void
      {
      }
      
      private function fileListError(e:Event) : void
      {
         this.triggerUpdateError("Error getting file.list");
      }
      
      private function fileListLoaded(e:Event) : void
      {
         var newFileList:Array;
         var newFiles:Vector.<FileListEntry>;
         var string:String = null;
         var file:File = null;
         var stream:FileStream = null;
         var currentFileList:Array = null;
         var currentFiles:Vector.<FileListEntry> = null;
         var fle:FileListEntry = null;
         var fle2:FileListEntry = null;
         var found:Boolean = false;
         var filesRemoved:Boolean = false;
         var filesToDownload:Vector.<MultiLoaderEntry> = null;
         var loader:NamedURLLoader = null;
         var loader_:URLLoader = e.target as URLLoader;
         this.newFileList = String(loader_.data);
         newFileList = this.newFileList.replace("\r","").split("\n");
         newFiles = new Vector.<FileListEntry>();
         for each(string in newFileList)
         {
            newFiles.push(new FileListEntry(string));
         }
         file = this.versionStorage.resolvePath(FILE_LIST);
         stream = new FileStream();
         stream.open(file,FileMode.READ);
         currentFileList = stream.readUTFBytes(stream.bytesAvailable).replace("\r","").split("\n");
         stream.close();
         currentFiles = new Vector.<FileListEntry>();
         for each(string in currentFileList)
         {
            currentFiles.push(new FileListEntry(string));
         }
         filesRemoved = false;
         for each(fle in currentFiles)
         {
            found = false;
            for each(fle2 in newFiles)
            {
               if(fle.name == fle2.name)
               {
                  found = true;
                  break;
               }
            }
            if(!found)
            {
               filesRemoved = true;
               file = this.versionStorage.resolvePath(fle.name);
               try
               {
                  file.deleteFile();
               }
               catch(e:Error)
               {
                  triggerUpdateError("Error removing outdates files");
                  return;
               }
            }
         }
         filesToDownload = new Vector.<MultiLoaderEntry>();
         for each(fle in newFiles)
         {
            found = false;
            for each(fle2 in currentFiles)
            {
               if(fle.name == fle2.name)
               {
                  found = fle.sum == fle2.sum;
                  break;
               }
            }
            if(!found)
            {
               filesToDownload.push(new MultiLoaderEntry(GameConfig.staticServer + "/" + this.version + "/" + fle.name,fle.name));
            }
         }
         if(filesToDownload.length > 0)
         {
            if(Boolean(this.multiLoader))
            {
               this.multiLoader.close();
            }
            this.multiLoader = new MultiLoader();
            this.multiLoader.addEventListener(MultiLoaderEvent.ENTRY_LOADED,this.fileLoaded);
            this.multiLoader.addEventListener(Event.COMPLETE,this.allFilesLoaded);
            this.multiLoader.load(filesToDownload);
         }
         else if(filesRemoved)
         {
            this.saveNewFileList();
         }
         else
         {
            this.triggerDataOk();
         }
      }
      
      private function fileError(e:Event) : void
      {
         this.multiLoader.close();
         this.triggerUpdateError("Error loading update file: " + NamedURLLoader(e.target).name);
      }
      
      private function fileLoaded(e:MultiLoaderEvent) : void
      {
         var loader:NamedURLLoader = e.loader;
         trace("fileLoaded()",loader.name,", creating");
         this.view.progress = this.multiLoader.progress;
         var path:Array = loader.name.split("/");
         path.pop();
         var file:File = this.versionStorage.resolvePath(".");
         this.createFolderPath(file,path);
         file = this.versionStorage.resolvePath(loader.name);
         var stream:FileStream = new FileStream();
         stream.open(file,FileMode.WRITE);
         stream.writeBytes(loader.data);
         stream.close();
      }
      
      private function allFilesLoaded(e:Event) : void
      {
         this.saveNewFileList();
      }
      
      private function saveNewFileList() : void
      {
         var file:File = this.versionStorage.resolvePath(FILE_LIST);
         var stream:FileStream = new FileStream();
         stream.open(file,FileMode.WRITE);
         stream.writeUTFBytes(this.newFileList);
         stream.close();
         this.triggerDataOk();
      }
      
      private function createFolderPath(file:File, path:Array) : void
      {
         var dir:String = null;
         for each(dir in path)
         {
            try
            {
               file = file.resolvePath(dir);
               file.createDirectory();
            }
            catch(e:Error)
            {
               multiLoader.close();
               triggerUpdateError("Error creating folder:" + file.url);
               return;
            }
         }
      }
      
      private function updateVersion() : void
      {
         this.loader = new URLLoader();
         this.loader.dataFormat = URLLoaderDataFormat.BINARY;
         this.loader.addEventListener(Event.COMPLETE,this.versionsLoaded);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.versionsError);
         this.loader.addEventListener(ProgressEvent.PROGRESS,this.versionsProgress);
         this.loader.load(new URLRequest(GameConfig.staticServer + "/versions"));
         this.view.action = "versions";
      }
      
      private function versionsProgress(e:Event) : void
      {
         Console.trace("versionsProgress",this.loader.bytesLoaded,this.loader.bytesTotal);
         this.view.progress = this.loader.bytesTotal > 0 ? this.loader.bytesLoaded / this.loader.bytesTotal : 0;
      }
      
      private function versionsError(e:Event) : void
      {
         this.triggerUpdateError("Error getting versions");
      }
      
      private function versionsLoaded(e:Event) : void
      {
         var lastWorkingVersion:String = null;
         var okFile:File = null;
         var versions:Array = String(this.loader.data).replace("\r","").replace(/\n$/g,"").split("\n");
         for(var i:int = versions.length - 1; i > -1; i--)
         {
            okFile = this.dataStorage.resolvePath(versions[i] + File.separator + PATCH_OK);
            if(okFile.exists)
            {
               lastWorkingVersion = versions[i];
               break;
            }
         }
         var upgradeSteps:int = versions.indexOf(this.version) - versions.indexOf(lastWorkingVersion);
         var update:Boolean = Boolean(lastWorkingVersion) && upgradeSteps < 2 && upgradeSteps > 0;
         if(update)
         {
            this.updatesToLoad = versions.slice(versions.indexOf(lastWorkingVersion) + 1,versions.indexOf(this.version) + 1);
            this.currentVersion = lastWorkingVersion;
            this.loadUpdates();
         }
         else
         {
            this.loadPackage();
         }
      }
      
      private function loadUpdates() : void
      {
         Console.trace("loadUpdates()");
         if(this.updatesToLoad.length < 1)
         {
            this.triggerDataOk();
            return;
         }
         this.currentUpdate = this.updatesToLoad.shift();
         Console.trace("loading update ",this.currentUpdate);
         this.loader = new URLLoader();
         this.loader.dataFormat = URLLoaderDataFormat.BINARY;
         this.loader.addEventListener(Event.COMPLETE,this.diffLoaded);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.diffError);
         this.loader.addEventListener(ProgressEvent.PROGRESS,this.diffProgress);
         this.loader.load(new URLRequest(GameConfig.staticServer + "/" + this.currentUpdate + ".diff"));
      }
      
      private function diffProgress(e:Event) : void
      {
         Console.trace("diffProgress",this.loader.bytesLoaded,this.loader.bytesTotal);
         this.view.progress = this.loader.bytesTotal > 0 ? this.loader.bytesLoaded / this.loader.bytesTotal : 0;
      }
      
      private function diffError(e:Event) : void
      {
         this.triggerUpdateError("Error loading update for version: " + this.currentUpdate);
      }
      
      private function diffLoaded(e:Event) : void
      {
         var diff:String = String(this.loader.data);
         this.removeList = diff.match(/(?<=^- )[^\n]+/gm);
         this.loader = new URLLoader();
         this.loader.dataFormat = URLLoaderDataFormat.BINARY;
         this.loader.addEventListener(Event.COMPLETE,this.versionLoaded);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.versionError);
         this.loader.addEventListener(ProgressEvent.PROGRESS,this.versionProgress);
         this.loader.load(new URLRequest(GameConfig.staticServer + "/" + this.currentUpdate + ".diff.zip"));
      }
      
      private function versionProgress(e:Event) : void
      {
         Console.trace("versionProgress",this.loader.bytesLoaded,this.loader.bytesTotal);
      }
      
      private function versionError(e:Event) : void
      {
         this.triggerUpdateError("Error loading update: " + this.currentUpdate);
      }
      
      private function versionLoaded(e:Event) : void
      {
         Console.trace("versionLoaded");
         this.view.action = "Unpacking content";
         this.unpacker = new Unpacker();
         this.unpacker.addEventListener(ProgressEvent.PROGRESS,this.unpackProgress);
         this.unpacker.addEventListener(Event.COMPLETE,this.versionUnpacked);
         this.unpacker.unpack(this.loader.data,this.dataStorage.resolvePath(this.currentUpdate + ".tmp"));
      }
      
      private function unpackProgress(e:Event) : void
      {
         this.view.progress = this.unpacker.progress;
      }
      
      private function versionUnpacked(e:Event) : void
      {
         var file:File = null;
         var filename:String = null;
         var stream:FileStream = null;
         var moveFolder:Function = function(src:File, dst:File):void
         {
            var file:File = null;
            var dstFile:File = null;
            if(!dst.exists)
            {
               src.moveTo(dst);
               return;
            }
            var list:Array = src.getDirectoryListing();
            for each(file in list)
            {
               dstFile = dst.resolvePath(file.name);
               if(file.isDirectory)
               {
                  moveFolder(file,dstFile);
               }
               else
               {
                  file.moveTo(dstFile,true);
               }
            }
            src.deleteDirectory();
         };
         Console.trace("versionUnpacked");
         for each(filename in this.removeList)
         {
            file = this.dataStorage.resolvePath(this.currentVersion + File.separator + filename);
            if(file.exists)
            {
               if(file.isDirectory)
               {
                  file.deleteDirectory(true);
               }
               else
               {
                  file.deleteFile();
               }
            }
         }
         file = this.dataStorage.resolvePath(this.currentVersion + File.separator + PATCH_OK);
         file.deleteFile();
         file = this.dataStorage.resolvePath(this.currentVersion);
         file.moveTo(this.dataStorage.resolvePath(this.currentUpdate),true);
         file = this.dataStorage.resolvePath(this.currentUpdate + ".tmp");
         this.versionStorage = this.dataStorage.resolvePath(this.currentUpdate);
         moveFolder(file,this.versionStorage);
         this.patchOk = this.versionStorage.resolvePath(PATCH_OK);
         stream = new FileStream();
         stream.open(this.patchOk,FileMode.WRITE);
         stream.close();
         this.loadUpdates();
      }
      
      private function loadPackage() : void
      {
         this.view.action = "Loading game content";
         this.loader = new URLLoader();
         this.loader.dataFormat = URLLoaderDataFormat.BINARY;
         this.loader.addEventListener(Event.COMPLETE,this.packageLoaded);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.packageError);
         this.loader.addEventListener(ProgressEvent.PROGRESS,this.packageProgress);
         Console.trace("Loading package: " + GameConfig.staticServer + "/" + this.version + ".zip");
         this.loader.load(new URLRequest(GameConfig.staticServer + "/" + this.version + ".zip"));
      }
      
      private function packageError(e:Event) : void
      {
         this.triggerUpdateError("Error loading game update");
      }
      
      private function packageProgress(e:Event) : void
      {
         this.view.progress = this.loader.bytesLoaded / this.loader.bytesTotal;
      }
      
      private function packageLoaded(e:Event) : void
      {
         Console.trace("packageLoaded");
         if(!this.versionStorage.exists)
         {
            try
            {
               this.versionStorage.createDirectory();
            }
            catch(e:IOError)
            {
               triggerUpdateError("error accessing/creating files");
               return;
            }
            catch(e:SecurityError)
            {
               triggerUpdateError("not enough permissions to access/create files");
               return;
            }
         }
         this.view.action = "Unpacking content";
         this.unpacker = new Unpacker();
         this.unpacker.addEventListener(ProgressEvent.PROGRESS,this.unpackProgress);
         this.unpacker.addEventListener(Event.COMPLETE,this.unpackedPackage);
         this.unpacker.unpack(this.loader.data,this.versionStorage);
      }
      
      private function unpackedPackage(e:Event) : void
      {
         Console.trace("unpackedPackage");
         this.patchOk = this.versionStorage.resolvePath(PATCH_OK);
         var stream:FileStream = new FileStream();
         stream.open(this.patchOk,FileMode.WRITE);
         stream.close();
         this.triggerDataOk();
      }
      
      private function triggerUpdateError(details:String = null) : void
      {
         Console.trace(details);
         var ne:ContentEvent = new ContentEvent(ContentEvent.UPDATE_ERROR);
         ne.details = details;
         dispatchEvent(ne);
      }
      
      private function triggerDataOk() : void
      {
         var ne:ContentEvent = new ContentEvent(ContentEvent.DATA_OK);
         ne.details = this.versionStorage.url;
         dispatchEvent(ne);
      }
      
      public function getStaticPath() : String
      {
         return this.versionStorage.url + File.separator;
      }
   }
}

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.ByteArray;
import flash.utils.getTimer;
import flash.utils.setTimeout;
import soul.view.console.Console;
import vega.util.zip.ZipEntry;
import vega.util.zip.ZipFile;

class Unpacker extends EventDispatcher
{
   
   private static const maxTime:uint = 1000;
   
   private var zipFile:ZipFile;
   
   private var storage:File;
   
   private var currentEntry:uint;
   
   private var unpackStart:int;
   
   public var progress:Number = 0;
   
   public function Unpacker()
   {
      super();
   }
   
   public function unpack(zip:ByteArray, storage:File) : void
   {
      this.zipFile = new ZipFile(zip);
      this.storage = storage;
      this.unpackStart = getTimer();
      this.chunk();
   }
   
   private function chunk() : void
   {
      var file:File = null;
      var stream:FileStream = null;
      var ba:ByteArray = null;
      var entry:ZipEntry = null;
      var start:int = getTimer();
      var total:uint = uint(this.zipFile.entries.length);
      for(var i:int = int(this.currentEntry); i < total; i++)
      {
         entry = this.zipFile.entries[i];
         if(hasEventListener(ProgressEvent.PROGRESS))
         {
            this.progress = i / total;
            dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS));
         }
         file = this.storage.resolvePath(entry.name);
         if(entry.isDirectory())
         {
            file.createDirectory();
         }
         else
         {
            stream = new FileStream();
            stream.open(file,FileMode.WRITE);
            ba = this.zipFile.getInput(entry);
            stream.writeBytes(ba);
            stream.close();
         }
         if(getTimer() - start >= maxTime)
         {
            this.currentEntry = i + 1;
            setTimeout(this.chunk,40);
            return;
         }
      }
      Console.trace("Unpacking taken:",getTimer() - this.unpackStart);
      dispatchEvent(new Event(Event.COMPLETE));
   }
}

class FileListEntry
{
   
   public var sum:String;
   
   public var name:String;
   
   public function FileListEntry(string:String)
   {
      super();
      this.sum = string.substring(0,32);
      this.name = string.substring(36);
   }
   
   public function toString() : String
   {
      return this.sum + ":" + this.name;
   }
}

class NamedURLLoader extends URLLoader
{
   
   public var name:String;
   
   public function NamedURLLoader()
   {
      super();
   }
}

class MultiLoader extends EventDispatcher
{
   
   private static const MAX_LOADERS:uint = 3;
   
   private const loaders:Vector.<NamedURLLoader> = new Vector.<NamedURLLoader>();
   
   private var toLoad:Vector.<MultiLoaderEntry> = new Vector.<MultiLoaderEntry>();
   
   private var loaded:uint = 0;
   
   public function MultiLoader()
   {
      super();
   }
   
   public function load(value:Vector.<MultiLoaderEntry>) : void
   {
      var entry:MultiLoaderEntry = null;
      var entry2:MultiLoaderEntry = null;
      var found:Boolean = false;
      var arr:Vector.<MultiLoaderEntry> = new Vector.<MultiLoaderEntry>();
      for each(entry in value)
      {
         found = false;
         for each(entry2 in this.toLoad)
         {
            if(entry2.equals(entry))
            {
               found = true;
               break;
            }
         }
         if(!found)
         {
            arr.push(entry);
         }
      }
      while(arr.length > 0 && this.loaders.length < MAX_LOADERS)
      {
         entry = arr.shift();
         this.add(entry);
      }
      if(arr.length > 0)
      {
         this.toLoad = this.toLoad.concat(arr);
      }
   }
   
   private function onFileError(e:IOErrorEvent) : void
   {
      var loader:NamedURLLoader = e.target as NamedURLLoader;
      this.loaders.splice(this.loaders.indexOf(loader),1);
      ++this.loaded;
      var ne:MultiLoaderEvent = new MultiLoaderEvent(MultiLoaderEvent.ENTRY_FAILED);
      ne.loader = loader;
      dispatchEvent(ne);
      this.checkComplete();
   }
   
   private function onFileComplete(e:Event) : void
   {
      var loader:NamedURLLoader = e.target as NamedURLLoader;
      this.loaders.splice(this.loaders.indexOf(loader),1);
      ++this.loaded;
      var ne:MultiLoaderEvent = new MultiLoaderEvent(MultiLoaderEvent.ENTRY_LOADED);
      ne.loader = loader;
      dispatchEvent(ne);
      this.checkComplete();
   }
   
   private function checkComplete() : void
   {
      if(this.toLoad.length > 0)
      {
         this.add(this.toLoad.shift());
      }
      else if(this.loaders.length < 1)
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
   
   public function add(file:Object) : void
   {
      var loader:NamedURLLoader = null;
      var entry:MultiLoaderEntry = file is MultiLoaderEntry ? file as MultiLoaderEntry : new MultiLoaderEntry(file as String);
      trace("MultiLoader.add()",file);
      if(this.loaders.length < MAX_LOADERS)
      {
         loader = new NamedURLLoader();
         loader.name = entry.name;
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         loader.addEventListener(IOErrorEvent.IO_ERROR,this.onFileError);
         loader.addEventListener(Event.COMPLETE,this.onFileComplete);
         this.loaders.push(loader);
         loader.load(new URLRequest(entry.url));
      }
      else
      {
         this.toLoad.push(entry);
      }
   }
   
   public function close() : void
   {
      var loader:NamedURLLoader = null;
      for each(loader in this.loaders)
      {
         loader.close();
      }
      this.loaders.length = 0;
      this.loaded = 0;
   }
   
   public function get progress() : Number
   {
      var total:uint = this.loaders.length + this.toLoad.length + this.loaded;
      return this.loaded / total;
   }
}

class MultiLoaderEntry
{
   
   public var name:String;
   
   public var url:String;
   
   public function MultiLoaderEntry(url:String, name:String = null)
   {
      super();
      this.name = Boolean(name) ? name : url;
      this.url = url;
   }
   
   public function valueOf() : String
   {
      return this.name;
   }
   
   public function equals(e:MultiLoaderEntry) : Boolean
   {
      return e.name == this.name && e.url == this.url;
   }
}

class MultiLoaderEvent extends Event
{
   
   public static const ENTRY_LOADED:String = "ENTRY_LOADED";
   
   public static const ENTRY_FAILED:String = "ENTRY_FAILED";
   
   public var loader:NamedURLLoader;
   
   public function MultiLoaderEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
   {
      super(type,bubbles,cancelable);
   }
}
