NAME = example
DEBUG=-debug pac

all: #my_herd
	touch build/example.svg
	gvpack -u build/$(NAME).dot | dot -Tsvg > build/example.svg

my_herd:
	../herdtools7/_build/install/default/bin/herd7 \
		-gv $(NAME).litmus -o build \
		-set-libdir ../herdtools7/herd/libdir \
		-show all -showevents all \
		-doshow all \
		-squished false $(DEBUG)

# Run my modified version of herd on a user given file
%.expected:
	../herdtools7/_build/install/default/bin/herd7 \
		-gv $(@:.expected=).litmus -o build \
		-set-libdir ../herdtools7/herd/libdir \
		-showevents all -show all \
		-doshow iico_ctrl -doshow ctrl -doshow all \
		-squished true -fontsize 20 #> $(@:.expected=.litmus.expected)
	#touch build/example.svg
	#dot -Tsvg build/$(@:.expected=).dot > build/example.svg

herd:
	herd7 \
		-show prop -doshow prop \
		-cat aarch64.cat -showevents all -show all \
		-gv $(NAME).litmus -o build -squished true -variant mte

litmus:
	../herdtools7/_build/install/default/bin/litmus7 \
		-os mac -set-libdir ../herdtools7/litmus/libdir \
		$(NAME).litmus -s 1000000


litmus_kvm:
	../herdtools7/_build/install/default/bin/litmus7 \
		-set-libdir ../herdtools7/litmus/libdir \
		$(NAME).litmus \
		-mach kvm-m1 \
		-o build/$(NAME).tar -s 100000
	#mkdir -p build/$(NAME)
	#tar xmf build/$(NAME).tar -C build/$(NAME)
	mkdir -p kvm-unit-tests/$(NAME)
	tar xmf build/$(NAME).tar -C kvm-unit-tests/$(NAME)

clean:
	rm -rf build/*

