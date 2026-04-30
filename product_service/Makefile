PORT ?= 8001
HOST ?= 127.0.0.1

APP_MODULE = src.app.main:app

.PHONY: run-product run-order run-services

create-structure:
	mkdir src tests docs
	touch README.md setup.py requirements.txt
	touch docs/DOMAIN.md
	touch src/.gitkeep tests/.gitkeep
	touch docs/SPECIFICATION.md

install-dep:
	pip install -r requirements.txt

install:
	pip install -e .

test-pytest:
	python3 -m pytest

run-product:
	@echo "Starting Product Service on port $(PORT)..."
	poetry run uvicorn $(APP_MODULE) --host $(HOST) --port $(PORT) &

run-order:
	@echo "Starting Product Service on port $(PORT)..."
	PRODUCT_SERVICE_URL=http://$(HOST):$(PORT) poetry run uvicorn $(APP_MODULE) --host $(HOST) --port 8002 &

run-services: run-product run-order
