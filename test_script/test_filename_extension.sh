#!/bin/bash

echo "::${0##*/}"

echo success_cases
# TODO: add success case for String and [String]

echo failure_cases

test_int()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from languages_manifest_filename_extension_is_int)

  build_start_points_image_languages_error "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: filename_extension must be a String or Array of Strings"
  assert_stderr_includes "--languages ${TMP_URL}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"filename_extension": 1'
  assert_stderr_line_count_equals 4
  assert_status_equals 34
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_int_array()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from languages_manifest_filename_extension_is_int_array)

  build_start_points_image_languages_error "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: filename_extension must be a String or Array of Strings"
  assert_stderr_includes "--languages ${TMP_URL}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"filename_extension": [1, 2, 3]'
  assert_stderr_line_count_equals 4
  assert_status_equals 34
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_empty_array()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from languages_manifest_filename_extension_is_empty_array)

  build_start_points_image_languages_error "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: filename_extension must be a String or Array of Strings"
  assert_stderr_includes "--languages ${TMP_URL}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"filename_extension": []'
  assert_stderr_line_count_equals 4
  assert_status_equals 34
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_empty_string()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from languages_manifest_filename_extension_is_empty_string)

  build_start_points_image_languages_error "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: filename_extension[0] must be non-empty String"
  assert_stderr_includes "--languages ${TMP_URL}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"filename_extension": [""]'
  assert_stderr_line_count_equals 4
  assert_status_equals 35
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_doesnt_start_dot()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from languages_manifest_filename_extension_is_dotless)

  build_start_points_image_languages_error "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: filename_extension[0] must start with a dot"
  assert_stderr_includes "--languages ${TMP_URL}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"filename_extension": ["cs"]'
  assert_stderr_line_count_equals 4
  assert_status_equals 36
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_only_a_dot()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from languages_manifest_filename_extension_is_only_dot)

  build_start_points_image_languages_error "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: filename_extension[0] must be more than just a dot"
  assert_stderr_includes "--languages ${TMP_URL}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"filename_extension": ["."]'
  assert_stderr_line_count_equals 4
  assert_status_equals 37
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_duplicates()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from languages_manifest_filename_extension_duplicates)

  build_start_points_image_languages_error "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: filename_extension has duplicates [1][3]"
  assert_stderr_includes "--languages ${TMP_URL}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"filename_extension": [".cs", ".h", ".c", ".h"]'
  assert_stderr_line_count_equals 4
  assert_status_equals 38
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2