#!/usr/bin/env python3
"""
S4RAS SSO Login Theme Asset Hash & Manifest Generator
Generates content-hashed CSS and JS filenames, updates theme.properties,
and records asset hashes for immutable caching and Cloudflare edge cache-busting.
"""

import os
import glob
import hashlib
import json
from datetime import datetime, timezone

THEME_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "theme", "s4ras", "login"))
CSS_DIR = os.path.join(THEME_DIR, "resources", "css")
JS_DIR = os.path.join(THEME_DIR, "resources", "js")
THEME_PROPS = os.path.join(THEME_DIR, "theme.properties")
MANIFEST_FILE = os.path.join(THEME_DIR, "asset-manifest.json")

def hash_content(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()[:8]

def build_assets():
    print(f"Building SSO Theme Assets in: {THEME_DIR}")
    os.makedirs(CSS_DIR, exist_ok=True)
    os.makedirs(JS_DIR, exist_ok=True)

    # 1. Process CSS
    css_src = os.path.join(CSS_DIR, "s4ras-login.css")
    if not os.path.exists(css_src):
        v_files = glob.glob(os.path.join(CSS_DIR, "s4ras-login-v*.css"))
        if v_files:
            css_src = sorted(v_files)[-1]
        else:
            raise FileNotFoundError(f"No source CSS found in {CSS_DIR}")

    with open(css_src, "rb") as f:
        css_data = f.read()
    css_hash = hash_content(css_data)
    css_target_name = f"s4ras-login.{css_hash}.css"
    css_target_path = os.path.join(CSS_DIR, css_target_name)

    # Clean old hashed css files
    for f in glob.glob(os.path.join(CSS_DIR, "s4ras-login.*.css")):
        if f != css_src and f != css_target_path:
            os.remove(f)

    with open(css_target_path, "wb") as f:
        f.write(css_data)
    print(f"  [CSS] Generated: {css_target_name} (hash: {css_hash})")

    # 2. Process JS files (s4ras-prefs.js and s4ras-pw.js)
    js_files_to_process = ["s4ras-prefs.js", "s4ras-pw.js"]
    generated_scripts = []
    js_manifest_info = {}

    for base_name in js_files_to_process:
        js_src = os.path.join(JS_DIR, base_name)
        if os.path.exists(js_src):
            with open(js_src, "rb") as f:
                js_data = f.read()
            h = hash_content(js_data)
            stem, ext = os.path.splitext(base_name)
            target_name = f"{stem}.{h}{ext}"
            target_path = os.path.join(JS_DIR, target_name)

            # Clean old hashed js files for this stem
            for f_old in glob.glob(os.path.join(JS_DIR, f"{stem}.*{ext}")):
                if f_old != js_src and f_old != target_path:
                    os.remove(f_old)

            with open(target_path, "wb") as f:
                f.write(js_data)
            print(f"  [JS]  Generated: {target_name} (hash: {h})")
            generated_scripts.append(f"js/{target_name}")
            js_manifest_info[stem] = {"file": target_name, "hash": h}

    # 3. Update theme.properties
    props_lines = [
        "parent=keycloak.v2",
        "locales=id,en",
        f"styles=css/{css_target_name}"
    ]
    if generated_scripts:
        props_lines.append(f"scripts={' '.join(generated_scripts)}")

    with open(THEME_PROPS, "w", encoding="utf-8") as f:
        f.write("\n".join(props_lines) + "\n")
    print(f"  [CONF] Updated {THEME_PROPS}")

    # 4. Write asset-manifest.json
    purge_targets = [
        f"https://sso.s4ras.site/resources/*/login/s4ras/css/{css_target_name}"
    ]
    for script_path in generated_scripts:
        purge_targets.append(f"https://sso.s4ras.site/resources/*/login/s4ras/{script_path}")

    manifest = {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "css_source": os.path.basename(css_src),
        "css_file": css_target_name,
        "css_hash": css_hash,
        "js_files": js_manifest_info,
        "theme_properties": {
            "parent": "keycloak.v2",
            "styles": f"css/{css_target_name}",
            "scripts": " ".join(generated_scripts)
        },
        "cloudflare_purge_targets": purge_targets
    }
    with open(MANIFEST_FILE, "w", encoding="utf-8") as f:
        json.dump(manifest, f, indent=2)
    print(f"  [MANIFEST] Written to {MANIFEST_FILE}")

    return manifest

if __name__ == "__main__":
    build_assets()
