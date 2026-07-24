package soulex.controller
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import mx.core.Container;
   import soul.model.system.Configuration;
   import soul.view.AlertStyleProxy;
   import soul.view.console.Console;
   import soulex.CharacterInfo;
   import soulex.GameConfig;
   import soulex.ServerInfo;
   import soulex.event.CharacterEvent;
   import soulex.event.LoginEvent;
   import soulex.event.ServerEvent;
   import soulex.view.LoginScreen;
   import soulex.view.ServerScreen;
   
   public class LoginManager extends EventDispatcher
   {
      
      private static const service:String = "offline";
      
      private var container:Container;
      
      private var loginScreen:LoginScreen;
      
      private var serverScreen:ServerScreen;
      
      private var urlLoader:URLLoader = new URLLoader();
      
      public function LoginManager(container:Container)
      {
         super();
         this.container = container;
      }
      
      public function remove() : void
      {
         this.removeScreens();
      }
      
      public function createLoginScreen() : void
      {
         this.loginScreen = new LoginScreen();
         this.loginScreen.login = GameConfig.lastLogin;
         this.loginScreen.password = GameConfig.lastPassword;
         this.loginScreen.addEventListener(LoginEvent.CONFIRM,this.loginConfirm);
         this.loginScreen.addEventListener(LoginEvent.LOCALE_CHANGED,this.localeChanged);
         this.loginScreen.addEventListener(LoginEvent.EXIT,this.exit);
         this.container.addElement(this.loginScreen);
      }
      
      private function localeChanged(e:LoginEvent) : void
      {
         GameConfig.locale = e.locale;
         var ne:LoginEvent = new LoginEvent(LoginEvent.LOCALE_CHANGED);
         dispatchEvent(ne);
      }
      
      private function exit(e:LoginEvent) : void
      {
         var ne:LoginEvent = new LoginEvent(LoginEvent.EXIT);
         dispatchEvent(ne);
      }
      
      private function loginConfirm(e:LoginEvent) : void
      {
         this.urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
         this.urlLoader.addEventListener(Event.COMPLETE,this.sessionLoaded);
         this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.sessionError);
         this.loginScreen.enabled = false;
         var request:URLRequest = new URLRequest("http://" + GameConfig.loginServer + "/" + service);
         request.method = URLRequestMethod.POST;
         var vars:URLVariables = new URLVariables();
         vars.act = "login";
         vars.user = e.user;
         vars.password = e.password;
         request.data = vars;
         this.urlLoader.load(request);
      }
      
      private function sessionError(e:IOErrorEvent) : void
      {
         Console.trace("sessionError",e.target);
         AlertStyleProxy.show("Could not connect to login server","Error");
      }
      
      private function sessionLoaded(e:Event) : void
      {
         var errorCode:int = 0;
         Console.trace("sessionLoaded",e.target);
         var urlLoader:URLLoader = e.target as URLLoader;
         var data:String = urlLoader.data;
         if(data.substr(0,4) == "fail")
         {
            errorCode = int(data.substring(4,-1));
            this.loginScreen.enabled = true;
            AlertStyleProxy.show("Wrong login or password\n errorcode:" + errorCode,"Warning");
            return;
         }
         GameConfig.lastLogin = this.loginScreen.userInput.text;
         if(this.loginScreen.remember.selected)
         {
            GameConfig.lastPassword = this.loginScreen.passwordInput.text;
         }
         GameConfig.session = urlLoader.data;
         urlLoader.removeEventListener(Event.COMPLETE,this.sessionLoaded);
         urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.sessionError);
         urlLoader.addEventListener(Event.COMPLETE,this.serversLoaded);
         urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.serversError);
         var request:URLRequest = new URLRequest("http://" + GameConfig.loginServer + "/" + service);
         request.method = URLRequestMethod.POST;
         var vars:URLVariables = new URLVariables();
         vars.act = "getServers";
         vars.session = GameConfig.session;
         request.data = vars;
         urlLoader.load(request);
      }
      
      private function serversError(e:IOErrorEvent) : void
      {
         Console.trace("serversError",e.target);
         AlertStyleProxy.show("Could not get server list","Error");
         this.loginScreen.enabled = true;
      }
      
      private function serversLoaded(e:Event) : void
      {
         Console.trace("serversLoaded",e.target);
         var urlLoader:URLLoader = e.target as URLLoader;
         GameConfig.servers = ServerInfo.load(urlLoader.data);
         if(urlLoader.data == "fail")
         {
            AlertStyleProxy.show("Could not get server list","Error");
            return;
         }
         urlLoader.removeEventListener(Event.COMPLETE,this.serversLoaded);
         urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.serversError);
         this.removeScreens();
         this.serverScreen = new ServerScreen();
         this.serverScreen.addEventListener(Event.CLOSE,this.serverCanceled);
         this.serverScreen.addEventListener(ServerEvent.SERVER_SELECTED,this.serverSelected);
         this.container.addElement(this.serverScreen);
      }
      
      private function serverCanceled(e:Event) : void
      {
         this.removeScreens();
         this.createLoginScreen();
      }
      
      private function serverSelected(e:ServerEvent) : void
      {
         GameConfig.selectedServer = GameConfig.servers[e.index];
         this.serverScreen.enabled = false;
         this.urlLoader.addEventListener(Event.COMPLETE,this.charactersLoaded);
         this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.charactersError);
         var request:URLRequest = new URLRequest("http://" + GameConfig.loginServer + "/" + service);
         request.method = URLRequestMethod.POST;
         var vars:URLVariables = new URLVariables();
         vars.act = "getServerCharacters";
         vars.session = GameConfig.session;
         vars.serverId = GameConfig.selectedServer.id;
         request.data = vars;
         this.urlLoader.load(request);
      }
      
      private function charactersError(e:IOErrorEvent) : void
      {
         Console.trace("charactersError",e.target);
         AlertStyleProxy.show("Error getting character list","Error");
      }
      
      private function charactersLoaded(e:Event) : void
      {
         Console.trace("charactersLoaded",e.target);
         var urlLoader:URLLoader = e.target as URLLoader;
         if(urlLoader.data == "fail")
         {
            AlertStyleProxy.show("Error getting character list","Error");
            return;
         }
         urlLoader.removeEventListener(Event.COMPLETE,this.charactersLoaded);
         urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.charactersError);
         GameConfig.characters = CharacterInfo.load(urlLoader.data);
         this.serverScreen.characters = GameConfig.characters;
         this.serverScreen.enabled = true;
         this.serverScreen.addEventListener(CharacterEvent.CHARACTER_SELECTED,this.characterSelected);
      }
      
      private function characterSelected(e:CharacterEvent) : void
      {
         this.serverScreen.enabled = false;
         GameConfig.selectedCharacter = GameConfig.characters[e.id];
         this.urlLoader.addEventListener(Event.COMPLETE,this.tokenLoaded);
         this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.tokenError);
         var request:URLRequest = new URLRequest("http://" + GameConfig.loginServer + "/" + service);
         request.method = URLRequestMethod.POST;
         var vars:URLVariables = new URLVariables();
         vars.act = "getToken";
         vars.session = GameConfig.session;
         vars.serverId = GameConfig.selectedServer.id;
         vars.characterId = GameConfig.selectedCharacter.id;
         request.data = vars;
         this.urlLoader.load(request);
      }
      
      private function tokenError(e:IOErrorEvent) : void
      {
         Console.trace("tokenError",e.target);
         AlertStyleProxy.show("Error getting character token","Error");
         this.serverScreen.enabled = true;
      }
      
      private function tokenLoaded(e:Event) : void
      {
         Console.trace("tokenLoaded",e.target);
         var urlLoader:URLLoader = e.target as URLLoader;
         if(urlLoader.data == "fail")
         {
            AlertStyleProxy.show("Error getting character token","Error");
            return;
         }
         this.removeScreens();
         Configuration.token = urlLoader.data;
         GameConfig.lastServer = GameConfig.selectedServer.id;
         GameConfig.lastCharacter = GameConfig.selectedCharacter.id;
         Configuration.host = GameConfig.selectedServer.host;
         var ne:LoginEvent = new LoginEvent(LoginEvent.COMPLETE);
         dispatchEvent(ne);
      }
      
      private function removeScreens() : void
      {
         if(Boolean(this.loginScreen))
         {
            this.container.removeElement(this.loginScreen);
            this.loginScreen = null;
         }
         if(Boolean(this.serverScreen))
         {
            this.container.removeElement(this.serverScreen);
            this.serverScreen = null;
         }
      }
   }
}

