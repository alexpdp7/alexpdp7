$ podman run -it --rm -v $PWD:/workspace -v ...auth.json:/home/cnb/.docker/config.json --security-opt label=disable docker.io/paketobuildpacks/builder-jammy-full /cnb/lifecycle/creator -app /workspace quay.io/alexpdp7/blog