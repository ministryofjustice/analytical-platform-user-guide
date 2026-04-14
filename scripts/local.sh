#!/usr/bin/env bash

MODE="${1:-preview}"
TECH_DOCS_PUBLISHER_IMAGE="ghcr.io/ministryofjustice/tech-docs-github-pages-publisher@sha256:8b00235edfa4d1248e3cdd08c022d5f398c7f4abb3315b6078f1e876214a171e" # v6.2.0

case ${MODE} in
package | preview)
  true
  ;;
*)
  echo "Usage: ${0} [package|preview]"
  exit 1
  ;;
esac

if [[ "$(uname -m)" == "aarch64" ]] || [[ "$(uname -m)" == "arm64" ]]; then
  PLATFORM_FLAG="--platform=linux/amd64"
else
  PLATFORM_FLAG=""
fi

docker run -it --rm "${PLATFORM_FLAG}" \
  --name "tech-docs-${MODE}" \
  --publish 4567:4567 \
  --volume "${PWD}/config:/tech-docs-github-pages-publisher/config" \
  --volume "${PWD}/source:/tech-docs-github-pages-publisher/source" \
  "${TECH_DOCS_PUBLISHER_IMAGE}" "/usr/local/bin/${MODE}"
