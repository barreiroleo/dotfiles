# If the first argument is "install"...
ifeq (install,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "install"
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)
endif

.PHONY: install
install:
	# @echo $(RUN_ARGS)
	sh ./scripts/query_install.sh $(RUN_ARGS)
