package soul.model.system
{
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import soul.model.interaction.arena.ArenaInfo;
   
   public class Configuration
   {
      
      public static var host:String;
      
      public static var token:String;
      
      public static var locale:String;
      
      public static var gameName:String;
      
      public static var userKey:String;
      
      public static var portalId:int;
      
      public static var portalToken:String;
      
      public static var hideEarn:Boolean;
      
      public static var openSelf:Boolean;
      
      public static var logoutTimeout:int;
      
      public static var coppersPerRuby:Number;
      
      public static var subscriptions:Array;
      
      public static var serverTimeDelta:Number;
      
      public static var loadSS:Boolean;
      
      public static var staticServerURL:String = "";
      
      public static var portalServerURL:String = "";
      
      public static const auctionItemsPerPage:int = 10;
      
      public function Configuration()
      {
         super();
      }
      
      public static function initFromParameters(parameters:Object) : void
      {
         Configuration.staticServerURL = Boolean(parameters.staticUrl) ? parameters.staticUrl : "";
         Configuration.locale = Boolean(parameters.locale) ? parameters.locale : "ru_RU";
         Configuration.userKey = parameters.user_key;
         Configuration.hideEarn = parameters.hide_earn == "true";
         Configuration.loadSS = parameters.loadSS == "true";
         Configuration.openSelf = parameters.openSelf == "true";
         Configuration.host = parameters.host;
         Configuration.token = parameters.token;
         Configuration.gameName = parameters.game || "sodgame";
      }
      
      public static function load(cfg:GameCfg) : void
      {
         logoutTimeout = cfg.exitTimeout;
         serverTimeDelta = cfg.serverTime - new Date().time;
         coppersPerRuby = cfg.coppersPerRuby;
         subscriptions = cfg.subscriptions;
      }
      
      public static function serverDateToLocal(serverTime:Date) : Date
      {
         return new Date(serverTime.time - serverTimeDelta);
      }
      
      public static function serverTimeToLocal(timeStamp:Number) : Number
      {
         return timeStamp - serverTimeDelta;
      }
      
      public static function localDateToServer(localDate:Date) : Date
      {
         return new Date(localDate.time + serverTimeDelta);
      }
      
      public static function getItemImageUrl(imageName:String) : String
      {
         return staticServerURL + "images/items/" + imageName;
      }
      
      public static function getAstralImageUrl(imageName:String) : String
      {
         return staticServerURL + "images/astral/" + imageName;
      }
      
      public static function getAbilityImageUrl(imageName:String) : String
      {
         return staticServerURL + "images/talent/" + imageName;
      }
      
      public static function getAchievementImage(imageName:String) : String
      {
         return staticServerURL + "images/achievement/" + imageName;
      }
      
      public static function getAchievementGroupSmallImage(imageName:String) : String
      {
         return staticServerURL + "images/achievement/group/small/" + imageName;
      }
      
      public static function getAchievementGroupBigImage(imageName:String) : String
      {
         return staticServerURL + "images/achievement/group/big/" + imageName;
      }
      
      public static function getSmallAvatarUrl(imageName:String) : String
      {
         return staticServerURL + "images/avatar/small/" + imageName;
      }
      
      public static function getChatSmileUrl(imageName:String) : String
      {
         return staticServerURL + "images/chat/smileys/" + imageName;
      }
      
      public static function getTalentIconUrl(imageName:String) : String
      {
         return staticServerURL + "images/talent/" + imageName + ".jpg";
      }
      
      public static function getArenaMapUrl(arena:ArenaInfo, preview_mode:Boolean = true) : String
      {
         return staticServerURL + "images/arena/" + arena.mapId.toLowerCase() + "/" + arena.layerId.toLowerCase() + (preview_mode ? "_info" : "") + ".jpg";
      }
      
      public static function getMapUrl(sectorId:String) : String
      {
         return staticServerURL + "images/maps/" + sectorId + ".jpg";
      }
      
      public static function getGlobalMapUrl() : String
      {
         return staticServerURL + "images/maps/" + locale + ".jpg";
      }
      
      public static function getReputationUrl(reputation:String) : String
      {
         return staticServerURL + "images/reputation/" + reputation.toLowerCase() + ".png";
      }
      
      public static function getImage(imagePath:String) : String
      {
         return staticServerURL + "images/" + imagePath;
      }
      
      public static function getBonusImage(type:String) : String
      {
         return staticServerURL + "images/bonuses/" + type + ".png";
      }
      
      public static function openExternalURL(url:String, window:String = null) : void
      {
         window ||= openSelf ? "_self" : "_blank";
         var newUrl:String = portalServerURL + "/ext_url/" + url + "?locale=" + locale + (Boolean(portalToken) ? "&game=" + gameName + "&realm=" + "&token=" + portalToken + "&server=" + host : "") + "&portalId=" + portalId + (Boolean(userKey) ? "&user_key=" + userKey : "");
         navigateToURL(new URLRequest(newUrl),window);
      }
   }
}

