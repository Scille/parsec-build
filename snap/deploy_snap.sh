docker run -v $(pwd):$(pwd) --rm -t snapcore/snapcraft:stable sh -c "
    cd $(pwd)/snap &&
    snapcraft push parsec_*.snap --release edge
"
