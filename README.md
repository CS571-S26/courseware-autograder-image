# courseware-autograder-image
Contains the base autograder image, built off `gradescope/autograder-base`. This image contains node, npm, and playwright dependencies pre-installed. **Not to be used standalone**, intended for use as a base image for other course autograders.

## Updating
Playwright versions are locked in the ci process for consistency. To update, edit `preinstalls/package.json` with the latest dependencies and run `npm i` *before* the docker build process prescribed below.

## Build
```bash
docker build -t ctnelson1997/cs571-f25-autograder-image .
docker push ctnelson1997/cs571-f25-autograder-image
```

## Use
```docker
FROM ctnelson1997/cs571-f25-autograder-image
```
