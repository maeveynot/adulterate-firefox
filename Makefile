DEST := /opt/firefox
OVERLAY_BROWSER_FILES := $(shell find overlay/browser -name .gitkeep -prune -o -type f -print)
OVERLAY_OTHER_FILES := $(shell find overlay -path overlay/browser -prune -o -name .gitkeep -prune -o -type f -print)

firefox/omni.ja firefox/browser/omni.ja:
	@./extract-from-latest-tarball $@

patched/omni.ja: firefox/omni.ja $(OVERLAY_OTHER_FILES)
	@./repack-zip-with-overlay -i $< -o $@ -r overlay $(OVERLAY_OTHER_FILES)
patched/browser/omni.ja: firefox/browser/omni.ja $(OVERLAY_BROWSER_FILES)
	@./repack-zip-with-overlay -i $< -o $@ -r overlay/browser $(OVERLAY_BROWSER_FILES)

$(DEST)/%.ja: patched/%.ja
	@./install-firefox-jar $< $@

.DEFAULT_GOAL := all
.PHONY: all
all: patched/omni.ja patched/browser/omni.ja

.PHONY: install
install: $(DEST)/omni.ja $(DEST)/browser/omni.ja

.PHONY: clean
clean:
	@rm -f firefox/omni.ja firefox/browser/omni.ja patched/omni.ja patched/browser/omni.ja
