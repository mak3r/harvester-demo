#!/bin/bash




function install() {
	#TODO: This still doesn't accept all defaults user interaction still required
	export DEBIAN_FRONTEND=noninteractive
	apt update && apt upgrade -y -q

	curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable servicelb --disable traefik" sh -

	cp /etc/rancher/k3s/k3s.yaml ~/.kube/config

	VERSION=$(curl -s https://github.com/kubevirt/containerized-data-importer/releases/latest | grep -o "v[0-9]\.[0-9]*\.[0-9]*")
	kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$VERSION/cdi-operator.yaml
	kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$VERSION/cdi-cr.yaml

	export VERSION=v0.38.1
	wget https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/virtctl-${VERSION}-linux-amd64

	mv virtctl-${VERSION}-linux-amd64 /usr/local/bin/virtctl

	wget https://github.com/derailed/k9s/releases/download/v0.24.2/k9s_Linux_x86_64.tar.gz
	tar -xzvf k9s_Linux_x86_64.tar.gz -C /usr/local/bin k9s
}

function get-traefik () {
	if ! grep 'BuildInfo' $(helm version); then
		curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | sh -
	fi
	helm repo add traefik https://helm.traefik.io/traefik
	helm repo update
	helm pull traefik/traefik -d /var/lib/rancher/k3s/server/static/charts/
}

function add-traefik-manifest () {
		cp manifests/traefik-custom.yaml /var/lib/rancher/k3s/server/manifests/
}

function rm-traefik-manifest () {
	rm /var/lib/rancher/k3s/server/manifests/traefik-custom.yaml
}

if grep vmx /proc/cpuinfo; then
	install
	get-traefik
	add-traefik-manifest
else
	"Hardware virtualization not enabled. Bailing out."
fi


