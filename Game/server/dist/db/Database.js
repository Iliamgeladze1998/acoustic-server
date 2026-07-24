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
Object.defineProperty(exports, "__esModule", { value: true });
exports.Database = void 0;
const sqlite3 = __importStar(require("sqlite3"));
const path = __importStar(require("path"));
class Database {
    constructor(dbPath = path.resolve(__dirname, '../../data/sod.db')) {
        this.db = new sqlite3.Database(dbPath);
        this.initTables();
    }
    initTables() {
        this.db.exec(`
      CREATE TABLE IF NOT EXISTS accounts (
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      );

      CREATE TABLE IF NOT EXISTS characters (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        server_id TEXT NOT NULL,
        name TEXT NOT NULL,
        disposition TEXT,
        sex TEXT,
        level INTEGER DEFAULT 1,
        side TEXT,
        location TEXT,
        avatar TEXT,
        data TEXT NOT NULL,
        FOREIGN KEY(user_id) REFERENCES accounts(id)
      );

      CREATE INDEX IF NOT EXISTS idx_accounts_email ON accounts(email);
      CREATE INDEX IF NOT EXISTS idx_characters_user ON characters(user_id);
    `);
    }
    createAccount(email, password, id) {
        return new Promise((resolve, reject) => {
            this.db.run('INSERT INTO accounts (id, email, password) VALUES (?, ?, ?)', [id, email, password], function (err) {
                if (err) {
                    if (err.message.includes('UNIQUE constraint failed')) {
                        resolve(false);
                    }
                    else {
                        reject(err);
                    }
                }
                else {
                    resolve(true);
                }
            });
        });
    }
    getAccountByEmail(email) {
        return new Promise((resolve, reject) => {
            this.db.get('SELECT id, email, password FROM accounts WHERE email = ?', [email], (err, row) => {
                if (err)
                    return reject(err);
                if (!row)
                    return resolve(undefined);
                resolve({ id: row.id, email: row.email, password: row.password });
            });
        });
    }
    getAllAccounts() {
        return new Promise((resolve, reject) => {
            this.db.all('SELECT id, email, password FROM accounts', [], (err, rows) => {
                if (err)
                    return reject(err);
                resolve((rows || []).map(r => ({ id: r.id, email: r.email, password: r.password })));
            });
        });
    }
    createCharacter(char) {
        return new Promise((resolve, reject) => {
            this.db.run('INSERT INTO characters (id, user_id, server_id, name, disposition, sex, level, side, location, avatar, data) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', [char.id, char.userId, char.serverId, char.name, char.disposition, char.sex, char.level, char.side, char.location, char.avatar, char.data], function (err) {
                if (err) {
                    if (err.message.includes('UNIQUE constraint failed')) {
                        resolve(false);
                    }
                    else {
                        reject(err);
                    }
                }
                else {
                    resolve(true);
                }
            });
        });
    }
    getCharactersByUser(userId) {
        return new Promise((resolve, reject) => {
            this.db.all('SELECT id, user_id as userId, server_id as serverId, name, disposition, sex, level, side, location, avatar, data FROM characters WHERE user_id = ?', [userId], (err, rows) => {
                if (err)
                    return reject(err);
                resolve(rows || []);
            });
        });
    }
    getCharacterById(charId) {
        return new Promise((resolve, reject) => {
            this.db.get('SELECT id, user_id as userId, server_id as serverId, name, disposition, sex, level, side, location, avatar, data FROM characters WHERE id = ?', [charId], (err, row) => {
                if (err)
                    return reject(err);
                if (!row)
                    return resolve(undefined);
                resolve(row);
            });
        });
    }
    updateCharacterData(charId, data) {
        return new Promise((resolve, reject) => {
            this.db.run('UPDATE characters SET data = ? WHERE id = ?', [data, charId], function (err) {
                if (err)
                    return reject(err);
                resolve(this.changes > 0);
            });
        });
    }
    close() {
        this.db.close();
    }
}
exports.Database = Database;
//# sourceMappingURL=Database.js.map