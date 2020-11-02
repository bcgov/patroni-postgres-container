# TL;DR

This is the platform services image catalogue. bla bla [here](./RELEASE.md).

# Image Management

Run RBAC to create an SA and bind it to, this is done on `klab`

```yaml
 kind: ClusterRole
 name: system:image-puller
```

Create a secret on `silver`:
```
oc create secret docker-registry bcgov-tools-klab \
  --docker-server=image-registry.apps.klab.devops.gov.bc.ca \
  --docker-username=bcgov-images-cicd \
  --docker-password=$SATOKEN \
  --docker-email=unused
```

Add it to builder secret on `silver`:
```console
oc secrets add sa/builder secrets/bcgov-tools-klab --for=pull
```

Make an image stream tak to import it `silver`:

```console
oc create imagestreamtag postgresql-124-patroni:1.0 \
  --from-image=image-registry.apps.klab.devops.gov.bc.ca/bcgov-tools/postgresql-124-patroni:1.0
```

```console
oc get is
```

```console
oc describe is/postgresql-10-patroni
```