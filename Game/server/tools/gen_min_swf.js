// Generate a minimal valid SWF file
// SWF format: https://www.adobe.com/content/dam/acom/en/devnet/pdf/swf-file-format-spec.pdf
// This creates a minimal SWF with a 2000x1500 white background shape

const fs = require('fs');
const path = require('path');

function writeUB(bits, value, bitCount) {
  for (let i = bitCount - 1; i >= 0; i--) {
    bits.push((value >> i) & 1);
  }
}

function bitsToBytes(bits) {
  const bytes = [];
  for (let i = 0; i < bits.length; i += 8) {
    let byte = 0;
    for (let j = 0; j < 8 && i + j < bits.length; j++) {
      byte |= bits[i + j] << (7 - j);
    }
    bytes.push(byte);
  }
  return Buffer.from(bytes);
}

function writeRect(xmin, xmax, ymin, ymax) {
  const bits = [];
  const maxVal = Math.max(Math.abs(xmin), Math.abs(xmax), Math.abs(ymin), Math.abs(ymax));
  let nBits = 1;
  while ((1 << nBits) <= maxVal) nBits++;
  nBits = Math.max(nBits, 1);
  
  writeUB(bits, nBits, 5);  // Nbits
  writeUB(bits, xmin >= 0 ? xmin : (1 << nBits) + xmin, nBits);  // Xmin
  writeUB(bits, xmax >= 0 ? xmax : (1 << nBits) + xmax, nBits);  // Xmax
  writeUB(bits, ymin >= 0 ? ymin : (1 << nBits) + ymin, nBits);  // Ymin
  writeUB(bits, ymax >= 0 ? ymax : (1 << nBits) + ymax, nBits);  // Ymax
  
  return bitsToBytes(bits);
}

function writeUI16(value) {
  const buf = Buffer.alloc(2);
  buf.writeUInt16LE(value, 0);
  return buf;
}

function writeUI32(value) {
  const buf = Buffer.alloc(4);
  buf.writeUInt32LE(value, 0);
  return buf;
}

// SWF tags
const TAG_END = 0x00;
const TAG_SET_BACKGROUND_COLOR = 0x09;  // SetBackgroundColor
const TAG_DEFINE_SHAPE = 0x02;  // DefineShape
const TAG_SHOW_FRAME = 0x01;  // ShowFrame
const TAG_FILE_ATTRIBUTES = 0x45;  // FileAttributes
const TAG_DEFINE_SCENE_AND_FRAME_LABEL_DATA = 0x56;

// Build tags
const tags = [];

// FileAttributes tag (required for SWF 8+)
{
  const body = Buffer.alloc(4);
  body[0] = 0x08; // UseDirectBlit
  const header = Buffer.alloc(2);
  header.writeUInt16LE((TAG_FILE_ATTRIBUTES << 6) | body.length, 0);
  tags.push(Buffer.concat([header, body]));
}

// SetBackgroundColor - white
{
  const body = Buffer.from([0xFF, 0xFF, 0xFF]);
  const header = Buffer.alloc(2);
  header.writeUInt16LE((TAG_SET_BACKGROUND_COLOR << 6) | body.length, 0);
  tags.push(Buffer.concat([header, body]));
}

