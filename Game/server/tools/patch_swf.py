#!/usr/bin/env python3
"""
Patch soul_client.swf to work in browser/Ruffle environment.

The key issue is that GameConfig.load() uses flash.filesystem.File API
which is not available in Ruffle (browser). We need to patch the SWF
to make GameConfig.load use URLLoader instead.

Strategy: Instead of complex ABC bytecode patching, we'll:
1. Replace 'applicationDirectory' string with a custom string that won't match
2. Replace 'FileStream' with 'URLLoader' in the GameConfig context
3. Replace 'FileMode' with something harmless
4. Replace 'READ' with 'BINARY' (URLLoaderDataFormat.BINARY)

Actually, a simpler approach: We'll inject a preloader SWF that:
- Loads soul_config.xml via URLLoader
- Sets GameConfig properties directly
- Then loads the main SWF

But even simpler: Let's just patch the string constants in the ABC.
"""

import zlib
import struct
import sys
import os

def read_swf(path):
    with open(path, 'rb') as f:
        sig = f.read(3)
        version = f.read(1)
        length = struct.unpack('<I', f.read(4))[0]
        if sig == b'CWS':
            body = zlib.decompress(f.read())
        elif sig == b'FWS':
            body = f.read()
        else:
            raise ValueError(f"Unknown SWF signature: {sig}")
        return sig, version, length, body

def write_swf(path, sig, version, body):
    with open(path, 'wb') as f:
        f.write(sig)
        f.write(version)
        f.write(struct.pack('<I', len(body) + 8))
        if sig == b'CWS':
            f.write(zlib.compress(body))
        else:
            f.write(body)

def patch_swf(input_path, output_path):
    sig, version, length, body = read_swf(input_path)
    
    print(f"SWF: sig={sig}, version={version}, length={length}, body={len(body)}")
    
    # Strategy: Replace key strings in the ABC constant pool
    # to redirect File-based loading to URL-based loading
    #
    # In GameConfig.load():
    #   file = File.applicationDirectory.resolvePath(configUrl)
    #   stream = new FileStream()
    #   stream.open(file, FileMode.READ)
    #   parse(stream.readUTFBytes(stream.bytesAvailable))
    #   stream.close()
    #
    # We can't easily change the bytecode, but we CAN:
    # 1. Make 'applicationDirectory' resolve to something that Ruffle handles
    # 2. Or better: patch the whole method body
    #
    # Actually, the simplest approach that might work in Ruffle:
    # Ruffle may stub out File.applicationDirectory to return null/empty
    # and then resolvePath would fail, causing an error.
    #
    # Let's try a different approach: create a wrapper HTML that
    # provides the config via flashvars or ExternalInterface.
    
    # For now, let's just make a backup and try string replacement
    # Replace 'applicationDirectory' with 'documentDirectory\x00' (pad to same length)
    # Actually that won't work because the lengths are encoded in ABC
    
    # Let's check what Ruffle does with File class
    # If File is not available at all, the class resolution will fail
    # and the SWF will throw a VerifyError
    
    # The real fix is to provide a preloader that sets up GameConfig
    # before the main SWF runs
    
    # Let's create a preloader SWF instead
    print("Creating preloader approach instead...")
    return False

def create_preloader_html(web_dir):
    """
    Create a modified index.html that:
    1. Loads soul_config.xml via fetch
    2. Injects it into the SWF via ExternalInterface or flashvars
    """
    config_path = os.path.join(web_dir, 'soul_config.xml')
    
    # Ensure soul_config.xml exists in web dir
    if not os.path.exists(config_path):
        with open(config_path, 'w') as f:
            f.write("""<config>
    <defaultLocale>en_EN</defaultLocale>
    <locales>
        <locale id="ru_RU">Русский</locale>
        <locale id="en_EN">English</locale>
        <locale id="de_DE">Deutch</locale>
        <locale id="es_ES">Español</locale>
    </locales>
        <gameServer>127.0.0.1</gameServer>
        <loginServer>127.0.0.1:9090</loginServer>
        <portalServer>http://127.0.0.1:9090</portalServer>
        <staticServer>http://127.0.0.1:9090/web</staticServer>
        <updateFile>http://127.0.0.1:9090/static/update.xml</updateFile>
</config>""")
        print(f"Created {config_path}")
    
    return True

if __name__ == '__main__':
    web_dir = '/root/Game/server/web'
    create_preloader_html(web_dir)
    print("Done - created soul_config.xml in web directory")
