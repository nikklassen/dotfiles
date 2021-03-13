(method_declaration
  receiver: (parameter_list
    (parameter_declaration
      type: [
        (pointer_type (type_identifier) @bulk_folds.method_receivers)
        (type_identifier) @bulk_folds.method_receivers
      ])))

(function_declaration
  name: (identifier) @fn (#match? @fn "^Test.*$")) @bulk_folds.test_functions

(method_declaration) @bulk_folds.methods

(function_declaration) @bulk_folds.functions
