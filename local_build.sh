owner="Scille"
repo="parsec-build"

if [ -z $GITHUB_API_TOKEN ]
then
	echo "Please export GITHUB_API_TOKEN"
	exit 1
fi

if [ -z $PARSEC_VERSION ]
then
	PARSEC_VERSION=`cat version`
fi

PARSEC_VERSION=`echo $PARSEC_VERSION | cut -c -32`

docker run --rm -it -v $(pwd):$(pwd) snapcore/snapcraft:stable sh -c """
	apt update -qq &&
	apt-get install -y software-properties-common curl &&
	add-apt-repository -y ppa:deadsnakes/ppa &&
	apt update -qq &&
	cd $(pwd)/snap &&
	snapcraft clean &&
	mv snapcraft.yaml snapcraft.yaml.old &&
	cp snapcraft.yaml.old snapcraft.yaml &&
	sed -i '2d' snapcraft.yaml &&
	sed -i '2iversion: "$PARSEC_VERSION"' snapcraft.yaml &&
	snapcraft &&
	mv snapcraft.yaml.old snapcraft.yaml &&
	rm -rf ../snap/parsec-cloud &&
	../upload-github-release-asset.sh github_api_token=${GITHUB_API_TOKEN} owner=$owner repo=$repo tag=${PARSEC_VERSION} filename=parsec_${PARSEC_VERSION}_amd64.snap
"""
