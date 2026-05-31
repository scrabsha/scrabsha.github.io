main:
    make

clean:
    make clean

serve: main
    python -m http.server --directory build/html

watch:
    cp env.toml.local .env
    watchexec --ignore build --ignore .env -- make
