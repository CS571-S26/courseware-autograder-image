
ARG GRADESCOPE_VERSION=ubuntu-jammy

FROM gradescope/autograder-base:${GRADESCOPE_VERSION}

# NOTE: Playwright version is locked in within preinstalls/package.json.
ARG NODE_VERSION=22
ARG HTTP_SERVER_VERSION=14.1.1

# Install Node.js (LTS) from NodeSource
RUN apt-get update \
	&& apt-get install -y --no-install-recommends curl ca-certificates gnupg \
	&& curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
	&& apt-get install -y --no-install-recommends nodejs \
	&& rm -rf /var/lib/apt/lists/* \
	&& ln -sf /usr/bin/npm /usr/local/bin/npm || true \
	&& ln -sf /usr/bin/npx /usr/local/bin/npx || true

# Install OS-level dependencies commonly required by Playwright browsers
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		ca-certificates wget gnupg \
		libnss3 libatk1.0-0 libatk-bridge2.0-0 libgtk-3-0 libx11-xcb1 libxcomposite1 \
		libasound2 libxrandr2 libgbm1 libpangocairo-1.0-0 libatspi2.0-0 fonts-liberation \
	&& rm -rf /var/lib/apt/lists/*

# Preinstall some dependencies to be ready at runtime.
COPY preinstalls /autograder/.preinstalls
RUN mkdir -p /home/root/.cache/ms-playwright && \
	cd /autograder/.preinstalls && \
	npm ci --no-audit --no-fund && \
	PLAYWRIGHT_BROWSERS_PATH=/home/root/.cache/ms-playwright npx playwright install chromium --with-deps
RUN npm i -g http-server@${HTTP_SERVER_VERSION}
