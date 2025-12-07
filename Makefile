# Input directories
content_dir := content
style_dir := style

typst_version := v0.14.1
typst := build/typst_$(typst_version)

# Output directory
target_dir := build/html

articles_dir := $(content_dir)/articles
index := $(articles_dir)/index.txt

html_files := $(shell find $(content_dir) -name '*.typ' | sed 's|^$(content_dir)\(.*\)\.typ|$(target_dir)\1.html|')
articles := $(shell find $(articles_dir) -name '*.typ')
css_files := $(shell find $(style_dir) -name '*.css' | sed 's|^$(style_dir)|$(target_dir)|')

main: $(html_files) $(css_files)

clean:
	rm -rf $(target_dir) build
	rm -f $(index)

$(target_dir)/articles.html: $(articles) $(index)

$(target_dir)/%.html: $(content_dir)/%.typ lib $(typst)
	mkdir -p $(shell dirname $@)
	$(typst) compile \
	    --features html \
	    --format html \
	    --root . \
	    $< \
	    $@

$(target_dir)/%.css: $(style_dir)/%.css
	cp $< $@

$(index): $(content_dir)/articles/*.typ
	ls $(content_dir)/articles/*.typ \
	| xargs -n1 basename \
	> $@

$(typst):
	mkdir -p $(shell dirname $(typst))
	curl -Lf https://github.com/typst/typst/releases/download/v0.14.1/typst-x86_64-unknown-linux-musl.tar.xz -o build/typst.tar.xz
	tar -xf build/typst.tar.xz \
		-C build \
		typst-x86_64-unknown-linux-musl/typst \
		--strip-components=1
	mv build/typst $(typst)
