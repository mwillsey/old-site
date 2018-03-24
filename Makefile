# targets that aren't filenames
.PHONY: all clean deploy build serve

all: build

build:
	jekyll build

# you can configure these at the shell, e.g.:
# SERVE_PORT=5001 make serve
SERVE_HOST ?= 127.0.0.1
SERVE_PORT ?= 5000

serve:
	jekyll serve --port $(SERVE_PORT) --host $(SERVE_HOST)

clean:
	$(RM) -r _site

DEPLOY_HOST ?= mwillsey.com
DEPLOY_PATH ?= /srv/http/mwillsey.com/
RSYNC := rsync --compress --recursive --checksum --itemize-changes --delete \
	     --perms --owner --group --times -e ssh --chmod=g-w --chown=:web

deploy: clean build
	$(RSYNC) _site/ $(DEPLOY_HOST):$(DEPLOY_PATH)