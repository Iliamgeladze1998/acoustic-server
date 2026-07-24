package soul.net
{
   import flash.events.Event;
   import soul.controller.loading.LoadingManager;
   import soul.view.console.Console;
   
   public class ServerLayerInstance
   {
      
      public static const TIMEOUT:uint = 5000;
      
      private static const ports:Array = [1234,5190,110,443,147,25,80];
      
      private static const portTimeout:uint = TIMEOUT * ports.length;
      
      private var trySockets:Vector.<SenderHandler>;
      
      private var trySuccess:Function;
      
      private var tryFailed:Function;
      
      private var port:uint;
      
      private var handler:SenderHandler;
      
      private var disconnectHandler:Function;
      
      public function ServerLayerInstance(initSuccess:Function, initFail:Function, disconnectHandler:Function)
      {
         var port:uint = 0;
         var socket:SenderHandler = null;
         super();
         Console.trace("Initializing TCP connection on ports: " + ports);
         LoadingManager.action = "Trying to connect server...";
         this.trySuccess = initSuccess;
         this.tryFailed = initFail;
         this.disconnectHandler = disconnectHandler;
         this.trySockets = new Vector.<SenderHandler>();
         for each(port in ports)
         {
            socket = new SenderHandler();
            socket.addEventListener(SenderHandler.CONNECTED,this.onConnect);
            socket.addEventListener(SenderHandler.FAILED,this.onFail);
            this.trySockets.push(socket);
            socket.timeout = portTimeout;
            socket.connect(ServerLayer.host,port);
         }
      }
      
      private function onFail(e:Event) : void
      {
         var socket:SenderHandler = e.currentTarget as SenderHandler;
         Console.trace("Connection failed on",socket.host,socket.port);
         if(Boolean(this.handler))
         {
            Console.trace("Already have working connection, ignoring");
            return;
         }
         var si:int = this.trySockets.indexOf(socket);
         if(si >= 0)
         {
            this.trySockets.splice(si,1);
         }
         if(this.trySockets.length < 1)
         {
            Console.trace("Out of connections. Giving up.");
            LoadingManager.action = "Connection failed...";
            this.trySockets = null;
            this.tryFailed();
         }
      }
      
      private function onConnect(e:Event) : void
      {
         var socket:SenderHandler = e.currentTarget as SenderHandler;
         Console.trace("Successfull connection host \'" + socket.host + "\' on port \'" + socket.port + "\'");
         if(Boolean(this.handler))
         {
            Console.trace("Already have working connection, ignoring");
            return;
         }
         this.handler = socket;
         this.handler.addEventListener(Event.CLOSE,this.onDisconnect);
         this.trySockets = null;
         this.trySuccess();
      }
      
      private function onDisconnect(e:Event) : void
      {
         var socket:SenderHandler = e.currentTarget as SenderHandler;
         Console.trace("Connection broken with host \'" + socket.host + "\' on port \'" + socket.port + "\'");
         this.disconnectHandler();
      }
      
      public function call(service:String, method:String, result:Function = null, fault:Function = null, args:Array = null) : void
      {
         this.handler.call(service,method,result,fault,args);
      }
      
      public function ping(result:Function = null) : void
      {
         this.handler.ping(result);
      }
      
      public function registerCharacter(token:String, result:Function = null, fault:Function = null) : void
      {
         this.handler.registerCharacter(token,result,fault);
      }
      
      public function unregisterCharacter(result:Function = null, fault:Function = null) : void
      {
         this.handler.unregisterCharacter(result,fault);
      }
      
      public function get latency() : uint
      {
         return this.handler.latency;
      }
   }
}

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Socket;
import flash.utils.ByteArray;
import flash.utils.clearInterval;
import flash.utils.clearTimeout;
import flash.utils.getTimer;
import flash.utils.setInterval;
import flash.utils.setTimeout;
import soul.net.io.AuthResponseType;
import soul.net.io.CustomResponder;
import soul.net.io.MessageType;
import soul.net.io.RPCResponseType;
import soul.view.console.Console;

