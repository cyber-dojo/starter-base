#!/bin/bash

test_each_url_is_printed_to_stdout_one_git_repo()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local C_TMP_URL=$(git_repo_url_in_TMP_DIR_from custom-tennis)

  build_start_points_image       \
    "${image_name}"              \
      --custom    "${C_TMP_URL}"

  assert_stdout_includes $(echo -e "--custom \t ${C_TMP_URL}")
  assert_stdout_includes "Successfully built ${image_name}"
  assert_stdout_line_count_equals 2
  assert_stderr_equals ''
  assert_status_equals 0
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_each_url_is_printed_to_stdout_more_than_one_git_repo()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local L1_TMP_URL=$(git_repo_url_in_TMP_DIR_from languages-csharp-nunit)
  local L2_TMP_URL=$(git_repo_url_in_TMP_DIR_from languages-ruby-minitest)

  build_start_points_image \
    "${image_name}"        \
      --languages          \
        "${L1_TMP_URL}"    \
        "${L2_TMP_URL}"

  assert_stdout_includes $(echo -e "--languages \t ${L1_TMP_URL}")
  assert_stdout_includes $(echo -e "--languages \t ${L2_TMP_URL}")
  assert_stdout_includes "Successfully built ${image_name}"
  assert_stdout_line_count_equals 3
  assert_stderr_equals ''
  assert_status_equals 0
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
