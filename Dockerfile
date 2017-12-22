FROM library/cassandra:3

RUN apt-get update
RUN apt-get -y install eatmydata

ENV CASSANDRA_MAX_HEAP_SIZE=4G \
    CASSANDRA_HEAP_NEWSIZE=800M

# Permit memory configuration
RUN sed \
    -e 's/^#MAX_HEAP_SIZE.*/MAX_HEAP_SIZE="$CASSANDRA_MAX_HEAP_SIZE"/' \
    -e 's/^#HEAP_NEWSIZE.*/HEAP_NEWSIZE="$CASSANDRA_HEAP_NEWSIZE"/' \
	-i~ /etc/cassandra/cassandra-env.sh

# Fast-boot settings inspired from 
# https://github.com/spotify/docker-cassandra/blob/master/cassandra/scripts/cassandra-singlenode.sh

# Disable virtual nodes
RUN sed -i -e "s/num_tokens/\#num_tokens/" $CASSANDRA_CONFIG/cassandra.yaml

# With virtual nodes disabled, we need to manually specify the token
RUN echo 'JVM_OPTS="$JVM_OPTS -Dcassandra.initial_token=0"' \
    >> $CASSANDRA_CONFIG/cassandra-env.sh

# Pointless in one-node cluster, saves about 5 sec waiting time
RUN echo 'JVM_OPTS="$JVM_OPTS -Dcassandra.skip_wait_for_gossip_to_settle=0"' \
    >> $CASSANDRA_CONFIG/cassandra-env.sh

HEALTHCHECK \
    --start-period=30s \
    --interval=5s \
    --timeout=10s \
    CMD ["/usr/bin/cqlsh", "-e", "DESCRIBE KEYSPACES"]

# Override the entrypoint in
# https://github.com/docker-library/cassandra/blob/master/3.11/Dockerfile
ENTRYPOINT ["eatmydata", "/docker-entrypoint.sh"]
CMD ["cassandra", "-f"]