class SenderHandler extends Socket
{
   
   public static const CONNECTED:String = "CONNECTED";
   
   public static const FAILED:String = "FAILED";
   
   private static const TTL:uint = 5000;
   
   private static const MAX_ID:uint = 100000;
   
   public var host:String;
   
   public var port:int;
   
   public var latency:uint = 0;
   
   private var handshakeInt:int;
   
   private var responders:Object = {};
   
   private var cleanInterval:int;
   
   private var _messageId:uint;
   
   private var output:ByteArray = new ByteArray();
   
   private var buffer:ByteArray = new ByteArray();
   
   private var messageSize:uint;
   
   public function SenderHandler()
   {
      super();
      addEventListener(Event.CONNECT,this.onConnect);
      addEventListener(IOErrorEvent.IO_ERROR,this.onError);
      addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
   }
   
   override public function connect(host:String, port:int) : void
   {
      Console.trace("Connecting \'" + host + "\' on port \'" + port + "\'");
      this.host = host;
      this.port = port;
      super.connect(host,port);
   }
   
   private function onError(e:Event) : void
   {
      dispatchEvent(new Event(FAILED));
   }
   
   private function onConnect(e:Event) : void
   {
      Console.trace("Connected to \'" + this.host + "\' on port \'" + this.port + "\', initializing handshake...");
      addEventListener(ProgressEvent.SOCKET_DATA,this.onClientData);
      addEventListener(Event.CLOSE,this.onSocketClose);
      this.cleanInterval = setInterval(this.clearMessages,TTL);
      this.handshakeInt = setTimeout(this.onHandshakeTimeout,timeout);
      this.ping(this.onHandshake);
   }
   
   private function onSocketClose(e:Event) : void
   {
      Console.trace("Connection to \'" + this.host + "\' on port \'" + this.port + "\' closed");
      clearInterval(this.cleanInterval);
   }
   
   private function onHandshake() : void
   {
      Console.trace("Handshake succeded with host \'" + this.host + "\' on port \'" + this.port + "\'");
      clearTimeout(this.handshakeInt);
      dispatchEvent(new Event(CONNECTED));
   }
   
   private function onHandshakeTimeout() : void
   {
      Console.trace("Handshake timeout with host \'" + this.host + "\' on port \'" + this.port + "\'");
      dispatchEvent(new Event(FAILED));
   }
   
   private function getMessageId() : uint
   {
      ++this._messageId;
      if(this._messageId >= MAX_ID)
      {
         this._messageId = 0;
      }
      return this._messageId;
   }
   
   public function call(service:String, method:String, result:Function = null, fault:Function = null, args:Array = null) : void
   {
      var ba:ByteArray = new ByteArray();
      ba.writeUTF(service);
      ba.writeUTF(method);
      ba.writeObject(args);
      var id:uint = uint(this.getMessageId());
      this.send(MessageType.RPC_REQUEST,id,ba,result,fault);
   }
   
   public function ping(result:Function = null) : void
   {
      this.send(MessageType.PING,this.getMessageId(),null,result);
   }
   
   private function pong() : void
   {
      this.send(MessageType.PONG,this.getMessageId());
   }
   
   public function registerCharacter(token:String, result:Function = null, fault:Function = null) : void
   {
      var ba:ByteArray = new ByteArray();
      ba.writeUTF(token);
      this.send(MessageType.AUTH_REQUEST,this.getMessageId(),ba,result,fault);
   }
   
   public function unregisterCharacter(result:Function = null, fault:Function = null) : void
   {
      close();
      result();
   }
   
