FROM library/cassandra:3

RUN apt-get update
RUN apt-get -y install eatmydata

ENV CASSANDRA_MAX_HEAP_SIZE=4G \
    CASSANDRA_HEAP_NEWSIZE=800M

RUN sed \
    -e 's/^#MAX_HEAP_SIZE.*/MAX_HEAP_SIZE="$CASSANDRA_MAX_HEAP_SIZE"/' \
    -e 's/^#HEAP_NEWSIZE.*/HEAP_NEWSIZE="$CASSANDRA_HEAP_NEWSIZE"/' \
	-i~ /etc/cassandra/cassandra-env.sh
