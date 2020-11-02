# TL;DR

This repo contains the Platform Service (PS) and community maintained version of PostgreSQL managed by Patroni for High Availability (HA). You will find this image in the `bcgov` namespace on all PS managed clusters.

```console
oc get is -n bcgov
```

You will find a sample of how to deploy the image [here](./samples/README.md).

# Image Management

This image is based on PostgreSQL v12.4. It will be periodically rebuilt acording to the `cron` schedule in the workflow. When it is rebuilt, [patch](https://semver.org/) updates as well as operating security fixes will be incorporated and redistributed to all clusters via the [stable tag](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-image-tag-version).

## Tags

The stable tag for this image is `12.4-latest`. When the image is rebuilt [patch](https://semver.org/) updates to PostgreSQL will be incorporated along with operating system updates.

See the [release notes](./RELEASE.md) for more information and any other unique tags. 

Sample Usage

```yaml
image-registry.openshift-image-registry.svc:5000/bcgov/patroni-postgres:12.4-latest
```

## Build

This image is built as per the [workflow](.github/workflows/image.yaml) and the OpenShift [templates](./openshift/templates).

## Distribution

Run RBAC to create an SA and bind it to, this is done on `klab`

```yaml
 kind: ClusterRole
 name: system:image-puller
```

Create a secret on `silver`:

```console
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