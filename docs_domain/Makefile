.PHONY: shell

VENV = .venv
PYTHON = $(VENV)/bin/python
PIP = $(VENV)/bin/pip

$(VENV)/bin/activate: requirements.txt
	python3 -m venv $(VENV)
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt
	touch $(VENV)/bin/activate


run: $(VENV)/bin/activate
	$(PYTHON) src/app.py

shell: $(VENV)/bin/activate

create-structure:
	mkdir src tests docs
	touch README.md setup.py requirements.txt
	touch docs/DOMAIN.md
	touch src/.gitkeep tests/.gitkeep

install-dep:
	pip install -r requirements.txt

install:
	pip install -e .

test-pytest:
	python3 -m pytest

test: install-dep install test-pytest