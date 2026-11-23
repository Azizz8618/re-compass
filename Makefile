ARCHIVE ?= $(HOME)/Рабочий стол/БЭСМ-6/Ильин_дискеты_февраль_2022.zip
SCRATCH ?= /tmp/re-compass-ilyin
IMAGES ?= /usr/local/share/besm6/2048 /usr/local/share/besm6/2053 /usr/local/share/besm6/2113 /usr/local/share/besm6/2248 /usr/local/share/besm6/2348

.PHONY: help extract scan check mars-check smoke

help:
	@printf 'цели: extract, scan, check, mars-check, smoke\n'
	@printf 'переменные: ARCHIVE, SCRATCH, IMAGES\n'

extract:
	bash tools/extract_ilyin.sh "$(ARCHIVE)" "$(SCRATCH)"

scan:
	bash tools/find_besm_artifacts.sh $(IMAGES)

check:
	bash -n tools/extract_ilyin.sh
	bash -n tools/find_besm_artifacts.sh
	bash -n tools/mars_check.sh
	bash -n tools/run_smoke.sh
	bash -n tools/run_kompas_suite.sh
	python3 -m py_compile tools/are_decode.py
	python3 -m py_compile tools/are_to_mars.py
	python3 -m py_compile tools/are_to_mars_multi.py
	python3 -m py_compile tools/check_zone_changes.py
	python3 -m py_compile tools/severov/analyze_tsspr.py
	python3 -m py_compile tools/severov/extract_and_gen.py
	python3 -m py_compile tools/severov/prt_pas_map.py
	bash -n tools/severov/check_decks.sh
	python3 -m py_compile tools/mars/parse_words.py
	python3 -m py_compile tools/severov/mkfront.py
	python3 -m py_compile tools/severov/extract_gold.py
	python3 -m py_compile tools/severov/genmad_make_deck.py
	python3 -m py_compile tools/severov/run_all_tests.py
	python3 -m py_compile tools/severov/ttc_make_deck.py
	@printf 'синтаксис скриптов: OK\n'

mars-check:
	bash tools/mars_check.sh

smoke:
	bash tools/run_smoke.sh

WORK ?= /tmp/.private/azizz/severov-all

test-all:
	python3 tools/severov/run_all_tests.py --work $(WORK)
