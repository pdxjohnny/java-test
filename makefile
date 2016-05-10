mkfile_path=$(abspath $(lastword $(MAKEFILE_LIST)))
NAME=$(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
# Compiler settings
JAVAC=javac
JAR=jar
JAVAC_FLAGS=-classpath classes -sourcepath src -d classes
MANIFEST=MANIFEST.MF
JAR_FLAGS=cmvf $(MANIFEST)
# Build the lib
CLI_SOURCES=$(wildcard src/*.java)
CLI_OBJECTS=$(addprefix classes/$(NAME)/,$(notdir $(CLI_SOURCES:.java=.class)))
CLI=bin/$(NAME).jar
TAR=bin/$(NAME).tar.gz

all: $(CLI_SOURCES) $(CLI)

$(CLI): $(CLI_OBJECTS) $(MANIFEST)
	$(JAR) $(JAR_FLAGS) $(CLI) -C classes $(NAME)

classes/$(NAME)/%.class: src/%.java
	$(JAVAC) $(JAVAC_FLAGS) $<

.PHONY: tar
tar:
	@tar --dereference --exclude='*/bin/*' \
		--exclude='*/obj/*' -czf $(TAR) .

install:
	@tar xvf bin/$(NAME).tar.gz -C /

clean:
	@rm -f $(CLI_OBJECTS)
