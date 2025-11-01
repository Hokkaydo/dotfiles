#!/bin/bash

wl-copy -c

MD2PDF_DIR="$HOME/.local/scripts/md2pdf"

for FILE in "$@"; do
    FILENAME="${FILE// /_}"                      # replace spaces by underscores
    BASENAME=$(basename "$FILENAME")             # just the filename
    EXT="${BASENAME##*.}"                        # file extension
    NAME="${BASENAME%.*}"                        # name without extension

    if [[ "$BASENAME" != *"."* ]]; then
        notify-send "Invalid file $BASENAME"
        continue
    fi

    # If Markdown: build a PDF
    if [[ "$EXT" == "md" ]]; then
        BUILD_DIR=$MD2PDF_DIR
        PDF_PATH="$BUILD_DIR/$NAME.pdf"

        mkdir -p "$BUILD_DIR"
        cp "$FILE" "$BUILD_DIR/$NAME.md"

        pushd "$BUILD_DIR" >/dev/null
        make
        MAKE_STATUS=$?
        popd >/dev/null
        
        rm "$BUILD_DIR/$NAME.md"
        if [[ $MAKE_STATUS -ne 0 || ! -f "$PDF_PATH" ]]; then
            notify-send "Failed to build PDF for $BASENAME"
            continue
        fi

        FILE="$PDF_PATH"
        BASENAME="$NAME.pdf"
    fi

    scp "$FILE" "hokkaydo@hokkaydo.be:/home/hokkaydo/www/notes/$BASENAME"
    if [[ "$EXT" == "md" ]]; then
        rm "$FILE"
    fi

    if [[ $? -ne 0 ]]; then
        notify-send "Couldn't upload $BASENAME"
        continue
    fi

    url="https://hokkaydo.be/notes/$BASENAME"
    wl-copy "$(wl-paste)$(echo -e -n "$url")"
    notify-send "$BASENAME uploaded"
done

exit
