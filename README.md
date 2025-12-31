# courseware-autograder-image

This Docker image runs Playwright JS tests mounted from the host against a mounted web project with a mounted script.

Overview
- Mount runner script to `/cs571/script.sh`, student source to `/cs571/src`, and Playwright tests to `/cs571/test` when running the container.
- The image preinstalls Playwright, its browser binaries, and a lightweight static server (`http-server`) at build time so runs are fast and deterministic.

Expected Mounts
- `/cs571/script.sh` —  runner script
- `/cs571/src` — student/source files (HTML/CSS/JS or a React/Vite project)
- `/cs571/test` — Playwright tests (JS)

## Build

```powershell
docker build -t ctnelson1997/cs571-playwright .
```

## Run
```powershell
docker run --rm -v ${PWD}/src:/cs571/src:ro -v ${PWD}/test:/cs571/test:ro -v ${PWD}/script.sh:/cs571/script.sh:ro --shm-size=2g ctnelson1997/cs571-playwright HTML
```

See `courseware-autograder-script` for script parameters like `HTML` and `REACT`.
