
.PHONY: update-weave
update-weave: ##@development update weave
	$(CLI) bash ./etc/update-weave.sh
