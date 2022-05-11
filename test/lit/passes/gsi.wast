;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: foreach %s %t wasm-opt --nominal --gsi -all -S -o - | filecheck %s

(module
  ;; CHECK:      (type $struct (struct_subtype (field i32) data))
  (type $struct (struct i32))

  ;; CHECK:      (type $none_=>_none (func_subtype func))

  ;; CHECK:      (global $global1 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: ))
  (global $global1 (ref $struct) (struct.new $struct
    (i32.const 42)
  ))

  ;; CHECK:      (global $global2 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT: ))
  (global $global2 (ref $struct) (struct.new $struct
    (i32.const 1337)
  ))

  ;; CHECK:      (func $test (type $none_=>_none)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (select
  ;; CHECK-NEXT:    (i32.const 42)
  ;; CHECK-NEXT:    (i32.const 1337)
  ;; CHECK-NEXT:    (ref.eq
  ;; CHECK-NEXT:     (ref.as_non_null
  ;; CHECK-NEXT:      (ref.null $struct)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (global.get $global1)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test
    ;; We can infer that this get can reference either $global1 or $global2,
    ;; and nothing else (aside from a null), and can emit a select between
    ;; those values.
    (drop
      (struct.get $struct 0
        (ref.null $struct)
      )
    )
  )
)

;; Just one global. We do not optimize here - we let other passes do that.
(module
  ;; CHECK:      (type $struct (struct_subtype (field i32) data))
  (type $struct (struct i32))

  ;; CHECK:      (type $none_=>_none (func_subtype func))

  ;; CHECK:      (global $global1 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: ))
  (global $global1 (ref $struct) (struct.new $struct
    (i32.const 42)
  ))

  ;; CHECK:      (func $test (type $none_=>_none)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $struct 0
  ;; CHECK-NEXT:    (ref.null $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test
    (drop
      (struct.get $struct 0
        (ref.null $struct)
      )
    )
  )
)

;; Three globals. For now, we do not optimize here.
(module
  ;; CHECK:      (type $struct (struct_subtype (field i32) data))
  (type $struct (struct i32))

  ;; CHECK:      (type $none_=>_none (func_subtype func))

  ;; CHECK:      (global $global1 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: ))
  (global $global1 (ref $struct) (struct.new $struct
    (i32.const 42)
  ))

  ;; CHECK:      (global $global2 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT: ))
  (global $global2 (ref $struct) (struct.new $struct
    (i32.const 1337)
  ))

  ;; CHECK:      (global $global3 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 99999)
  ;; CHECK-NEXT: ))
  (global $global3 (ref $struct) (struct.new $struct
    (i32.const 99999)
  ))

  ;; CHECK:      (func $test (type $none_=>_none)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $struct 0
  ;; CHECK-NEXT:    (ref.null $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test
    (drop
      (struct.get $struct 0
        (ref.null $struct)
      )
    )
  )
)

