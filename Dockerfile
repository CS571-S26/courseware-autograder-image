FROM node:22

# Install OS-level dependencies commonly required by Playwright browsers
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		ca-certificates wget gnupg \
		libnss3 libatk1.0-0 libatk-bridge2.0-0 libgtk-3-0 libx11-xcb1 libxcomposite1 \
		libasound2 libxrandr2 libgbm1 libpangocairo-1.0-0 libatspi2.0-0 fonts-liberation \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /cs571
RUN useradd -m cs571bot && chown -R cs571bot:cs571bot /cs571

# Preinstall some dependencies to be ready at runtime.
COPY preinstalls.json /cs571/.preinstalls/package.json

RUN mkdir -p /home/cs571bot/.cache/ms-playwright && \
	cd /cs571/.preinstalls && \
	npm i --no-audit --no-fund && \
	PLAYWRIGHT_BROWSERS_PATH=/home/cs571bot/.cache/ms-playwright npx playwright install --with-deps && \
	# Ensure the installed node_modules and browser caches are owned by cs571bot
	chown -R cs571bot:cs571bot /cs571/.preinstalls /home/cs571bot/.cache/ms-playwright /home/cs571bot

COPY entrypoint.sh /cs571/entrypoint.sh
RUN chmod +x /cs571/entrypoint.sh && chown cs571bot:cs571bot /cs571/entrypoint.sh

RUN mkdir /cs571_go
RUN chown cs571bot:cs571bot /cs571_go

USER cs571bot

VOLUME ["/cs571/src", "/cs571/test", "/cs571/script.sh"]

# NOTE: script.sh is expected to be mounted at runtime to /cs571/script.sh; the entrypoint normalizes CRLF and runs it.
ENTRYPOINT ["/cs571/entrypoint.sh"]
