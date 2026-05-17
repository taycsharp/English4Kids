# Happy English Kids

A colorful Flutter MVP for children aged 5–10 who are starting to learn English.

## Included features

- Home screen with stars and child profile
- Topic selection screen
- Vocabulary learning with text-to-speech
- Pronunciation practice with speech recognition
- Listening game
- Picture quiz
- Sentence speaking practice
- Progress dashboard
- Parent settings
- Local progress saving with `shared_preferences`
- Reward dialog with confetti
- 8 topics × 10 words = 80 words

## Important revision notes

This revised version fixes the runtime red-screen error:

`dependOnInheritedWidgetOfExactType<AppScope>() ... was called before initState() completed`

The fix is in `lib/app.dart`, where `AppScope.of(context)` now reads the inherited widget without registering a dependency. This is safe here because `AppScope` only provides long-lived services.

It also fixes the default Flutter test error by adding `test/widget_test.dart` using `HappyEnglishKidsApp`, and updates deprecated `DropdownButtonFormField.value` usage to `initialValue`.

## Create a full Flutter project shell

If this ZIP only contains source files, create the platform folders first:

```bash
cd /Users/klc/Downloads/happy_english_kids
flutter create .
```

Then copy this ZIP content into that project folder if needed.

## Install dependencies

```bash
flutter pub get
```

## Apply iOS and Android permissions

After `flutter create .`, run:

```bash
bash tools/apply_platform_permissions.sh
```

The script adds these iOS keys:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access to help children practice English pronunciation.</string>

<key>NSSpeechRecognitionUsageDescription</key>
<string>This app uses speech recognition to help children practice speaking English.</string>
```

And this Android permission:

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
```

## Test on iOS Simulator

```bash
open -a Simulator
flutter devices
flutter analyze
flutter test
flutter run -d "iPhone 16e"
```

If your simulator has a different name, use the exact name from `flutter devices`.

## Test on real iPhone

```bash
flutter devices
flutter run -d "Tay’s iPhone"
```

Speech recognition is usually more reliable on a real iPhone than on Simulator.

## Future upgrades

- Real images instead of emojis
- Native audio recordings
- AI pronunciation scoring
- Parent dashboard
- Multiple child profiles
- Daily learning plan
- Offline lessons
- Backend sync
- Firebase authentication
- Teacher mode
- Vietnamese parent guide
- English-only child mode

## Stability note
This package version removes the Confetti overlay from the reward dialog and uses a simple dialog instead. This avoids repeated `!semantics.parentDataDirty` debug assertions seen on some iOS Simulator / Flutter combinations after opening reward popups.
