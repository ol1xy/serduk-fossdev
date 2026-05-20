MAKEFLAGS += --no-print-directory
.PHONY: run shell clean test


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
	
	@echo "entering venv, type exit to quit"
	@PATH=$(shell pwd)/$(VENV)/bin:$$PATH bash

clean:
	rm -rf $(VENV)

check-requirements:
	@
	@grep -hE '^(import|from) [a-zA-Z0-9_]+' src/*.py | sed -E 's/^(import|from) ([a-zA-Z0-9_]+).*/\2/' | sort -u > .imports_temp; \
	> .missing_temp; \
	missing_count=0; \
	while read import; do \
		if ! $(PYTHON) -c "import $$import" 2>/dev/null; then \
			echo "Module '$$import' not founded in virtual environment"; \
			echo "$$import" >> .missing_temp; \
			missing_count=$$((missing_count + 1)); \
		fi; \
	done < .imports_temp; \
	rm -f .imports_temp; \
	\
	if [ "$$missing_count" -gt 0 ]; then \
		echo "Updating requirements.txt..."; \
		[ -n "$$(tail -c1 requirements.txt 2>/dev/null)" ] && echo "" >> requirements.txt; \
		cat .missing_temp >> requirements.txt; \
		echo "Installing required packages ($$missing_count)"; \
		$(PIP) install -r requirements.txt; \
		echo "All packages installed and updated"; \
	else \
		echo "All modules found"; \
	fi; \
	rm -f .missing_temp

lint: $(VENV)/bin/activate
	@echo "Run python-code linter 'flake8'"
	$(PYTHON) -m flake8 ./src

format: $(VENV)/bin/activate
	@echo "Run python-code formatter 'black'"

	$(PYTHON) -m black ./src

typecheck: $(VENV)/bin/activate
	@
	$(PYTHON) -m mypy src

test: $(VENV)/bin/activate
	@
	$(PYTHON) -m pytest tests

check: check-requirements lint format
	@echo "All checks started"
