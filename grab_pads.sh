#!/bin/bash
function clean_up {
	rm -f /var/tmp/bookclub_master_tidy.html
	rm -f /var/tmp/bookclub_master_parsed.html
	rm -f /var/tmp/all_urls
	rm -f /var/tmp/pad_urls
	rm -f /var/tmp/pad_filenames
}
trap "clean_up" EXIT SIGQUIT SIGTERM
curl https://pad.nfld.uk/p/bookclub_master/export/html | \
	tidy | tee /var/tmp/bookclub_master_tidy.html | \
	sed -e 's/pad\.nfld\.uk\/p/nfld\.uk/' > /var/tmp/bookclub_master_parsed.html
lynx -dump -listonly /var/tmp/bookclub_master_tidy.html > /var/tmp/all_urls
awk 'match($0, /\/pad/) { print $2 }' /var/tmp/all_urls > /var/tmp/pad_urls
mapfile -t PADS < /var/tmp/pad_urls
gawk 'match($0, /\/nfld.uk\/([a-zA-Z0-9_]*)/, i) { print i[1]".html" }' /var/tmp/bookclub_master_parsed.html | \
	uniq > /var/tmp/pad_filenames
mapfile -t FILENAMES < /var/tmp/pad_filenames
for i in "${!PADS[@]}"; do
	PAD_EXPORT="${PADS[i]}/export/html"
	ARCHIVE_NAME="${FILENAMES[i]}.old"
	if [[ -f "${FILENAMES[i]}" ]]; then
		cp "${FILENAMES[i]}" "${ARCHIVE_NAME}"
	fi
	curl "${PAD_EXPORT}" | tidy > "${FILENAMES[i]}"
done
cp bookclub_master.html bookclub_master.html.old
awk '{gsub(/\/nfld.uk\/[a-zA-Z0-9_]*/, "&.html")}1' /var/tmp/bookclub_master_parsed.html > ./bookclub_master.html
