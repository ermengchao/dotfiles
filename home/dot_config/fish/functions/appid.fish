function appid
  if test (count $argv) -eq 0
    echo "Usage: appid <Application>, such as 'appid Xcode'"
      return 1
  end
  set id (osascript -e "id of app \"$argv[1]\"")
  echo "🍎 Bundle ID: $id"
  echo "📂 Plist File Path：$HOME/Library/Preferences/$id.plist"
end
