#!/bin/bash

_fatal() {
    echo  "$@" >&2
    exit 1
}

test -n "$2" || _fatal "usage: $(basename $0) INPUT_UTTERANCE OUTPUT_FILE"

INPUT_UTTERANCE="$1"
OUTPUT_FILE="${2%.wav}"

# Payload for papago
MAKE_ID_URL=https://papago.naver.com/apis/tts/makeID
HMAC_KEY=v1.6.6_b84eb7dae4
PSEUDO_UUID=$(od -x /dev/urandom | head -1 | awk '{OFS="-"; print $2$3,$4,$5,$6,$7$8$9}')
TIMESTAMP=$(date +%s234)
TOKEN=$(echo -en "$UUID\n$MAKE_ID_URL\n$TIMESTAMP" | openssl dgst -md5 -hmac "$HMAC_KEY" -binary | base64)

# Get ID for download
TTS_ID=$(curl -sk -XPOST "$MAKE_ID_URL" \
    --data-urlencode "text=$INPUT_UTTERANCE" \
    --data-urlencode "speaker=kyuri" \
    -H "Authorization: PPG $UUID:$TOKEN" \
    -H "Timestamp: $TIMESTAMP" \
    | awk -F'"' '{print $4}')

# Download MP3
curl -sk "https://papago.naver.com/apis/tts/$TTS_ID" -o "$OUTPUT_FILE.mp3"
