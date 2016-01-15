MODULE = friso SAu  wzip

all: $(MODULE)
	@for module in $(MODULE); \
	do \
	make -C $$module ; \
	done

.PHONY: clean
clean: $(MODULE)
	@for module in $(MODULE); \
	do \
	make -C $$module clean; \
	done

