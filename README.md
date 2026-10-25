Docker Agate
============

Use [docker compose](https://docs.docker.com/compose/) to launch agate and mongodb applications:

```
docker-compose up
```

Then connect to:

[http://localhost:8871](http://localhost:8871)

Running as a non-root user
--------------------------

The image starts as root by default: the entrypoint takes ownership of `AGATE_HOME` for the `agate`
user (uid and gid 10041) and drops to it before starting Agate. Started as that user instead, with
`--user 10041:10041` or `runAsUser: 10041` on Kubernetes, the entrypoint skips both steps and
starts Agate directly, which is what a Pod Security `restricted` namespace (`runAsNonRoot`)
needs. The volume's ownership is then yours to arrange: give it to uid 10041, or set
`fsGroup: 10041` on the pod, or Agate will not be able to write its home.

```
docker run --user 10041:10041 -v agate-home:/srv -p 8881:8081 obiba/agate
```
