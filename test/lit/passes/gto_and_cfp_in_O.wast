;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: foreach %s %t wasm-opt -O -all --closed-world -S -o - | filecheck %s
;; RUN: foreach %s %t wasm-opt -O -all                -S -o - | filecheck %s --check-prefix OPEN_WORLD

;; Test that -O, with nominal typing + GC enabled, will run global type
;; optimization in conjunction with constant field propagation etc. But, in an
;; open world we do not run them.

(module
  ;; OPEN_WORLD:      (type $struct (struct (field (mut funcref)) (field (mut i32))))
  (type $struct (struct_subtype (field (mut funcref)) (field (mut i32)) data))

  ;; OPEN_WORLD:      (type $1 (func))

  ;; OPEN_WORLD:      (type $2 (func (result i32)))

  ;; OPEN_WORLD:      (global $glob (ref $struct) (struct.new $struct
  ;; OPEN_WORLD-NEXT:  (ref.func $by-ref)
  ;; OPEN_WORLD-NEXT:  (i32.const 100)
  ;; OPEN_WORLD-NEXT: ))
  (global $glob (ref $struct) (struct.new $struct
    (ref.func $by-ref)
    (i32.const 100)
  ))

  ;; OPEN_WORLD:      (export "main" (func $main))

  ;; OPEN_WORLD:      (func $by-ref (type $1) (; has Stack IR ;)
  ;; OPEN_WORLD-NEXT:  (struct.set $struct 1
  ;; OPEN_WORLD-NEXT:   (global.get $glob)
  ;; OPEN_WORLD-NEXT:   (i32.const 200)
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT: )
  (func $by-ref
    ;; This function is kept alive by the reference in $glob. After we remove
    ;; the field that the funcref is written to, we remove the funcref, which
    ;; means this function can be removed.
    ;;
    ;; Once it is removed, this write no longer exists, and does not hamper
    ;; constant field propagation from inferring the value of the i32 field.
    (struct.set $struct 1
      (global.get $glob)
      (i32.const 200)
    )
  )

  ;; CHECK:      (type $0 (func (result i32)))

  ;; CHECK:      (export "main" (func $main))

  ;; CHECK:      (func $main (type $0) (; has Stack IR ;) (result i32)
  ;; CHECK-NEXT:  (i32.const 100)
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (func $main (type $2) (; has Stack IR ;) (result i32)
  ;; OPEN_WORLD-NEXT:  (struct.get $struct 1
  ;; OPEN_WORLD-NEXT:   (global.get $glob)
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT: )
  (func $main (export "main") (result i32)
    ;; After all the above optimizations, we can infer that $main should simply
    ;; return 100.
    (struct.get $struct 1
      (global.get $glob)
    )
  )
)
