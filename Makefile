# targets that aren't filenames
.PHONY: all clean deploy build serve

all: build


ifdef IN_NIX_SHELL
JEKYLL=jekyll
else
JEKYLL=bundler exec jekyll
endif


build:
	$(JEKYLL) build

# you can configure these at the shell, e.g.:
# SERVE_PORT=5001 make serve
SERVE_HOST ?= 127.0.0.1
SERVE_PORT ?= 5000

serve:
	$(JEKYLL) serve --port $(SERVE_PORT) --host $(SERVE_HOST)

clean:
	$(RM) -r _site

DEPLOY_PATH ?= mwillsey.com:/var/www/mwillsey.com/
RSYNC := rsync --compress --recursive --checksum --itemize-changes --delete \
	     --perms --owner --group --times -e ssh --chmod=g-w --chown=:web

deploy: clean build
	$(RSYNC) _site/ $(DEPLOY_PATH)
