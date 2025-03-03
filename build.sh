FILE_PATH="$1"

if [ -f "$FILE_PATH" ]; then
  cp "$FILE_PATH" storage/
  export TEXT_FILE_PATH="storage/$(basename $FILE_PATH)"
  bundle install
else
  echo "File does not exist: $FILE_PATH"
  exit 1
fi
