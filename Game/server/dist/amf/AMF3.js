"use strict";
// AMF3 (Action Message Format 3) reader/writer
// Used by Flash Player for binary serialization in the SoD protocol
Object.defineProperty(exports, "__esModule", { value: true });
exports.AMF3Writer = exports.AMF3Reader = void 0;
class AMF3Reader {
    constructor(buf) {
        this.pos = 0;
        this.strings = [];
        this.objects = [];
        this.traits = [];
        this.buf = buf;
    }
    get bytesAvailable() {
        return this.buf.length - this.pos;
    }
    readByte() {
        return this.buf.readInt8(this.pos++);
    }
    readUnsignedByte() {
        return this.buf.readUInt8(this.pos++);
    }
    readUnsignedInt() {
        const val = this.buf.readUInt32BE(this.pos);
        this.pos += 4;
        return val;
    }
    readInt() {
        const val = this.buf.readInt32BE(this.pos);
        this.pos += 4;
        return val;
    }
    readShort() {
        const val = this.buf.readInt16BE(this.pos);
        this.pos += 2;
        return val;
    }
    readUnsignedShort() {
        const val = this.buf.readUInt16BE(this.pos);
        this.pos += 2;
        return val;
    }
    readDouble() {
        const val = this.buf.readDoubleBE(this.pos);
        this.pos += 8;
        return val;
    }
    readUTF() {
        const len = this.readUnsignedShort();
        const str = this.buf.toString('utf8', this.pos, this.pos + len);
        this.pos += len;
        return str;
    }
    // Read AMF3 U29 variable-length integer
    readU29() {
        let result;
        const b1 = this.readUnsignedByte();
        if (b1 < 0x80) {
            result = b1;
        }
        else if (b1 < 0xC0) {
            const b2 = this.readUnsignedByte();
            result = ((b1 & 0x7F) << 7) | b2;
        }
        else if (b1 < 0xE0) {
            const b2 = this.readUnsignedByte();
            const b3 = this.readUnsignedByte();
            result = ((b1 & 0x3F) << 14) | (b2 << 7) | b3;
        }
        else {
            const b2 = this.readUnsignedByte();
            const b3 = this.readUnsignedByte();
            const b4 = this.readUnsignedByte();
            result = ((b1 & 0x1F) << 22) | (b2 << 14) | (b3 << 7) | b4;
        }
        return result;
    }
    // Read AMF3 string (with string table reference)
    readAMF3String() {
        const ref = this.readU29();
        if ((ref & 1) === 0) {
            // Reference to string table
            const index = ref >> 1;
            return this.strings[index];
        }
        const len = ref >> 1;
        if (len === 0) {
            return '';
        }
        const str = this.buf.toString('utf8', this.pos, this.pos + len);
        this.pos += len;
        this.strings.push(str);
        return str;
    }
    readObject() {
        if (this.bytesAvailable <= 0)
            return null;
        const marker = this.readUnsignedByte();
        return this.readValue(marker);
    }
    readValue(marker) {
        switch (marker) {
            case 0x00: return undefined; // undefined
            case 0x01: return null; // null
            case 0x02: return false; // false
            case 0x03: return true; // true
            case 0x04: return this.readAMF3Integer();
            case 0x05: return this.readDouble();
            case 0x06: return this.readAMF3String();
            case 0x07: return this.readAMF3XmlDoc();
            case 0x08: return this.readAMF3Date();
            case 0x09: return this.readAMF3Array();
            case 0x0A: return this.readAMF3Object();
            case 0x0B: return this.readAMF3Xml();
            case 0x0C: return this.readAMF3ByteArray();
            default:
                throw new Error(`Unknown AMF3 marker: 0x${marker.toString(16)}`);
        }
    }
    readAMF3Integer() {
        return this.readU29();
    }
    readAMF3XmlDoc() {
        const ref = this.readU29();
        if ((ref & 1) === 0) {
            return this.objects[ref >> 1];
        }
        const len = ref >> 1;
        const str = this.buf.toString('utf8', this.pos, this.pos + len);
        this.pos += len;
        this.objects.push(str);
        return str;
    }
    readAMF3Date() {
        const ref = this.readU29();
        if ((ref & 1) === 0) {
            return this.objects[ref >> 1];
        }
        const ms = this.readDouble();
        const date = new Date(ms);
        this.objects.push(date);
        return date;
    }
    readAMF3Array() {
        const ref = this.readU29();
        if ((ref & 1) === 0) {
            return this.objects[ref >> 1];
        }
        const len = ref >> 1;
        const obj = {};
        // Read associative part (key-value pairs until empty string key)
        let key = this.readAMF3String();
        while (key !== '') {
            obj[key] = this.readObject();
            key = this.readAMF3String();
        }
        // Read dense part (indexed values)
        for (let i = 0; i < len; i++) {
            obj[i] = this.readObject();
        }
        this.objects.push(obj);
        return obj;
    }
    readAMF3Object() {
        const ref = this.readU29();
        if ((ref & 1) === 0) {
            return this.objects[ref >> 1];
        }
        const traitsRef = ref >> 1;
        let className;
        let sealedMembers = [];
        let dynamic = false;
        if ((traitsRef & 1) === 0) {
            // Trait reference
            const trait = this.traits[traitsRef >> 1];
            className = trait.className;
            sealedMembers = trait.sealedMembers;
            dynamic = trait.dynamic;
        }
        else {
            // New trait
            className = this.readAMF3String();
            const traitInfo = traitsRef >> 1;
            dynamic = (traitInfo & 1) !== 0;
            const sealedCount = traitInfo >> 1;
            for (let i = 0; i < sealedCount; i++) {
                sealedMembers.push(this.readAMF3String());
            }
            this.traits.push({ className, sealedMembers, dynamic });
        }
        const obj = { __className: className };
        // Read sealed members
        for (const member of sealedMembers) {
            obj[member] = this.readObject();
        }
        // Read dynamic members
        if (dynamic) {
            let key = this.readAMF3String();
            while (key !== '') {
                obj[key] = this.readObject();
                key = this.readAMF3String();
            }
        }
        this.objects.push(obj);
        return obj;
    }
    readAMF3Xml() {
        return this.readAMF3XmlDoc();
    }
    readAMF3ByteArray() {
        const ref = this.readU29();
        if ((ref & 1) === 0) {
            return this.objects[ref >> 1];
        }
        const len = ref >> 1;
        const data = this.buf.subarray(this.pos, this.pos + len);
        this.pos += len;
        this.objects.push(data);
        return data;
    }
}
exports.AMF3Reader = AMF3Reader;
class AMF3Writer {
    constructor() {
        this.buffers = [];
        this.strings = [];
        this.stringRefs = new Map();
        this.objects = [];
        this.objectRefs = new Map();
    }
    writeByte(val) {
        this.buffers.push(Buffer.from([val & 0xFF]));
    }
    writeUnsignedByte(val) {
        this.buffers.push(Buffer.from([val & 0xFF]));
    }
    writeUnsignedInt(val) {
        const buf = Buffer.alloc(4);
        buf.writeUInt32BE(val >>> 0, 0);
        this.buffers.push(buf);
    }
    writeInt(val) {
        const buf = Buffer.alloc(4);
        buf.writeInt32BE(val, 0);
        this.buffers.push(buf);
    }
    writeShort(val) {
        const buf = Buffer.alloc(2);
        buf.writeInt16BE(val, 0);
        this.buffers.push(buf);
    }
    writeUnsignedShort(val) {
        const buf = Buffer.alloc(2);
        buf.writeUInt16BE(val & 0xFFFF, 0);
        this.buffers.push(buf);
    }
    writeDouble(val) {
        const buf = Buffer.alloc(8);
        buf.writeDoubleBE(val, 0);
        this.buffers.push(buf);
    }
    writeUTF(str) {
        const strBuf = Buffer.from(str, 'utf8');
        this.writeUnsignedShort(strBuf.length);
        this.buffers.push(strBuf);
    }
    toBuffer() {
        return Buffer.concat(this.buffers);
    }
    writeU29(val) {
        val = val >>> 0;
        if (val < 0x80) {
            this.writeUnsignedByte(val);
        }
        else if (val < 0x4000) {
            this.writeUnsignedByte((val >> 7) | 0x80);
            this.writeUnsignedByte(val & 0x7F);
        }
        else if (val < 0x200000) {
            this.writeUnsignedByte((val >> 14) | 0x80);
            this.writeUnsignedByte(((val >> 7) & 0x7F) | 0x80);
            this.writeUnsignedByte(val & 0x7F);
        }
        else {
            this.writeUnsignedByte((val >> 22) | 0x80);
            this.writeUnsignedByte(((val >> 14) & 0x7F) | 0x80);
            this.writeUnsignedByte(((val >> 7) & 0x7F) | 0x80);
            this.writeUnsignedByte(val & 0x7F);
        }
    }
    writeAMF3String(str) {
        if (str === '') {
            this.writeU29(1); // empty string, no table entry
            return;
        }
        const ref = this.stringRefs.get(str);
        if (ref !== undefined) {
            this.writeU29(ref << 1);
            return;
        }
        const strBuf = Buffer.from(str, 'utf8');
        this.writeU29((strBuf.length << 1) | 1);
        this.buffers.push(strBuf);
        this.stringRefs.set(str, this.strings.length);
        this.strings.push(str);
    }
    writeObject(val) {
        if (val === undefined || val === null) {
            this.writeUnsignedByte(0x01); // null
            return;
        }
        if (val === false) {
            this.writeUnsignedByte(0x02);
            return;
        }
        if (val === true) {
            this.writeUnsignedByte(0x03);
            return;
        }
        if (typeof val === 'number') {
            if (Number.isInteger(val) && val >= -0x10000000 && val <= 0x0FFFFFFF) {
                this.writeUnsignedByte(0x04); // integer
                this.writeU29(val);
            }
            else {
                this.writeUnsignedByte(0x05); // double
                this.writeDouble(val);
            }
            return;
        }
        if (typeof val === 'string') {
            this.writeUnsignedByte(0x06); // string
            this.writeAMF3String(val);
            return;
        }
        if (val instanceof Date) {
            this.writeUnsignedByte(0x08); // date
            this.writeU29(1); // no ref, length=0
            this.writeDouble(val.getTime());
            return;
        }
        if (Array.isArray(val)) {
            this.writeAMF3Array(val);
            return;
        }
        if (Buffer.isBuffer(val)) {
            this.writeUnsignedByte(0x0C); // byte array
            this.writeU29((val.length << 1) | 1);
            this.buffers.push(val);
            return;
        }
        // Treat as anonymous object
        this.writeAMF3Object(val);
    }
    writeAMF3Array(arr) {
        this.writeUnsignedByte(0x09); // array marker
        this.writeU29((arr.length << 1) | 1); // no ref, count
        this.writeAMF3String(''); // no associative part
        for (const item of arr) {
            this.writeObject(item);
        }
    }
    writeAMF3Object(obj) {
        this.writeUnsignedByte(0x0A); // object marker
        const className = obj.__className || '';
        const sealedKeys = obj.__sealed ? Object.keys(obj).filter(k => !k.startsWith('__')) : [];
        const isDynamic = obj.__sealed ? false : true;
        if (className && sealedKeys.length > 0 && !isDynamic) {
            // Typed sealed object:
            // ref = (N << 4) | 0b0011  (new object, new trait, not dynamic, not externalizable, N sealed members)
            const traitVal = (sealedKeys.length << 4) | 0b0011;
            this.writeU29(traitVal);
            this.writeAMF3String(className);
            for (const key of sealedKeys) {
                this.writeAMF3String(key);
            }
            // Write sealed member values in order
            for (const key of sealedKeys) {
                this.writeObject(obj[key]);
            }
        }
        else if (className) {
            // Typed dynamic object: trait = 0b0111 (new trait, dynamic, 0 sealed, not externalizable)
            this.writeU29(0x07);
            this.writeAMF3String(className);
            // Write all properties as dynamic
            for (const key of Object.keys(obj)) {
                if (key === '__className' || key === '__sealed')
                    continue;
                this.writeAMF3String(key);
                this.writeObject(obj[key]);
            }
            this.writeAMF3String(''); // end of dynamic members
        }
        else {
            // Anonymous dynamic object: trait = 0b0111 (new trait, dynamic, 0 sealed, not externalizable)
            this.writeU29(0x07);
            this.writeAMF3String('');
            for (const key of Object.keys(obj)) {
                if (key === '__className' || key === '__sealed')
                    continue;
                this.writeAMF3String(key);
                this.writeObject(obj[key]);
            }
            this.writeAMF3String(''); // end of dynamic members
        }
    }
}
exports.AMF3Writer = AMF3Writer;
//# sourceMappingURL=AMF3.js.map