Docker Agate
============

Docker image for [Agate](https://www.obiba.org/pages/products/agate/), the OBiBa central authentication server.
Images are published on Docker Hub as [`obiba/agate`](https://hub.docker.com/r/obiba/agate).
See also the [Agate installation documentation](https://agatedoc.obiba.org/en/latest/admin/installation.html#docker-image-installation).

Quick start
-----------

Use [docker compose](https://docs.docker.com/compose/) to launch Agate together with MongoDB and a
[Mailpit](https://mailpit.axllent.org/) SMTP sink:

```
docker compose up
```

Then connect to:

* Agate: [http://localhost:8881](http://localhost:8881) (login `administrator` / `password`)
* Mailpit: [http://localhost:8025](http://localhost:8025) (mails sent by Agate)

The `docker-compose.yml` is a development setup: the Agate home is mounted from `/tmp/agate` and the
MongoDB credentials default to `obiba` / `password` (override with `MONGO_USER` and `MONGO_PASSWORD`).

Image layout
------------

| Path | Purpose |
|------|---------|
| `/usr/share/agate` | Agate distribution (binaries, default configuration) |
| `/opt/agate/bin` | Image start scripts (`start.sh`, `first_run.sh`) |
| `/srv` | `AGATE_HOME`: configuration, data and logs. Declared as a volume. |

Ports:

| Port | Protocol |
|------|----------|
| 8081 | HTTP |
| 8444 | HTTPS |

On first start, the entrypoint copies the default configuration into `AGATE_HOME/conf`, applies the
environment variables below and writes an `AGATE_HOME/.first_run.sh.done` marker. On later starts the
configuration in the volume is used as is: changing an environment variable afterwards has no effect,
edit the files in `AGATE_HOME/conf` instead (or delete the marker to re-apply the environment).

Environment variables
---------------------

Only read on first start, unless stated otherwise.

| Variable | Default | Description |
|----------|---------|-------------|
| `AGATE_ADMINISTRATOR_PASSWORD` | `password` | Password of the `administrator` user. |
| `AGATE_PUBLIC_URL` | | Public URL of Agate (e.g. `https://agate.example.org`). Ignored once set in the administration UI. |
| `MONGODB_URI` | | Full MongoDB URI (`host:port/db?options`). Takes precedence over the `MONGO_*` variables. |
| `MONGO_HOST` | | MongoDB host. |
| `MONGO_PORT` | `27017` | MongoDB port. |
| `MONGO_DB` | `agate` | MongoDB database name. |
| `MONGO_USER` | | MongoDB user, authenticated against the `admin` database. Requires `MONGO_PASSWORD`. |
| `MONGO_PASSWORD` | | MongoDB password. |
| `RECAPTCHA_SITE_KEY` | | Google reCAPTCHA site key. Requires `RECAPTCHA_SECRET_KEY`. |
| `RECAPTCHA_SECRET_KEY` | | Google reCAPTCHA secret key. |
| `SPRING_MAIL_*` | | Any `spring.mail.*` property of `application-prod.yml` (`SPRING_MAIL_HOST`, `SPRING_MAIL_PORT`, `SPRING_MAIL_FROM`, `SPRING_MAIL_AUTH_TYPE`, ...). Read at every start. |
| `JAVA_OPTS` | `-Xmx2G` | JVM options. Read at every start. |

Without `MONGODB_URI` or `MONGO_HOST`, Agate connects to `localhost:27017/agate`.

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

Running arbitrary commands
--------------------------

Any command other than `app` is executed as is, for instance to run the
[Agate Python client](https://agatedoc.obiba.org/en/latest/python-user-guide/) shipped in the image:

```
docker run --rm obiba/agate agate --help
```

Building
--------

```
make build tag=5.1.1
make push tag=5.1.1
```

The Agate version is set by `AGATE_VERSION` in the `Dockerfile`.