   public function send(messageType:uint, id:uint, message:ByteArray = null, result:Function = null, fault:Function = null) : void
   {
      var responder:CustomResponder = null;
      if(!connected)
      {
         return;
      }
      if(result != null || fault != null)
      {
         responder = new CustomResponder();
         responder.id = id;
         responder.result = result;
         responder.fault = fault;
         responder.created = getTimer();
         responder.ttd = responder.created + TTL;
         this.responders[responder.id] = responder;
      }
      this.output.writeByte(messageType);
      this.output.writeInt(id);
      if(Boolean(message))
      {
         this.output.writeBytes(message);
      }
      writeUnsignedInt(this.output.length);
      writeBytes(this.output);
      flush();
      this.output.clear();
   }
   
   private function onClientData(e:Event) : void
   {
      var length:uint = 0;
      while(Boolean(connected) && bytesAvailable > 0)
      {
         if(this.buffer.length > 0)
         {
            readBytes(this.buffer,this.buffer.length,Math.min(bytesAvailable,this.messageSize - this.buffer.length));
            if(this.buffer.length == this.messageSize)
            {
               this.parseMessage(this.buffer);
               this.buffer.clear();
               this.messageSize = 0;
            }
         }
         else
         {
            length = uint(readUnsignedInt());
            if(bytesAvailable < length)
            {
               this.messageSize = length;
               readBytes(this.buffer);
            }
            else
            {
               readBytes(this.buffer,0,length);
               this.parseMessage(this.buffer);
               this.buffer.clear();
               this.messageSize = 0;
            }
         }
      }
   }
   
   private function parseMessage(ba:ByteArray) : void
   {
      var type:uint = 0;
      var id:uint = 0;
      type = uint(ba.readByte());
      id = ba.readUnsignedInt();
      this.parseObject(type,id,ba);
   }
   
   private function parseObject(messageType:uint, messageId:uint, ba:ByteArray) : void
   {
      var responder:CustomResponder = null;
      var object:Object = null;
      var authResponseType:uint = 0;
      var rpcResponseType:uint = 0;
      var service:String = null;
      var method:String = null;
      var params:Array = null;
      var now:uint = uint(getTimer());
      switch(messageType)
      {
         case MessageType.AUTH_RESPONSE:
            authResponseType = uint(ba.readByte());
            responder = this.responders[messageId];
            if(Boolean(responder))
            {
               switch(authResponseType)
               {
                  case AuthResponseType.SUCCESS:
                     if(responder.result != null)
                     {
                        responder.result();
                     }
                     break;
                  default:
                     if(responder.fault != null)
                     {
                        responder.fault();
                     }
               }
            }
            break;
         case MessageType.RPC_RESPONSE:
            rpcResponseType = uint(ba.readByte());
            object = ba.bytesAvailable > 0 ? ba.readObject() : null;
            responder = this.responders[messageId];
            if(Boolean(responder))
            {
               switch(rpcResponseType)
               {
                  case RPCResponseType.SUCCESS:
                     if(responder.result != null)
                     {
                        if(responder.result.length > 0)
                        {
                           responder.result(object);
                        }
                        else
                        {
                           responder.result();
                        }
                     }
                     break;
                  default:
                     if(responder.fault != null)
                     {
                        if(responder.fault.length > 0)
                        {
                           responder.fault(object);
                        }
                        else
                        {
                           responder.fault();
                        }
                     }
               }
            }
            break;
         case MessageType.COMMAND:
            service = ba.readUTF();
            method = ba.readUTF();
            params = ba.readObject();
            ComponentLocator.call(service,method,params);
            break;
         case MessageType.PING:
            this.pong();
            break;
         case MessageType.PONG:
            responder = this.responders[messageId];
            if(Boolean(responder))
            {
               responder.result();
            }
      }
      if(Boolean(responder))
      {
         this.latency = now - responder.created;
      }
   }
   
   private function clearMessages() : void
   {
      var resp:CustomResponder = null;
      var now:int = getTimer();
      for each(resp in this.responders)
      {
         if(now > resp.ttd)
         {
            delete this.responders[resp.id];
         }
      }
   }
}
