"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.LoginServer = void 0;
const express_1 = __importDefault(require("express"));
const path = __importStar(require("path"));
const fs = __importStar(require("fs"));
const Database_1 = require("../db/Database");
class LoginServer {
    constructor(port = 80, gameServer, world) {
        // In-memory data stores
        this.accounts = new Map();
        this.sessions = new Map(); // session -> userId
        this.servers = [];
        this.characters = new Map(); // userId -> chars
        this.port = port;
        this.gameServer = gameServer;
        this.world = world;
        this.db = new Database_1.Database();
        this.app = (0, express_1.default)();
        this.app.use(express_1.default.urlencoded({ extended: true }));
        this.app.use(express_1.default.text());
        this.setupRoutes();
    }
    async init() {
        // Load existing accounts from database
        const existingAccounts = await this.db.getAllAccounts();
        for (const acc of existingAccounts) {
            this.accounts.set(acc.email, acc);
        }
        // Create default test account if not exists
        if (!this.accounts.has('test@test.com')) {
            this.accounts.set('test@test.com', { email: 'test@test.com', password: 'test', id: 'user_1' });
            await this.db.createAccount('test@test.com', 'test', 'user_1');
        }
        // Create admin account if not exists
        if (!this.accounts.has('ADMIN')) {
            this.accounts.set('ADMIN', { email: 'ADMIN', password: 'Setembrini1', id: 'user_admin' });
            await this.db.createAccount('ADMIN', 'Setembrini1', 'user_admin');
        }
        // Game server
        this.servers.push({
            id: 'srv_1',
            name: 'Dreams Server',
            host: '178.104.173.138',
            online: true,
            characters: 2,
            version: '0.90.3',
        });
        // Test character
        this.characters.set('user_1', [{
                id: 'char_1',
                name: 'Hero',
                serverId: 'srv_1',
                disposition: 'knight',
                sex: 'male',
                level: 1,
                side: 'light',
                location: 'start',
                avatar: 'knight/male/default.jpg',
            }]);
        // Admin character
        this.characters.set('user_admin', [{
                id: 'admin_char',
                name: 'ADMIN',
                serverId: 'srv_1',
                disposition: 'knight',
                sex: 'male',
                level: 60,
                side: 'light',
                location: 'start',
                avatar: 'knight/male/default.jpg',
            }]);
    }
    setupRoutes() {
        // Serve web client (Ruffle + SWF)
        const webDir = path.resolve(__dirname, '../../web');
        this.app.use('/web', express_1.default.static(webDir));
        // Serve static files (images, maps, etc.)
        const staticDir = path.resolve(__dirname, '../../static');
        this.app.use('/static', express_1.default.static(staticDir, {
            fallthrough: true,
        }));
        // Serve versions list for GameContent update check
        this.app.get('/static/versions', (req, res) => {
            res.set('Content-Type', 'text/plain');
            res.send('0.90.3');
        });
        // Serve content package .zip for GameContent
        this.app.get('/static/:version.zip', (req, res) => {
            const version = req.params.version;
            const packageFile = path.resolve(__dirname, '../../static/packages/' + version + '.zip');
            if (require('fs').existsSync(packageFile)) {
                res.sendFile(packageFile);
            }
            else {
                res.status(404).send('not found');
            }
        });
        // Serve file.list for game content update check
        this.app.get('/static/:version/file.list', (req, res) => {
            const version = req.params.version;
            const listFile = path.resolve(__dirname, '../../static/packages/' + version + '.filelist');
            if (fs.existsSync(listFile)) {
                res.set('Content-Type', 'text/plain');
                res.sendFile(listFile);
            }
            else {
                // Return matching file.list so client thinks no update needed
                res.set('Content-Type', 'text/plain');
                res.send('d41d8cd98f00b204e9800998ecf8427e    version.txt\n');
            }
        });
        // Serve update.xml (valid Adobe AIR update descriptor)
        this.app.get('/static/update.xml', (req, res) => {
            res.set('Content-Type', 'text/xml');
            res.send(`<?xml version="1.0" encoding="utf-8"?>
<update xmlns="http://ns.adobe.com/air/framework/update/description/2.5">
    <versionNumber>0.90.3</versionNumber>
    <url>http://178.104.173.138:9090/download/soul_client.air</url>
    <description><![CDATA[No update available.]]></description>
</update>`);
        });
        // Root -> web client
        this.app.get('/', (req, res) => {
            res.redirect('/web/');
        });
        // Download patched .air client
        this.app.get('/download/soul_client.air', (req, res) => {
            const airFile = path.resolve(__dirname, '../../soul_client_patched.air');
            res.download(airFile, 'soul_client.air');
        });
        this.app.post('/offline', (req, res) => {
            const act = req.body.act;
            switch (act) {
                case 'login':
                    this.handleLogin(req, res);
                    break;
                case 'register':
                    this.handleRegister(req, res);
                    break;
                case 'getServers':
                    this.handleGetServers(req, res);
                    break;
                case 'getServerCharacters':
                    this.handleGetCharacters(req, res);
                    break;
                case 'getToken':
                    this.handleGetToken(req, res);
                    break;
                default:
                    res.send('fail');
            }
        });
        // Admin endpoints
        this.app.post('/admin/gold', (req, res) => {
            const charId = req.body.character;
            const type = req.body.type || 'coppers';
            const amount = parseInt(req.body.amount) || 0;
            if (this.world.addCurrency(charId, type, amount)) {
                res.json({ ok: true, message: `Added ${amount} ${type} to ${charId}` });
            }
            else {
                res.status(404).json({ ok: false, error: 'Character not found' });
            }
        });
        this.app.post('/admin/level', (req, res) => {
            const charId = req.body.character;
            const level = parseInt(req.body.level) || 1;
            if (this.world.setLevel(charId, level)) {
                res.json({ ok: true, message: `Set ${charId} level to ${level}` });
            }
            else {
                res.status(404).json({ ok: false, error: 'Character not found' });
            }
        });
        this.app.post('/admin/stats', (req, res) => {
            const charId = req.body.character;
            const stats = req.body.stats;
            if (this.world.setCharacterParams(charId, stats)) {
                res.json({ ok: true, message: `Updated stats for ${charId}` });
            }
            else {
                res.status(404).json({ ok: false, error: 'Character not found' });
            }
        });
        this.app.post('/admin/item', (req, res) => {
            const charId = req.body.character;
            const item = {
                id: 'item_' + Date.now(),
                slot: req.body.slot || 'inventory',
                type: req.body.type || 'weapon',
                bound: false,
                binding: 'none',
                templateId: req.body.templateId || 'sword_1',
                imagePath: req.body.imagePath || 'items/sword_1.png',
                itemClass: req.body.itemClass || 'weapon',
                count: parseInt(req.body.count) || 1,
                durability: 100,
                durabilityMaximum: 100,
                usable: false,
                sockets: 0,
                socketTypes: [],
                subType: req.body.subType || '',
                level: parseInt(req.body.level) || 1,
                items: [],
                autoAbilities: [],
                equipped: false,
                bodySlot: -1,
                locked: false,
            };
            if (this.world.addItem(charId, item)) {
                res.json({ ok: true, message: `Added item to ${charId}` });
            }
            else {
                res.status(404).json({ ok: false, error: 'Character not found' });
            }
        });
        this.app.get('/admin/characters', (req, res) => {
            const chars = Array.from(this.world.getAllCharacters?.() || []);
            res.json(chars);
        });
    }
    async handleRegister(req, res) {
        const user = req.body.user;
        const password = req.body.password;
        if (!user || !password || user.length < 3 || password.length < 4) {
            res.send('fail2');
            return;
        }
        if (this.accounts.has(user)) {
            res.send('fail3');
            return;
        }
        const userId = 'user_' + Date.now();
        const account = { id: userId, email: user, password };
        this.accounts.set(user, account);
        try {
            await this.db.createAccount(user, password, userId);
        }
        catch (err) {
            console.error('[LoginServer] Failed to save account:', err);
        }
        // Create default character
        const charId = 'char_' + Date.now();
        this.characters.set(userId, [{
                id: charId,
                name: user,
                serverId: 'srv_1',
                disposition: 'knight',
                sex: 'male',
                level: 1,
                side: 'light',
                location: 'start',
                avatar: 'knight/male/default.jpg',
            }]);
        // Also create character in world
        this.world.createPlayerCharacter(charId, user, 1);
        const session = this.generateSession();
        this.sessions.set(session, userId);
        console.log(`[LoginServer] Registered and logged in: ${user}, session: ${session}`);
        res.send(session);
    }
    handleLogin(req, res) {
        const user = req.body.user;
        const password = req.body.password;
        const account = this.accounts.get(user);
        if (!account || account.password !== password) {
            res.send('fail1');
            return;
        }
        const session = this.generateSession();
        this.sessions.set(session, account.id);
        console.log(`[LoginServer] Login success: ${user}, session: ${session}`);
        res.send(session);
    }
    handleGetServers(req, res) {
        const session = req.body.session;
        const userId = this.sessions.get(session);
        console.log(`[LoginServer] getServers request, session: ${session}, userId: ${userId}`);
        if (!userId) {
            res.send('fail');
            return;
        }
        let xml = '<?xml version="1.0" encoding="UTF-8"?>\n<Servers>\n';
        for (const srv of this.servers) {
            xml += `<ServerInfo id="${srv.id}" name="${srv.name}" host="${srv.host}" online="${srv.online}" characters="${srv.characters}" version="${srv.version}"/>\n`;
        }
        xml += '</Servers>';
        res.set('Content-Type', 'text/xml');
        console.log(`[LoginServer] getServers response: ${xml}`);
        res.send(xml);
    }
    handleGetCharacters(req, res) {
        const session = req.body.session;
        const serverId = req.body.serverId;
        const userId = this.sessions.get(session);
        if (!userId) {
            res.send('fail');
            return;
        }
        const chars = this.characters.get(userId) || [];
        let xml = '<?xml version="1.0" encoding="UTF-8"?>\n<Characters>\n';
        for (const char of chars) {
            xml += `<CharacterInfo id="${char.id}" name="${char.name}" serverId="${char.serverId}" disposition="${char.disposition}" sex="${char.sex}" level="${char.level}" side="${char.side}" location="${char.location}" avatar="${char.avatar}"/>\n`;
        }
        xml += '</Characters>';
        res.set('Content-Type', 'text/xml');
        console.log(`[LoginServer] getCharacters response for ${userId}: ${xml}`);
        res.send(xml);
    }
    handleGetToken(req, res) {
        const session = req.body.session;
        const characterId = req.body.characterId;
        const userId = this.sessions.get(session);
        if (!userId) {
            res.send('fail');
            return;
        }
        const token = this.generateToken();
        this.gameServer.registerToken(token, characterId);
        console.log(`[LoginServer] Token issued: ${token} for character: ${characterId}`);
        res.send(token);
    }
    generateSession() {
        return 'sess_' + Math.random().toString(36).substring(2, 15) + Date.now().toString(36);
    }
    generateToken() {
        return 'tok_' + Math.random().toString(36).substring(2, 15) + Date.now().toString(36);
    }
    start() {
        this.app.listen(this.port, () => {
            console.log(`[LoginServer] Listening on port ${this.port}`);
        });
    }
}
exports.LoginServer = LoginServer;
//# sourceMappingURL=LoginServer.js.map