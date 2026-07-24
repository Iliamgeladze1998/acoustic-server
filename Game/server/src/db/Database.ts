import * as sqlite3 from 'sqlite3';
import * as path from 'path';

export interface UserAccount {
  id: string;
  email: string;
  password: string;
}

export interface CharacterInfo {
  id: string;
  userId: string;
  serverId: string;
  name: string;
  disposition: string;
  sex: string;
  level: number;
  side: string;
  location: string;
  avatar: string;
  data: string;
}

export class Database {
  private db: sqlite3.Database;

  constructor(dbPath: string = path.resolve(__dirname, '../../data/sod.db')) {
    this.db = new sqlite3.Database(dbPath);
    this.initTables();
  }

  private initTables(): void {
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

  createAccount(email: string, password: string, id: string): Promise<boolean> {
    return new Promise((resolve, reject) => {
      this.db.run(
        'INSERT INTO accounts (id, email, password) VALUES (?, ?, ?)',
        [id, email, password],
        function(err) {
          if (err) {
            if (err.message.includes('UNIQUE constraint failed')) {
              resolve(false);
            } else {
              reject(err);
            }
          } else {
            resolve(true);
          }
        }
      );
    });
  }

  getAccountByEmail(email: string): Promise<UserAccount | undefined> {
    return new Promise((resolve, reject) => {
      this.db.get(
        'SELECT id, email, password FROM accounts WHERE email = ?',
        [email],
        (err, row: any) => {
          if (err) return reject(err);
          if (!row) return resolve(undefined);
          resolve({ id: row.id, email: row.email, password: row.password });
        }
      );
    });
  }

  getAllAccounts(): Promise<UserAccount[]> {
    return new Promise((resolve, reject) => {
      this.db.all(
        'SELECT id, email, password FROM accounts',
        [],
        (err, rows: any[]) => {
          if (err) return reject(err);
          resolve((rows || []).map(r => ({ id: r.id, email: r.email, password: r.password })));
        }
      );
    });
  }

  createCharacter(char: CharacterInfo): Promise<boolean> {
    return new Promise((resolve, reject) => {
      this.db.run(
        'INSERT INTO characters (id, user_id, server_id, name, disposition, sex, level, side, location, avatar, data) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [char.id, char.userId, char.serverId, char.name, char.disposition, char.sex, char.level, char.side, char.location, char.avatar, char.data],
        function(err) {
          if (err) {
            if (err.message.includes('UNIQUE constraint failed')) {
              resolve(false);
            } else {
              reject(err);
            }
          } else {
            resolve(true);
          }
        }
      );
    });
  }

  getCharactersByUser(userId: string): Promise<CharacterInfo[]> {
    return new Promise((resolve, reject) => {
      this.db.all(
        'SELECT id, user_id as userId, server_id as serverId, name, disposition, sex, level, side, location, avatar, data FROM characters WHERE user_id = ?',
        [userId],
        (err, rows: any[]) => {
          if (err) return reject(err);
          resolve(rows || []);
        }
      );
    });
  }

  getCharacterById(charId: string): Promise<CharacterInfo | undefined> {
    return new Promise((resolve, reject) => {
      this.db.get(
        'SELECT id, user_id as userId, server_id as serverId, name, disposition, sex, level, side, location, avatar, data FROM characters WHERE id = ?',
        [charId],
        (err, row: any) => {
          if (err) return reject(err);
          if (!row) return resolve(undefined);
          resolve(row);
        }
      );
    });
  }

  updateCharacterData(charId: string, data: string): Promise<boolean> {
    return new Promise((resolve, reject) => {
      this.db.run(
        'UPDATE characters SET data = ? WHERE id = ?',
        [data, charId],
        function(err) {
          if (err) return reject(err);
          resolve(this.changes > 0);
        }
      );
    });
  }

  close(): void {
    this.db.close();
  }
}
