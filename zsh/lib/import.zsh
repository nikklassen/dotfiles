#!/bin/zsh

_MODULE_ROOT=""

typeset -A _NAMESPACE_FUNCTIONS
typeset -A _SCOPE_STACK

function import::init() {
  # %x gives the path of the current script being executed
  # :h strips the filename, leaving just the directory
  _MODULE_ROOT="${${(%):-%x}:h}"
  if [[ -z "$1" ]]; then
    return 0
  fi
  if [[ "$1" == /* ]]; then
    _MODULE_ROOT="$1"
  else
    _MODULE_ROOT="${_MODULE_ROOT%/}/$1"
  fi
}

function import::source() {
  local file="$1"

  # Make path relative to module root, unless it starts with ./
  if [[ -n "$_MODULE_ROOT" ]] && [[ "$file" != ./* ]]; then
    file="$_MODULE_ROOT/$file"
  fi

  # Try to find file with .zsh or .sh extension if not found
  if [[ ! -f "$file" ]]; then
    if [[ -f "$file.zsh" ]]; then
      file="$file.zsh"
    elif [[ -f "$file.sh" ]]; then
      file="$file.sh"
    else
      echo "Error: File '$file' not found" >&2
      exit 1
    fi
  fi

  # basenamse + remove extension
  local namespace="${file:t:r}"
  typeset -A old_functions
  for f in ${(k)functions}; do
    old_functions[$f]=1
  done

  local header="__IMPORTED_FUNCTIONS__"
  local saw_header=0
  local function_defs=()
  (
    typeset -A _NAMESPACE_GLOBALS
    source "$file"
    echo "$header"
    for func in ${(k)functions}; do
      if [[ "$func" != _* && -z ${old_functions[$func]} ]]; then
        local namespaced_name="${namespace}::${func}"
        echo "function $namespaced_name() { ${functions[$func]} }\n"
      fi
      if [[ -n ${_NAMESPACE_GLOBALS[$func]} ]]; then
        echo "function $func() { ${functions[$func]} }\n"
      fi
    done
  ) | while IFS= read -r line; do
    if [[ $line == $header ]]; then
      saw_header=1
      continue
    fi
    if [[ $saw_header == 1 ]]; then
      function_defs+=("$line")
    else
      echo "$line"
    fi
  done
  eval "${(F)function_defs}"
}

function import::global() {
  _NAMESPACE_GLOBALS[$1]=1
}

function import::_push_scope() {
  local namespace="$1"
  local scope_key="_saved_${namespace}"

  # Get all functions for this namespace
  local namespaced_functions=(${(M)${(k)functions}:#${namespace}::*})

  for namespaced_func in $namespaced_functions; do
    local base_func="${namespaced_func#${namespace}::}"

    # If a function with the base name already exists, save it
    if [[ -n ${functions[$base_func]} ]]; then
      functions -c "${base_func}" "${scope_key}_${base_func}"
    fi
    functions -c "${namespaced_func}" "${base_func}"

    # Replace with the namespaced version
    eval "function $base_func() { ${functions[$namespaced_func]} }"
  done
}

function import::_pop_scope() {
  local namespace="$1"
  local scope_key="_saved_${namespace}"

  local saved_functions=(${(M)${(k)functions}:#${scope_key}_*})
  for saved_func in $saved_functions; do
    local base_func="${saved_func#${scope_key}_}"

    functions -c "${saved_func}" "${base_func}"
    unfunction "${saved_func}"
  done
}

