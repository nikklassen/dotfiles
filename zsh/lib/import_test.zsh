#!/bin/zsh

BASE="${${(%):-%x}:h}"
source "$BASE/test.zsh"

# Module under test
source "$BASE/import.zsh"

function test_scope() {
  function test::hello() { echo "hello"; }

  import::_push_scope "test"

  local want="hello"
  local got="$(hello)"
  [[ "$want" != "$got" ]] && fail "namespaced hello got '$got', want '$want'"

  return 0
}
test_case test_scope

function test_scope_overwrite() {
  # Test functions - create a collision scenario
  function test::hello() { echo "namespaced hello"; }
  function hello() { echo "original hello function"; }

  local want="original hello function"
  local got="$(hello)"
  [[ "$got" != "$want" ]] && fail "hello function got $got, want $want"

  import::_push_scope "test"
  want="namespaced hello"
  got="$(hello)"
  [[ "$want" != "$got" ]] && fail "namespaced hello got '$got', want '$want'"

  [[ -n "${functions[_saved_test_hello]}" ]] || fail "_saved_test_hello function not saved"

  import::_pop_scope "test"

  want="original hello function"
  got="$(hello)"
  [[ "$got" != "$want" ]] && fail "restored hello function got $got, want $want"

  return 0
}
test_case test_scope_overwrite

function test_import() {
  import::init

  import::source testdata/helper

  local want="helper"
  local got="$(helper::print)"
  [[ "$got" != "$want" ]] && fail "helper::print got '$got', want '$want'"

  return 0
}
test_case test_import

function test_global() {
  import::init

  import::source testdata/helper_global

  local want="helper global"
  local got="$(print_global)"
  [[ "$got" != "$want" ]] && fail "print_global got '$got', want '$want'"

  return 0
}
test_case test_global
