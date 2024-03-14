# TL;DR

This repo contains the Platform Service (PS) and community maintained version of PostgreSQL managed by Patroni for High Availability (HA).  The image is available from Artifactory.

You will find a sample of how to deploy the image [here](./samples/README.md).

# Image Management

This image is based on PostgreSQL v12.4.  Due to this being an old version of both Patroni and Postgres, we no longer automatically rebuild it to pick up software updates, because the Dockerfile no longer builds, due to software version changes.  We are planning on providing updated information soon.

## Tags

The stable tag for this image is `2.0.1-12.4-latest`.

See the [release notes](./RELEASE.md) for more information and any other unique tags. 

## Usage

Below is a sample of how you might reference this image from a `StatefulSet` deployment manifest. 

```yaml
  image: artifacts.developer.gov.bc.ca/bcgov-docker-local/patroni-postgres:2.0.1-12.4-latest
```

Find a sample StatefulSet deployment [here](./samples/README.md).

# Build

This image is built as per the [workflow](.github/workflows/image.yaml) and the OpenShift [templates](./openshift/templates).

## Distribution
This is the old section that describes copying the image to your local namespace.

Run RBAC to create an SA and bind it to, this is done on a lab or build cluster:

```yaml
 kind: ClusterRole
 name: system:image-puller
```

Using the token from the SA above, create a docker registry secret with the appropriate credentials. For the `--docker-server` argument use the **external registry host name**.

```console
oc create secret docker-registry bcgov-tools-klab \
  --docker-server=image-registry.foo.bar.gov.bc.ca \
  --docker-username=bcgov-images-cicd \
  --docker-password=$SATOKEN \
  --docker-email=unused
```

Then allow the builder service account to access the newly minted docker credentials for pulling images:

```console
oc secrets add sa/builder secrets/bcgov-tools-klab --for=pull
```

And finally, create an `imagestreamtag` to import the image to your cluster. Again, for the `-from-image` argument use the **external registry host name**.

```console
oc create imagestreamtag patroni-postgresql:12.4-latest \
  --from-image=image-registry.foo.bar.gov.bc.ca /bcgov-tools/patroni-postgresql:12.4-latest
```

Check to make sure it imported:

```console
oc get is
```

```console
oc describe is/patroni-postgresql
```
