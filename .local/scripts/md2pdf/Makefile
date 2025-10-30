PWD = $(shell pwd)
PANDOC_CMD = docker run --rm --volume "$(PWD):/data" pandoc/extra \
    $^ \
    -o $@ \
    --template eisvogel \
	--syntax-highlighting=idiomatic \
    --number-sections


YELLOW   = \033[1;33m
BLUE     = \033[0;34m
GREEN    = \033[0;32m
NC       = \033[0m 

# Compile all markdown files to pdf of the parent folder
all: $(patsubst %.md,%.pdf,$(wildcard *.md))

%.pdf : %.md
	@printf "$(YELLOW)--> Compiling: $(BLUE)%s$(NC)\n" "$@"
	@$(PANDOC_CMD)
	#@chmod 664 $@
	@printf "$(GREEN) ✔ Successfully created $(BLUE)%s.pdf$(NC)\n" "$@"

