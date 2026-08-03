import pandas as pd
import time
import re
import os
import signal
from deep_translator import GoogleTranslator

INPUT_FILE = 'products_general_08012026.csv'
OUTPUT_FILE = 'products_translated_final.csv'
PROGRESS_FILE = 'translation_progress.csv'

DELAY = 1.2
BATCH_SAVE = 50
MAX_RETRIES = 3

translator = GoogleTranslator(source='en', target='ka')

interrupted = False
def signal_handler(sig, frame):
    global interrupted
    print("\n\n⚠ Interrupted! Saving progress...", flush=True)
    interrupted = True
signal.signal(signal.SIGINT, signal_handler)

def split_html_segments(html):
    """Split HTML into translatable text and non-translatable tags.
    Tags are kept exactly as-is. Only text between tags is translated."""
    if not html or str(html).strip().lower() == 'nan':
        return []
    
    html = str(html)
    parts = re.split(r'(<[^>]+>)', html)
    segments = []
    for part in parts:
        if not part:
            continue
        if part.startswith('<') and part.endswith('>'):
            segments.append((part, False))
        else:
            text = part.strip()
            if text and text != '\xa0' and text != '&nbsp;':
                segments.append((part, True))
            else:
                segments.append((part, False))
    return segments

def translate_html(html):
    """Translate only visible text content inside HTML. Tags stay untouched."""
    if not html or str(html).strip().lower() == 'nan':
        return html
    
    html = str(html)
    segments = split_html_segments(html)
    if not segments:
        return html
    
    result_parts = []
    for text, should_translate in segments:
        if should_translate:
            text_to_translate = text.strip()
            if text_to_translate and text_to_translate != '\xa0':
                if re.search(r'[\u10a0-\u10ff]', text_to_translate):
                    result_parts.append(text)
                    continue
                
                translated = None
                for attempt in range(MAX_RETRIES):
                    try:
                        translated = translator.translate(text_to_translate[:4500])
                        time.sleep(DELAY)
                        break
                    except Exception as e:
                        print(f"    Retry {attempt+1}/{MAX_RETRIES}: {str(e)[:60]}", flush=True)
                        time.sleep(3 * (attempt + 1))
                
                if translated:
                    leading = text[:len(text) - len(text.lstrip())]
                    trailing = text[len(text.rstrip()):]
                    result_parts.append(leading + translated + trailing)
                else:
                    result_parts.append(text)
            else:
                result_parts.append(text)
        else:
            result_parts.append(text)
    
    return ''.join(result_parts)

def main():
    print(f"Loading CSV: {INPUT_FILE}", flush=True)
    df = pd.read_csv(INPUT_FILE, sep=';', encoding='utf-8')
    total = len(df)
    print(f"Total rows: {total}", flush=True)
    
    start_idx = 0
    if os.path.exists(PROGRESS_FILE):
        df_progress = pd.read_csv(PROGRESS_FILE, sep=';', encoding='utf-8')
        if len(df_progress) == total:
            df = df_progress
            for i, val in enumerate(df['Description']):
                original_val = pd.read_csv(INPUT_FILE, sep=';', encoding='utf-8')['Description'].iloc[i]
                if str(val) == str(original_val) and str(val).strip().lower() != 'nan' and str(val).strip():
                    start_idx = i
                    break
            else:
                start_idx = total
            print(f"Resuming from row {start_idx}", flush=True)
    
    to_translate = sum(1 for i in range(start_idx, total) 
                       if str(df.iloc[i]['Description']).strip().lower() not in ('nan', '', 'none'))
    print(f"Rows to translate: {to_translate}", flush=True)
    print(f"Estimated time: ~{to_translate * DELAY / 60:.0f} minutes", flush=True)
    print(flush=True)
    
    translated_count = 0
    skipped_count = 0
    
    for i in range(start_idx, total):
        if interrupted:
            break
        
        val = df.iloc[i]['Description']
        if pd.isna(val) or str(val).strip().lower() in ('nan', '', 'none'):
            skipped_count += 1
            continue
        
        original = str(val)
        
        georgian_chars = len(re.findall(r'[\u10a0-\u10ff]', original))
        total_chars = len(original)
        if total_chars > 0 and georgian_chars / total_chars > 0.5:
            print(f"  [{i+1}/{total}] Already Georgian, skipping", flush=True)
            skipped_count += 1
            continue
        
        print(f"  [{i+1}/{total}] Translating: {original[:60]}...", flush=True)
        
        try:
            translated = translate_html(original)
            df.at[i, 'Description'] = translated
            translated_count += 1
        except Exception as e:
            print(f"    ERROR: {str(e)[:80]}", flush=True)
        
        if translated_count > 0 and translated_count % BATCH_SAVE == 0:
            df.to_csv(PROGRESS_FILE, sep=';', encoding='utf-8', index=False)
            print(f"  --- Progress saved ({translated_count} translated) ---", flush=True)
    
    print(f"\n{'='*60}", flush=True)
    print(f"Translated: {translated_count}", flush=True)
    print(f"Skipped (empty/nan/already Georgian): {skipped_count}", flush=True)
    print(f"Saving to: {OUTPUT_FILE}", flush=True)
    
    df.to_csv(OUTPUT_FILE, sep=';', encoding='utf-8', index=False)
    
    if os.path.exists(PROGRESS_FILE) and not interrupted:
        os.remove(PROGRESS_FILE)
    
    print("Done!", flush=True)

if __name__ == '__main__':
    main()
