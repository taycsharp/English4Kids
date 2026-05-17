#!/usr/bin/env bash
set -euo pipefail

if [ ! -f "ios/Runner/Info.plist" ]; then
  echo "ios/Runner/Info.plist not found. Run: flutter create ."
  exit 1
fi

if ! /usr/libexec/PlistBuddy -c "Print :NSMicrophoneUsageDescription" ios/Runner/Info.plist >/dev/null 2>&1; then
  /usr/libexec/PlistBuddy -c "Add :NSMicrophoneUsageDescription string 'This app needs microphone access to help children practice English pronunciation.'" ios/Runner/Info.plist
else
  /usr/libexec/PlistBuddy -c "Set :NSMicrophoneUsageDescription 'This app needs microphone access to help children practice English pronunciation.'" ios/Runner/Info.plist
fi

if ! /usr/libexec/PlistBuddy -c "Print :NSSpeechRecognitionUsageDescription" ios/Runner/Info.plist >/dev/null 2>&1; then
  /usr/libexec/PlistBuddy -c "Add :NSSpeechRecognitionUsageDescription string 'This app uses speech recognition to help children practice speaking English.'" ios/Runner/Info.plist
else
  /usr/libexec/PlistBuddy -c "Set :NSSpeechRecognitionUsageDescription 'This app uses speech recognition to help children practice speaking English.'" ios/Runner/Info.plist
fi

if [ -f "android/app/src/main/AndroidManifest.xml" ]; then
  if ! grep -q 'android.permission.RECORD_AUDIO' android/app/src/main/AndroidManifest.xml; then
    python3 - <<'PY'
from pathlib import Path
p = Path('android/app/src/main/AndroidManifest.xml')
s = p.read_text()
permission = '    <uses-permission android:name="android.permission.RECORD_AUDIO"/>\n'
if '<manifest' in s and '<application' in s and 'android.permission.RECORD_AUDIO' not in s:
    s = s.replace('<application', permission + '    <application', 1)
p.write_text(s)
PY
  fi
fi

echo "Permissions applied."
