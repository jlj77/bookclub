#!/bin/bash
RSS_FILE="rss.xml"
#
# RSS 1.0 header
publish_header() {
    echo '<?xml version="1.0" encoding="UTF-8"?>'
    echo ''
    echo '<rdf:RDF'
    echo '  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'
    echo '  xmlns="http://purl.org/rss/1.0/"'
    echo '  xmlns:dc="http://purl.org/dc/elements/1.1/"'
    echo '>'
    echo ''
    echo '<channel rdf:about="https://nfld.uk/rss.xml">'
    echo '  <title>Book club @ nfld files</title>'
    echo '  <link>https://nfld.uk</link>'
    echo '  <description>The latest book club discussions, nominations, etc.</description>'
    echo '</channel>'
}

publish_items() {
    DATE=$(date)
    FILES="*html"
    for FILENAME in $FILES
    do
        if [[ -f "${FILENAME}" ]]; then
            ARCHIVE_NAME="${FILENAME}.old"
            if [[ -f "${ARCHIVE_NAME}" ]]; then
                echo "Processing ${FILENAME}..."
                DIFF_OUT=$(wdiff -3 "${FILENAME}" "${ARCHIVE_NAME}")
                if [[ $? == 1 ]]; then
                    printf "\n<item rdf:about=\"https://nfld.uk/%s\">\n" "$FILENAME" >> $RSS_FILE
                    printf "  <title><![CDATA[Recent updates to %s]]></title>\n" "$FILENAME" >> $RSS_FILE
                    printf "  <link>https://nfld.uk/%s</link>\n" "$FILENAME" >> $RSS_FILE
                    printf "  <dc:date>%s</dc:date>\n" "$DATE" >> $RSS_FILE
                    printf "  <description><![CDATA[%s]]></description>\n" "$DIFF_OUT" >> $RSS_FILE
                    printf "</item>\n\n" >> $RSS_FILE
                fi
            fi
        fi
    done
}

publish_header > $RSS_FILE
publish_items
echo "</rdf:RDF>" >> $RSS_FILE
echo "Feed complete."
