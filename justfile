main:
    make

clean:
    make clean

serve: main
    python -m http.server --directory build/html

watch:
    watchexec --ignore build -- make
