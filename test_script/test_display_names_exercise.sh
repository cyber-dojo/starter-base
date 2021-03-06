#!/bin/bash

readonly error_code=90

test_failure_duplicates()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL_1=$(git_repo_url_in_TMP_DIR_from exercises_manifest_has_display_names_duplicate_1)
  local TMP_URL_2=$(git_repo_url_in_TMP_DIR_from exercises_manifest_has_display_names_duplicate_2)

  build_start_points_image "${image_name}" \
    --exercises \
      "${TMP_URL_1}" \
      "${TMP_URL_2}"

  refute_image_created
  assert_stderr_includes "ERROR: display_name duplicate"
  assert_stderr_includes "--exercises ${TMP_URL_1}"
  assert_stderr_includes "manifest='exercises-fizz-buzz/manifest.json'"
  assert_stderr_includes '"display_name": "Dup"'
  assert_stderr_includes "--exercises ${TMP_URL_2}"
  assert_stderr_includes "manifest='exercises-tiny-maze/manifest.json'"
  assert_stderr_includes '"display_name": "Dup"'
  assert_stderr_line_count_equals 7
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
