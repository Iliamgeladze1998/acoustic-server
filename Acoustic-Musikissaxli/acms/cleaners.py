#!/usr/bin/env python3
"""
Global Data Cleaners for Music Instrument Data
Provides common cleaning functions for music instrument model names
"""

import re
import pandas as pd
from typing import List, Dict, Optional
from fuzzywuzzy import fuzz, process

class MusicInstrumentCleaner:
    """Global cleaner for music instrument data"""
    
    def __init__(self):
        # Common music instrument patterns and replacements
        self.instrument_patterns = {
            # Guitar types
            r'\b(?:electric|acoustic|classical|nylon|steel|folk|jazz|blues|rock|metal)\s+guitar\b': 'guitar',
            r'\b(?:lead|rhythm|bass)\s+guitar\b': 'guitar',
            r'\b(?:guitar|gitara|gitarr)\b': 'guitar',
            
            # Piano/Keyboard
            r'\b(?:piano|keyboard|digital\s+piano|synthesizer|synth|organ|electric\s+piano)\b': 'piano',
            r'\b(?:piano|pianino|klaviatura)\b': 'piano',
            
            # Drums/Percussion
            r'\b(?:drum|drums|percussion|snare|bass\s+drum|tom|cymbal|hihat|hi-hat)\b': 'drums',
            r'\b(?:drum|baraban|tsymbali|tarelka)\b': 'drums',
            
            # String instruments
            r'\b(?:violin|viola|cello|double\s+bass|contrabass|fiddle)\b': 'violin',
            r'\b(?:violin|skripka|alt|violonchelo|kontrabas)\b': 'violin',
            
            # Wind instruments
            r'\b(?:saxophone|sax|clarinet|flute|oboe|bassoon|trumpet|trombone|tuba|horn)\b': 'wind',
            r'\b(?:saxophone|saksofon|klarnet|fleita|truba|trombon)\b': 'wind',
            
            # Common suffixes/prefixes to clean
            r'\b(?:professional|pro|deluxe|premium|standard|basic|beginner|student)\b': '',
            r'\b(?:new|original|authentic|genuine|official)\b': '',
            r'\b(?:with|for|and|or|plus|extra|additional)\b': '',
            
            # Brand names to clean (keep only model)
            r'\b(?:fender|gibson|yamaha|ibanez|taylor|martin|seagull|epiphone|squier)\b': '',
            r'\b(?:roland|korg|nord|casio|kawai|steinway|bosendorfer)\b': '',
            
            # Numbers and codes
            r'\b(?:model|no|number|num|code|sku|item)\s*[:#]?\s*\w+': '',
            r'\b\d{2,4}\b': '',  # Remove 2-4 digit numbers (likely years/codes)
            
            # Color variations
            r'\b(?:black|white|red|blue|green|yellow|brown|natural|sunburst|cherry|maple|rosewood)\b': '',
            
            # Common noise
            r'[^\w\s-]': '',  # Remove special characters except letters, numbers, spaces, hyphens
            r'\s+': ' ',  # Normalize spaces
            r'^\s+|\s+$': '',  # Trim
        }
        
        # Music instrument categories for fuzzy matching
        self.instrument_categories = {
            'guitar': ['guitar', 'gitara', 'gitarr', 'acoustic', 'electric', 'classical'],
            'piano': ['piano', 'pianino', 'keyboard', 'synthesizer', 'organ', 'digital'],
            'drums': ['drums', 'drum', 'baraban', 'percussion', 'cymbal', 'snare'],
            'violin': ['violin', 'skripka', 'viola', 'cello', 'fiddle', 'contrabass'],
            'wind': ['saxophone', 'saksofon', 'flute', 'trumpet', 'clarinet', 'trombone'],
            'bass': ['bass', 'bass guitar', 'double bass', 'contrabass'],
            'ukulele': ['ukulele', 'ukelele'],
            'mandolin': ['mandolin', 'mandoline'],
        }
    
    def clean_text(self, text: str) -> str:
        """Apply regex patterns to clean text"""
        if pd.isna(text) or not isinstance(text, str):
            return ""
        
        text = text.lower().strip()
        
        # Apply all cleaning patterns
        for pattern, replacement in self.instrument_patterns.items():
            text = re.sub(pattern, replacement, text, flags=re.IGNORECASE)
        
        # Clean up multiple spaces
        text = re.sub(r'\s+', ' ', text).strip()
        
        return text
    
    def extract_model(self, name: str) -> str:
        """Extract clean model name from product name"""
        if pd.isna(name) or not isinstance(name, str):
            return ""
        
        # First pass: regex cleaning
        cleaned = self.clean_text(name)
        
        # Second pass: fuzzy matching to identify instrument type
        instrument_type = self.identify_instrument_type(cleaned)
        
        # Third pass: extract model-specific terms
        model = self.extract_model_terms(cleaned, instrument_type)
        
        return model.strip()
    
    def identify_instrument_type(self, text: str) -> str:
        """Use fuzzy matching to identify instrument type"""
        best_match = None
        best_score = 0
        
        for category, keywords in self.instrument_categories.items():
            for keyword in keywords:
                score = fuzz.partial_ratio(text.lower(), keyword)
                if score > best_score and score > 70:  # Threshold for fuzzy match
                    best_score = score
                    best_match = category
        
        return best_match or "unknown"
    
    def extract_model_terms(self, text: str, instrument_type: str) -> str:
        """Extract model-specific terms based on instrument type"""
        # Remove the instrument type from text to get model
        model_text = text.lower()
        
        # Remove category keywords
        if instrument_type != "unknown":
            for keyword in self.instrument_categories[instrument_type]:
                model_text = model_text.replace(keyword, "")
        
        # Clean up remaining text
        model_text = re.sub(r'\s+', ' ', model_text).strip()
        
        # If too short, return original cleaned text
        if len(model_text) < 3:
            return text
        
        return model_text.title()  # Capitalize properly
    
    def clean_dataframe(self, df: pd.DataFrame, name_column: str = 'NAME') -> pd.DataFrame:
        """Apply cleaning to entire dataframe"""
        df = df.copy()
        
        # Create CLEAN_MODEL column
        df['CLEAN_MODEL'] = df[name_column].apply(self.extract_model)
        
        # Add instrument type column
        df['INSTRUMENT_TYPE'] = df['CLEAN_MODEL'].apply(
            lambda x: self.identify_instrument_type(x) if x else "unknown"
        )
        
        return df
    
    def get_cleaning_stats(self, df: pd.DataFrame) -> Dict:
        """Get statistics about cleaning results"""
        total = len(df)
        non_empty = len(df[df['CLEAN_MODEL'].str.len() > 0])
        instrument_types = df['INSTRUMENT_TYPE'].value_counts().to_dict()
        
        return {
            'total_products': total,
            'successfully_cleaned': non_empty,
            'success_rate': f"{(non_empty/total)*100:.1f}%",
            'instrument_distribution': instrument_types
        }

