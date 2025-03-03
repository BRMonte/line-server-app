echo "Installing dependencies with bundle..."
bundle install

if [ -z "$1" ]; then
  echo "No file provided, exiting..."
  exit 1
fi

FILE="$1"

echo "Copying $FILE to storage/..."
cp "$FILE" storage/
