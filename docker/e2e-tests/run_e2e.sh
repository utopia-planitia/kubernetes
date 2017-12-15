#!/bin/bash
##########################################################################
# Copyright 2017 Heptio Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ginkgo_args=(
    "--focus=${E2E_FOCUS}"
    "--skip=${E2E_SKIP}"
    "--noColor=true"
)

case ${E2E_PARALLEL} in
    'y'|'Y')           ginkgo_args+=("--nodes=25") ;;
    [1-9]|[1-9][0-9]*) ginkgo_args+=("--nodes=${E2E_PARALLEL}") ;;
esac

/usr/local/bin/ginkgo "${ginkgo_args[@]}" /usr/local/bin/e2e.test -- --disable-log-dump --repo-root=/kubernetes --provider="${E2E_PROVIDER}" --report-dir="${RESULTS_DIR}" --kubeconfig="${KUBECONFIG}"