# Utility functions for specific cleaning tasks
def remove_brand_names(text: str) -> str:
    """Remove common brand names from text"""
    brands = [
        'fender', 'gibson', 'yamaha', 'ibanez', 'taylor', 'martin', 'seagull',
        'epiphone', 'squier', 'roland', 'korg', 'nord', 'casio', 'kawai',
        'steinway', 'bosendorfer', 'pearl', 'zildjian', 'sabian', 'paiste'
    ]
    
    for brand in brands:
        text = re.sub(rf'\b{brand}\b', '', text, flags=re.IGNORECASE)
    
    return text.strip()

def normalize_colors(text: str) -> str:
    """Remove color descriptions from model names"""
    colors = [
        'black', 'white', 'red', 'blue', 'green', 'yellow', 'brown',
        'natural', 'sunburst', 'cherry', 'maple', 'rosewood', 'ebony',
        'tobacco', 'amber', 'vintage', 'aged', 'relic'
    ]
    
    for color in colors:
        text = re.sub(rf'\b{color}\b', '', text, flags=re.IGNORECASE)
    
    return text.strip()

def extract_series_number(text: str) -> Optional[str]:
    """Extract series/model numbers from text"""
    # Common patterns for model numbers
    patterns = [
        r'\b([A-Z]{1,3}\d{2,4})\b',  # Letter + numbers (e.g., RG550, LP100)
        r'\b(\d{3,4}[A-Z]?)\b',   # Numbers + optional letter (e.g., 335, 175)
        r'\b([A-Z]{2,4}-\d{2,4})\b',  # Dash format (e.g., SG-200)
        r'\b(\d{2,3}\.\d)\b',  # Decimal format (e.g., 2.0, 3.5)
    ]
    
    for pattern in patterns:
        match = re.search(pattern, text.upper())
        if match:
            return match.group(1)
    
    return None