// DefineShape - a simple white rectangle covering the whole map
{
  // Shape bounds: 0,0 to 40000,30000 (2000x1500 pixels in twips)
  const bounds = writeRect(0, 40000, 0, 30000);
  
  // ShapeWithStyle (DefineShape uses ShapeStyle)
  // FillStyleArray: 1 fill style (solid white)
  // LineStyleArray: 0 line styles
  // NumFillBits: 1, NumLineBits: 0
  
  const fillStyles = Buffer.from([0x01, 0x00, 0xFF, 0xFF, 0xFF]); // 1 style, solid, white RGB
  const lineStyles = Buffer.from([0x00]); // 0 line styles
  
  // Style change record: StateFillType=1, FillType=0 (first fill style)
  // Then 4 straight edge records for the rectangle corners
  // StyleChange: 0x10 (StateFillType0=1) + 0 (StateNewStyles=0, StateLineStyle=0, StateFillType1=0, StateMoveTo=0)
  // FillStyle = 0 (1 bit, but NumFillBits=1 so 1 bit = 0)
  
  // Actually, DefineShape (tag 2) format:
  // ShapeId (UI16), ShapeBounds (RECT), Shapes (SHAPEWITHSTYLE)
  // SHAPEWITHSTYLE: FillStyles, LineStyles, NumFillBits(4), NumLineBits(4), ShapeRecords
  
  // For a simple rectangle:
  // FillStyles: 1 solid white
  // LineStyles: 0
  // NumFillBits = 1 (4 bits), NumLineBits = 0 (4 bits) = 0x10
  // ShapeRecord 0: StyleChange - set fill to 0, move to (0,0)
  //   Flags: StateFillType0=1 (0x10), StateMoveTo=1 (0x01) = 0x11
  //   MoveBits = 16 (enough for 40000)
  //   MoveDeltaX = 0, MoveDeltaY = 0
  //   FillStyle0 = 0 (1 bit)
  // ShapeRecord 1-4: StraightEdge - 4 edges to make rectangle
  // ShapeRecord 5: EndShape = 0x00
  
  // Let me build this more carefully...
  const shapeId = writeUI16(1); // Character ID = 1
  
  // Shape records (bit-level)
  const shapeBits = [];
  
  // StyleChange record: StateFillType0=1, StateMoveTo=1
  writeUB(shapeBits, 0, 1); // StateNewStyles = 0
  writeUB(shapeBits, 0, 1); // StateLineStyle = 0
  writeUB(shapeBits, 1, 1); // StateFillType1 = 0 (wait, this is FillType1)
  writeUB(shapeBits, 1, 1); // StateFillType0 = 1
  writeUB(shapeBits, 1, 1); // StateMoveTo = 1
  writeUB(shapeBits, 0, 5); // reserved
  
  // MoveBits
  const moveBits = 16;
  writeUB(shapeBits, moveBits, 5); // MoveBits
  writeUB(shapeBits, 0, moveBits); // MoveDeltaX = 0
  writeUB(shapeBits, 0, moveBits); // MoveDeltaY = 0
  
  // FillStyle0 = 1 (use first fill style)
  writeUB(shapeBits, 1, 1); // FillStyle0 = 1 (1 bit since NumFillBits=1)
  
  // StraightEdge records for rectangle: (0,0) -> (40000,0) -> (40000,30000) -> (0,30000) -> (0,0)
  // Each edge: TypeFlag=1 (edge), StraightFlag=1, NumLines=1 (2 bits), dx, dy
  
  function writeStraightEdge(bits, dx, dy) {
    writeUB(bits, 1, 1); // TypeFlag = 1 (edge)
    writeUB(bits, 1, 1); // StraightFlag = 1 (straight)
    
    // Determine which axes are present
    const dxNonZero = dx !== 0;
    const dyNonZero = dy !== 0;
    
    if (dxNonZero && dyNonZero) {
      writeUB(bits, 0b11, 2); // GeneralLine
    } else if (dxNonZero) {
      writeUB(bits, 0b10, 2); // Horizontal line
    } else {
      writeUB(bits, 0b01, 2); // Vertical line
    }
    
    // NumBits for edge values
    const maxAbs = Math.max(Math.abs(dx), Math.abs(dy));
    let nBits = 2;
    while ((1 << (nBits - 1)) <= maxAbs) nBits++;
    nBits = Math.max(nBits, 2);
    writeUB(bits, nBits - 2, 4); // NumBits - 2 (4 bits)
    
    if (dxNonZero) writeUB(bits, dx >= 0 ? dx : (1 << nBits) + dx, nBits);
    if (dyNonZero) writeUB(shapeBits, dy >= 0 ? dy : (1 << nBits) + dy, nBits);
  }
  
  // Edge 1: (0,0) -> (40000, 0) - horizontal
  writeStraightEdge(shapeBits, 40000, 0);
  // Edge 2: (40000, 0) -> (40000, 30000) - vertical
  writeStraightEdge(shapeBits, 0, 30000);
  // Edge 3: (40000, 30000) -> (0, 30000) - horizontal (negative)
  writeStraightEdge(shapeBits, -40000, 0);
  // Edge 4: (0, 30000) -> (0, 0) - vertical (negative)
  writeStraightEdge(shapeBits, 0, -30000);
  
  // End shape record
  writeUB(shapeBits, 0, 6); // TypeFlag=0 + 5 reserved bits = 0
  
  const shapeBytes = bitsToBytes(shapeBits);
  
  // NumFillBits=1 (4 bits), NumLineBits=0 (4 bits)
  const styleBits = Buffer.from([0x10]); // 0001 0000 = NumFillBits=1, NumLineBits=0
  
  // Build the Shapes block
  const shapesBlock = Buffer.concat([
    fillStyles,
    lineStyles,
    styleBits,
    shapeBytes
  ]);
  
  const body = Buffer.concat([shapeId, bounds, shapesBlock]);
  const header = Buffer.alloc(2);
  // Tag code + length (short form if < 63 bytes)
  if (body.length < 0x3F) {
    header.writeUInt16LE((TAG_DEFINE_SHAPE << 6) | body.length, 0);
    tags.push(Buffer.concat([header, body]));
  } else {
    // Long form
    header.writeUInt16LE((TAG_DEFINE_SHAPE << 6) | 0x3F, 0);
    const longLength = writeUI32(body.length);
    tags.push(Buffer.concat([header, longLength, body]));
  }
}

// ShowFrame
{
  const header = Buffer.alloc(2);
  header.writeUInt16LE((TAG_SHOW_FRAME << 6) | 0, 0);
  tags.push(header);
}

// End tag
{
  const header = Buffer.alloc(2);
  header.writeUInt16LE((TAG_END << 6) | 0, 0);
  tags.push(header);
}

// Build the SWF
const signature = Buffer.from('FWS'); // Uncompressed
const version = Buffer.from([10]);
const frameSize = writeRect(0, 20000, 0, 12000); // 1000x600 pixels in twips
const frameRate = writeUI16(0x0018); // 24 fps (8.8 fixed point)
const frameCount = writeUI16(1);

const body = Buffer.concat([frameSize, frameRate, frameCount, ...tags]);
const fileLength = Buffer.alloc(4);
fileLength.writeUInt32LE(8 + body.length, 0); // 8 = signature(3) + version(1) + length(4)

const swf = Buffer.concat([signature, version, fileLength, body]);

const outputPath = process.argv[2] || path.join(__dirname, '../web/libs/common.swf');
fs.mkdirSync(path.dirname(outputPath), { recursive: true });
fs.writeFileSync(outputPath, swf);
console.log(`Generated minimal SWF: ${outputPath} (${swf.length} bytes)`);
