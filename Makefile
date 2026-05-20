.DEFAULT_GOAL := help

MAKEFLAGS += --no-print-directory
.PHONY: run shell clean test dump

DIR ?= .
OUTPUT_FILE = project_summary.txt
EXCLUDE_DIRS = -not -path "*/.*" -not -path "*node_modules*" -not -path "*venv*" -not -path "*__pycache__" -not -path "*build*" -not -path "*dist*"
EXCLUDE_FILES = -not -name "$(OUTPUT_FILE)" -not -name "Makefile" -not -name "*.log"

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

help:
	@echo "This makefile for repo-level activity"

create-practice:
ifndef PRACTICE
	$(error must pass val via PRACTICE)
endif
	@echo "Creating practice"	
	mkdir -p ${PRACTICE}
	cp PracticeMakefile $(PRACTICE)/Makefile

remove-practice:
ifndef PRACTICE
	$(error must pass val via PRACTICE)
endif
	rm -rf ${PRACTICE}

dump:
	@if command -v tree >/dev/null 2>&1; then \
		tree -I ".git|node_modules|venv|__pycache__|build|dist" $(DIR) >> $(OUTPUT_FILE); \
	else \
		find $(DIR) $(EXCLUDE_DIRS) $(EXCLUDE_FILES) | sort | sed 's|[^/]*/|    |g' >> $(OUTPUT_FILE); \
	fi
	@find $(DIR) -type f $(EXCLUDE_DIRS) $(EXCLUDE_FILES) | sort | while read -r file; do \
		echo "\n-------------------------------------------------------------------------------" >> $(OUTPUT_FILE); \
		echo "FILE: $$file" >> $(OUTPUT_FILE); \
		echo "-------------------------------------------------------------------------------" >> $(OUTPUT_FILE); \
		if command -v file >/dev/null 2>&1; then \
			if file "$$file" | grep -qE "text|JSON|XML|source"; then \
				cat "$$file" >> $(OUTPUT_FILE); \
			else \
				echo "[Skipped:]" >> $(OUTPUT_FILE); \
			fi; \
		else \
			cat "$$file" >> $(OUTPUT_FILE) 2>/dev/null; \
		fi; \
		echo "" >> $(OUTPUT_FILE); \
	done
	@echo "Successfully saved in $(OUTPUT_FILE)"
# mkdir demo-practice
# mkdir demo-practice/src
# mkdir demo-practice/tests
# mkdir demo-practice/docs
# mkdir demo-practice/README.md