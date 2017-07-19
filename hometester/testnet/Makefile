.PHONY: clean start stop build

BITCOIND=bitcoind
BITCOINCLI=bitcoin-cli
B1_FLAGS=-regtest
B2_FLAGS=-regtest
B1=-datadir=1 $(B1_FLAGS)
B2=-datadir=2 $(B2_FLAGS)
BLOCKS=1
ADDRESS=
AMOUNT=
ACCOUNT=
BITCOIN_SRC_DIR=/home/tester/bitcoin/src
DB4_LIB_DIR=/home/tester/db4

start:
	$(BITCOIND) $(B1) -daemon
	$(BITCOIND) $(B2) -daemon

generate:
	$(BITCOINCLI) $(B1) generate $(BLOCKS)

getinfo:
	$(BITCOINCLI) $(B1) getinfo
	$(BITCOINCLI) $(B2) getinfo

send:
	$(BITCOINCLI) $(B1) sendtoaddress $(ADDRESS) $(AMOUNT)

send2:
	$(BITCOINCLI) $(B2) sendtoaddress $(ADDRESS) $(AMOUNT)

address:
	$(BITCOINCLI) $(B1) getnewaddress $(ACCOUNT)

address2:
	$(BITCOINCLI) $(B2) getnewaddress $(ACCOUNT)

stop:
	-$(BITCOINCLI) $(B1) stop
	-$(BITCOINCLI) $(B2) stop

build-bitcoin:
	cd $(BITCOIN_SRC_DIR)/.. && ./autogen.sh && ./configure LDFLAGS="-L$(DB4_LIB_DIR)/lib" CPPFLAGS="-I$(DB4_LIB_DIR)/include" && make
	echo "**** Tester's password is 'tester' ****"
	cd $(BITCOIN_SRC_DIR)/.. && sudo make install

build: | stop build-bitcoin clean start

clean:
	rm -r 1/regtest
	rm -r 2/regtest
