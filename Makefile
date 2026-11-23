ARCHIVE ?= $(HOME)/Рабочий стол/БЭСМ-6/Ильин_дискеты_февраль_2022.zip
SCRATCH ?= /tmp/re-compass-ilyin
IMAGES ?= /usr/local/share/besm6/2048 /usr/local/share/besm6/2053 /usr/local/share/besm6/2113 /usr/local/share/besm6/2248 /usr/local/share/besm6/2348

.PHONY: help extract scan check

help:
	@printf 'цели: extract, scan, check\n'
	@printf 'переменные: ARCHIVE, SCRATCH, IMAGES\n'

extract:
	bash tools/extract_ilyin.sh "$(ARCHIVE)" "$(SCRATCH)"

scan:
	bash tools/find_besm_artifacts.sh $(IMAGES)

check:
	bash -n tools/extract_ilyin.sh
	bash -n tools/find_besm_artifacts.sh
	@printf 'синтаксис скриптов: OK\n'
