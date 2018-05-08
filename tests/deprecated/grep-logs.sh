#/bin/bash

#set -euxo pipefail

EXIT=0

while read -r POD; do
    while read -r CONTAINER; do
        DEPRECATIONS=$(kubectl -n kube-system logs "$POD" -c "$CONTAINER" | grep -i deprecated | grep -v "the object has been modified; please apply your changes to the latest version and try again")
        if [ "$DEPRECATIONS" != "" ]; then
            EXIT=1
            echo "found deprecations in container $CONTAINER of pod $POD"
            echo "$DEPRECATIONS"
        fi
    done <<< $(kubectl -n kube-system get pods $POD -o go-template --template '{{range .spec.containers}}{{.name}}{{"\n"}}{{end}}')
done <<< $(kubectl -n kube-system get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')

exit $EXIT
