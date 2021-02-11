# How to get up and running with Harvester for kubevirt simplicity.

1. Setup baremetal server
1. Install k3s
1. Setup the local kubeconfig

  ```
  sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
  chown <user>:<group> ~/.kube/config 
  ```
1. Install helm

```
export VERIFY_CHECKSUM=false
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
```
1. Pull down the harvester code

  ```
  git clone https://github.com/rancher/harvester
  ```
1. Install harvester via helm
  ```
  cd harvester/deploy/charts/harvester
  ```
1. Helm attempt
  ```
  helm upgrade --install harvester . --namespace harvester-system --set longhorn.enabled=false,minio.persistence.storageClass="local-path",service.harvester.type=NodePort,multus.enabled=false,minio.mode=standalone --create-namespace
  ```

1. With longhorn enabled
  ```
  helm upgrade --install harvester . --namespace harvester-system --set longhorn.enabled=true,minio.persistence.storageClass=longhorn,service.harvester.type=NodePort,multus.enabled=true --create-namespace
  ```

# Harvester install

1. Install k3s
1. Setup the local kubeconfig

  ```
  sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
  chown <user>:<group> ~/.kube/config 
  ```

1. Install helm


    ```
    export VERIFY_CHECKSUM=false
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
    ```

1. Pull down the harvester code

 
    ```
    git clone https://github.com/rancher/harvester
    ```

1. Install harvester via helm

    ```
    cd harvester/deploy/charts/harvester
    ```

1. Helm attempt

    ```
    helm upgrade --install harvester . --namespace harvester-system --set longhorn.enabled=true,minio.persistence.storageClass="longhorn",service.harvester.type=NodePort,multus.enabled=false,minio.mode=standalone --create-namespace
    ```


# Kubevirt

1. Install k3s

  `curl -sfL https://get.k3s.io | sh -`

1. Update and upgrade ubuntu

  `apt update && apt upgrade -y`

1. Validate hardware virtualization

  `grep --color vmx /proc/cpuinfo`

1. ~~Install libvirt package~~

  `apt install -y libvirt`

1. Install containerized data importer

  ```
  VERSION=$(curl -s https://github.com/kubevirt/containerized-data-importer/releases/latest | grep -o "v[0-9]\.[0-9]*\.[0-9]*")
  kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$VERSION/cdi-operator.yaml
  kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$VERSION/cdi-cr.yaml
  ```

1. Upload image

  `virtctl image-upload dv dv-name --uploadproxy-url=https://cdi-uploadproxy.mycluster.com --image-path=/images/fedora30.qcow2
`

1. Get virtctl

  ```
  export VERSION=v0.38.1
  wget https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/virtctl-${VERSION}-linux-amd64
  ```

