;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: foreach %s %t wasm-opt -all --gufa -S -o - | filecheck %s

(module
  ;; CHECK:      (type $0 (func (param i32)))

  ;; CHECK:      (export "test" (func $test))

  ;; CHECK:      (func $test (type $0) (param $x i32)
  ;; CHECK-NEXT:  (local $y i32)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (i32.const 10)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $y
  ;; CHECK-NEXT:   (i32.const 20)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const 10)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const 20)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (i32.const 30)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $y
  ;; CHECK-NEXT:   (i32.const 40)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const 30)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const 40)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (i32.const 30)
  ;; CHECK-NEXT:   (local.set $y
  ;; CHECK-NEXT:    (i32.const 50)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const 30)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $y)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (export "test") (param $x i32)
    (local $y i32)
    ;; A parameter - nothing to optimize.
    (drop
      (local.get $x)
    )
    ;; This has the default value, and can be optimized to 0.
    (drop
      (local.get $y)
    )
    (local.set $x
      (i32.const 10)
    )
    (local.set $y
      (i32.const 20)
    )
    ;; These can both be optimized to constants, 10 and 20.
    (drop
      (local.get $x)
    )
    (drop
      (local.get $y)
    )
    (local.set $x
      (i32.const 30)
    )
    (local.set $y
      (i32.const 40)
    )
    ;; Now these are 30 and 40.
    (drop
      (local.get $x)
    )
    (drop
      (local.get $y)
    )
    (if
      (local.get $x)
      (local.set $y
        (i32.const 50)
      )
    )
    ;; x is the same but y is no longer optimizable, since it might contain 50.
    (drop
      (local.get $x)
    )
    (drop
      (local.get $y)
    )
  )
)
